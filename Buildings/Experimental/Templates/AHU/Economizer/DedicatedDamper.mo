within Buildings.Experimental.Templates.AHU.Economizer;
model DedicatedDamper
  extends Interfaces.Economizer(
    final typ=Types.Economizer.DedicatedDamper);

  Modelica.Fluid.Interfaces.FluidPort_a port_OutMin(
    redeclare package Medium = Medium)
    "Minimum outdoor air intake"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
      iconTransformation(extent={{-110,-10},{-90,10}})));

  Fluid.Actuators.Dampers.MixingBoxMinimumFlow mix
    annotation (Placement(transformation(extent={{-10,-12},{10,8}})));

equation
  connect(port_OutMin, mix.port_OutMin) annotation (Line(points={{-100,0},{-60,0},
          {-60,8},{-10,8}}, color={0,127,255}));
  connect(port_Out, mix.port_Out) annotation (Line(points={{-100,-60},{-20,-60},
          {-20,4},{-10,4}}, color={0,127,255}));
  connect(mix.port_Sup, port_Sup) annotation (Line(points={{10,4},{20,4},{20,-60},
          {100,-60}}, color={0,127,255}));
  connect(mix.port_Ret, port_Ret) annotation (Line(points={{10,-8},{40,-8},{40,
          60},{100,60}}, color={0,127,255}));
  connect(port_Exh, mix.port_Exh) annotation (Line(points={{-100,60},{-40,60},{
          -40,-8},{-10,-8}}, color={0,127,255}));
  connect(y, mix.y) annotation (Line(points={{0,120},{0,10}}, color={0,0,127}));
  connect(yOutMin, mix.yOutMin) annotation (Line(points={{-60,120},{-60,80},{-6,
          80},{-6,10}}, color={0,0,127}));
  annotation (
  defaultComponentName="eco",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end DedicatedDamper;
