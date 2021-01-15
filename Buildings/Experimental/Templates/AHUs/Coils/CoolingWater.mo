within Buildings.Experimental.Templates.AHUs.Coils;
model CoolingWater
  extends Interfaces.Coil(
    final typ=Types.Coil.CoolingWater,
    final have_sou=true,
    final typAct=act.typ);

  outer replaceable parameter Coils.Data.None datCoiCoo
    "Coil data"
    annotation (Placement(transformation(extent={{-10,42},{10,62}})));

  /*
  The following does not work because datCoiCoo is not found in the
  scope where the redeclaration happens.
  Need to use an interface class instead.
  */
  /*
  replaceable Fluid.HeatExchangers.WetCoilCounterFlow coi
    constrainedby Fluid.Interfaces.PartialFourPortInterface(
      redeclare final package Medium1 = MediumSou,
      redeclare final package Medium2 = MediumAir,
      final m1_flow_nominal=datCoiCoo.m1_flow_nominal,
      final m2_flow_nominal=datCoiCoo.m2_flow_nominal,
      final dp1_nominal=datCoiCoo.dp1_nominal,
      final dp2_nominal=datCoiCoo.dp2_nominal)
    "Coil"
    annotation (choices(
      choice(redeclare replaceable Fluid.HeatExchangers.WetCoilCounterFlow coi(
        final UA_nominal=datCoiCoo.UA_nominal)
          "Discretized model"),
      choice(redeclare replaceable Fluid.HeatExchangers.DryCoilEffectivenessNTU coi(
        final use_Q_flow_nominal=true,
        final configuration=datCoiCoo.configuration,
        final Q_flow_nominal=datCoiCoo.Q_flow_nominal,
        final T_a1_nominal=datCoiCoo.T_a1_nominal,
        final T_a2_nominal=datCoiCoo.T_a2_nominal)
          "Epsilon-NTU model")),
      Placement(transformation(extent={{10,4},{-10,-16}})));
  */

  replaceable Coils.Actuators.None act
    constrainedby Coils.Actuators.None(
      redeclare final package Medium = MediumSou)
    "Actuator"
    annotation (
      choicesAllMatching=true,
      Placement(transformation(extent={{-10,-70},{10,-50}})));

  replaceable HeatExchangers.DryCoilEffectivenessNTU coi
    constrainedby Interfaces.HeatExchanger(
      redeclare final package Medium1 = MediumSou,
      redeclare final package Medium2 = MediumAir)
    "Coil"
    annotation (
      choicesAllMatching=true,
      Placement(transformation(extent={{10,4},{-10,-16}})));
equation
  connect(port_aSou, act.port_aSup) annotation (Line(points={{-40,-100},{-40,-80},
          {-4,-80},{-4,-70}}, color={0,127,255}));
  connect(act.port_bRet, port_bSou) annotation (Line(points={{4,-70},{4,-80},{40,
          -80},{40,-100}}, color={0,127,255}));
  connect(ahuBus.ahuO.yCoiCoo, act.y) annotation (Line(
      points={{0.1,100.1},{0.1,80},{-40,80},{-40,-60},{-11,-60}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(act.port_bSup, coi.port_a1) annotation (Line(points={{-4,-50},{-4,-22},
          {20,-22},{20,-12},{10,-12}}, color={0,127,255}));
  connect(coi.port_b1, act.port_aRet) annotation (Line(points={{-10,-12},{-20,-12},
          {-20,-24},{4,-24},{4,-50}}, color={0,127,255}));
  connect(port_a, coi.port_a2)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(coi.port_b2, port_b) annotation (Line(points={{10,0},{56,0},{56,0},{100,
          0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end CoolingWater;
