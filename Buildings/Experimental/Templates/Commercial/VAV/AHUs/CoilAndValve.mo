within Buildings.Experimental.Templates.Commercial.VAV.AHUs;
model CoilAndValve "VAV air handler unit"
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

  Modelica.Fluid.Interfaces.FluidPort_a port_freAir(redeclare package Medium =
        MediumAir) "Fresh air intake" annotation (Placement(transformation(
          extent={{-70,-70},{-50,-50}}), iconTransformation(extent={{-70,-40},{-50,-20}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_supAir(redeclare package Medium =
        MediumAir) "Supply air" annotation (Placement(transformation(extent={{110,-70},{130,-50}}),
                         iconTransformation(extent={{110,-80},{130,-60}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_heaCoiIn(redeclare package Medium =
        MediumWat) "Heating coil inlet"
    annotation (Placement(transformation(extent={{30,-150},{50,-130}}),
        iconTransformation(extent={{-20,-150},{0,-130}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_heaCoiOut(redeclare package Medium =
        MediumWat) "Heating coil outlet"
    annotation (Placement(transformation(extent={{10,-150},{30,-130}}),
        iconTransformation(extent={{-60,-150},{-40,-130}})));

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
    annotation (Placement(transformation(extent={{40,-50},{20,-70}})));

  BaseClasses.AhuSubBusO ahuSubBusO
    annotation (Placement(transformation(extent={{-26,-10},{-6,10}}),
        iconTransformation(extent={{-82,54},{-62,74}})));
  BaseClasses.AhuBus ahuBus annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-54,8}),    iconTransformation(extent={{-106,70},{-86,90}})));
  BaseClasses.AhuSubBusI ahuSubBusI
    annotation (Placement(transformation(extent={{-26,16},{-6,36}}),
        iconTransformation(extent={{-82,80},{-62,100}})));
  Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear val annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={20,-110})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage val1
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={20,-84})));
equation

  connect(ahuSubBusO, ahuBus.ahuO) annotation (Line(
      points={{-16,0},{-34,0},{-34,8.1},{-54.1,8.1}},
      color={255,204,51},
      thickness=0.5));
  connect(ahuSubBusI, ahuBus.ahuI) annotation (Line(
      points={{-16,26},{-34,26},{-34,8.1},{-54.1,8.1}},
      color={255,204,51},
      thickness=0.5));
  connect(port_freAir, heaCoi.port_a2)
    annotation (Line(points={{-60,-60},{-16,-60},{-16,-54},{20,-54}}, color={0,127,255}));
  connect(val.port_1, port_heaCoiOut) annotation (Line(points={{20,-120},{20,-140}}, color={0,127,255}));
  connect(heaCoi.port_b1, val1.port_b) annotation (Line(points={{20,-66},{20,-74}}, color={0,127,255}));
  connect(port_heaCoiIn, port_heaCoiIn) annotation (Line(points={{40,-140},{40,-140}}, color={0,127,255}));
  connect(heaCoi.port_a1, port_heaCoiIn) annotation (Line(points={{40,-66},{40,-140}}, color={0,127,255}));
  connect(val.port_2, val1.port_a) annotation (Line(points={{20,-100},{20,-94}}, color={0,127,255}));
  connect(val.port_3, heaCoi.port_a1) annotation (Line(points={{30,-110},{40,-110},{40,-66}}, color={0,127,255}));
  connect(heaCoi.port_b2, port_supAir)
    annotation (Line(points={{40,-54},{90,-54},{90,-60},{120,-60}}, color={0,127,255}));
  connect(ahuSubBusO.yValHeaCoi, val1.y) annotation (Line(
      points={{-16,0},{-6,0},{-6,-84},{8,-84}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(ahuSubBusO.yValHeaCoi, val.y) annotation (Line(
      points={{-16,0},{-6,0},{-6,-110},{8,-110}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (
    defaultComponentName="ahu",
    Diagram(coordinateSystem(extent={{-60,-140},{120,40}})),   Icon(
        coordinateSystem(extent={{-60,-140},{120,40}})));
end CoilAndValve;
