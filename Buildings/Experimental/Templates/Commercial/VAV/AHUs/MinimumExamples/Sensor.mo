within Buildings.Experimental.Templates.Commercial.VAV.AHUs.MinimumExamples;
model Sensor
  replaceable package Medium = Buildings.Media.Water "Water"
  annotation (choices(
        choice(redeclare package Medium = Buildings.Media.Air "Moist air")));
  Modelica.Fluid.Interfaces.FluidPort_a port_ent(
    redeclare package Medium=Medium)
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_lvg(
    redeclare package Medium=Medium)
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
equation
  connect(port_ent, port_lvg)
    annotation (Line(points={{-100,0},{100,0}}, color={0,127,255}));
end Sensor;
