within Buildings.Experimental.Templates.Commercial.VAV.AHUs.Validation;
model BusTestControllerExp
public
  Buildings.Experimental.Templates.BaseClasses.AhuBus ahuBus
    annotation (Placement(transformation(extent={{-20,-20},{20,20}}), iconTransformation(extent={{-50,-10},{-30,10}})));
  Controls.OBC.CDL.Continuous.Division controller annotation (Placement(transformation(extent={{-10,44},{10,64}})));
  Modelica.Blocks.Routing.RealPassThrough realPassThrough
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
equation

  connect(realPassThrough.y, controller.u1)
    annotation (Line(points={{-39,70},{-24,70},{-24,60},{-12,60}}, color={0,0,127}));



  connect(controller.y, ahuBus.yAct) annotation (Line(points={{12,54},{40,54},{40,0},{0,0}},       color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(ahuBus.yMea, controller.u2) annotation (Line(
      points={{0,0},{-40,0},{-40,48},{-12,48}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(ahuBus.yMea, realPassThrough.u) annotation (Line(
      points={{0,0},{-72,0},{-72,70},{-62,70}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Diagram(coordinateSystem(extent={{-80,-20},{60,100}})),Icon(coordinateSystem(extent={{-40,-40},{40,40}})));
end BusTestControllerExp;
