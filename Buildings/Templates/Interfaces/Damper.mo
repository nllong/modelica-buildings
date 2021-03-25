within Buildings.Templates.Interfaces;
partial model Damper
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Medium";

  parameter Types.Damper typ "Equipment type"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  final parameter String braStr=
    if Modelica.Utilities.Strings.length(insNam) -
      Modelica.Utilities.Strings.find(insNam, "damOut")==5 or
      Modelica.Utilities.Strings.find(insNam, ".damOut.")<>0 then "Outdoor air"
    elseif Modelica.Utilities.Strings.find(insNam, "damOutMin")<>0 then "Minimum outdoor air"
    elseif Modelica.Utilities.Strings.find(insNam, "damRel")<>0 then "Relief air"
    elseif Modelica.Utilities.Strings.find(insNam, "damRet")<>0 then "Return air"
    elseif Modelica.Utilities.Strings.find(insNam, "damVAV")<>0 then "Terminal"
    else "Undefined"
    "String used to identify the damper location"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  final parameter String insNam = getInstanceName()
    "Instance name"
    annotation(Evaluate=true);
  outer parameter String id
    "System identifier";
  outer parameter ExternData.JSONFile dat
    "External parameter file";

  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        Medium) "Entering air" annotation (Placement(transformation(extent={{-110,
            -10},{-90,10}}), iconTransformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        Medium) "Leaving air" annotation (Placement(transformation(extent={{90,-10},
            {110,10}}), iconTransformation(extent={{90,-10},{110,10}})));
  BaseClasses.Connectors.BusInterface busCon if
    typ <> Types.Damper.None and
    typ <> Types.Damper.Barometric and
    typ <> Types.Damper.NoPath
    "Control bus"
    annotation (
      Placement(
        visible=DynamicSelect(true, typ <> Types.Damper.None and
          typ <> Types.Damper.NoPath),
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={0,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,100})));

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false,
      extent={{-100,-100},{100,100}}),
      graphics={
        Text(
          visible=DynamicSelect(true, typ <> Types.Damper.None and
            typ <> Types.Damper.NoPath),
          extent={{-151,-116},{149,-156}},
          lineColor={0,0,255},
          textString="%name")}),
     Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end Damper;
