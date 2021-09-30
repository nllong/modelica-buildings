within Buildings.Examples.ExpandableConnectors.BaseClasses;
model Sensor
  SensorSubBusInterface subBusInterface
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  Modelica.Blocks.Sources.Constant const(k=273.15 + 10)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
equation
  connect(const.y, subBusInterface.y) annotation (Line(points={{-39,0},{0.05,0},
          {0.05,100.05}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
          preserveAspectRatio=false)));
end Sensor;
