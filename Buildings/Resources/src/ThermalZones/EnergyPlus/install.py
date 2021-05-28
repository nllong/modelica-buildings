#!/usr/bin/env python3
#######################################################
# Script the installs spawn, which generates
# an FMU with the EnergyPlus envelope model
#######################################################
import os

from multiprocessing import Pool

import tempfile
import tarfile
import zipfile
import urllib.request, urllib.parse, urllib.error
import shutil

# Commit, see https://gitlab.com/kylebenne/spawn/-/pipelines?scope=all&page=1
# Also available is latest/Spawn-latest-{Linux,win64,Darwin}
# The setup below will lead to a specific commit being pulled.
commit = "16cc01513da400117965e0aae35c0bddac4404e3"
NAME_VERSION = f"Spawn-0.1.0-{commit[0:10]}"



def log(msg):
    print(msg)


def get_bin_directory():
    file_path = os.path.dirname(os.path.realpath(__file__))
    return os.path.abspath(
        os.path.join(file_path, "..", "..", "..", "..", "Resources", "bin")
    )


def get_distribution(dis):
    des_dir = os.path.join(get_bin_directory(), dis["des"])
    tar_fil = os.path.basename(dis["src"])

    # Download the file
    log("Downloading {}".format(dis["src"]))
    urllib.request.urlretrieve(dis["src"], tar_fil)

    log("Extracting {}".format(tar_fil))
    if tar_fil.endswith(".zip"):
        # Make a tar.gz out of it.
        with tempfile.TemporaryDirectory(prefix="tmp-Buildings-inst") as zip_dir:
            with zipfile.ZipFile(tar_fil, "r") as zip_ref:
                zip_ref.extractall(zip_dir)
            new_name = tar_fil[:-3] + ".tar.gz"
            with tarfile.open(new_name, "w") as t:
                t.add(zip_dir)
        os.remove(tar_fil)
        tar_fil = new_name

    tar = tarfile.open(tar_fil)
    for key in dis["files"]:
        found = False
        for nam in tar.getnames():
            if nam.endswith(key):
                dis["files"][key] = nam
                found = True
        if not found:
            raise IOError("Failed to find '{}'".format(key))

    # Extract and move the files
    for key in dis["files"]:
        tar.extract(dis["files"][key], path=".")

        des_fil = os.path.join(des_dir, key)

        # Create the target directory
        try:
            os.stat(os.path.dirname(des_fil))
        except:
            os.makedirs(os.path.dirname(des_fil))

        os.rename(dis["files"][key], des_fil)
        log(("Wrote {} {}".format(dis["files"][key], des_fil)))

    # Delete the created empty directories
    top = dis["files"]["README.md"].split(os.path.sep)[0]
    for root, dirs, files in os.walk(top, topdown=False):
        for name in dirs:
            os.rmdir(os.path.join(root, name))
    os.rmdir(top)
    # Delete the tar.gz file
    os.remove(tar_fil)


def get_vars_as_json(spawnFlag):
    """Return a json structure that contains the output variables supported by spawn"""
    import os
    import subprocess
    import json

    bin_dir = get_bin_directory()
    spawn = os.path.join(bin_dir, "spawn-linux64", "bin", "spawn")

    ret = subprocess.run([spawn, spawnFlag], stdout=subprocess.PIPE, check=True)
    vars = json.loads(ret.stdout)
    if spawnFlag == "--output-vars":
        vars = sorted(vars, key = lambda i: i['name'])
    else:
        vars = sorted(vars, key = lambda i: (i['componentType'], i['controlType']))
    return vars


def get_html_table(allVars, template_name):
    """Returns an html-formatted table with all variables in the json structure `allVars`,
    using the template `template_name`
    """
    import jinja2
    import os

    path_to_template = os.path.dirname(os.path.realpath(__file__))
    env = jinja2.Environment(loader=jinja2.FileSystemLoader(path_to_template))
    template = env.get_template(template_name)
    html = template.render(vars=allVars)
    return html


def replace_table_in_mo(html, varType, moFile):
    """Replaces in the .mo file the table with the output variables"""
    import os
    import re

    mo_name = os.path.join(
        os.path.dirname(os.path.realpath(__file__)),
        "..",
        "..",
        "..",
        "..",
        "ThermalZones",
        "EnergyPlus",
        moFile,
    )
    mo_new = ""
    with open(mo_name, "r") as mo_fil:
        mo_old = mo_fil.read()
        # Start and end anchors in the mo file
        staStr = f"<!-- Start of table of {varType} generated by install.py. Do not edit. -->"
        endStr = (
            f"<!-- End of table of {varType} generated by install.py. Do not edit. -->"
        )
        mo_new, count = re.subn(
            r"(?<=%s).*(?=%s)" % (staStr, endStr),
            f"\n{html}\n",
            mo_old,
            flags=re.MULTILINE | re.DOTALL,
        )
        # Raise an error if the table was not updated. (Updating the table with the same content won't raise an error.)
        if count == 0:
            raise RuntimeError(
                f"Failed to update list of {varType} in {mo_name}. File was not modified."
            )
    # Write new file.
    with open(mo_name, "w") as mo_fil:
        mo_fil.write(mo_new)


if __name__ == "__main__":

    dists = list()
    dists.append(
        {
            "src": f"https://spawn.s3.amazonaws.com/builds/{NAME_VERSION}-Linux.tar.gz",
            "des": "spawn-linux64",
            "files": {
                "bin/spawn": "",
                "README.md": "",
                "lib/epfmi.so": "",
                "etc/Energy+.idd": "",
            },
        }
    )
    dists.append(
        {
            "src": f"https://spawn.s3.amazonaws.com/builds/{NAME_VERSION}-win64.zip",
            "des": "spawn-win64",
            "files": {
                "bin/epfmi.dll": "",
                "bin/spawn.exe": "",
                "README.md": "",
                "lib/epfmi.lib": "",
                "etc/Energy+.idd": "",
            },
        }
    )

    p = Pool(2)
    p.map(get_distribution, dists)
    vars = [
        {
            "spawnFlag": "--output-vars",
            "htmlTemplate": "output_vars_template.html",
            "varType": "output variables",
            "moFile": "OutputVariable.mo"
        },
        {
            "spawnFlag": "--actuators",
            "htmlTemplate": "actuators_template.html",
            "varType": "actuators",
            "moFile": "Actuator.mo"
        },
    ]
    for v in vars:
        js = get_vars_as_json(v["spawnFlag"])
        html = get_html_table(js, v["htmlTemplate"])
        replace_table_in_mo(html, v["varType"], v["moFile"])
