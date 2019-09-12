within Buildings.Experimental.Templates.Commercial.VAV.AHUs;
model CoolingCoilHeatingCoilEconomizerNoReturnFanControlBus
  "VAV air handler unit"
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
    Placement(transformation(extent={{260,354},{280,374}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_freAir(redeclare package Medium =
        MediumAir) "Fresh air intake" annotation (Placement(transformation(
          extent={{-410,30},{-390,50}}), iconTransformation(extent={{-110,10},{
            -90,30}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_exhAir(redeclare package Medium =
        MediumAir) "Exhaust air" annotation (Placement(transformation(extent={{-410,
            -50},{-390,-30}}), iconTransformation(extent={{-110,-30},{-90,-10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_supAir(redeclare package Medium =
        MediumAir) "Supply air" annotation (Placement(transformation(extent={{390,-50},
            {410,-30}}), iconTransformation(extent={{90,-30},{110,-10}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_retAir(redeclare package Medium =
        MediumAir) "Return air"
    annotation (Placement(transformation(extent={{392,30},{412,50}}),
        iconTransformation(extent={{90,10},{110,30}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_cooCoiIn(redeclare package Medium =
        MediumWat) "Cooling coil inlet"
    annotation (Placement(transformation(extent={{110,-410},{130,-390}}),
        iconTransformation(extent={{70,-110},{90,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_CooCoiOut(redeclare package Medium =
        MediumWat) "Cooling coil outlet" annotation (Placement(transformation(
          extent={{30,-410},{50,-390}}), iconTransformation(extent={{30,-110},{
            50,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_heaCoiIn(redeclare package Medium =
        MediumWat) "Heating coil inlet"
    annotation (Placement(transformation(extent={{-50,-410},{-30,-390}}),
        iconTransformation(extent={{-50,-110},{-30,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_heaCoiOut(redeclare package Medium =
        MediumWat) "Heating coil outlet"
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
    annotation (Placement(transformation(extent={{20,-36},{0,-56}})));

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
    annotation (Placement(transformation(extent={{82,-36},{62,-56}})));

  Fluid.FixedResistances.PressureDrop resSup(
    redeclare package Medium = MediumAir,
    m_flow_nominal=mAir_flow_nominal,
    dp_nominal=dpSup_nominal)
    "Pressure drop of heat exchangers and filter combined"
    annotation (Placement(transformation(extent={{140,-50},{160,-30}})));

  Fluid.Sensors.TemperatureTwoPort senTMix(
    redeclare package Medium = MediumAir,
    m_flow_nominal=mAir_flow_nominal) "Mixed air temperature sensor"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));

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
        origin={-90,2})));

  Fluid.Sensors.TemperatureTwoPort senTSup(
    redeclare package Medium = MediumAir,
    m_flow_nominal=mAir_flow_nominal) "Supply air temperature sensor"
    annotation (Placement(transformation(extent={{310,-50},{330,-30}})));
  Fluid.Sensors.TemperatureTwoPort TRet(
    redeclare package Medium = MediumAir,
    m_flow_nominal=mAir_flow_nominal) "Return air temperature sensor"
    annotation (Placement(transformation(extent={{360,30},{340,50}})));
  Fluid.FixedResistances.PressureDrop resRet(
    redeclare package Medium = MediumAir,
    m_flow_nominal=mAir_flow_nominal,
    dp_nominal=dpRet_nominal)
                  "Pressure drop for return duct"
    annotation (Placement(transformation(extent={{160,30},{140,50}})));
  Fluid.Movers.SpeedControlled_y fanSup(
    redeclare package Medium = MediumAir,
    per=datFanSup,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Supply air fan"
    annotation (Placement(transformation(extent={{220,-30},{240,-50}})));

  Fluid.Sensors.VolumeFlowRate senVOut_flow(
    redeclare package Medium = MediumAir,
    m_flow_nominal=mAir_flow_nominal)
    "Outside air volume flow rate"
    annotation (Placement(transformation(extent={{-160,30},{-140,50}})));

  parameter Data.CoolingCoil datCooCoi
    annotation (Placement(transformation(extent={{262,308},{282,328}})));
  BaseClasses.AhuSubBusO ahuSubBusO
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-358,-320}),
        iconTransformation(extent={{-82,54},{-62,74}})));
  BaseClasses.AhuBus ahuBus annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-400,-340}),iconTransformation(extent={{-106,70},{-86,90}})));
  BaseClasses.AhuSubBusI ahuSubBusI
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-358,-360}),
        iconTransformation(extent={{-82,80},{-62,100}})));
equation
  connect(eco.port_Out, senVOut_flow.port_b) annotation (Line(points={{-100,8},{
          -120,8},{-120,40},{-140,40}}, color={0,127,255}));
  connect(eco.port_Ret, senTMix.port_a) annotation (Line(points={{-80,-4},{-68,-4},
          {-68,-40},{-60,-40}}, color={0,127,255}));
  connect(senTMix.port_b, heaCoi.port_a2)
    annotation (Line(points={{-40,-40},{0,-40}},   color={0,127,255}));
  connect(heaCoi.port_b2, cooCoi.port_a2)
    annotation (Line(points={{20,-40},{62,-40}},color={0,127,255}));
  connect(resSup.port_b, fanSup.port_a)
    annotation (Line(points={{160,-40},{220,-40}}, color={0,127,255}));
  connect(senVOut_flow.port_a, port_freAir) annotation (Line(points={{-160,40},{
          -400,40}},                     color={0,127,255}));
  connect(eco.port_Exh, port_exhAir) annotation (Line(points={{-100,-4},{-120,-4},
          {-120,-40},{-400,-40}}, color={0,127,255}));
  connect(senTSup.port_b, port_supAir)
    annotation (Line(points={{330,-40},{400,-40}}, color={0,127,255}));
  connect(TRet.port_a, port_retAir)
    annotation (Line(points={{360,40},{402,40}}, color={0,127,255}));
  connect(cooCoi.port_a1, port_cooCoiIn) annotation (Line(points={{82,-52},{120,
          -52},{120,-400}},                 color={0,127,255}));
  connect(cooCoi.port_b1, port_CooCoiOut) annotation (Line(points={{62,-52},{50,
          -52},{50,-300},{40,-300},{40,-400}},
                                      color={0,127,255}));
  connect(heaCoi.port_a1, port_heaCoiIn) annotation (Line(points={{20,-52},{30,-52},
          {30,-180},{-40,-180},{-40,-400}},color={0,127,255}));
  connect(heaCoi.port_b1, port_heaCoiOut) annotation (Line(points={{0,-52},{-20,
          -52},{-20,-160},{-120,-160},{-120,-400}}, color={0,127,255}));

  connect(TRet.port_b, resRet.port_a)
    annotation (Line(points={{340,40},{160,40}}, color={0,127,255}));
  connect(resRet.port_b, eco.port_Sup) annotation (Line(points={{140,40},{-68,40},
          {-68,8},{-80,8}}, color={0,127,255}));
  connect(fanSup.port_b, senTSup.port_a)
    annotation (Line(points={{240,-40},{310,-40}}, color={0,127,255}));
  connect(cooCoi.port_b2, resSup.port_a)
    annotation (Line(points={{82,-40},{140,-40}}, color={0,127,255}));
  connect(ahuSubBusO.yFanSup, fanSup.y) annotation (Line(
      points={{-358,-320},{230,-320},{230,-52}},
      color={255,204,51},
      thickness=0.5));
  connect(senTMix.T, ahuSubBusI.TAirLvgMix) annotation (Line(points={{-50,-29},{-50,-360},{-358,-360}},
                                 color={0,0,127}));
  connect(ahuSubBusO, ahuBus.ahuO) annotation (Line(
      points={{-358,-320},{-382,-320},{-382,-340},{-400,-340}},
      color={255,204,51},
      thickness=0.5));
  connect(ahuSubBusI, ahuBus.ahuI) annotation (Line(
      points={{-358,-360},{-382,-360},{-382,-340},{-400,-340}},
      color={255,204,51},
      thickness=0.5));
  connect(senTSup.T, ahuSubBusI.TAirSup) annotation (Line(points={{320,-29},{320,-360},{-358,-360}},
                                color={0,0,127}));
  connect(TRet.T, ahuSubBusI.TAirRet)
    annotation (Line(points={{350,51},{350,-360},{-358,-360}},
                                                             color={0,0,127}));
  connect(senVOut_flow.V_flow, ahuSubBusI.VFloAirOut) annotation (Line(points={{-150,51},{-150,-360},{-358,-360}},
                                            color={0,0,127}));
  connect(port_supAir, port_supAir) annotation (Line(points={{400,-40},{102,-40},
          {102,-40},{400,-40}}, color={0,127,255}));
  connect(ahuSubBusO.yEcoRet, eco.yRet) annotation (Line(
      points={{-358,-320},{-104,-320},{-104,24},{-96.8,24},{-96.8,14}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(ahuSubBusO.yEcoExh, eco.yExh) annotation (Line(
      points={{-358,-320},{-72,-320},{-72,22},{-83,22},{-83,14}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(ahuSubBusO.yEcoOut, eco.yOut) annotation (Line(
      points={{-358,-320},{-60,-320},{-60,28},{-90,28},{-90,14}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  annotation (
    defaultComponentName="ahu",
    Diagram(coordinateSystem(extent={{-400,-400},{400,400}})), Icon(
        coordinateSystem(extent={{-100,-100},{100,100}})));
end CoolingCoilHeatingCoilEconomizerNoReturnFanControlBus;
