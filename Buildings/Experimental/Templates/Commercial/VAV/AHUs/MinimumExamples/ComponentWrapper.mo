within Buildings.Experimental.Templates.Commercial.VAV.AHUs.MinimumExamples;
model ComponentWrapper
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

  parameter ComponentType comTyp = ComponentType.Component1;

  Component1 com1 if
                    comTyp == ComponentType.Component1
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Component2 com2 if comTyp == ComponentType.Component2
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));

equation
  connect(port_airEnt,com1.port_airEnt)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(com1.port_airLvg,port_airLvg)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(port_watEnt,com1.port_watEnt)  annotation (Line(points={{-40,-100},{-40,
          -40},{-4,-40},{-4,-10}}, color={0,127,255}));
  connect(com1.port_watLvg,port_watLvg)  annotation (Line(points={{4,-10},{4,-40},
          {40,-40},{40,-100}}, color={0,127,255}));
  connect(port_airEnt,com2.port_airEnt)  annotation (Line(points={{-100,0},{-80,
          0},{-80,40},{-10,40}}, color={0,127,255}));
  connect(com2.port_airLvg,port_airLvg)  annotation (Line(points={{10,40},{80,40},
          {80,0},{100,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ComponentWrapper;
