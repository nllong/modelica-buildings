within Buildings.Experimental.Templates.Commercial.VAV.Controller;
model DummyCentralBug
  "Central system to which the terminal units are connected, e.g., AHU or plant"
  extends Modelica.Blocks.Icons.Block;
  parameter Integer nTer = 5
    "Number of connected terminal units";
  parameter Boolean tesStaAhu = false
    "Boolean flag for testing staAhu";
  Modelica.Blocks.Sources.RealExpression outSig[nTer](y={i for i in 1:nTer})
    "Output signal to terminal units"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Blocks.Routing.RealPassThrough inpSig[nTer]
    annotation (Placement(transformation(extent={{-40,-50},{-60,-30}})));
  BaseClasses.TerminalBus terBus[nTer]
    annotation (Placement(transformation(extent={{12,-20},{52,20}})));
equation
  connect(outSig.y, terBus.outSig) annotation (Line(points={{-39,0},{32,0}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(inpSig.u, terBus.inpSig) annotation (Line(points={{-38,-40},{32,-40},
          {32,0}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (                                         Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-80,-60},{60,20}})));
end DummyCentralBug;
