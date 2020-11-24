within Buildings.Experimental.Templates.Commercial.VAV.AHUs;
model AHULayout "VAV air handler unit with expandable connector"
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
      constrainedby Fluid.Movers.Data.Generic "Performance data for supply fan"
    annotation (
      choicesAllMatching=true,
      Dialog(
        group="Fan"),
    Placement(transformation(extent={{318,-298},{338,-278}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_airOutMin(redeclare package Medium
      = MediumAir) "Outdoor air port for minimum OA damper" annotation (
      Placement(transformation(extent={{-410,-190},{-390,-170}}),
        iconTransformation(extent={{-110,10},{-90,30}})),
        __Linkage(Connect(path="air_sup_min")));
  Modelica.Fluid.Interfaces.FluidPort_a port_airOut(redeclare package Medium =
        MediumAir) "Outdoor air port" annotation (Placement(transformation(
          extent={{-410,-230},{-390,-210}}), iconTransformation(extent={{-110,10},{
            -90,30}})),
        __Linkage(Connect(path="air_ret")));

  Modelica.Fluid.Interfaces.FluidPort_b port_airExh(redeclare package Medium =
        MediumAir) "Exhaust air port" annotation (Placement(transformation(extent={{-410,
            -150},{-390,-130}}), iconTransformation(extent={{-110,-30},{-90,-10}})),
    __Linkage(Connect(path="air_ret")));
  Modelica.Fluid.Interfaces.FluidPort_b port_supAir(redeclare package Medium =
    MediumAir) "Supply air" annotation (Placement(transformation(extent={{390,-230},{410,-210}}),
    iconTransformation(extent={{90,-30},{110,-10}})),
    __Linkage(Connect(path="air_sup")));

  Modelica.Fluid.Interfaces.FluidPort_b port_coiPreHeaRet(redeclare package
      Medium = MediumWat) "Preheat coil return port" annotation (Placement(
        transformation(extent={{-270,-410},{-250,-390}}), iconTransformation(
          extent={{-90,-110},{-70,-90}})),
        __Linkage(Connect(path="chw_sup")));
  Modelica.Fluid.Interfaces.FluidPort_a port_coiPreHeaSup(redeclare package
      Medium = MediumWat) "Preheat coil supply port" annotation (Placement(
        transformation(extent={{-210,-410},{-190,-390}}), iconTransformation(
          extent={{-50,-110},{-30,-90}})),
        __Linkage(Connect(path="phw_sup")));


  Modelica.Fluid.Interfaces.FluidPort_a port_retAir(redeclare package Medium =
        MediumAir) "Return air"
    annotation (Placement(transformation(extent={{390,-150},{410,-130}}),
        iconTransformation(extent={{90,10},{110,30}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_coiCooSup(redeclare package Medium
      = MediumWat) "Cooling coil supply port" annotation (Placement(
        transformation(extent={{-70,-410},{-50,-390}}), iconTransformation(
          extent={{70,-110},{90,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_coiCooRet(redeclare package Medium
      = MediumWat) "Cooling coil return port" annotation (Placement(
        transformation(extent={{-130,-410},{-110,-390}}),
                                                      iconTransformation(extent=
           {{30,-110},{50,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_coiReHeaSup(redeclare package
      Medium = MediumWat) "Reheat coil supply port" annotation (Placement(
        transformation(extent={{70,-410},{90,-390}}),   iconTransformation(
          extent={{-50,-110},{-30,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_coiReHeaRet(redeclare package
      Medium = MediumWat) "Reheat coil return port" annotation (Placement(
        transformation(extent={{10,-410},{30,-390}}),     iconTransformation(
          extent={{-90,-110},{-70,-90}})));

  Fluid.HeatExchangers.DryCoilEffectivenessNTU coiReHea(
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
    T_a2_nominal=THeaCoiAirIn_nominal) "Reheat coil"
    annotation (Placement(transformation(extent={{20,-216},{0,-236}})));

  Fluid.HeatExchangers.WetCoilCounterFlow coiCoo(
    redeclare package Medium1 = MediumWat,
    redeclare package Medium2 = MediumAir,
    UA_nominal=mAir_flow_nominal*1000*15/
        Buildings.Fluid.HeatExchangers.BaseClasses.lmtd(
        T_a1=datcoiCoo.TWatIn_nominal,
        T_b1=datcoiCoo.TWatOut_nominal,
        T_a2=datcoiCoo.TAirIn_nominal,
        T_b2=datcoiCoo.TOut_nominal),
    m1_flow_nominal=datcoiCoo.mWat_flow_nominal,
    m2_flow_nominal=datcoiCoo.mAir_flow_nominal,
    dp1_nominal=datcoiCoo.dpWat_nominal,
    dp2_nominal=datcoiCoo.dpAir_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Cooling coil"
    annotation (Placement(transformation(extent={{-40,-216},{-60,-236}})));

  Fluid.FixedResistances.PressureDrop resSup(
    redeclare package Medium = MediumAir,
    m_flow_nominal=mAir_flow_nominal,
    dp_nominal=dpSup_nominal)
    "Pressure drop of heat exchangers and filter combined"
    annotation (Placement(transformation(extent={{160,-230},{180,-210}})));

  Fluid.Sensors.TemperatureTwoPort senTMix(
    redeclare package Medium = MediumAir,
    m_flow_nominal=mAir_flow_nominal) "Mixed air temperature sensor"
    annotation (Placement(transformation(extent={{-210,-230},{-190,-210}})));

  Fluid.Sensors.TemperatureTwoPort senTSup(
    redeclare package Medium = MediumAir,
    m_flow_nominal=mAir_flow_nominal) "Supply air temperature sensor"
    annotation (Placement(transformation(extent={{350,-230},{370,-210}})));
  Fluid.Sensors.TemperatureTwoPort senTRet(redeclare package Medium = MediumAir,
      m_flow_nominal=mAir_flow_nominal) "Return air temperature sensor"
    annotation (Placement(transformation(extent={{370,-150},{350,-130}})));
  Fluid.FixedResistances.PressureDrop resRet(
    redeclare package Medium = MediumAir,
    m_flow_nominal=mAir_flow_nominal,
    dp_nominal=dpRet_nominal)
                  "Pressure drop for return duct"
    annotation (Placement(transformation(extent={{180,-150},{160,-130}})));
  Fluid.Movers.SpeedControlled_y fanSup(
    redeclare package Medium = MediumAir,
    per=datFanSup,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Supply fan"
    annotation (Placement(transformation(extent={{70,-210},{90,-230}})));

  Fluid.Sensors.VolumeFlowRate senVOut_flow(
    redeclare package Medium = MediumAir,
    m_flow_nominal=mAir_flow_nominal)
    "Outside air volume flow rate"
    annotation (Placement(transformation(extent={{-330,-150},{-310,-130}})));

  parameter Data.CoolingCoil datcoiCoo "Coolin coil nominal parameters"
    annotation (Placement(transformation(extent={{280,-340},{300,-320}})));

  BaseClasses.AhuBus ahuBus annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-400,0}),   iconTransformation(extent={{-10,90},{10,110}})));

  Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller conAHU
    annotation (Placement(transformation(extent={{-320,128},{-240,240}})));
  BaseClasses.TerminalBus terBus[nTer] "Terminal unit bus" annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={398,-2})));
  Fluid.HeatExchangers.DryCoilEffectivenessNTU coiPreHea(
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
    T_a2_nominal=THeaCoiAirIn_nominal) "Preheat coil"
    annotation (Placement(transformation(extent={{-100,-216},{-120,-236}})),
      __Linkage(Connect(path="air_sup")));

  Fluid.Sensors.TemperatureTwoPort senTOut(redeclare package Medium = MediumAir,
      m_flow_nominal=mAir_flow_nominal) "Outdoor air temperature sensor"
    annotation (Placement(transformation(extent={{-370,-230},{-350,-210}})),
    __Linkage(Connect(path="air_sup")));
  Fluid.Sensors.TemperatureTwoPort senTCoiPreHeaLvg(redeclare package Medium =
        MediumAir, m_flow_nominal=mAir_flow_nominal)
    "Preheat coil leaving air temperature sensor"
    annotation (Placement(transformation(extent={{-90,-230},{-70,-210}})),
    __Linkage(Connect(path="air_sup")));
  Fluid.Sensors.TemperatureTwoPort senTExh(redeclare package Medium = MediumAir,
      m_flow_nominal=mAir_flow_nominal) "Exhaust air temperature sensor"
    annotation (Placement(transformation(extent={{-370,-150},{-350,-130}}),
    __Linkage(Connect(path="air_ret"))));
  Fluid.Actuators.Dampers.MixingBox eco "Air economizer"
    annotation (Placement(transformation(extent={{-250,-170},{-230,-190}})),
    __Linkage(Connect(explicit="port_Ret: air_ret, port_Exh: air_ret, port_Out: air_sup, port_Sup: air_sup")));
  Fluid.Actuators.Dampers.MixingBoxMinimumFlow eco_cla1 "Air economizer"
    annotation (Placement(transformation(extent={{-210,-170},{-190,-190}})),
    __Linkage(Connect(explicit="port_Ret: air_ret, port_Exh: air_ret, port_Out: air_sup, port_Sup: air_sup, port_OutMin: air_sup_min")));

  Fluid.Sensors.TemperatureTwoPort senTCoiCooLvg(redeclare package Medium =
        MediumAir, m_flow_nominal=mAir_flow_nominal)
    "Cooling coil leaving air temperature sensor"
    annotation (Placement(transformation(extent={{-30,-230},{-10,-210}})));
  Fluid.Movers.SpeedControlled_y fanSup_pos1(
    redeclare package Medium = MediumAir,
    per=datFanSup,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Supply air fan"
    annotation (Placement(transformation(extent={{-170,-210},{-150,-230}})));

  Fluid.Movers.SpeedControlled_y fanSup_cla1(
    redeclare package Medium = MediumAir,
    per=datFanSup,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Supply fan"
    annotation (Placement(transformation(extent={{70,-250},{90,-270}})));
  Fluid.Sensors.TemperatureTwoPort senTCoiReHeaLvg(redeclare package Medium =
        MediumAir, m_flow_nominal=mAir_flow_nominal)
    "Reheat coil leaving air temperature sensor"
    annotation (Placement(transformation(extent={{30,-230},{50,-210}})),
    __Linkage(present=true));
  Fluid.Movers.SpeedControlled_y fanRet(
    redeclare package Medium = MediumAir,
    per=datFanSup,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Return/relief/exhaust fan"
    annotation (Placement(transformation(extent={{90,-130},{70,-150}})));
  Fluid.Movers.SpeedControlled_y fanRet_pos1(
    redeclare package Medium = MediumAir,
    per=datFanSup,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Return/relief/exhaust fan"
    annotation (Placement(transformation(extent={{-270,-130},{-290,-150}})));
  Fluid.HeatExchangers.DXCoils.AirCooled.VariableSpeed coiCoo_cla1(
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Cooling coil "
    annotation (Placement(transformation(extent={{-60,-270},{-40,-250}})));
  Fluid.HeatExchangers.Heater_T coiPreHea_cla1 "Preheat coil"
    annotation (Placement(transformation(extent={{-120,-270},{-100,-250}})));
  BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(
        transformation(extent={{-20,320},{20,360}}), iconTransformation(extent=
            {{-656,216},{-636,236}})));
  Fluid.HeatExchangers.Heater_T coiReHea_cla1 "Reheat coil"
    annotation (Placement(transformation(extent={{0,-270},{20,-250}})));
  replaceable parameter Fluid.Movers.Data.Generic datFanSup_cla1[n](pressure(
        V_flow={0,mAir_flow_nominal/1.2*2}, dp=2*{dpFanSup_nominal,0}))
    constrainedby Fluid.Movers.Data.Generic "Performance data for supply fan"
    annotation (
    choicesAllMatching=true,
    Dialog(group="Fan"),
    Placement(transformation(extent={{280,-298},{300,-278}})));
  Fluid.HeatExchangers.DryCoilEffectivenessNTU coiPreHea_pos1(
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
    T_a2_nominal=THeaCoiAirIn_nominal) "Preheat coil" annotation (Placement(
        transformation(extent={{-300,-216},{-320,-236}})), __Linkage(Connect(
          path="air_sup")));

  Fluid.Sensors.TemperatureTwoPort senTCoiPreHeaLvg_pos1(redeclare package
      Medium = MediumAir, m_flow_nominal=mAir_flow_nominal)
    "Preheat coil leaving air temperature sensor" annotation (Placement(
        transformation(extent={{-290,-230},{-270,-210}})), __Linkage(Connect(
          path="air_sup")));
  Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller conAHU_cla1
    annotation (Placement(transformation(extent={{-180,130},{-100,242}})));
  Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller conAHU_cla2
    annotation (Placement(transformation(extent={{-60,130},{20,242}})));
equation

  connect(port_supAir, port_supAir) annotation (Line(points={{400,-220},{400,-220}},
                                color={0,127,255}));
  connect(port_airOut, senTOut.port_a)
    annotation (Line(points={{-400,-220},{-370,-220}}, color={0,127,255}));
  connect(senTOut.port_b, coiPreHea_pos1.port_a2)
    annotation (Line(points={{-350,-220},{-320,-220}}, color={0,127,255}));
  connect(port_airOutMin, eco_cla1.port_OutMin) annotation (Line(points={{-400,-180},
          {-280,-180},{-280,-190},{-210,-190}}, color={0,127,255}));
  connect(coiPreHea_pos1.port_b2, senTCoiPreHeaLvg_pos1.port_a)
    annotation (Line(points={{-300,-220},{-290,-220}}, color={0,127,255}));
  connect(senTCoiPreHeaLvg_pos1.port_b, senTMix.port_a)
    annotation (Line(points={{-270,-220},{-210,-220}}, color={0,127,255}));
  connect(senTMix.port_b, fanSup_pos1.port_a)
    annotation (Line(points={{-190,-220},{-170,-220}}, color={0,127,255}));
  connect(fanSup_pos1.port_b, coiPreHea.port_a2)
    annotation (Line(points={{-150,-220},{-120,-220}}, color={0,127,255}));
  connect(fanRet_pos1.port_a, eco.port_Exh) annotation (Line(points={{-270,-140},
          {-260,-140},{-260,-174},{-250,-174}}, color={0,127,255}));
  connect(eco.port_Out, senTCoiPreHeaLvg_pos1.port_b) annotation (Line(points={{
          -250,-186},{-260,-186},{-260,-220},{-270,-220}}, color={0,127,255}));
  connect(eco.port_Ret, fanRet.port_b) annotation (Line(points={{-230,-174},{-220,
          -174},{-220,-140},{70,-140}}, color={0,127,255}));
  connect(eco.port_Sup, senTMix.port_a) annotation (Line(points={{-230,-186},{-220,
          -186},{-220,-220},{-210,-220}}, color={0,127,255}));
  connect(fanRet_pos1.port_b, senVOut_flow.port_b)
    annotation (Line(points={{-290,-140},{-310,-140}}, color={0,127,255}));
  connect(senVOut_flow.port_a, senTExh.port_b)
    annotation (Line(points={{-330,-140},{-350,-140}}, color={0,127,255}));
  connect(senTExh.port_a, port_airExh)
    annotation (Line(points={{-370,-140},{-400,-140}}, color={0,127,255}));
  connect(coiPreHea.port_b2, senTCoiPreHeaLvg.port_a)
    annotation (Line(points={{-100,-220},{-90,-220}}, color={0,127,255}));
  connect(senTCoiPreHeaLvg.port_b, coiCoo.port_a2) annotation (Line(points={{-70,
          -220},{-60,-220},{-60,-220}}, color={0,127,255}));
  connect(coiCoo.port_b2, senTCoiCooLvg.port_a)
    annotation (Line(points={{-40,-220},{-30,-220}}, color={0,127,255}));
  connect(senTCoiCooLvg.port_b, coiReHea.port_a2)
    annotation (Line(points={{-10,-220},{0,-220}}, color={0,127,255}));
  connect(coiReHea.port_b2, senTCoiReHeaLvg.port_a)
    annotation (Line(points={{20,-220},{30,-220}}, color={0,127,255}));
  connect(port_coiPreHeaSup, coiPreHea.port_a1) annotation (Line(points={{-200,
          -400},{-200,-242},{-94,-242},{-94,-232},{-100,-232}}, color={0,127,
          255}));
  connect(coiPreHea.port_b1, port_coiPreHeaRet) annotation (Line(points={{-120,
          -232},{-260,-232},{-260,-400}}, color={0,127,255}));
  connect(port_coiCooSup, coiCoo.port_a1) annotation (Line(points={{-60,-400},{
          -60,-240},{-30,-240},{-30,-232},{-40,-232}}, color={0,127,255}));
  connect(coiCoo.port_b1, port_coiCooRet) annotation (Line(points={{-60,-232},{
          -80,-232},{-80,-380},{-120,-380},{-120,-400}}, color={0,127,255}));
  connect(coiReHea.port_b1, port_coiReHeaRet) annotation (Line(points={{0,-232},
          {-8,-232},{-8,-240},{20,-240},{20,-400}}, color={0,127,255}));
  connect(port_coiReHeaSup, coiReHea.port_a1) annotation (Line(points={{80,-400},
          {80,-380},{40,-380},{40,-232},{20,-232}}, color={0,127,255}));
  connect(senTCoiReHeaLvg.port_b, fanSup.port_a)
    annotation (Line(points={{50,-220},{70,-220}}, color={0,127,255}));
  connect(fanSup.port_b, resSup.port_a)
    annotation (Line(points={{90,-220},{160,-220}}, color={0,127,255}));
  connect(resSup.port_b, senTSup.port_a)
    annotation (Line(points={{180,-220},{350,-220}}, color={0,127,255}));
  connect(senTSup.port_b, port_supAir)
    annotation (Line(points={{370,-220},{400,-220}}, color={0,127,255}));
  connect(port_retAir, senTRet.port_a) annotation (Line(points={{400,-140},{386,
          -140},{386,-140},{370,-140}}, color={0,127,255}));
  connect(senTRet.port_b, resRet.port_a) annotation (Line(points={{350,-140},{
          264,-140},{264,-140},{180,-140}}, color={0,127,255}));
  connect(resRet.port_b, fanRet.port_a)
    annotation (Line(points={{160,-140},{90,-140}}, color={0,127,255}));
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
          extent={{-400,-340},{-166,-362}},
          lineColor={0,0,0},
          textString="Equipment section",
          horizontalAlignment=TextAlignment.Left),
        Text(
          extent={{-400,60},{-166,38}},
          lineColor={0,0,0},
          textString="Control bus section",
          horizontalAlignment=TextAlignment.Left),
        Text(
          extent={{-400,340},{-166,318}},
          lineColor={0,0,0},
          textString="Controls section",
          horizontalAlignment=TextAlignment.Left),
        Text(
          extent={{-380,-244},{-298,-254}},
          lineColor={28,108,200},
          textString="path: air_sup",
          horizontalAlignment=TextAlignment.Left),
        Text(
          extent={{-380,-110},{-298,-120}},
          lineColor={28,108,200},
          textString="path: air_ret",
          horizontalAlignment=TextAlignment.Left),
        Text(
          extent={{-380,-168},{-298,-178}},
          lineColor={28,108,200},
          textString="path: air_sup_min",
          horizontalAlignment=TextAlignment.Left),
        Text(
          extent={{96,-260},{178,-270}},
          lineColor={244,125,35},
          horizontalAlignment=TextAlignment.Left,
          textString="fanSup_cla1 is a fan array")}),          Icon(
        coordinateSystem(extent={{-100,-100},{100,100}})));
end AHULayout;
