within Buildings.Experimental.Templates.AHUs.Economizers;
model CommonDamperFreeNoRelief
  "Single common OA damper - Dampers actuated individually, no relief"
  extends Interfaces.Economizer(
    final typ=Types.Economizer.CommonDamperFreeNoRelief);

  outer parameter Data.CommonDamperFreeNoRelief datEco
    annotation (Placement(transformation(extent={{-10,-98},{10,-78}})));

  BaseClasses.MixingBoxFreeNoRelief mix(
    redeclare final package Medium = Medium,
    final mOut_flow_nominal=datEco.mOut_flow_nominal,
    final mRec_flow_nominal=datEco.mRec_flow_nominal,
    final dpOut_nominal=datEco.dpDamOut_nominal,
    final dpRec_nominal=datEco.dpDamRec_nominal)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

equation
  connect(port_Out, mix.port_Out) annotation (Line(points={{-100,-60},{-20,-60},
          {-20,6},{-10,6}}, color={0,127,255}));
  connect(mix.port_Sup, port_Sup) annotation (Line(points={{10,6},{20,6},{20,-60},
          {100,-60}}, color={0,127,255}));
  connect(mix.port_Ret, port_Ret) annotation (Line(points={{10,-6},{40,-6},{40,60},
          {100,60}},     color={0,127,255}));
  connect(yOut, mix.yOut)
    annotation (Line(points={{0,120},{0,12}}, color={0,0,127}));
  connect(yRet, mix.yRet) annotation (Line(points={{80,120},{80,20},{-6.8,20},{-6.8,
          12}}, color={0,0,127}));
  annotation (
  defaultComponentName="eco",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end CommonDamperFreeNoRelief;
