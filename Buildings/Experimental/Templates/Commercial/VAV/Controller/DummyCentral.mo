within Buildings.Experimental.Templates.Commercial.VAV.Controller;
model DummyCentral
  "Central system to which the terminal units are connected, e.g., AHU or plant"
  extends Modelica.Blocks.Icons.Block;
  parameter Integer nTer = 5
    "Number of connected terminal units";
  parameter Boolean tesStaAhu = false
    "Boolean flag for testing staAhu";
  Modelica.Blocks.Sources.RealExpression outSig[nTer](y={i for i in 1:nTer})
    "Output signal to terminal units"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  BaseClasses.AhuBus ahuBus(nTer=nTer)
    annotation (Placement(transformation(
          extent={{20,-20},{60,20}}), iconTransformation(extent={{20,-22},{60,
            20}})));
  Controls.OBC.CDL.Logical.Sources.Constant staAhu(k=true) if tesStaAhu
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Modelica.Blocks.Routing.RealPassThrough inpSig[nTer]
    annotation (Placement(transformation(extent={{-40,-50},{-60,-30}})));
equation
  connect(outSig.y, ahuBus.ahuTer.outSig) annotation (Line(points={{-39,0},{0,0},
          {0,0.1},{40.1,0.1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(staAhu.y, ahuBus.staAhu) annotation (Line(points={{-38,40},{40.1,40},{
          40.1,0.1}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(inpSig.u, ahuBus.ahuTer.inpSig) annotation (Line(points={{-38,-40},{
          40.1,-40},{40.1,0.1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (                                         Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-80,-60},{60,60}})));
end DummyCentral;
