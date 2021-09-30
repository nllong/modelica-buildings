within Buildings.Examples.ExpandableConnectors.BaseClasses;
model Controller
  BusInterface busInterface
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  Modelica.Blocks.Routing.RealPassThrough realPassThrough
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(realPassThrough.y, busInterface.equBus.out) annotation (Line(points={
          {11,0},{60,0},{60,-80},{0.05,-80},{0.05,-99.95}}, color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(busInterface.senBus.y, realPassThrough.u) annotation (Line(
      points={{0,-100},{0,-80},{-60,-80},{-60,0},{-12,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
          preserveAspectRatio=false)));
end Controller;
