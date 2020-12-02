within Buildings.Experimental.Templates.Commercial.VAV.AHUs.MinimumExamples;
model LayoutTemplate "AHU layout template"

  // MEDIA
  replaceable package MediumA = Buildings.Media.Air
    "Medium model for air";
  replaceable package MediumW = Buildings.Media.Water
    "Medium model for water";

  // PARAMETERS
  //// Structural
  final parameter Boolean have_airFloMeaSta
    "Set to true if the AHU has Air Flow Measurement Station"
    annotation(Evaluate=true);

  //// System level
  parameter Modelica.SIunits.MassFlowRate mSup_flow_nominal
    "Nominal supply air mass flow rate";
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
  parameter Modelica.Fluid.Types.Dynamics massDynamics=energyDynamics
    "Type of mass balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));

  // Economizer
  parameter Modelica.SIunits.MassFlowRate mOut_flow_nominal
    "Mass flow rate outside air damper"
    annotation (Dialog(group="Economizer"));
  parameter Modelica.SIunits.PressureDifference dpDamOut_nominal(min=0, displayUnit="Pa")
    "Pressure drop of damper in outside air leg"
     annotation (Dialog(group="Economizer"));
  parameter Modelica.SIunits.PressureDifference dpFixOut_nominal(min=0, displayUnit="Pa")=0
    "Pressure drop of duct and other resistances in outside air leg"
     annotation (Dialog(group="Economizer"));
  parameter Modelica.SIunits.MassFlowRate mRec_flow_nominal
    "Mass flow rate recirculation air damper"
    annotation (Dialog(group="Economizer"));
  parameter Modelica.SIunits.PressureDifference dpDamRec_nominal(min=0, displayUnit="Pa")
    "Pressure drop of damper in recirculation air leg"
     annotation (Dialog(group="Economizer"));
  parameter Modelica.SIunits.PressureDifference dpFixRec_nominal(min=0, displayUnit="Pa")=0
    "Pressure drop of duct and other resistances in recirculation air leg"
     annotation (Dialog(group="Economizer"));
  parameter Modelica.SIunits.MassFlowRate mExh_flow_nominal
    "Mass flow rate exhaust air damper"
    annotation (Dialog(group="Economizer"));
  parameter Modelica.SIunits.PressureDifference dpDamExh_nominal(min=0, displayUnit="Pa")
    "Pressure drop of damper in exhaust air leg"
     annotation (Dialog(group="Economizer"));
  parameter Modelica.SIunits.PressureDifference dpFixExh_nominal(min=0, displayUnit="Pa")=0
    "Pressure drop of duct and other resistances in exhaust air leg"
     annotation (Dialog(group="Economizer"));
  parameter Modelica.SIunits.MassFlowRate mOutMin_flow_nominal
    "Mass flow rate minimum outside air damper"
    annotation (Dialog(group="Economizer"));
  parameter Modelica.SIunits.PressureDifference dpDamOutMin_nominal(
    min=0, displayUnit="Pa")
    "Pressure drop of damper in minimum outside air leg"
     annotation (Dialog(group="Economizer"));
  parameter Modelica.SIunits.PressureDifference dpFixOutMin_nominal(
    min=0, displayUnit="Pa") = 0
    "Pressure drop of duct and other resistances in minimum outside air leg"
     annotation (Dialog(group="Economizer"));

  //// Cooling coil
  parameter Data.CoolingCoil datCoiCoo(
    mAir_flow_nominal=mSup_flow_nominal) "Cooling coil parameters"
    annotation (
      Dialog(group="Cooling coil"),
      Placement(transformation(extent={{-60,-308},{-40,-288}})));
  parameter Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.DXCoil
    datCoiCoo_cla1
    "DX coil performance data"
    annotation (
      Dialog(group="Cooling coil"),
      Placement(transformation(extent={{-60,-338},{-40,-318}})));

  //// Supply fan
  parameter Modelica.SIunits.PressureDifference dpFanSup_nominal(
    min=Modelica.Constants.small,
    displayUnit="Pa")
    "Fan head at nominal air flow rate and full speed"
    annotation(Dialog(group="Supply fan"));
  /* Fixme: This should be constrained to all fans, not all movers. */
  replaceable parameter Fluid.Movers.Data.Generic datFanSup(
    pressure(
      V_flow={0, mSup_flow_nominal/1.2*2},
      dp=2*{dpFanSup_nominal, 0}))
    constrainedby Fluid.Movers.Data.Generic
    "Performance data for supply fan"
    annotation (
      choicesAllMatching=true,
      Dialog(group="Supply fan"),
    Placement(transformation(extent={{70,-308},{90,-288}})));
  replaceable parameter Fluid.Movers.Data.Generic datFanSup_cla1[n](
    each pressure(
      V_flow={0, mSup_flow_nominal/1.2*2},
      dp=2*{dpFanSup_nominal, 0}))
    constrainedby Fluid.Movers.Data.Generic
    "Performance data for supply fan"
    annotation (
    choicesAllMatching=true,
    Dialog(group="Supply fan"),
    Placement(transformation(extent={{70,-336},{90,-316}})));

  // I/O VARIABLES
  Modelica.Fluid.Interfaces.FluidPort_a port_airOut(
    redeclare final package Medium = MediumA)
    "Outdoor air port"
    annotation (Placement(transformation(extent={{-410,-230},{-390,-210}}),
      iconTransformation(extent={{-110,10},{-90,30}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_airExh(
    redeclare final package Medium = MediumA)
    "Exhaust air port"
    annotation (Placement(transformation(extent={{-410,-150},{-390,-130}}),
      iconTransformation(extent={{-110,-30},{-90,-10}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_airOutMin(
    redeclare final package Medium = MediumA)
    "Outdoor air port for minimum OA damper"
    annotation (
      Placement(transformation(extent={{-410,-190},{-390,-170}}),
        iconTransformation(extent={{-110,10},{-90,30}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_supAir(
    redeclare final package Medium =MediumA)
    "Supply air"
    annotation (Placement(transformation(extent={{390,-230},{410,-210}}),
    iconTransformation(extent={{90,-30},{110,-10}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_retAir(
    redeclare final package Medium = MediumA)
    "Return air"
    annotation (Placement(transformation(extent={{390,-150},{410,-130}}),
      iconTransformation(extent={{90,10},{110,30}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_coiCooSup(
    redeclare final package Medium = MediumW)
    "Cooling coil supply port"
    annotation (
      Placement(transformation(extent={{-30,-410},{-10,-390}}),
      iconTransformation(extent={{70,-110},{90,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_coiCooRet(
    redeclare final package Medium = MediumW)
    "Cooling coil return port"
    annotation (Placement( transformation(extent={{-90,-410},{-70,-390}}),
      iconTransformation(extent={{30,-110},{50,-90}})));
  BoundaryConditions.WeatherData.Bus weaBus
    "Weather bus"
    annotation (Placement(transformation(extent={{-20,320},{20,360}}),
      iconTransformation(extent={{-656,216},{-636,236}})));
  BaseClasses.AhuBus ahuBus
    "AHU bus"
    annotation (Placement(transformation(
      extent={{-20,-20},{20,20}},
      rotation=90,
      origin={-400,0}), iconTransformation(extent={{-10,90},{10,110}})));
  BaseClasses.TerminalBus terBus[nTer]
    "Terminal unit bus"
    annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={398,-2})));

  // COMPONENTS
  //// Economizer
  Fluid.Actuators.Dampers.MixingBox eco(
    redeclare final package Medium = MediumA,
    final mOut_flow_nominal=mOut_flow_nominal,
    final mRec_flow_nominal=mRec_flow_nominal,
    final mExh_flow_nominal=mExh_flow_nominal,
    final dpDamOut_flow_nominal=dpDamOut_nominal,
    final dpFixOut_nominal=dpFixOut_nominal,
    final dpDamRec_flow_nominal=dpDamRec_nominal,
    final dpFixRec_nominal=dpFixRec_nominal,
    final dpDamExh_flow_nominal=dpDamExh_nominal,
    final dpFixExh_nominal=dpExhOut_nominal)
    "Air economizer"
    annotation (Placement(transformation(extent={{-250,-170},{-230,-190}})));
  Fluid.Actuators.Dampers.MixingBoxMinimumFlow eco_cla1(
    redeclare final package Medium = MediumA,
    final mOut_flow_nominal=mOut_flow_nominal,
    final mOutMin_flow_nominal=mOutMin_flow_nominal,
    final mRec_flow_nominal=mRec_flow_nominal,
    final mExh_flow_nominal=mExh_flow_nominal,
    final dpDamOut_flow_nominal=dpDamOut_nominal,
    final dpFixOut_nominal=dpFixOut_nominal,
    final dpDamOutMin_nominal=dpDamOutMin_nominal,
    final dpFixOutMin_nominal=dpFixOutMin_nominal,
    final dpDamRec_flow_nominal=dpDamRec_nominal,
    final dpFixRec_nominal=dpFixRec_nominal,
    final dpDamExh_flow_nominal=dpDamExh_nominal,
    final dpFixExh_nominal=dpExhOut_nominal)
    "Air economizer"
    annotation (Placement(transformation(extent={{-290,-170},{-270,-190}})));
  Fluid.Sensors.TemperatureTwoPort senTMix(
    redeclare final package Medium = MediumA,
    final m_flow_nominal=mSup_flow_nominal)
    "Mixed air temperature sensor"
    annotation (Placement(transformation(extent={{-210,-230},{-190,-210}})),
      __Linkage(present="@ispresent(eco*)"));
  Fluid.Sensors.VolumeFlowRate senVFloOut(
    redeclare final package Medium = MediumA,
    final m_flow_nominal=mOut_flow_nominal)
    "OA flow rate sensor"
    annotation (Placement(transformation(extent={{-370,-230},{-350,-210}})),
      __Linkage(present="have_airFloMeaSta and @ispresent(eco)"));
  Fluid.Sensors.VolumeFlowRate senVFloOut_pos1(
    redeclare final package Medium = MediumA,
    final m_flow_nominal=mOutMin_flow_nominal)
    "OA flow rate sensor"
    annotation (Placement(transformation(extent={{-370,-190},{-350,-170}})),
      __Linkage(present="have_airFloMeaSta and @ispresent(eco_cla1)"));

  //// Cooling coil
  Fluid.HeatExchangers.WetCoilCounterFlow coiCoo(
    redeclare final package Medium1 = MediumW,
    redeclare final package Medium2 = MediumA,
    final UA_nominal=datCoiCoo.UA_nominal,
    final m1_flow_nominal=datCoiCoo.mWat_flow_nominal,
    final m2_flow_nominal=datCoiCoo.mSup_flow_nominal,
    final dp1_nominal=datCoiCoo.dpWat_nominal,
    final dp2_nominal=datCoiCoo.dpAir_nominal,
    energyDynamics=energyDynamics)
    "Cooling coil"
    annotation (Placement(transformation(extent={{-40,-216},{-60,-236}})));
  Fluid.HeatExchangers.DXCoils.AirCooled.VariableSpeed coiCoo_cla1(
    redeclare final package Medium = MediumA,
    final dp_nominal=datCoiCoo_cla1.dpAir_nominal,
    final minSpeRat=datCoiCoo_cla1.minSpeRat_coiCoo_cla1,
    energyDynamics=energyDynamics)
    "Cooling coil"
    annotation (Placement(transformation(extent={{-60,-270},{-40,-250}})));
  Fluid.Sensors.TemperatureTwoPort senTCoiCooLvg(
    redeclare final package Medium = MediumA,
    final m_flow_nominal=mSup_flow_nominal)
    "Cooling coil leaving air temperature sensor"
    annotation (Placement(transformation(extent={{-30,-230},{-10,-210}})),
      __Linkage(present="@ispresent(cooCoi*)"));

  //// Supply fan
  Fluid.Movers.SpeedControlled_y fanSup(
    redeclare final package Medium = MediumA,
    final per=datFanSup,
    energyDynamics=energyDynamics)
    "Supply fan"
    annotation (Placement(transformation(extent={{70,-210},{90,-230}})));
  Fluid.Movers.SpeedControlled_y fanSup_pos1(
    redeclare final package Medium = MediumA,
    final per=datFanSup,
    energyDynamics=energyDynamics)
    "Supply fan"
    annotation (Placement(transformation(extent={{-170,-210},{-150,-230}})));
  Fluid.Movers.SpeedControlled_y fanSup_cla1(
    redeclare final package Medium = MediumA,
    final per=datFanSup,
    energyDynamics=energyDynamics)
    "Supply fan"
    annotation (Placement(transformation(extent={{70,-250},{90,-270}})));
  Fluid.Sensors.TemperatureTwoPort senTSup(
    redeclare final package Medium = MediumA,
    final m_flow_nominal=mSup_flow_nominal)
    "Supply air temperature sensor"
    annotation(Placement(transformation(extent={{350,-230},{370,-210}})),
      __Linkage(present="@ispresent(fanSup*)"));


  parameter Data.CoolingCoil datEco(mAir_flow_nominal=mSup_flow_nominal)
    "Cooling coil parameters" annotation (Dialog(group="Cooling coil"),
      Placement(transformation(extent={{-250,-260},{-230,-240}})));
  parameter Data.CoolingCoil datEco_cla1(mAir_flow_nominal=mSup_flow_nominal)
    "Cooling coil parameters" annotation (Dialog(group="Cooling coil"),
      Placement(transformation(extent={{-290,-260},{-270,-240}})));
initial equation
  /* Initial equations may be needed to compute some parameter values, e.g.
  coiCoo.UA_nominal (in sensible conditions).
  They should be annotated with __Linkage(present=...) */

equation

  connect(port_supAir, port_supAir) annotation (Line(points={{400,-220},{400,-220}},
                                color={0,127,255}));
  connect(eco.port_Sup, senTMix.port_a) annotation (Line(points={{-230,-186},{-220,
          -186},{-220,-220},{-210,-220}}, color={0,127,255}));
  connect(senTSup.port_b, port_supAir)
    annotation (Line(points={{370,-220},{400,-220}}, color={0,127,255}));
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
  connect(port_coiCooSup, coiCoo.port_a1) annotation (Line(points={{-20,-400},{-20,
          -232},{-40,-232}}, color={0,127,255}));
  connect(port_coiCooRet, coiCoo.port_b1) annotation (Line(points={{-80,-400},{-80,
          -232},{-60,-232}}, color={0,127,255}));
  connect(port_airOut, senVFloOut.port_a)
    annotation (Line(points={{-400,-220},{-370,-220}}, color={0,127,255}));
  connect(senVFloOut.port_b, eco.port_Out) annotation (Line(points={{-350,-220},
          {-260,-220},{-260,-186},{-250,-186}}, color={0,127,255}));
  connect(senVFloOut.port_b, senTMix.port_a)
    annotation (Line(points={{-350,-220},{-210,-220}}, color={0,127,255}));
  connect(port_airOutMin, senVFloOut_pos1.port_a)
    annotation (Line(points={{-400,-180},{-370,-180}}, color={0,127,255}));
  connect(senVFloOut_pos1.port_b, eco_cla1.port_OutMin) annotation (Line(points={{-350,
          -180},{-300,-180},{-300,-190},{-290,-190}},       color={0,127,255}));
  connect(eco.port_Ret, port_retAir) annotation (Line(points={{-230,-174},{-220,
          -174},{-220,-140},{400,-140}}, color={0,127,255}));
  connect(port_retAir, port_airExh)
    annotation (Line(points={{400,-140},{-400,-140}}, color={0,127,255}));
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
end LayoutTemplate;
