within Buildings.Experimental.Templates_V0.Commercial.VAV.AHUs.MinimumExamples;
model Component1
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
  Modelica.Fluid.Interfaces.FluidPort_a port_watEnt(
    redeclare package Medium=MediumW)
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-50,-110},{-30,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_watLvg(
    redeclare package Medium=MediumW)
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{30,-110},{50,-90}})));
equation
  connect(port_airEnt,port_airLvg)
    annotation (Line(points={{-100,0},{100,0}}, color={0,127,255}));
  connect(port_watEnt,port_watLvg)  annotation (Line(points={{-40,-100},{-40,
          -60},{40,-60},{40,-100}}, color={0,127,255}));
end Component1;
