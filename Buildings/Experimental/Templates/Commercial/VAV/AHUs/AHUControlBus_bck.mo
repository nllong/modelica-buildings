within Buildings.Experimental.Templates.Commercial.VAV.AHUs;
model AHUControlBus_bck "VAV air handler unit with expandable connector"
  replaceable package MediumAir = Buildings.Media.Air "Medium model for air";
  replaceable package MediumWat = Buildings.Media.Water "Medium model for water";

  parameter Modelica.SIunits.MassFlowRate mAir_flow_nominal "Nominal air mass flow rate";

  parameter Modelica.SIunits.MassFlowRate mWatHeaCoi_flow_nominal
    "Nominal water mass flow rate for heating coil"
    annotation(Dialog(group="Heating coil"));

  parameter Modelica.SIunits.HeatFlowRate QHeaCoi_flow_nominal(min=0)=
    mAir_flow_nominal * (THeaCoiAirIn_nominal-THeaCoiAirOut_nominal)*1006
    "Nominal heat transfer of heating coil";
  parameter Modelica.SIunits.Temperature THeaCoiAirIn_nominal=281.65
    "Nominal air inlet temperature heating coil"
    annotation(Dialog(group="Heating coil"));
  parameter Modelica.SIunits.Temperature THeaCoiAirOut_nominal=313.65
    "Nominal air inlet temperature heating coil"
    annotation(Dialog(group="Heating coil"));
  parameter Modelica.SIunits.Temperature THeaCoiWatIn_nominal=318.15
    "Nominal water inlet temperature heating coil"
    annotation(Dialog(group="Heating coil"));
  parameter Modelica.SIunits.Temperature THeaCoiWatOut_nominal=THeaCoiWatIn_nominal-QHeaCoi_flow_nominal/mWatHeaCoi_flow_nominal/4200
    "Nominal water inlet temperature heating coil"
    annotation(Dialog(group="Heating coil"));

  parameter Modelica.SIunits.PressureDifference dpHeaCoiWat_nominal(
    min=0,
    displayUnit="Pa") = 3000
    "Water-side pressure drop of heating coil"
    annotation(Dialog(group="Heating coil"));

  parameter Modelica.SIunits.PressureDifference dpSup_nominal(
    min=0,
    displayUnit="Pa") = 500
    "Pressure difference of supply air leg (coils and filter)";

  parameter Modelica.SIunits.PressureDifference dpRet_nominal(
    min=0,
    displayUnit="Pa") = 50
    "Pressure difference of supply air leg (coils and filter)";

  parameter Modelica.SIunits.PressureDifference dpFanSup_nominal(
    min=Modelica.Constants.small,
    displayUnit="Pa")
    "Fan head at mAir_flow_nominal and full speed";

  /* Fixme: This should be constrained to all fans, not all movers */
  replaceable parameter Fluid.Movers.Data.Generic datFanSup(
    pressure(
      V_flow={0,mAir_flow_nominal/1.2*2},
      dp=2*{dpFanSup_nominal,0}))
      constrainedby Fluid.Movers.Data.Generic
    "Performance data for supply fan"
    annotation (
      choicesAllMatching=true,
      Dialog(
        group="Fan"),
    Placement(transformation(extent={{318,-294},{338,-274}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_freAir(redeclare package Medium =
        MediumAir) "Fresh air intake" annotation (Placement(transformation(
          extent={{-410,-150},{-390,-130}}),
                                         iconTransformation(extent={{-110,10},{
            -90,30}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_exhAir(redeclare package Medium =
        MediumAir) "Exhaust air" annotation (Placement(transformation(extent={{-410,-230},{-390,-210}}),
                               iconTransformation(extent={{-110,-30},{-90,-10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_supAir(redeclare package Medium =
        MediumAir) "Supply air" annotation (Placement(transformation(extent={{390,-230},{410,-210}}),
                         iconTransformation(extent={{90,-30},{110,-10}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_retAir(redeclare package Medium =
        MediumAir) "Return air"
    annotation (Placement(transformation(extent={{392,-150},{412,-130}}),
        iconTransformation(extent={{90,10},{110,30}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_cooCoiIn(redeclare package Medium
      = MediumWat) "Cooling coil inlet"
    annotation (Placement(transformation(extent={{110,-410},{130,-390}}),
        iconTransformation(extent={{70,-110},{90,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_CooCoiOut(redeclare package Medium
      = MediumWat) "Cooling coil outlet" annotation (Placement(transformation(
          extent={{30,-410},{50,-390}}), iconTransformation(extent={{30,-110},{
            50,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_heaCoiIn(redeclare package Medium
      = MediumWat) "Heating coil inlet"
    annotation (Placement(transformation(extent={{-50,-410},{-30,-390}}),
        iconTransformation(extent={{-50,-110},{-30,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_heaCoiOut(redeclare package Medium
      = MediumWat) "Heating coil outlet"
    annotation (Placement(transformation(extent={{-130,-410},{-110,-390}}),
        iconTransformation(extent={{-90,-110},{-70,-90}})));

  Fluid.HeatExchangers.DryCoilEffectivenessNTU heaCoi(
    redeclare package Medium1 = MediumWat,
    redeclare package Medium2 = MediumAir,
    m1_flow_nominal=mWatHeaCoi_flow_nominal,
    m2_flow_nominal=mAir_flow_nominal,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    use_Q_flow_nominal=true,
    Q_flow_nominal=QHeaCoi_flow_nominal,
    dp1_nominal=dpHeaCoiWat_nominal,
    dp2_nominal=0,
    T_a1_nominal=THeaCoiWatIn_nominal,
    T_a2_nominal=THeaCoiAirIn_nominal)
    "Heating coil"
    annotation (Placement(transformation(extent={{20,-216},{0,-236}})));

  Fluid.HeatExchangers.WetCoilCounterFlow cooCoi(
    redeclare package Medium1 = MediumWat,
    redeclare package Medium2 = MediumAir,
    UA_nominal=mAir_flow_nominal*1000*15/
        Buildings.Fluid.HeatExchangers.BaseClasses.lmtd(
        T_a1=datCooCoi.TWatIn_nominal,
        T_b1=datCooCoi.TWatOut_nominal,
        T_a2=datCooCoi.TAirIn_nominal,
        T_b2=datCooCoi.TOut_nominal),
    m1_flow_nominal=datCooCoi.mWat_flow_nominal,
    m2_flow_nominal=datCooCoi.mAir_flow_nominal,
    dp1_nominal=datCooCoi.dpWat_nominal,
    dp2_nominal=datCooCoi.dpAir_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Cooling coil"
    annotation (Placement(transformation(extent={{82,-216},{62,-236}})));

  Fluid.FixedResistances.PressureDrop resSup(
    redeclare package Medium = MediumAir,
    m_flow_nominal=mAir_flow_nominal,
    dp_nominal=dpSup_nominal)
    "Pressure drop of heat exchangers and filter combined"
    annotation (Placement(transformation(extent={{140,-230},{160,-210}})));

  Fluid.Sensors.TemperatureTwoPort senTMix(
    redeclare package Medium = MediumAir,
    m_flow_nominal=mAir_flow_nominal) "Mixed air temperature sensor"
    annotation (Placement(transformation(extent={{-60,-230},{-40,-210}})));

  Buildings.Examples.VAVReheat.BaseClasses.MixingBox eco(
    redeclare package Medium = MediumAir,
    mOut_flow_nominal=mAir_flow_nominal,
    dpOut_nominal=10,
    mRec_flow_nominal=mAir_flow_nominal,
    dpRec_nominal=10,
    mExh_flow_nominal=mAir_flow_nominal,
    dpExh_nominal=10,
    from_dp=false) "Economizer" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,-178})));

  Fluid.Sensors.TemperatureTwoPort senTSup(
    redeclare package Medium = MediumAir,
    m_flow_nominal=mAir_flow_nominal) "Supply air temperature sensor"
    annotation (Placement(transformation(extent={{310,-230},{330,-210}})));
  Fluid.Sensors.TemperatureTwoPort TRet(
    redeclare package Medium = MediumAir,
    m_flow_nominal=mAir_flow_nominal) "Return air temperature sensor"
    annotation (Placement(transformation(extent={{360,-150},{340,-130}})));
  Fluid.FixedResistances.PressureDrop resRet(
    redeclare package Medium = MediumAir,
    m_flow_nominal=mAir_flow_nominal,
    dp_nominal=dpRet_nominal)
                  "Pressure drop for return duct"
    annotation (Placement(transformation(extent={{160,-150},{140,-130}})));
  Fluid.Movers.SpeedControlled_y fanSup(
    redeclare package Medium = MediumAir,
    per=datFanSup,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Supply air fan"
    annotation (Placement(transformation(extent={{220,-210},{240,-230}})));

  Fluid.Sensors.VolumeFlowRate senVOut_flow(
    redeclare package Medium = MediumAir,
    m_flow_nominal=mAir_flow_nominal)
    "Outside air volume flow rate"
    annotation (Placement(transformation(extent={{-160,-150},{-140,-130}})));

  parameter Data.CoolingCoil datCooCoi
    annotation (Placement(transformation(extent={{320,-340},{340,-320}})));

  BaseClasses.AhuBus ahuBus annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-400,0}),   iconTransformation(extent={{-10,90},{10,110}})));

  Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller conAHU1
    annotation (Placement(transformation(extent={{-320,128},{-240,240}})));
protected
  BaseClasses.AhuSubBusO ahuSubBusO
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-354,20}),
        iconTransformation(extent={{-82,54},{-62,74}})));
  BaseClasses.AhuSubBusI ahuSubBusI
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-354,-20}),
        iconTransformation(extent={{-82,80},{-62,100}})));
equation
  connect(eco.port_Out, senVOut_flow.port_b) annotation (Line(points={{-100,-172},{-120,-172},{-120,-140},{-140,-140}},
                                        color={0,127,255}));
  connect(eco.port_Ret, senTMix.port_a) annotation (Line(points={{-80,-184},{-68,-184},{-68,-220},{-60,-220}},
                                color={0,127,255}));
  connect(senTMix.port_b, heaCoi.port_a2)
    annotation (Line(points={{-40,-220},{0,-220}}, color={0,127,255}));
  connect(heaCoi.port_b2, cooCoi.port_a2)
    annotation (Line(points={{20,-220},{62,-220}},
                                                color={0,127,255}));
  connect(resSup.port_b, fanSup.port_a)
    annotation (Line(points={{160,-220},{220,-220}},
                                                   color={0,127,255}));
  connect(senVOut_flow.port_a, port_freAir) annotation (Line(points={{-160,-140},{-400,-140}},
                                         color={0,127,255}));
  connect(eco.port_Exh, port_exhAir) annotation (Line(points={{-100,-184},{-120,-184},{-120,-220},{-400,-220}},
                                  color={0,127,255}));
  connect(senTSup.port_b, port_supAir)
    annotation (Line(points={{330,-220},{400,-220}},
                                                   color={0,127,255}));
  connect(TRet.port_a, port_retAir)
    annotation (Line(points={{360,-140},{402,-140}},
                                                 color={0,127,255}));
  connect(cooCoi.port_a1, port_cooCoiIn) annotation (Line(points={{82,-232},{120,-232},{120,-400}},
                                            color={0,127,255}));
  connect(cooCoi.port_b1, port_CooCoiOut) annotation (Line(points={{62,-232},{50,-232},{50,-400},{40,-400}},
                                      color={0,127,255}));
  connect(heaCoi.port_a1, port_heaCoiIn) annotation (Line(points={{20,-232},{30,-232},{30,-360},{-40,-360},{-40,-400}},
                                           color={0,127,255}));
  connect(heaCoi.port_b1, port_heaCoiOut) annotation (Line(points={{0,-232},{-20,-232},{-20,-340},{-120,-340},{-120,
          -400}},                                   color={0,127,255}));

  connect(TRet.port_b, resRet.port_a)
    annotation (Line(points={{340,-140},{160,-140}},
                                                 color={0,127,255}));
  connect(resRet.port_b, eco.port_Sup) annotation (Line(points={{140,-140},{-68,-140},{-68,-172},{-80,-172}},
                            color={0,127,255}));
  connect(fanSup.port_b, senTSup.port_a)
    annotation (Line(points={{240,-220},{310,-220}},
                                                   color={0,127,255}));
  connect(cooCoi.port_b2, resSup.port_a)
    annotation (Line(points={{82,-220},{140,-220}},
                                                  color={0,127,255}));
  connect(ahuSubBusO.yFanSup, fanSup.y) annotation (Line(
      points={{-354,20},{230,20},{230,-232}},
      color={255,204,51},
      thickness=0.5));
  connect(senTMix.T, ahuSubBusI.TAirLvgMix) annotation (Line(points={{-50,-209},{-50,-20},{-354,-20}},
                                 color={0,0,127}));
  connect(ahuSubBusO, ahuBus.ahuO) annotation (Line(
      points={{-354,20},{-378,20},{-378,0.1},{-400.1,0.1}},
      color={255,204,51},
      thickness=0.5));
  connect(senTSup.T, ahuSubBusI.TAirSup) annotation (Line(points={{320,-209},{320,-20},{-354,-20}},
                                color={0,0,127}));
  connect(TRet.T, ahuSubBusI.TAirRet)
    annotation (Line(points={{350,-129},{350,-20},{-354,-20}},
                                                             color={0,0,127}));
  connect(senVOut_flow.V_flow, ahuSubBusI.VFloAirOut) annotation (Line(points={{-150,-129},{-150,-20},{-354,-20}},
                                            color={0,0,127}));
  connect(port_supAir, port_supAir) annotation (Line(points={{400,-220},{400,-220}},
                                color={0,127,255}));
  connect(ahuSubBusO.yEcoOut, eco.yOut) annotation (Line(
      points={{-354,20},{-90,20},{-90,-166}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(ahuSubBusO.yEcoExh, eco.yExh) annotation (Line(
      points={{-354,20},{-82,20},{-82,-166},{-83,-166}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(conAHU1.ySupFan, ahuSubBusO.ySupFan) annotation (Line(points={{-236,222},{-180,222},{-180,20},{-354,20}},
        color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(ahuSubBusO.yEcoRet, eco.yRet) annotation (Line(
      points={{-354,20},{-96,20},{-96,-166},{-96.8,-166}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(conAHU1.ySupFanSpe, ahuSubBusO.ySupFanSpe) annotation (Line(points={{-236,210},{-186,210},{-186,20},{-354,20}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(conAHU1.TSupSet, ahuSubBusO.tSupSet) annotation (Line(points={{-236,202},{-194,202},{-194,20},{-354,20}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(conAHU1.yHea, ahuSubBusO.yHea) annotation (Line(points={{-236,194},{-200,194},{-200,20},{-354,20}}, color={0,
          0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(conAHU1.yCoo, ahuSubBusO.yCoo) annotation (Line(points={{-236,184},{-208,184},{-208,20},{-354,20}}, color={0,
          0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(conAHU1.yRetDamPos, ahuSubBusO.yRetDamPos) annotation (Line(points={{-236,176},{-214,176},{-214,20},{-354,20}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(ahuSubBusI, conAHU1.TZonHeaSet) annotation (Line(
      points={{-354,-20},{-340,-20},{-340,238},{-324,238}},
      color={255,204,51},
      thickness=0.5));
  connect(ahuSubBusI, conAHU1.TZonCooSet) annotation (Line(
      points={{-354,-20},{-340,-20},{-340,232},{-324,232}},
      color={255,204,51},
      thickness=0.5));
  connect(ahuSubBusI, conAHU1.TOut) annotation (Line(
      points={{-354,-20},{-340,-20},{-340,220},{-324,220}},
      color={255,204,51},
      thickness=0.5));
  connect(ahuSubBusI, conAHU1.VDis_flow[1]) annotation (Line(
      points={{-354,-20},{-340,-20},{-340,214},{-324,214}},
      color={255,204,51},
      thickness=0.5));
  connect(ahuSubBusI, conAHU1.ducStaPre) annotation (Line(
      points={{-354,-20},{-340,-20},{-340,208},{-324,208}},
      color={255,204,51},
      thickness=0.5));
  connect(ahuSubBusI.TDis, conAHU1.TDis) annotation (Line(
      points={{-354,-20},{-340,-20},{-340,194},{-324,194}},
      color={255,204,51},
      thickness=0.5));
  connect(ahuSubBusI, conAHU1.TZon[1]) annotation (Line(
      points={{-354,-20},{-340,-20},{-340,198},{-324,198}},
      color={255,204,51},
      thickness=0.5));
  connect(ahuSubBusI, conAHU1.TSup) annotation (Line(
      points={{-354,-20},{-340,-20},{-340,188},{-324,188}},
      color={255,204,51},
      thickness=0.5));
  connect(ahuSubBusI, conAHU1.TOutCut) annotation (Line(
      points={{-354,-20},{-340,-20},{-340,182},{-324,182}},
      color={255,204,51},
      thickness=0.5));
  connect(ahuSubBusI, conAHU1.VOut_flow) annotation (Line(
      points={{-354,-20},{-340,-20},{-340,164},{-324,164}},
      color={255,204,51},
      thickness=0.5));
  connect(ahuSubBusI, conAHU1.TMix) annotation (Line(
      points={{-354,-20},{-340,-20},{-340,158},{-324,158}},
      color={255,204,51},
      thickness=0.5));
  connect(ahuSubBusI, conAHU1.uOpeMod) annotation (Line(
      points={{-354,-20},{-340,-20},{-340,152},{-324,152}},
      color={255,204,51},
      thickness=0.5));
  connect(ahuSubBusI, conAHU1.uZonTemResReq) annotation (Line(
      points={{-354,-20},{-340,-20},{-340,146},{-324,146}},
      color={255,204,51},
      thickness=0.5));
  connect(ahuSubBusI, conAHU1.uZonPreResReq) annotation (Line(
      points={{-354,-20},{-340,-20},{-340,140},{-324,140}},
      color={255,204,51},
      thickness=0.5));
  connect(conAHU1.yOutDamPos, ahuSubBusO.yOutDamPos) annotation (Line(points={{-236,156},{-220,156},{-220,20},{-354,20}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(ahuSubBusI, ahuBus.ahuI) annotation (Line(
      points={{-354,-20},{-378,-20},{-378,0.1},{-400.1,0.1}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (
    defaultComponentName="ahu",
    Diagram(coordinateSystem(extent={{-400,-400},{400,340}}), graphics={
        Rectangle(
          extent={{-400,60},{400,-60}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={245,239,184},
          pattern=LinePattern.None),
        Text(
          extent={{-366,-278},{-132,-300}},
          lineColor={28,108,200},
          textString="Equipment section"),
        Text(
          extent={{-104,52},{130,30}},
          lineColor={28,108,200},
          textString="Bus section"),
        Text(
          extent={{-118,298},{116,276}},
          lineColor={28,108,200},
          textString="Controls section"),
        Text(
          extent={{-394,346},{-164,310}},
          lineColor={0,0,0},
          fontSize=10,
          textString=
              "This model is pseudo code: the bus connections are not valid as is. It only illustrates the typical model architecture.")}),
                                                               Icon(
        coordinateSystem(extent={{-100,-100},{100,100}})));
end AHUControlBus_bck;
