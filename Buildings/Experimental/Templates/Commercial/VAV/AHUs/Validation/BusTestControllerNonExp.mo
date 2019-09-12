within Buildings.Experimental.Templates.Commercial.VAV.AHUs.Validation;
model BusTestControllerNonExp
  Controls.OBC.CDL.Continuous.Division controller annotation (Placement(transformation(extent={{-10,44},{10,64}})));
  Modelica.Blocks.Routing.RealPassThrough realPassThrough
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  BaseClasses.NonExpandableBus nonExpandableBus annotation (Placement(transformation(extent={{-8,0},{12,20}}),
        iconTransformation(extent={{-50,20},{-30,40}})));
equation

  connect(realPassThrough.y, controller.u1)
    annotation (Line(points={{-39,70},{-24,70},{-24,60},{-12,60}}, color={0,0,127}));

  controller.u2 = nonExpandableBus.yMea;
  nonExpandableBus.yAct = controller.y;
  realPassThrough.u = nonExpandableBus.yMea;

  annotation (Diagram(coordinateSystem(extent={{-80,-20},{40,100}})),Icon(coordinateSystem(extent={{-40,-40},{40,40}})));
end BusTestControllerNonExp;
