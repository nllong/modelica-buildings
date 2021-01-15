within Buildings.Experimental.Templates_V0.Commercial.VAV.AHUs.MinimumExamples;
model SystemTemplate
  replaceable package MediumA = Buildings.Media.Air "Moist air";
  replaceable package MediumW = Buildings.Media.Water "Water";

  parameter ComponentType comTyp = ComponentType.Component1;

  Modelica.Fluid.Interfaces.FluidPort_a port_airEnt(
    redeclare package Medium=MediumA)
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_airLvg(
    redeclare package Medium=MediumA)
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_watEnt(
    redeclare package Medium=MediumW) if comTyp == ComponentType.Component1
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-50,-110},{-30,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_watLvg(
    redeclare package Medium=MediumW) if comTyp == ComponentType.Component1
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{30,-110},{50,-90}})));
  ComponentWrapper componentWrapper(
    final comTyp=comTyp)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Sensor sensor if comTyp == ComponentType.Component1
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,-50})));
equation
  connect(componentWrapper.port_watLvg,port_watLvg)  annotation (Line(points={{4,
          -10},{4,-20},{40,-20},{40,-100}}, color={0,127,255}));
  connect(port_airEnt,componentWrapper.port_airEnt)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(componentWrapper.port_airLvg,port_airLvg)  annotation (Line(points={{10,
          0},{56,0},{56,0},{100,0}}, color={0,127,255}));
  connect(port_watEnt, sensor.port_ent)
    annotation (Line(points={{-40,-100},{-40,-60}}, color={0,127,255}));
  connect(sensor.port_lvg, componentWrapper.port_watEnt) annotation (Line(
        points={{-40,-40},{-40,-20},{-4,-20},{-4,-10}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SystemTemplate;
