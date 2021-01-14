within Buildings.Experimental.Templates.AHUs.Coils;
model CoolingWater
  extends Interfaces.Coil(
    final typ=Types.Coil.CoolingWater,
    final have_sou=true,
    final have_y=act.typ<>Types.Actuator.None);

  outer replaceable parameter Data.CoolingWater datCoi
    constrainedby Data.CoolingWater
    annotation (Placement(transformation(extent={{-10,42},{10,62}})));

  replaceable Fluid.HeatExchangers.WetCoilCounterFlow coi
    constrainedby Fluid.Interfaces.PartialFourPortInterface(
      redeclare final package Medium1 = MediumSou,
      redeclare final package Medium2 = MediumAir,
      final m1_flow_nominal=datCoi.m1_flow_nominal,
      final m2_flow_nominal=datCoi.m2_flow_nominal)
    "Coil"
    annotation (
      choices(
        choice(redeclare Fluid.HeatExchangers.WetCoilCounterFlow cooCoi
          "Discretized model"),
        choice(redeclare Fluid.HeatExchangers.DryCoilEffectivenessNTU cooCoi
          "Epsilon-NTU model")),
      Placement(transformation(extent={{10,4},{-10,-16}})));

  replaceable Actuators.TwoWayValve act
    constrainedby Interfaces.Actuator(
      redeclare final package Medium = MediumSou)
    annotation (
      choicesAllMatching=true, Placement(transformation(extent={{-10,-70},{10,-50}})));

equation
  connect(port_a, coi.port_a2)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(coi.port_b2, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(port_aSou, act.port_aSup) annotation (Line(points={{-40,-100},{-40,-80},
          {-4,-80},{-4,-70}}, color={0,127,255}));
  connect(act.port_bSup, coi.port_b1) annotation (Line(points={{-4,-50},{-4,-40},
          {-20,-40},{-20,-12},{-10,-12}}, color={0,127,255}));
  connect(coi.port_a1, act.port_aRet) annotation (Line(points={{10,-12},{20,-12},
          {20,-40},{4,-40},{4,-50}}, color={0,127,255}));
  connect(act.port_bRet, port_bSou) annotation (Line(points={{4,-70},{4,-80},{40,
          -80},{40,-100}}, color={0,127,255}));
  connect(act.y, y) annotation (Line(points={{-11,-60},{-80,-60},{-80,120}},
                    color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end CoolingWater;
