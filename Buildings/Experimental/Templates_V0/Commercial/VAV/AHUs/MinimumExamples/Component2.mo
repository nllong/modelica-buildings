within Buildings.Experimental.Templates_V0.Commercial.VAV.AHUs.MinimumExamples;
model Component2
  replaceable package MediumA = Buildings.Media.Air "Moist air";
  replaceable package MediumW = Buildings.Media.Water "Water";
  Modelica.Fluid.Interfaces.FluidPort_a port_airEnt(
    redeclare package Medium=MediumA)
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_airLvg(
    redeclare package Medium=MediumA)
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
equation
  connect(port_airEnt, port_airLvg)
    annotation (Line(points={{-100,0},{100,0}}, color={0,127,255}));
end Component2;
