within Buildings.Experimental.Templates.Commercial.VAV.AHUs.Validation;
model BusTestNonExp
  BusTestControllerNonExp controllerSystem annotation (Placement(transformation(extent={{-20,-10},{-40,10}})));
  BusTestControlledNonExp controlledSystem annotation (Placement(transformation(extent={{20,-10},{40,10}})));
equation
  connect(controllerSystem.nonExpandableBus, controlledSystem.nonExpandableBus)
    annotation (Line(points={{-20,7.5},{0,7.5},{0,7.5},{20,7.5}}, color={0,0,0}));
  annotation (Diagram(coordinateSystem(extent={{-60,-20},{60,20}})), Icon(coordinateSystem(extent={{-60,-60},{60,60}})));
end BusTestNonExp;
