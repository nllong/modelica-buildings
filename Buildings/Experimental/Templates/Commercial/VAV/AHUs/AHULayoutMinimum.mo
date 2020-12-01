within Buildings.Experimental.Templates.Commercial.VAV.AHUs;
model AHULayoutMinimum "Minimum example for the AHU layout template"
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
    Placement(transformation(extent={{280,-300},{300,-280}})));

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

  Modelica.Fluid.Interfaces.FluidPort_a port_retAir(redeclare package Medium =
        MediumAir) "Return air"
    annotation (Placement(transformation(extent={{390,-150},{410,-130}}),
        iconTransformation(extent={{90,10},{110,30}})));

  Fluid.Sensors.TemperatureTwoPort senTMix(
    redeclare package Medium = MediumAir,
    m_flow_nominal=mAir_flow_nominal) "Mixed air temperature sensor"
    annotation (Placement(transformation(extent={{-210,-230},{-190,-210}})));

  Fluid.Sensors.TemperatureTwoPort senTSup(
    redeclare package Medium = MediumAir,
    m_flow_nominal=mAir_flow_nominal) "Supply air temperature sensor"
    annotation (Placement(transformation(extent={{350,-230},{370,-210}})));

  BaseClasses.AhuBus ahuBus annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-400,0}),   iconTransformation(extent={{-10,90},{10,110}})));

  BaseClasses.TerminalBus terBus[nTer] "Terminal unit bus" annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={398,-2})));

  Fluid.Actuators.Dampers.MixingBox eco "Air economizer"
    annotation (Placement(transformation(extent={{-250,-170},{-230,-190}})),
    __Linkage(Connect(explicit="port_Ret: air_ret, port_Exh: air_ret, port_Out: air_sup, port_Sup: air_sup")));
  Fluid.Actuators.Dampers.MixingBoxMinimumFlow eco_cla1 "Air economizer"
    annotation (Placement(transformation(extent={{-210,-170},{-190,-190}})),
    __Linkage(Connect(explicit="port_Ret: air_ret, port_Exh: air_ret, port_Out: air_sup, port_Sup: air_sup, port_OutMin: air_sup_min")));

  BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(
        transformation(extent={{-20,320},{20,360}}), iconTransformation(extent=
            {{-656,216},{-636,236}})));

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
  Fluid.HeatExchangers.DXCoils.AirCooled.VariableSpeed coiCoo_cla1(
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Cooling coil "
    annotation (Placement(transformation(extent={{-60,-270},{-40,-250}})));
  Fluid.Sensors.TemperatureTwoPort senTCoiCooLvg(redeclare package Medium =
        MediumAir, m_flow_nominal=mAir_flow_nominal)
    "Cooling coil leaving air temperature sensor"
    annotation (Placement(transformation(extent={{-30,-230},{-10,-210}})));
  Fluid.Movers.SpeedControlled_y fanSup_pos1(
    redeclare package Medium = MediumAir,
    per=datFanSup,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Supply air fan"
    annotation (Placement(transformation(extent={{-170,-210},{-150,-230}})));
  Fluid.Movers.SpeedControlled_y fanSup(
    redeclare package Medium = MediumAir,
    per=datFanSup,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Supply fan"
    annotation (Placement(transformation(extent={{70,-210},{90,-230}})));
  Fluid.Movers.SpeedControlled_y fanSup_cla1(
    redeclare package Medium = MediumAir,
    per=datFanSup,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Supply fan"
    annotation (Placement(transformation(extent={{70,-250},{90,-270}})));
  parameter Data.CoolingCoil datcoiCoo "Coolin coil nominal parameters"
    annotation (Placement(transformation(extent={{280,-340},{300,-320}})));
  Fluid.Sensors.TemperatureTwoPort senTRet(redeclare package Medium = MediumAir,
      m_flow_nominal=mAir_flow_nominal) "Return air temperature sensor"
    annotation (Placement(transformation(extent={{370,-150},{350,-130}})));
equation

  connect(port_supAir, port_supAir) annotation (Line(points={{400,-220},{400,-220}},
                                color={0,127,255}));
  connect(port_airOutMin, eco_cla1.port_OutMin) annotation (Line(points={{-400,-180},
          {-280,-180},{-280,-190},{-210,-190}}, color={0,127,255}));
  connect(eco.port_Sup, senTMix.port_a) annotation (Line(points={{-230,-186},{-220,
          -186},{-220,-220},{-210,-220}}, color={0,127,255}));
  connect(senTSup.port_b, port_supAir)
    annotation (Line(points={{370,-220},{400,-220}}, color={0,127,255}));
  connect(port_airOut, eco.port_Out) annotation (Line(points={{-400,-220},{-260,
          -220},{-260,-186},{-250,-186}}, color={0,127,255}));
  connect(coiCoo.port_b2, senTCoiCooLvg.port_a)
    annotation (Line(points={{-40,-220},{-30,-220}}, color={0,127,255}));
  connect(port_airExh, eco.port_Exh) annotation (Line(points={{-400,-140},{-260,
          -140},{-260,-174},{-250,-174}}, color={0,127,255}));
  connect(senTMix.port_b, fanSup_pos1.port_a)
    annotation (Line(points={{-190,-220},{-170,-220}}, color={0,127,255}));
  connect(fanSup_pos1.port_b, coiCoo.port_a2)
    annotation (Line(points={{-150,-220},{-60,-220}}, color={0,127,255}));
  connect(senTCoiCooLvg.port_b, fanSup.port_a)
    annotation (Line(points={{-10,-220},{70,-220}}, color={0,127,255}));
  connect(fanSup.port_b, senTSup.port_a)
    annotation (Line(points={{90,-220},{350,-220}}, color={0,127,255}));
  connect(port_retAir, senTRet.port_a)
    annotation (Line(points={{400,-140},{370,-140}}, color={0,127,255}));
  connect(senTRet.port_b, eco.port_Ret) annotation (Line(points={{350,-140},{
          -220,-140},{-220,-174},{-230,-174}}, color={0,127,255}));
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
          horizontalAlignment=TextAlignment.Left)}),           Icon(
        coordinateSystem(extent={{-100,-100},{100,100}})));
end AHULayoutMinimum;
