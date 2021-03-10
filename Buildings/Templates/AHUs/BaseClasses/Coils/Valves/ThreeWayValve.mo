within Buildings.Templates.AHUs.BaseClasses.Coils.Valves;
model ThreeWayValve "Three-way valve"
  extends Interfaces.Valve(
    final typ=Types.Actuator.ThreeWayValve);
  extends Data.ThreeWayValve
    annotation (IconMap(primitivesVisible=false));

  replaceable Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear val(
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    constrainedby Fluid.Actuators.BaseClasses.PartialThreeWayValve(
      redeclare final package Medium=Medium,
      final m_flow_nominal=mWat_flow_nominal,
      final dpValve_nominal=dpValve_nominal,
      final dpFixed_nominal=dpFixed_nominal)
    "Valve"
    annotation (
      choicesAllMatching=true,
      Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={40,0})));
  Fluid.FixedResistances.Junction jun(
    redeclare final package Medium=Medium,
    final m_flow_nominal=mWat_flow_nominal * {1, -1, -1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    dp_nominal=fill(0, 3))
    "Junction"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,0})));
equation
  connect(y, val.y)
    annotation (Line(points={{-120,0},{-80,0},{-80,20},{60,20},{60,2.22045e-15},
          {52,2.22045e-15}},                   color={0,0,127}));
  connect(port_aSup, jun.port_1)
    annotation (Line(points={{-40,-100},{-40,-10}}, color={0,127,255}));
  connect(jun.port_2, port_bSup)
    annotation (Line(points={{-40,10},{-40,100}}, color={0,127,255}));
  connect(jun.port_3, val.port_3)
    annotation (Line(points={{-30,0},{30,0}}, color={0,127,255}));
  connect(val.port_2, port_bRet) annotation (Line(points={{40,-10},{40,-100},{
          40,-100}}, color={0,127,255}));
  connect(val.port_1, port_aRet)
    annotation (Line(points={{40,10},{40,100},{40,100}}, color={0,127,255}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ThreeWayValve;