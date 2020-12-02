within Buildings.Experimental.Templates.Commercial.VAV.AHUs.MinimumExamples;
model Application
  replaceable package MediumA = Buildings.Media.Air "Moist air";
  replaceable package MediumW = Buildings.Media.Water "Water";
  System sys_com1
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  Fluid.Sources.MassFlowSource_T boundary(
    redeclare package Medium=MediumA,
    nPorts=1)
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Fluid.Sources.Boundary_pT bou(
    redeclare package Medium=MediumA,
    nPorts=1)
    annotation (Placement(transformation(extent={{60,50},{40,70}})));
  Fluid.Sources.MassFlowSource_T boundary1(
    redeclare package Medium = MediumW,
    nPorts=1)
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Fluid.Sources.Boundary_pT bou1(
    redeclare package Medium = MediumW,
    nPorts=1)
    annotation (Placement(transformation(extent={{60,10},{40,30}})));
  System sys_com2(comTyp=ComponentType.Component2)
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  Fluid.Sources.MassFlowSource_T boundary2(redeclare package Medium = MediumA,
      nPorts=1)
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Fluid.Sources.Boundary_pT bou2(redeclare package Medium = MediumA, nPorts=1)
    annotation (Placement(transformation(extent={{60,-50},{40,-30}})));
equation
  connect(boundary.ports[1], sys_com1.port_AirEnt)
    annotation (Line(points={{-40,60},{-10,60}}, color={0,127,255}));
  connect(sys_com1.port_AirLvg, bou.ports[1])
    annotation (Line(points={{10,60},{40,60}}, color={0,127,255}));
  connect(boundary1.ports[1], sys_com1.port_WatEnt)
    annotation (Line(points={{-40,20},{-4,20},{-4,50}}, color={0,127,255}));
  connect(sys_com1.port_WatLvg, bou1.ports[1])
    annotation (Line(points={{4,50},{4,20},{40,20}}, color={0,127,255}));
  connect(boundary2.ports[1], sys_com2.port_AirEnt)
    annotation (Line(points={{-40,-40},{-10,-40}}, color={0,127,255}));
  connect(sys_com2.port_AirLvg, bou2.ports[1])
    annotation (Line(points={{10,-40},{40,-40}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Application;
