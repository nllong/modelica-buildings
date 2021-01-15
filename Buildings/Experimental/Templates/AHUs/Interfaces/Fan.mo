within Buildings.Experimental.Templates.AHUs.Interfaces;
partial model Fan
  extends Buildings.Fluid.Interfaces.PartialTwoPort(
    redeclare final package Medium=MediumAir);
  replaceable package MediumAir=Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Air medium";
  constant Types.Fan typ
    "Equipment type"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  constant Boolean have_y = false
    annotation (Evaluate=true, Dialog(group="Configuration"));
  constant Boolean have_yBoo = false
    annotation (Evaluate=true, Dialog(group="Configuration"));
  constant Boolean have_yInt = false
    annotation (Evaluate=true, Dialog(group="Configuration"));

  Modelica.Blocks.Interfaces.RealInput y(min=0, max=1) if have_y
    "s control signal"
    annotation (Placement(
      transformation(extent={{-20,-20},{20,20}}, rotation=270, origin={0,120}),
      iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,110})));
  Modelica.Blocks.Interfaces.IntegerInput yInt(min=0) if have_yInt
    "Actuator control signal"
    annotation (Placement(
      transformation(extent={{-20,-20},{20,20}}, rotation=270, origin={20,120}),
      iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-50,110})));
  Modelica.Blocks.Interfaces.BooleanInput yBoo if have_yBoo
    "Actuator control signal"
    annotation (Placement(
      transformation(extent={{-20,-20},{20,20}}, rotation=270, origin={40,120}),
      iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-30,110})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Fan;
