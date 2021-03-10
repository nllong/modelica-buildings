within Buildings.Templates.AHUs.BaseClasses.Coils;
model WaterBased
  extends Interfaces.Coil(
    final typ=Types.Coil.WaterBased,
    final have_weaBus=false,
    final have_sou=true,
    final typAct=act.typ,
    final typHex=hex.typ);
  extends Data.WaterBased
    annotation (IconMap(primitivesVisible=false));

  replaceable Valves.None act constrainedby Interfaces.Valve(redeclare final
      package Medium = MediumSou) "Actuator" annotation (choicesAllMatching=
        true, Placement(transformation(extent={{-10,-70},{10,-50}})));

  // TODO: conditional choices based on funStr to restrict HX models for cooling.
  replaceable HeatExchangers.DryCoilEffectivenessNTU hex constrainedby
    Interfaces.HeatExchangerWater(
    redeclare final package Medium1 = MediumSou,
    redeclare final package Medium2 = MediumAir,
    final m1_flow_nominal=mWat_flow_nominal,
    final m2_flow_nominal=mAir_flow_nominal,
    final dp1_nominal=if typAct==Types.Actuator.None then dpWat_nominal else 0,
    final dp2_nominal=dpAir_nominal)
    "Heat exchanger"
    annotation (
      choicesAllMatching=true,
      Placement(transformation(extent={{10,4},{-10,-16}})));
  Modelica.Blocks.Routing.RealPassThrough sigCoo if funStr=="Cooling"
    "Cooling control signal"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,50})));
  Modelica.Blocks.Routing.RealPassThrough sigHea if funStr=="Heating"
    "Heating control signal" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={20,50})));
equation

  connect(port_aSou, act.port_aSup) annotation (Line(points={{-40,-100},{-40,-80},
          {-4,-80},{-4,-70}}, color={0,127,255}));
  connect(act.port_bRet, port_bSou) annotation (Line(points={{4,-70},{4,-80},{40,
          -80},{40,-100}}, color={0,127,255}));
  connect(act.port_bSup,hex. port_a1) annotation (Line(points={{-4,-50},{-4,-22},
          {20,-22},{20,-12},{10,-12}}, color={0,127,255}));
  connect(hex.port_b1, act.port_aRet) annotation (Line(points={{-10,-12},{-20,-12},
          {-20,-24},{4,-24},{4,-50}}, color={0,127,255}));
  connect(port_a,hex. port_a2)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(hex.port_b2, port_b) annotation (Line(points={{10,0},{56,0},{56,0},{100,
          0}}, color={0,127,255}));

  connect(ahuBus.ahuO.yCoiCoo, sigCoo.u) annotation (Line(
      points={{0.1,100.1},{0.1,100},{-20,100},{-20,62}},
      color={255,204,51},
      thickness=0.5));
  connect(ahuBus.ahuO.yCoiHea, sigHea.u) annotation (Line(
      points={{0.1,100.1},{10,100.1},{10,100},{20,100},{20,62}},
      color={255,204,51},
      thickness=0.5));
  connect(sigCoo.y, act.y) annotation (Line(points={{-20,39},{-20,20},{-40,20},{
          -40,-60},{-11,-60}}, color={0,0,127}));
  connect(sigHea.y, act.y) annotation (Line(points={{20,39},{20,20},{40,20},{40,
          -40},{-20,-40},{-20,-60},{-11,-60}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end WaterBased;