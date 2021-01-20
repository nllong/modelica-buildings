within Buildings.Experimental.Templates.AHUs.Coils.Actuators;
model ThreeWayValve
  extends Interfaces.Actuator(
    final typ=Types.Actuator.TwoWayValve);

  outer parameter Buildings.Experimental.Templates.AHUs.Coils.Data.WaterBased
    datCoi annotation (Placement(transformation(extent={{-10,-98},{10,-78}})));

  replaceable Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear val
    constrainedby Fluid.Actuators.BaseClasses.PartialThreeWayValve(
      redeclare final package Medium=Medium,
      final m_flow_nominal=datCoi.mWat_flow_nominal,
      final dpValve_nominal=datCoi.datAct.dpValve_nominal,
      final dpFixed_nominal=datCoi.datAct.dpFixed_nominal)
    annotation (
      choicesAllMatching=true,
      Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={40,0})));
  Fluid.FixedResistances.Junction jun(dp_nominal=fill(0, 3)) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,0})));
equation
  connect(port_aRet, val.port_a)
    annotation (Line(points={{40,100},{40,10}}, color={0,127,255}));
  connect(val.port_b, port_bRet)
    annotation (Line(points={{40,-10},{40,-100}}, color={0,127,255}));
  connect(y, val.y)
    annotation (Line(points={{-120,0},{-80,0},{-80,20},{60,20},{60,2.22045e-15},
          {52,2.22045e-15}},                   color={0,0,127}));
  connect(jun.port_3, val.port_3)
    annotation (Line(points={{-30,0},{30,0}}, color={0,127,255}));
  connect(port_aSup, jun.port_1)
    annotation (Line(points={{-40,-100},{-40,-10}}, color={0,127,255}));
  connect(jun.port_2, port_bSup)
    annotation (Line(points={{-40,10},{-40,100}}, color={0,127,255}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ThreeWayValve;
