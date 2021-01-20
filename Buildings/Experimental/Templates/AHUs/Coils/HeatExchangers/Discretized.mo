within Buildings.Experimental.Templates.AHUs.Coils.HeatExchangers;
model Discretized
  extends Interfaces.HeatExchanger(
    final m1_flow_nominal=datCoi.mWat_flow_nominal,
    final m2_flow_nominal=datCoi.mAir_flow_nominal,
    final typ=Types.HeatExchanger.Discretized);

  outer parameter Buildings.Experimental.Templates.AHUs.Coils.Data.WaterBased
    datCoi annotation (Placement(transformation(extent={{-10,-98},{10,-78}})));

  Fluid.HeatExchangers.WetCoilCounterFlow hex(
    redeclare final package Medium1 = Medium1,
    redeclare final package Medium2 = Medium2,
    final m1_flow_nominal=m1_flow_nominal,
    final m2_flow_nominal=m2_flow_nominal,
    final dp1_nominal=datCoi.dpWat_nominal,
    final dp2_nominal=datCoi.dpAir_nominal,
    final UA_nominal=datCoi.datHex.UA_nominal,
    final r_nominal=datCoi.datHex.r_nominal,
    final nEle=datCoi.datHex.nEle,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  // This is a dummy initial equation to test fixed=false.
// initial equation
//   hex.UA_nominal = 100;
equation
  connect(port_b2, hex.port_b2) annotation (Line(points={{-100,-60},{-20,-60},{-20,
          -6},{-10,-6}}, color={0,127,255}));
  connect(hex.port_a1, port_a1) annotation (Line(points={{-10,6},{-20,6},{-20,60},
          {-100,60}}, color={0,127,255}));
  connect(hex.port_b1, port_b1) annotation (Line(points={{10,6},{20,6},{20,60},{
          100,60}}, color={0,127,255}));
  connect(hex.port_a2, port_a2) annotation (Line(points={{10,-6},{20,-6},{20,-60},
          {100,-60}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Discretized;
