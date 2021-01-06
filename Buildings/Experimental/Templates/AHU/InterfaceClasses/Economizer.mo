within Buildings.Experimental.Templates.AHU.InterfaceClasses;
model Economizer
  import TypeEconomizer = Buildings.Experimental.Templates.AHU.Types.Economizer
    "System type enumeration";
  replaceable package MediumAir=Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Air medium";
  constant TypeEconomizer typ
    "Type of system"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  Modelica.Fluid.Interfaces.FluidPort_b port_bExh(
    redeclare package Medium = MediumAir)
    "Exhaust/relief air" annotation (
      Placement(transformation(extent={{-110,50},{-90,70}}),
        iconTransformation(extent={{-250,110},{-230,130}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_OutMin(
    redeclare package Medium = MediumAir)
    "Minimum outdoor air intake"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
      iconTransformation(extent={{-250,-10},{-230,10}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_Out(
    redeclare package Medium = MediumAir)
    "Outdoor air intake" annotation (Placement(transformation(
          extent={{-110,-70},{-90,-50}}),    iconTransformation(extent={{-250,-130},
            {-230,-110}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aRet(
    redeclare package Medium = MediumAir)
    "Return air"
    annotation (Placement(
      transformation(extent={{90,50},{110,70}}),
      iconTransformation(extent={{230,110}, {250,130}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bSup(
    redeclare package Medium = MediumAir)
    "Supply air"
    annotation (Placement(
        transformation(extent={{90,-70},{110,-50}}),    iconTransformation(
          extent={{230,-130},{250,-110}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Economizer;
