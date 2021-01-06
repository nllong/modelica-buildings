within Buildings.Experimental.Templates.AHU.Coils;
model CoolingWater
  extends Interfaces.Coil(
    final typ=Types.Coil.CoolingWater);
  replaceable Fluid.HeatExchangers.WetCoilCounterFlow cooCoi
    constrainedby Buildings.Fluid.Interfaces.PartialFourPortInterface(
      redeclare final package Medium1 = MediumSou,
      redeclare final package Medium2 = MediumAir)
    "Heat exchanger"
    annotation (
      choices(
        choice(redeclare Fluid.HeatExchangers.WetCoilCounterFlow cooCoi
        "Discretized model"),
        choice(redeclare Fluid.HeatExchangers.DryCoilEffectivenessNTU cooCoi
        "Epsilon-NTU model")),
      Placement(transformation(extent={{10,4},{-10,-16}})));

  replaceable Actuators.TwoWayValve twoWayValve
    constrainedby Interfaces.Actuator(
      redeclare final package Medium = MediumSou)
    annotation (
      choicesAllMatching=true,
      Placement(transformation(extent={{-10,-70},{10,-50}})));
equation
  connect(port_a, cooCoi.port_a2)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(cooCoi.port_b2, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(port_aSou, twoWayValve.port_aSup) annotation (Line(points={{-40,-100},
          {-40,-80},{-4,-80},{-4,-70}}, color={0,127,255}));
  connect(twoWayValve.port_bSup, cooCoi.port_b1) annotation (Line(points={{-4,-50},
          {-4,-40},{-20,-40},{-20,-12},{-10,-12}}, color={0,127,255}));
  connect(cooCoi.port_a1, twoWayValve.port_aRet) annotation (Line(points={{10,-12},
          {20,-12},{20,-40},{4,-40},{4,-50}}, color={0,127,255}));
  connect(twoWayValve.port_bRet, port_bSou) annotation (Line(points={{4,-70},{4,
          -80},{40,-80},{40,-100}}, color={0,127,255}));
  connect(twoWayValve.y, y) annotation (Line(points={{-11,-60},{-40,-60},{-40,
          80},{0,80},{0,120}},
                           color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end CoolingWater;
