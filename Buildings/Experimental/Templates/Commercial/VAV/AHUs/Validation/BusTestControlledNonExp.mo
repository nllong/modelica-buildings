within Buildings.Experimental.Templates.Commercial.VAV.AHUs.Validation;
model BusTestControlledNonExp
public
  Modelica.Blocks.Sources.RealExpression sensor(y=2 + sin(time*3.14))
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Blocks.Routing.RealPassThrough actuator annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  BaseClasses.NonExpandableBus nonExpandableBus annotation (Placement(transformation(extent={{-10,-60},{10,-40}}),
        iconTransformation(extent={{-50,20},{-30,40}})));
equation
  nonExpandableBus.yMea = sensor.y;
  actuator.u = nonExpandableBus.yAct;
  annotation (Diagram(coordinateSystem(extent={{-100,-80},{100,40}})),  Icon(coordinateSystem(extent={{-40,-40},{40,40}})));
end BusTestControlledNonExp;
