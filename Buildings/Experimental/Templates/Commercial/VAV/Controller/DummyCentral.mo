within Buildings.Experimental.Templates.Commercial.VAV.Controller;
model DummyCentral
  "Central system to which the terminal units are connected, e.g., AHU or plant"
  extends Modelica.Blocks.Icons.Block;
  parameter Integer nCon = 5
    "Number of connected components";
  Modelica.Blocks.Sources.RealExpression outSig[nCon](y={i for i in 1:nCon})
    "Output signal to terminal units"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Blocks.Routing.RealPassThrough inpSig[nCon]
    annotation (Placement(transformation(extent={{-40,-50},{-60,-30}})));
  BaseClasses.AhuBus ahuBus(nTer=nCon) annotation (Placement(transformation(
          extent={{20,-20},{60,20}}), iconTransformation(extent={{20,-22},{60,
            20}})));
  Controls.OBC.CDL.Logical.Sources.Constant con(k=true)
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
equation
  connect(outSig.y, ahuBus.ahuTer.outSig) annotation (Line(points={{-39,0},{0,0},
          {0,0.1},{40.1,0.1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(ahuBus.ahuTer.inpSig, inpSig.u) annotation (Line(
      points={{40.1,0.1},{40.1,-40},{-38,-40}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(con.y, ahuBus.staAhu) annotation (Line(points={{-38,40},{40.1,40},{
          40.1,0.1}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end DummyCentral;
