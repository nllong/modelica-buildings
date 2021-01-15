within Buildings.Experimental.Templates.AHUs.Coils.HeatExchangers;
model WetCoilCounterFlow
  extends Interfaces.HeatExchanger(
    final m1_flow_nominal=datCoiCoo.m1_flow_nominal,
    final m2_flow_nominal=datCoiCoo.m2_flow_nominal);

  outer parameter Coils.Data.CoolingWaterDiscretized datCoiCoo
    annotation (Placement(transformation(extent={{-10,-98},{10,-78}})));

  Fluid.HeatExchangers.WetCoilCounterFlow hex(
    redeclare final package Medium1 = Medium1,
    redeclare final package Medium2 = Medium2,
    final m1_flow_nominal=m1_flow_nominal,
    final m2_flow_nominal=m2_flow_nominal,
    final dp1_nominal=datCoiCoo.dp1_nominal,
    final dp2_nominal=datCoiCoo.dp2_nominal,
    final UA_nominal=datCoiCoo.UA_nominal)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
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
end WetCoilCounterFlow;
