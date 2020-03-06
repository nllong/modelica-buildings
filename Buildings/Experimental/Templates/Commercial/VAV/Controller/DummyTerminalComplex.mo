within Buildings.Experimental.Templates.Commercial.VAV.Controller;
model DummyTerminalComplex
  extends Modelica.Blocks.Icons.Block;
  parameter Integer indTer
    "Terminal index used for testing purposes";
  Modelica.Blocks.Sources.RealExpression inpSig(y=time*indTer)
    "Input signal to AHU controller"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Blocks.Routing.RealPassThrough outSig
    annotation (Placement(transformation(extent={{-40,-50},{-60,-30}})));
  BaseClasses.AhuBus ahuBus annotation (Placement(transformation(extent={{40,-20},
            {80,20}}), iconTransformation(extent={{-4,-10},{16,10}})));
protected
  BaseClasses.AhuSubBusI ahuSubBusI
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  BaseClasses.AhuSubBusO ahuSubBusO
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
equation
  connect(inpSig.y, ahuSubBusI.inpSig) annotation (Line(points={{-39,0},{0,0}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(ahuSubBusI, ahuBus.ahuI) annotation (Line(
      points={{0,0},{36,0},{36,0.1},{60.1,0.1}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(ahuBus.ahuO, ahuSubBusO) annotation (Line(
      points={{60.1,0.1},{60.1,-40},{0,-40}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(ahuSubBusO.outSig, outSig.u) annotation (Line(
      points={{0,-40},{-38,-40}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end DummyTerminalComplex;
