within Buildings.Experimental.Templates.AHU;
package Main
  model VAVSingleDuct
    extends Interfaces.Main(
      final typ=Types.Main.SupplyReturn,
      final typSup=Types.Supply.SingleDuct);
    import TypesAHU = Buildings.Experimental.Templates.AHU.Types
      "Enumerations";

    final constant TypesAHU.Economizer typEco = eco.typ
      "Type of economizer"
      annotation (Evaluate=true, Dialog(group="Configuration"));
    final constant Boolean have_souCoiCoo = coiCoo.have_sou
      "Type of economizer"
      annotation (Evaluate=true, Dialog(group="Configuration"));

    Modelica.Fluid.Interfaces.FluidPort_a port_OutMin(
      redeclare package Medium = MediumAir) if typEco==TypesAHU.Economizer.DedicatedDamper
      "Minimum outdoor air intake"
      annotation (Placement(transformation(extent={{-310,
              -150},{-290,-130}}), iconTransformation(extent={{-210,-10},{-190,10}})));
    Modelica.Fluid.Interfaces.FluidPort_b port_coiCooRet(
      redeclare package Medium = MediumCoo) if have_souCoiCoo
      "Cooling coil return port"
      annotation (Placement(
        transformation(extent={{10,-290},{30,-270}}),
        iconTransformation(extent={{10,-210},{30,-190}})));
    Modelica.Fluid.Interfaces.FluidPort_a port_coiCooSup(
      redeclare package Medium = MediumCoo) if have_souCoiCoo
      "Cooling coil supply port"
      annotation (Placement(
          transformation(extent={{-30,-290},{-10,-270}}), iconTransformation(
            extent={{-30,-210},{-10,-190}})));

    replaceable Economizers.None eco
      constrainedby Interfaces.Economizer(
      redeclare final package Medium = MediumAir)
      "Economizer"
      annotation (
        choicesAllMatching=true,
        Placement(transformation(extent={{-222,-150},{-202,-130}})));

    replaceable Coils.None coiCoo
      constrainedby Interfaces.Coil(
      redeclare final package MediumAir = MediumAir,
      redeclare final package MediumSou = MediumCoo)
      "Cooling coil"
      annotation (
        choicesAllMatching=true,
        Placement(transformation(extent={{-10,-210},{10,-190}})));


  equation
    connect(port_OutMin, eco.port_OutMin)
      annotation (Line(points={{-300,-140},{-222,-140}}, color={0,127,255}));
    connect(port_Exh, eco.port_Exh) annotation (Line(points={{-300,-80},{-240,-80},
            {-240,-133},{-222,-133}}, color={0,127,255}));
    connect(port_Out, eco.port_Out) annotation (Line(points={{-300,-200},{-240,-200},
            {-240,-147},{-222,-147}}, color={0,127,255}));
    connect(eco.port_Ret, port_Ret) annotation (Line(points={{-202,-132.8},{-180,-132.8},
            {-180,-80},{300,-80}}, color={0,127,255}));
    connect(eco.port_Sup, coiCoo.port_a) annotation (Line(points={{-202,-147},{-180,
            -147},{-180,-200},{-10,-200}}, color={0,127,255}));
    connect(coiCoo.port_b, port_Sup)
      annotation (Line(points={{10,-200},{300,-200}}, color={0,127,255}));
    connect(port_coiCooSup, coiCoo.port_aSou) annotation (Line(points={{-20,-280},
            {-20,-220},{-4,-220},{-4,-210}}, color={0,127,255}));
    connect(coiCoo.port_bSou, port_coiCooRet) annotation (Line(points={{4,-210},{4,
            -220},{20,-220},{20,-280}}, color={0,127,255}));
    annotation (
      defaultComponentName="ahu",
      Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
      coordinateSystem(preserveAspectRatio=false)));
  end VAVSingleDuct;
end Main;
