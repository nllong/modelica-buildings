within Buildings.Experimental.Templates.Commercial.VAV.AHUs.Validation;
model BusTestControlledExp
public
  Modelica.Blocks.Sources.RealExpression sensor(y=2 + sin(time*3.14))
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Experimental.Templates.BaseClasses.AhuBus ahuBus
    annotation (Placement(transformation(extent={{-20,-20},{20,20}}), iconTransformation(extent={{-50,-10},{-30,10}})));
  Modelica.Blocks.Routing.RealPassThrough actuator annotation (Placement(transformation(extent={{60,-10},{80,10}})));

equation
  connect(ahuBus.yAct, actuator.u) annotation (Line(
      points={{0,0},{30,0},{30,0},{58,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(sensor.y, ahuBus.yMea) annotation (Line(points={{-59,0},{-30,0},{-30,0},{0,0}},       color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (Diagram(coordinateSystem(extent={{-100,-20},{100,20}})),  Icon(coordinateSystem(extent={{-40,-40},{40,40}})));
end BusTestControlledExp;
