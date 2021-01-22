within Buildings.Experimental.Templates.AHUs.Economizers;
model DedicatedDamperTandem
  extends Interfaces.Economizer(
    final typ=Types.Economizer.DedicatedDamperTandem);

  outer parameter Economizers.Data.DedicatedDamperTandem datEco
    annotation (Placement(transformation(extent={{-10,-98},{10,-78}})));

  Fluid.Actuators.Dampers.MixingBoxMinimumFlow mix(
    redeclare final package Medium = Medium,
    final mOut_flow_nominal=datEco.mOut_flow_nominal,
    final mOutMin_flow_nominal=datEco.mOutMin_flow_nominal,
    final mRec_flow_nominal=datEco.mRec_flow_nominal,
    final mExh_flow_nominal=datEco.mExh_flow_nominal,
    final dpDamExh_nominal=datEco.dpDamExh_nominal,
    final dpDamOut_nominal=datEco.dpDamOut_nominal,
    final dpDamOutMin_nominal=datEco.dpDamOutMin_nominal,
    final dpDamRec_nominal=datEco.dpDamRec_nominal)
    annotation (Placement(transformation(extent={{-10,-12},{10,8}})));

equation
  connect(port_OutMin, mix.port_OutMin) annotation (Line(points={{-100,0},{-60,0},
          {-60,8},{-10,8}}, color={0,127,255}));
  connect(port_Out, mix.port_Out) annotation (Line(points={{-100,-60},{-20,-60},
          {-20,4},{-10,4}}, color={0,127,255}));
  connect(mix.port_Sup, port_Sup) annotation (Line(points={{10,4},{20,4},{20,-60},
          {100,-60}}, color={0,127,255}));
  connect(mix.port_Ret, port_Ret) annotation (Line(points={{10,-8},{40,-8},{40,
          60},{100,60}}, color={0,127,255}));
  connect(port_Exh, mix.port_Exh) annotation (Line(points={{-100,60},{-40,60},{-40,
          -8},{-10,-8}}, color={0,127,255}));
  connect(ahuBus.ahuO.yEcoOut, mix.y) annotation (Line(
      points={{0.1,100.1},{0.1,56},{0,56},{0,10}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(ahuBus.ahuO.yEcoOutMin, mix.yOutMin) annotation (Line(
      points={{0.1,100.1},{-6,100.1},{-6,10}},
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
end DedicatedDamperTandem;
