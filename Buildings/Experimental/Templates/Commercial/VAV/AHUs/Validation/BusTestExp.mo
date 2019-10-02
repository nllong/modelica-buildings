within Buildings.Experimental.Templates.Commercial.VAV.AHUs.Validation;
model BusTestExp
  extends Modelica.Icons.Example;
  BusTestControllerExp controllerSystem annotation (Placement(transformation(extent={{-20,-10},{-40,10}})));
  BusTestControlledExp controlledSystem annotation (Placement(transformation(extent={{20,-10},{40,10}})));
equation
  connect(controllerSystem.ahuBus, controlledSystem.ahuBus)
    annotation (Line(
      points={{-20,0},{20,0}},
      color={255,204,51},
      thickness=0.5));
  annotation (Diagram(coordinateSystem(extent={{-60,-20},{60,20}})));
end BusTestExp;
