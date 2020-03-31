within Buildings.Experimental.Templates.Commercial.VAV.Controller;
model DummyTerminal
  extends Modelica.Blocks.Icons.Block;
  parameter Integer indTer
    "Terminal index used for testing purposes";
  Modelica.Blocks.Sources.RealExpression inpSig(y=time*indTer)
    "Input signal to AHU controller"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Blocks.Routing.RealPassThrough outSig
    annotation (Placement(transformation(extent={{-40,-50},{-60,-30}})));
  BaseClasses.TerminalBus terBus annotation (Placement(transformation(extent={{20,
            -20},{60,20}}), iconTransformation(extent={{20,-20},{60,20}})));
  Modelica.Blocks.Routing.BooleanPassThrough staAhu
    annotation (Placement(transformation(extent={{-40,-90},{-60,-70}})));
equation
  connect(terBus.outSig, outSig.u) annotation (Line(
      points={{40,0},{40,-40},{-38,-40}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(inpSig.y, terBus.inpSig) annotation (Line(points={{-39,0},{40,0}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(terBus.staAhu, staAhu.u) annotation (Line(
      points={{40.1,0.1},{40.1,-80},{-38,-80}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end DummyTerminal;
