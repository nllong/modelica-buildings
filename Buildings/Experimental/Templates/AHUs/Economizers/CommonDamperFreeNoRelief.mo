within Buildings.Experimental.Templates.AHUs.Economizers;
model CommonDamperFreeNoRelief
  "Single common OA damper - Dampers actuated individually, no relief"
  extends Interfaces.Economizer(
    final typ=Types.Economizer.CommonDamperFreeNoRelief);

  outer parameter Economizers.Data.CommonDamperFreeNoRelief datEco
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
  connect(ahuBus.ahuO.yEcoOut, mix.yOut) annotation (Line(
      points={{0.1,100.1},{0.1,56},{0,56},{0,12}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(ahuBus.ahuO.yEcoRet, mix.yRet) annotation (Line(
      points={{0.1,100.1},{-6,100.1},{-6,12},{-6.8,12}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (
  defaultComponentName="eco",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end CommonDamperFreeNoRelief;
