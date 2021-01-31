within Buildings.Experimental.Templates.AHUs.Data;
record VAVSingleDuct
  extends Modelica.Icons.Record;

  replaceable parameter Templates.AHUs.Economizers.Data.None datEco
    constrainedby Buildings.Experimental.Templates.AHUs.Economizers.Data.None
    "Economizer parameters"
    annotation (Placement(transformation(extent={{-40,-150},{-20,-130}})),
      choicesAllMatching=true,
      Dialog(
        enable=typEco<>Types.Economizer.None,
        group="Economizer"));

  replaceable parameter Templates.AHUs.Coils.Data.None datCoiCoo
    constrainedby Buildings.Experimental.Templates.AHUs.Coils.Data.None
    "Cooling coil parameters"
    annotation (Placement(transformation(extent={{-40,-150},{-20,-130}})),
      choicesAllMatching=true,
      Dialog(
        enable=typCoiCoo<>Types.Coil.None,
        group="Cooling coil"));

  replaceable parameter Templates.AHUs.Fans.Data.None datFanSup
    constrainedby Buildings.Experimental.Templates.AHUs.Fans.Data.None
    "Supply fan parameters";
    annotation (Placement(transformation(extent={{-40,-150},{-20,-130}})),
      choicesAllMatching=true,
      Dialog(
        enable=typFanSup<>Types.Fan.None,
        group="Supply fan"));

end VAVSingleDuct;
