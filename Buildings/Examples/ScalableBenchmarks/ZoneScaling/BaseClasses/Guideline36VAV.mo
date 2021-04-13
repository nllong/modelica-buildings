within Buildings.Examples.ScalableBenchmarks.ZoneScaling.BaseClasses;
model Guideline36VAV
  "Variable air volume flow system with terminal reheat suited for five thermal zones"

  package MediumA = Buildings.Media.Air "Medium model for air";
  package MediumW = Buildings.Media.Water "Medium model for water";

  constant Integer numZon=5 "Total number of served VAV boxes";

  parameter Modelica.SIunits.Volume VRooCor "Room volume core";
  parameter Modelica.SIunits.Volume VRooSou "Room volume south";
  parameter Modelica.SIunits.Volume VRooNor "Room volume north";
  parameter Modelica.SIunits.Volume VRooEas "Room volume east";
  parameter Modelica.SIunits.Volume VRooWes "Room volume west";

  parameter Modelica.SIunits.Area AFloCor "Floor area core";
  parameter Modelica.SIunits.Area AFloSou "Floor area south";
  parameter Modelica.SIunits.Area AFloNor "Floor area north";
  parameter Modelica.SIunits.Area AFloEas "Floor area east";
  parameter Modelica.SIunits.Area AFloWes "Floor area west";

  parameter Modelica.SIunits.Area AFlo[numZon]={AFloCor,AFloSou,AFloEas,
      AFloNor,AFloWes} "Floor area of each zone";
  final parameter Modelica.SIunits.Area ATot=sum(AFlo) "Total floor area";

  constant Real conv=1.2/3600 "Conversion factor for nominal mass flow rate";

  parameter Real ACHCor(final unit="1/h")=6
    "Design air change per hour core";
  parameter Real ACHSou(final unit="1/h")=6
    "Design air change per hour south";
  parameter Real ACHEas(final unit="1/h")=9
    "Design air change per hour east";
  parameter Real ACHNor(final unit="1/h")=6
    "Design air change per hour north";
  parameter Real ACHWes(final unit="1/h")=7
    "Design air change per hour west";

  parameter Modelica.SIunits.MassFlowRate mCor_flow_nominal=ACHCor*VRooCor*conv
    "Design mass flow rate core";
  parameter Modelica.SIunits.MassFlowRate mSou_flow_nominal=ACHSou*VRooSou*conv
    "Design mass flow rate south";
  parameter Modelica.SIunits.MassFlowRate mEas_flow_nominal=ACHEas*VRooEas*conv
    "Design mass flow rate east";
  parameter Modelica.SIunits.MassFlowRate mNor_flow_nominal=ACHNor*VRooNor*conv
    "Design mass flow rate north";
  parameter Modelica.SIunits.MassFlowRate mWes_flow_nominal=ACHWes*VRooWes*conv
    "Design mass flow rate west";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=0.7*(mCor_flow_nominal
       + mSou_flow_nominal + mEas_flow_nominal + mNor_flow_nominal +
      mWes_flow_nominal) "Nominal mass flow rate";

  parameter Real ratVFloHea(final unit="1") = 0.3
    "VAV box maximum air flow rate ratio in heating mode";

  parameter Modelica.SIunits.Angle lat=41.98*3.14159/180 "Latitude";

  parameter Real ratOAFlo_A(final unit="m3/(s.m2)") = 0.3e-3
    "Outdoor airflow rate required per unit area";
  parameter Real ratOAFlo_P = 2.5e-3
    "Outdoor airflow rate required per person";
  parameter Real ratP_A = 5e-2
    "Occupant density";
  parameter Real effZ(final unit="1") = 0.8
    "Zone air distribution effectiveness (limiting value)";
  parameter Real divP(final unit="1") = 0.7
    "Occupant diversity ratio";
  parameter Modelica.SIunits.VolumeFlowRate VCorOA_flow_nominal=
    (ratOAFlo_P * ratP_A + ratOAFlo_A) * AFloCor / effZ
    "Zone outdoor air flow rate";
  parameter Modelica.SIunits.VolumeFlowRate VSouOA_flow_nominal=
    (ratOAFlo_P * ratP_A + ratOAFlo_A) * AFloSou / effZ
    "Zone outdoor air flow rate";
  parameter Modelica.SIunits.VolumeFlowRate VEasOA_flow_nominal=
    (ratOAFlo_P * ratP_A + ratOAFlo_A) * AFloEas / effZ
    "Zone outdoor air flow rate";
  parameter Modelica.SIunits.VolumeFlowRate VNorOA_flow_nominal=
    (ratOAFlo_P * ratP_A + ratOAFlo_A) * AFloNor / effZ
    "Zone outdoor air flow rate";
  parameter Modelica.SIunits.VolumeFlowRate VWesOA_flow_nominal=
    (ratOAFlo_P * ratP_A + ratOAFlo_A) * AFloWes / effZ
    "Zone outdoor air flow rate";
  parameter Modelica.SIunits.VolumeFlowRate Vou_flow_nominal=
    (divP * ratOAFlo_P * ratP_A + ratOAFlo_A) * sum(
      {AFloCor, AFloSou, AFloNor, AFloEas, AFloWes})
    "System uncorrected outdoor air flow rate";
  parameter Real effVen(final unit="1") = if divP < 0.6 then
    0.88 * divP + 0.22 else 0.75
    "System ventilation efficiency";
  parameter Modelica.SIunits.VolumeFlowRate Vot_flow_nominal=
    Vou_flow_nominal / effVen
    "System design outdoor air flow rate";

  parameter Modelica.SIunits.Temperature THeaOn=293.15
    "Heating setpoint during on";
  parameter Modelica.SIunits.Temperature THeaOff=285.15
    "Heating setpoint during off";
  parameter Modelica.SIunits.Temperature TCooOn=297.15
    "Cooling setpoint during on";
  parameter Modelica.SIunits.Temperature TCooOff=303.15
    "Cooling setpoint during off";
  parameter Modelica.SIunits.PressureDifference dpBuiStaSet(min=0) = 12
    "Building static pressure";
  parameter Real yFanMin = 0.1 "Minimum fan speed";

  parameter Modelica.SIunits.Temperature THotWatInl_nominal(
    displayUnit="degC")=55 + 273.15
    "Reheat coil nominal inlet water temperature";

  parameter Boolean allowFlowReversal=true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation (Evaluate=true);

  parameter Boolean use_windPressure=true "Set to true to enable wind pressure";

  parameter Boolean sampleModel=true
    "Set to true to time-sample the model, which can give shorter simulation time if there is already time sampling in the system model"
    annotation (Evaluate=true, Dialog(tab=
    "Experimental (may be changed in future releases)"));

  Buildings.Fluid.Sources.Outside amb(redeclare package Medium = MediumA,
      nPorts=3) "Ambient conditions"
    annotation (Placement(transformation(extent={{-136,-56},{-114,-34}})));

  Buildings.Fluid.HeatExchangers.DryCoilEffectivenessNTU heaCoi(
    redeclare package Medium1 = MediumW,
    redeclare package Medium2 = MediumA,
    m1_flow_nominal=m_flow_nominal*1000*(10 - (-20))/4200/10,
    m2_flow_nominal=m_flow_nominal,
    show_T=true,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    Q_flow_nominal=m_flow_nominal*1006*(16.7 - 4),
    dp1_nominal=0,
    dp2_nominal=200 + 200 + 100 + 40,
    allowFlowReversal1=false,
    allowFlowReversal2=allowFlowReversal,
    T_a1_nominal=THotWatInl_nominal,
    T_a2_nominal=4 + 273.15)
    "Heating coil"
    annotation (Placement(transformation(extent={{118,-36},{98,-56}})));

  Buildings.Fluid.HeatExchangers.WetCoilCounterFlow cooCoi(
    show_T=true,
    UA_nominal=3*m_flow_nominal*1000*15/
      Buildings.Fluid.HeatExchangers.BaseClasses.lmtd(
      T_a1=26.2,
      T_b1=12.8,
      T_a2=6,
      T_b2=16),
    redeclare package Medium1 = MediumW,
    redeclare package Medium2 = MediumA,
    m1_flow_nominal=m_flow_nominal*1000*15/4200/10,
    m2_flow_nominal=m_flow_nominal,
    dp2_nominal=0,
    dp1_nominal=0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    allowFlowReversal1=false,
    allowFlowReversal2=allowFlowReversal)
    "Cooling coil"
    annotation (Placement(transformation(extent={{210,-36},{190,-56}})));
  Buildings.Fluid.FixedResistances.PressureDrop dpRetDuc(
    m_flow_nominal=m_flow_nominal,
    redeclare package Medium = MediumA,
    allowFlowReversal=allowFlowReversal,
    dp_nominal=40) "Pressure drop for return duct"
    annotation (Placement(transformation(extent={{400,130},{380,150}})));
  Buildings.Fluid.Movers.SpeedControlled_y fanSup(
    redeclare package Medium = MediumA,
    per(pressure(V_flow={0,m_flow_nominal/1.2*2}, dp=2*{780 + 10 + dpBuiStaSet,
            0})),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Supply air fan"
    annotation (Placement(transformation(extent={{300,-50},{320,-30}})));

  Buildings.Fluid.Sensors.VolumeFlowRate senSupFlo(redeclare package Medium =
        MediumA, m_flow_nominal=m_flow_nominal)
    "Sensor for supply fan flow rate"
    annotation (Placement(transformation(extent={{400,-50},{420,-30}})));

  Buildings.Fluid.Sensors.VolumeFlowRate senRetFlo(redeclare package Medium =
        MediumA, m_flow_nominal=m_flow_nominal)
    "Sensor for return fan flow rate"
    annotation (Placement(transformation(extent={{360,130},{340,150}})));

  Buildings.Fluid.Sources.Boundary_pT sinHea(
    redeclare package Medium = MediumW,
    p=300000,
    T=318.15,
    nPorts=6) "Sink for heating coil" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={80,-238})));
  Buildings.Fluid.Sources.Boundary_pT sinCoo(
    redeclare package Medium = MediumW,
    p=300000,
    T=285.15,
    nPorts=1) "Sink for cooling coil" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={180,-120})));
  Modelica.Blocks.Routing.RealPassThrough TOut(y(
      final quantity="ThermodynamicTemperature",
      final unit="K",
      displayUnit="degC",
      min=0))
    annotation (Placement(transformation(extent={{-300,170},{-280,190}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TSup(
    redeclare package Medium = MediumA,
    m_flow_nominal=m_flow_nominal,
    allowFlowReversal=allowFlowReversal)
    annotation (Placement(transformation(extent={{330,-50},{350,-30}})));
  Buildings.Fluid.Sensors.RelativePressure dpDisSupFan(redeclare package Medium =
        MediumA) "Supply fan static discharge pressure" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={320,0})));
  Buildings.Controls.SetPoints.OccupancySchedule occSch(occupancy=3600*{6,19})
    "Occupancy schedule"
    annotation (Placement(transformation(extent={{-318,-220},{-298,-200}})));
  Buildings.Utilities.Math.Min min(nin=5) "Computes lowest room temperature"
    annotation (Placement(transformation(extent={{1320,442},{1340,462}})));
  Buildings.Utilities.Math.Average ave(nin=5)
    "Compute average of room temperatures"
    annotation (Placement(transformation(extent={{1320,412},{1340,432}})));
  Buildings.Fluid.Sources.MassFlowSource_T souCoo(
    redeclare package Medium = MediumW,
    T=279.15,
    nPorts=1,
    use_m_flow_in=true) "Source for cooling coil" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={230,-120})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TRet(
    redeclare package Medium = MediumA,
    m_flow_nominal=m_flow_nominal,
    allowFlowReversal=allowFlowReversal) "Return air temperature sensor"
    annotation (Placement(transformation(extent={{110,130},{90,150}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TMix(
    redeclare package Medium = MediumA,
    m_flow_nominal=m_flow_nominal,
    allowFlowReversal=allowFlowReversal) "Mixed air temperature sensor"
    annotation (Placement(transformation(extent={{30,-50},{50,-30}})));
  Buildings.Fluid.Sources.MassFlowSource_T souHea(
    redeclare package Medium = MediumW,
    T=THotWatInl_nominal,
    use_m_flow_in=true,
    nPorts=1)           "Source for heating coil" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={132,-120})));
  Buildings.Fluid.Sensors.VolumeFlowRate VOut1(redeclare package Medium =
        MediumA, m_flow_nominal=m_flow_nominal) "Outside air volume flow rate"
    annotation (Placement(transformation(extent={{-72,-44},{-50,-22}})));

  Buildings.Air.Systems.MultiZone.VAVReheat.BaseClasses.VAVReheatBox cor(
    redeclare package MediumA = MediumA,
    redeclare package MediumW = MediumW,
    m_flow_nominal=mCor_flow_nominal,
    VRoo=VRooCor,
    allowFlowReversal=allowFlowReversal,
    ratVFloHea=ratVFloHea,
    THotWatInl_nominal=THotWatInl_nominal,
    THotWatOut_nominal=THotWatInl_nominal - 10,
    TAirInl_nominal=12 + 273.15,
    QHea_flow_nominal=mCor_flow_nominal*ratVFloHea*cpAir*(32 - 12))
    "Zone for core of buildings (azimuth will be neglected)"
    annotation (Placement(transformation(extent={{570,22},{610,62}})));
  Buildings.Air.Systems.MultiZone.VAVReheat.BaseClasses.VAVReheatBox sou(
    redeclare package MediumA = MediumA,
    redeclare package MediumW = MediumW,
    m_flow_nominal=mSou_flow_nominal,
    VRoo=VRooSou,
    allowFlowReversal=allowFlowReversal,
    ratVFloHea=ratVFloHea,
    THotWatInl_nominal=THotWatInl_nominal,
    THotWatOut_nominal=THotWatInl_nominal - 10,
    TAirInl_nominal=12 + 273.15,
    QHea_flow_nominal=mSou_flow_nominal*ratVFloHea*cpAir*(32 - 12))
    "South-facing thermal zone"
    annotation (Placement(transformation(extent={{750,20},{790,60}})));
  Buildings.Air.Systems.MultiZone.VAVReheat.BaseClasses.VAVReheatBox eas(
    redeclare package MediumA = MediumA,
    redeclare package MediumW = MediumW,
    m_flow_nominal=mEas_flow_nominal,
    VRoo=VRooEas,
    allowFlowReversal=allowFlowReversal,
    ratVFloHea=ratVFloHea,
    THotWatInl_nominal=THotWatInl_nominal,
    THotWatOut_nominal=THotWatInl_nominal - 10,
    TAirInl_nominal=12 + 273.15,
    QHea_flow_nominal=mEas_flow_nominal*ratVFloHea*cpAir*(32 - 12))
    "East-facing thermal zone"
    annotation (Placement(transformation(extent={{930,20},{970,60}})));
  Buildings.Air.Systems.MultiZone.VAVReheat.BaseClasses.VAVReheatBox nor(
    redeclare package MediumA = MediumA,
    redeclare package MediumW = MediumW,
    m_flow_nominal=mNor_flow_nominal,
    VRoo=VRooNor,
    allowFlowReversal=allowFlowReversal,
    ratVFloHea=ratVFloHea,
    THotWatInl_nominal=THotWatInl_nominal,
    THotWatOut_nominal=THotWatInl_nominal - 10,
    TAirInl_nominal=12 + 273.15,
    QHea_flow_nominal=mNor_flow_nominal*ratVFloHea*cpAir*(32 - 12))
    "North-facing thermal zone"
    annotation (Placement(transformation(extent={{1090,20},{1130,60}})));
  Buildings.Air.Systems.MultiZone.VAVReheat.BaseClasses.VAVReheatBox wes(
    redeclare package MediumA = MediumA,
    redeclare package MediumW = MediumW,
    m_flow_nominal=mWes_flow_nominal,
    VRoo=VRooWes,
    allowFlowReversal=allowFlowReversal,
    ratVFloHea=ratVFloHea,
    THotWatInl_nominal=THotWatInl_nominal,
    THotWatOut_nominal=THotWatInl_nominal - 10,
    TAirInl_nominal=12 + 273.15,
    QHea_flow_nominal=mWes_flow_nominal*ratVFloHea*cpAir*(32 - 12))
    "West-facing thermal zone"
    annotation (Placement(transformation(extent={{1290,20},{1330,60}})));
  Buildings.Fluid.FixedResistances.Junction splRetRoo1(
    redeclare package Medium = MediumA,
    m_flow_nominal={m_flow_nominal,m_flow_nominal - mCor_flow_nominal,
        mCor_flow_nominal},
    from_dp=false,
    linearized=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal(each displayUnit="Pa") = {0,0,0},
    portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering)
    "Splitter for room return"
    annotation (Placement(transformation(extent={{630,10},{650,-10}})));
  Buildings.Fluid.FixedResistances.Junction splRetSou(
    redeclare package Medium = MediumA,
    m_flow_nominal={mSou_flow_nominal + mEas_flow_nominal + mNor_flow_nominal
         + mWes_flow_nominal,mEas_flow_nominal + mNor_flow_nominal +
        mWes_flow_nominal,mSou_flow_nominal},
    from_dp=false,
    linearized=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal(each displayUnit="Pa") = {0,0,0},
    portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering)
    "Splitter for room return"
    annotation (Placement(transformation(extent={{812,10},{832,-10}})));
  Buildings.Fluid.FixedResistances.Junction splRetEas(
    redeclare package Medium = MediumA,
    m_flow_nominal={mEas_flow_nominal + mNor_flow_nominal + mWes_flow_nominal,
        mNor_flow_nominal + mWes_flow_nominal,mEas_flow_nominal},
    from_dp=false,
    linearized=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal(each displayUnit="Pa") = {0,0,0},
    portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering)
    "Splitter for room return"
    annotation (Placement(transformation(extent={{992,10},{1012,-10}})));
  Buildings.Fluid.FixedResistances.Junction splRetNor(
    redeclare package Medium = MediumA,
    m_flow_nominal={mNor_flow_nominal + mWes_flow_nominal,mWes_flow_nominal,
        mNor_flow_nominal},
    from_dp=false,
    linearized=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal(each displayUnit="Pa") = {0,0,0},
    portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering)
    "Splitter for room return"
    annotation (Placement(transformation(extent={{1150,10},{1170,-10}})));
  Buildings.Fluid.FixedResistances.Junction splSupRoo1(
    redeclare package Medium = MediumA,
    m_flow_nominal={m_flow_nominal,m_flow_nominal - mCor_flow_nominal,
        mCor_flow_nominal},
    from_dp=true,
    linearized=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal(each displayUnit="Pa") = {0,0,0},
    portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving)
    "Splitter for room supply"
    annotation (Placement(transformation(extent={{580,-30},{600,-50}})));
  Buildings.Fluid.FixedResistances.Junction splSupSou(
    redeclare package Medium = MediumA,
    m_flow_nominal={mSou_flow_nominal + mEas_flow_nominal + mNor_flow_nominal
         + mWes_flow_nominal,mEas_flow_nominal + mNor_flow_nominal +
        mWes_flow_nominal,mSou_flow_nominal},
    from_dp=true,
    linearized=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal(each displayUnit="Pa") = {0,0,0},
    portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving)
    "Splitter for room supply"
    annotation (Placement(transformation(extent={{760,-30},{780,-50}})));
  Buildings.Fluid.FixedResistances.Junction splSupEas(
    redeclare package Medium = MediumA,
    m_flow_nominal={mEas_flow_nominal + mNor_flow_nominal + mWes_flow_nominal,
        mNor_flow_nominal + mWes_flow_nominal,mEas_flow_nominal},
    from_dp=true,
    linearized=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal(each displayUnit="Pa") = {0,0,0},
    portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving)
    "Splitter for room supply"
    annotation (Placement(transformation(extent={{940,-30},{960,-50}})));
  Buildings.Fluid.FixedResistances.Junction splSupNor(
    redeclare package Medium = MediumA,
    m_flow_nominal={mNor_flow_nominal + mWes_flow_nominal,mWes_flow_nominal,
        mNor_flow_nominal},
    from_dp=true,
    linearized=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal(each displayUnit="Pa") = {0,0,0},
    portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving)
    "Splitter for room supply"
    annotation (Placement(transformation(extent={{1100,-30},{1120,-50}})));
  BoundaryConditions.WeatherData.Bus weaBus "Weather Data Bus"
    annotation (Placement(transformation(extent={{-330,170},{-310,190}}),
        iconTransformation(extent={{-88,68},{-68,88}})));

  Modelica.Blocks.Routing.DeMultiplex5 TRooAir(u(each unit="K", each
        displayUnit="degC")) "Demultiplex for room air temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={488,286})));

  Buildings.Air.Systems.MultiZone.VAVReheat.BaseClasses.MixingBox eco(
    redeclare package Medium = MediumA,
    mOut_flow_nominal=m_flow_nominal,
    dpOut_nominal=10,
    mRec_flow_nominal=m_flow_nominal,
    dpRec_nominal=10,
    mExh_flow_nominal=m_flow_nominal,
    dpExh_nominal=10,
    from_dp=false) "Economizer" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-10,-46})));

  Results res(
    final A=ATot,
    PFan=fanSup.P + 0,
    PHea=heaCoi.Q2_flow + cor.terHea.Q2_flow + nor.terHea.Q2_flow + wes.terHea.Q2_flow
         + eas.terHea.Q2_flow + sou.terHea.Q2_flow,
    PCooSen=cooCoi.QSen2_flow,
    PCooLat=cooCoi.QLat2_flow) "Results of the simulation";
  /*fanRet*/

  parameter Modelica.SIunits.VolumeFlowRate VPriSysMax_flow=m_flow_nominal/1.2
    "Maximum expected system primary airflow rate at design stage";
  parameter Modelica.SIunits.VolumeFlowRate minZonPriFlo[numZon]={
    conVAVCor.VDisSetMin_flow, conVAVSou.VDisSetMin_flow,
    conVAVEas.VDisSetMin_flow, conVAVNor.VDisSetMin_flow,
    conVAVWes.VDisSetMin_flow}
    "Minimum expected zone primary flow rate";
  parameter Modelica.SIunits.Time samplePeriod=120
    "Sample period of component, set to the same value as the trim and respond that process yPreSetReq";
  parameter Modelica.SIunits.PressureDifference dpDisRetMax=40
    "Maximum return fan discharge static pressure setpoint";

  Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Controller conVAVCor(
    V_flow_nominal=mCor_flow_nominal/1.2,
    AFlo=AFloCor,
    final samplePeriod=samplePeriod,
    VDisSetMin_flow=max(1.5*VCorOA_flow_nominal, 0.15*mCor_flow_nominal/1.2),
    VDisHeaSetMax_flow=ratVFloHea*mCor_flow_nominal/1.2)
    "Controller for terminal unit core"
    annotation (Placement(transformation(extent={{530,84},{550,104}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Controller conVAVSou(
    V_flow_nominal=mSou_flow_nominal/1.2,
    AFlo=AFloSou,
    final samplePeriod=samplePeriod,
    VDisSetMin_flow=max(1.5*VSouOA_flow_nominal, 0.15*mSou_flow_nominal/1.2),
    VDisHeaSetMax_flow=ratVFloHea*mSou_flow_nominal/1.2)
    "Controller for terminal unit south"
    annotation (Placement(transformation(extent={{702,84},{722,104}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Controller conVAVEas(
    V_flow_nominal=mEas_flow_nominal/1.2,
    AFlo=AFloEas,
    final samplePeriod=samplePeriod,
    VDisSetMin_flow=max(1.5*VEasOA_flow_nominal, 0.15*mEas_flow_nominal/1.2),
    VDisHeaSetMax_flow=ratVFloHea*mEas_flow_nominal/1.2)
    "Controller for terminal unit east"
    annotation (Placement(transformation(extent={{880,84},{900,104}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Controller conVAVNor(
    V_flow_nominal=mNor_flow_nominal/1.2,
    AFlo=AFloNor,
    final samplePeriod=samplePeriod,
    VDisSetMin_flow=max(1.5*VNorOA_flow_nominal, 0.15*mNor_flow_nominal/1.2),
    VDisHeaSetMax_flow=ratVFloHea*mNor_flow_nominal/1.2)
    "Controller for terminal unit north"
    annotation (Placement(transformation(extent={{1038,84},{1058,104}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Controller conVAVWes(
    V_flow_nominal=mWes_flow_nominal/1.2,
    AFlo=AFloWes,
    final samplePeriod=samplePeriod,
    VDisSetMin_flow=max(1.5*VWesOA_flow_nominal, 0.15*mWes_flow_nominal/1.2),
    VDisHeaSetMax_flow=ratVFloHea*mWes_flow_nominal/1.2)
    "Controller for terminal unit west"
    annotation (Placement(transformation(extent={{1240,84},{1260,104}})));
  Modelica.Blocks.Routing.Multiplex5 TDis "Discharge air temperatures"
    annotation (Placement(transformation(extent={{220,360},{240,380}})));
  Modelica.Blocks.Routing.Multiplex5 VDis_flow
    "Air flow rate at the terminal boxes"
    annotation (Placement(transformation(extent={{220,320},{240,340}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum TZonResReq(nin=5)
    "Number of zone temperature requests"
    annotation (Placement(transformation(extent={{300,360},{320,380}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum PZonResReq(nin=5)
    "Number of zone pressure requests"
    annotation (Placement(transformation(extent={{300,320},{320,340}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yExhDam(k=1)
    "Exhaust air damper control signal"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swiFreSta "Switch for freeze stat"
    annotation (Placement(transformation(extent={{60,-202},{80,-182}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yFreHeaCoi(final k=1)
    "Flow rate signal for heating coil when freeze stat is on"
    annotation (Placement(transformation(extent={{0,-192},{20,-172}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller conAHU(
    kMinOut=0.03,
    final pMaxSet=410,
    final yFanMin=yFanMin,
    final VPriSysMax_flow=VPriSysMax_flow,
    final peaSysPop=divP*sum({ratP_A*AFlo[i] for i in 1:numZon}))
    "AHU controller"
    annotation (Placement(transformation(extent={{340,512},{420,640}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.Zone
    zonOutAirSet[numZon](
    final AFlo=AFlo,
    final have_occSen=fill(false, numZon),
    final have_winSen=fill(false, numZon),
    final desZonPop={ratP_A*AFlo[i] for i in 1:numZon},
    final minZonPriFlo=minZonPriFlo)
    "Zone level calculation of the minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{220,580},{240,600}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.SumZone
    zonToSys(final numZon=numZon) "Sum up zone calculation output"
    annotation (Placement(transformation(extent={{280,570},{300,590}})));
  Buildings.Controls.OBC.CDL.Routing.RealReplicator reaRep1(final nout=numZon)
    "Replicate design uncorrected minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{460,580},{480,600}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep1(final nout=numZon)
    "Replicate signal whether the outdoor airflow is required"
    annotation (Placement(transformation(extent={{460,550},{480,570}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.ZoneStatus zonSta[numZon]
    "Check zone temperature status"
    annotation (Placement(transformation(extent={{-220,268},{-200,296}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.GroupStatus zonGroSta(
    final numZon=numZon) "Check zone group status according to the zones status"
    annotation (Placement(transformation(extent={{-160,260},{-140,300}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.OperationMode
    opeModSel(final numZon=numZon)
    annotation (Placement(transformation(extent={{-100,284},{-80,316}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.SetPoints.ZoneTemperatures
    TZonSet[numZon](
    final have_occSen=fill(false, numZon),
    final have_winSen=fill(false, numZon))  "Zone setpoint"
    annotation (Placement(transformation(extent={{-100,180},{-80,208}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant warCooTim[numZon](
    final k=fill(1800, numZon)) "Warm up and cool down time"
    annotation (Placement(transformation(extent={{-300,370},{-280,390}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant falSta[numZon](
    final k=fill(false, numZon))
    "All windows are closed, no zone has override switch"
    annotation (Placement(transformation(extent={{-300,330},{-280,350}})));
  Buildings.Controls.OBC.CDL.Routing.RealReplicator reaRep(nout=numZon)
    "Assume all zones have same occupancy schedule"
    annotation (Placement(transformation(extent={{-200,-190},{-180,-170}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep(nout=numZon)
    "Assume all zones have same occupancy schedule"
    annotation (Placement(transformation(extent={{-200,-150},{-180,-130}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant demLimLev[numZon](
    final  k=fill(0, numZon)) "Demand limit level, assumes to be 0"
    annotation (Placement(transformation(extent={{-300,230},{-280,250}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerReplicator intRep(
    final nout=numZon)
    "All zones in same operation mode"
    annotation (Placement(transformation(extent={{-140,220},{-120,240}})));

public
  Buildings.Controls.OBC.CDL.Continuous.Gain gaiHeaCoi(k=m_flow_nominal*1000*40
        /4200/10) "Gain for heating coil mass flow rate"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={124,-172})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gaiCooCoi(k=m_flow_nominal*1000*15
        /4200/10) "Gain for cooling coil mass flow rate"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={222,-174})));
  Buildings.Controls.OBC.CDL.Logical.OnOffController freSta(bandwidth=1)
    "Freeze stat for heating coil"
    annotation (Placement(transformation(extent={{0,-100},{20,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant freStaTSetPoi(k=273.15
         + 3) "Freeze stat set point for heating coil"
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));
  Fluid.Sources.MassFlowSource_T souHeaCor(
    redeclare package Medium = MediumW,
    T=THotWatInl_nominal,
    use_m_flow_in=true,
    nPorts=1) "Source for core zone reheat coil" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={540,38})));
  Fluid.Sources.MassFlowSource_T souHeaSou(
    redeclare package Medium = MediumW,
    T=THotWatInl_nominal,
    use_m_flow_in=true,
    nPorts=1) "Source for south zone reheat coil" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={722,36})));
  Fluid.Sources.MassFlowSource_T souHeaEas(
    redeclare package Medium = MediumW,
    T=THotWatInl_nominal,
    use_m_flow_in=true,
    nPorts=1) "Source for east zone reheat coil" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={896,36})));
  Fluid.Sources.MassFlowSource_T souHeaNor(
    redeclare package Medium = MediumW,
    T=THotWatInl_nominal,
    use_m_flow_in=true,
    nPorts=1) "Source for north zone reheat coil" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={1058,36})));
  Fluid.Sources.MassFlowSource_T souHeaWes(
    redeclare package Medium = MediumW,
    T=THotWatInl_nominal,
    use_m_flow_in=true,
    nPorts=1) "Source for west zone reheat coil" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={1252,36})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gaiHeaCoiCor(
    k=cor.mHotWat_flow_nominal) "Gain for core zone reheat coil mass flow rate"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={504,46})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gaiHeaCoiSou(
    k=sou.mHotWat_flow_nominal) "Gain for south zone reheat coil mass flow rate"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={690,44})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gaiHeaCoiEas(
    k=eas.mHotWat_flow_nominal) "Gain for east zone reheat coil mass flow rate"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={862,44})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gaiHeaCoiNor(
    k=nor.mHotWat_flow_nominal) "Gain for north zone reheat coil mass flow rate"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={1028,44})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gaiHeaCoiWes(
    k=wes.mHotWat_flow_nominal) "Gain for west zone reheat coil mass flow rate"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={1218,44})));

  Modelica.Blocks.Interfaces.RealInput floTRooAir[5](
    each unit="K",
    each displayUnit="degC") "Room air temperatures"
    annotation (Placement(transformation(extent={{23,-23},{-23,23}},
        rotation=180,
        origin={1219,509}),
        iconTransformation(extent={{-100,-10},{-80,10}})));
  Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_a portsSou[2](
    redeclare package Medium = MediumA) "South zone fluid inlets and outlets"
    annotation (
      Placement(transformation(extent={{754,288},{834,312}}),
        iconTransformation(extent={{56,-44},{86,-36}})));
  Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_a portsWes[2](
    redeclare package Medium = MediumA) "West zone fluid inlets and outlets"
    annotation (
      Placement(transformation(extent={{1296,288},{1376,312}}),
        iconTransformation(extent={{56,76},{86,84}})));
  Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_a portsNor[2](
    redeclare package Medium = MediumA) "North zone fluid inlets and outlets"
    annotation (
      Placement(transformation(extent={{1094,288},{1174,312}}),
        iconTransformation(extent={{56,36},{86,44}})));
  Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_a portsEas[2](
    redeclare package Medium = MediumA) "East zone fluid inlets and outlets"
    annotation (
      Placement(transformation(extent={{936,288},{1016,312}}),
        iconTransformation(extent={{56,-4},{86,4}})));
  Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_a portsCor[2](
    redeclare package Medium = MediumA) "Core zone fluid inlets and outlets"
    annotation (
      Placement(transformation(extent={{574,288},{654,312}}),
        iconTransformation(extent={{56,-84},{86,-76}})));
protected
  constant Modelica.SIunits.SpecificHeatCapacity cpAir=
    Buildings.Utilities.Psychrometrics.Constants.cpAir
    "Air specific heat capacity";
  constant Modelica.SIunits.SpecificHeatCapacity cpWatLiq=
    Buildings.Utilities.Psychrometrics.Constants.cpWatLiq
    "Water specific heat capacity";
  model Results "Model to store the results of the simulation"
    parameter Modelica.SIunits.Area A "Floor area";
    input Modelica.SIunits.Power PFan "Fan energy";
    input Modelica.SIunits.Power PHea "Heating energy";
    input Modelica.SIunits.Power PCooSen "Sensible cooling energy";
    input Modelica.SIunits.Power PCooLat "Latent cooling energy";

    Real EFan(
      unit="J/m2",
      start=0,
      nominal=1E5,
      fixed=true) "Fan energy";
    Real EHea(
      unit="J/m2",
      start=0,
      nominal=1E5,
      fixed=true) "Heating energy";
    Real ECooSen(
      unit="J/m2",
      start=0,
      nominal=1E5,
      fixed=true) "Sensible cooling energy";
    Real ECooLat(
      unit="J/m2",
      start=0,
      nominal=1E5,
      fixed=true) "Latent cooling energy";
    Real ECoo(unit="J/m2") "Total cooling energy";
  equation

    A*der(EFan) = PFan;
    A*der(EHea) = PHea;
    A*der(ECooSen) = PCooSen;
    A*der(ECooLat) = PCooLat;
    ECoo = ECooSen + ECooLat;

  end Results;

equation
  connect(fanSup.port_b, dpDisSupFan.port_a) annotation (Line(
      points={{320,-40},{320,-10}},
      color={0,0,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));
  connect(TSup.port_a, fanSup.port_b) annotation (Line(
      points={{330,-40},{320,-40}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(amb.ports[1], VOut1.port_a) annotation (Line(
      points={{-114,-42.0667},{-94,-42.0667},{-94,-33},{-72,-33}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splRetRoo1.port_1, dpRetDuc.port_a) annotation (Line(
      points={{630,0},{430,0},{430,140},{400,140}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splRetNor.port_1, splRetEas.port_2) annotation (Line(
      points={{1150,0},{1012,0}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splRetEas.port_1, splRetSou.port_2) annotation (Line(
      points={{992,0},{952,0},{952,0},{912,0},{912,0},{832,0}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splRetSou.port_1, splRetRoo1.port_2) annotation (Line(
      points={{812,0},{650,0}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splSupRoo1.port_3, cor.port_aAir) annotation (Line(
      points={{590,-30},{590,-4},{590,22},{590,22}},
      color={0,127,255},
      thickness=0.5));
  connect(splSupRoo1.port_2, splSupSou.port_1) annotation (Line(
      points={{600,-40},{760,-40}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splSupSou.port_3, sou.port_aAir) annotation (Line(
      points={{770,-30},{770,-6},{770,20},{770,20}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splSupSou.port_2, splSupEas.port_1) annotation (Line(
      points={{780,-40},{940,-40}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splSupEas.port_3, eas.port_aAir) annotation (Line(
      points={{950,-30},{950,-6},{950,20},{950,20}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splSupEas.port_2, splSupNor.port_1) annotation (Line(
      points={{960,-40},{1100,-40}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splSupNor.port_3, nor.port_aAir) annotation (Line(
      points={{1110,-30},{1110,-6},{1110,20},{1110,20}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splSupNor.port_2, wes.port_aAir) annotation (Line(
      points={{1120,-40},{1310,-40},{1310,20}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(cooCoi.port_b1, sinCoo.ports[1]) annotation (Line(
      points={{190,-52},{180,-52},{180,-110}},
      color={28,108,200},
      thickness=0.5));
  connect(weaBus.TDryBul, TOut.u) annotation (Line(
      points={{-320,180},{-302,180}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(amb.weaBus, weaBus) annotation (Line(
      points={{-136,-44.78},{-320,-44.78},{-320,180}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(splRetRoo1.port_3, portsCor[2]) annotation (Line(
      points={{640,10},{640,300},{634,300}},
      color={0,127,255},
      thickness=0.5));
  connect(splRetSou.port_3, portsSou[2]) annotation (Line(
      points={{822,10},{822,300},{814,300}},
      color={0,127,255},
      thickness=0.5));
  connect(splRetEas.port_3, portsEas[2]) annotation (Line(
      points={{1002,10},{1002,300},{996,300}},
      color={0,127,255},
      thickness=0.5));
  connect(splRetNor.port_3, portsNor[2]) annotation (Line(
      points={{1160,10},{1160,300},{1154,300}},
      color={0,127,255},
      thickness=0.5));
  connect(splRetNor.port_2, portsWes[2]) annotation (Line(
      points={{1170,0},{1364,0},{1364,300},{1356,300}},
      color={0,127,255},
      thickness=0.5));
  connect(floTRooAir, min.u) annotation (Line(
      points={{1219,509},{1284.7,509},{1284.7,452},{1318,452}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(floTRooAir, ave.u) annotation (Line(
      points={{1219,509},{1286,509},{1286,422},{1318,422}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(TRooAir.u, floTRooAir) annotation (Line(
      points={{488,298},{488,608},{1282,608},{1282,509},{1219,509}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));

  connect(cooCoi.port_b2, fanSup.port_a) annotation (Line(
      points={{210,-40},{300,-40}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));

  connect(cor.port_bAir, portsCor[1]) annotation (Line(
      points={{590,62},{590,300},{594,300}},
      color={0,127,255},
      thickness=0.5));
  connect(sou.port_bAir, portsSou[1]) annotation (Line(
      points={{770,60},{770,300},{774,300}},
      color={0,127,255},
      thickness=0.5));
  connect(eas.port_bAir, portsEas[1]) annotation (Line(
      points={{950,60},{950,300},{956,300}},
      color={0,127,255},
      thickness=0.5));
  connect(nor.port_bAir, portsNor[1]) annotation (Line(
      points={{1110,60},{1110,300},{1114,300}},
      color={0,127,255},
      thickness=0.5));
  connect(wes.port_bAir, portsWes[1]) annotation (Line(
      points={{1310,60},{1310,300},{1316,300}},
      color={0,127,255},
      thickness=0.5));

  connect(VOut1.port_b, eco.port_Out) annotation (Line(
      points={{-50,-33},{-42,-33},{-42,-40},{-20,-40}},
      color={0,127,255},
      thickness=0.5));
  connect(eco.port_Sup, TMix.port_a) annotation (Line(
      points={{0,-40},{30,-40}},
      color={0,127,255},
      thickness=0.5));
  connect(eco.port_Exh, amb.ports[2]) annotation (Line(
      points={{-20,-52},{-96,-52},{-96,-45},{-114,-45}},
      color={0,127,255},
      thickness=0.5));
  connect(eco.port_Ret, TRet.port_b) annotation (Line(
      points={{0,-52},{10,-52},{10,140},{90,140}},
      color={0,127,255},
      thickness=0.5));
  connect(senRetFlo.port_a, dpRetDuc.port_b)
    annotation (Line(points={{360,140},{380,140}}, color={0,127,255}));
  connect(TSup.port_b, senSupFlo.port_a)
    annotation (Line(points={{350,-40},{400,-40}}, color={0,127,255}));
  connect(senSupFlo.port_b, splSupRoo1.port_1)
    annotation (Line(points={{420,-40},{580,-40}}, color={0,127,255}));
  connect(cooCoi.port_a1, souCoo.ports[1]) annotation (Line(
      points={{210,-52},{230,-52},{230,-110}},
      color={28,108,200},
      thickness=0.5));
  connect(gaiHeaCoi.y, souHea.m_flow_in) annotation (Line(points={{124,-160},{
          124,-132}},            color={0,0,127}));
  connect(gaiCooCoi.y, souCoo.m_flow_in) annotation (Line(points={{222,-162},{
          222,-132}},            color={0,0,127}));
  connect(dpDisSupFan.port_b, amb.ports[3]) annotation (Line(
      points={{320,10},{320,14},{-88,14},{-88,-47.9333},{-114,-47.9333}},
      color={0,0,0},
      pattern=LinePattern.Dot));
  connect(senRetFlo.port_b, TRet.port_a) annotation (Line(points={{340,140},{
          226,140},{110,140}}, color={0,127,255}));
  connect(freStaTSetPoi.y, freSta.reference)
    annotation (Line(points={{-18,-90},{-10,-90},{-10,-84},{-2,-84}},
                                                  color={0,0,127}));
  connect(freSta.u, TMix.T) annotation (Line(points={{-2,-96},{-6,-96},{-6,-68},
          {20,-68},{20,-20},{40,-20},{40,-29}}, color={0,0,127}));
  connect(TMix.port_b, heaCoi.port_a2) annotation (Line(
      points={{50,-40},{98,-40}},
      color={0,127,255},
      thickness=0.5));
  connect(heaCoi.port_b2, cooCoi.port_a2) annotation (Line(
      points={{118,-40},{190,-40}},
      color={0,127,255},
      thickness=0.5));
  connect(souHea.ports[1], heaCoi.port_a1) annotation (Line(
      points={{132,-110},{132,-52},{118,-52}},
      color={28,108,200},
      thickness=0.5));
  connect(heaCoi.port_b1, sinHea.ports[1]) annotation (Line(
      points={{98,-52},{90,-52},{90,-234.667}},
      color={28,108,200},
      thickness=0.5));
  connect(cor.port_bHotWat, sinHea.ports[2]) annotation (Line(points={{570,30},{
          560,30},{560,-240},{322,-240},{322,-236},{90,-236}},
                                          color={0,127,255}));
  connect(sou.port_bHotWat, sinHea.ports[3]) annotation (Line(points={{750,28},
          {740,28},{740,-240},{412,-240},{412,-237.333},{90,-237.333}},
                                                  color={0,127,255}));
  connect(eas.port_bHotWat, sinHea.ports[4]) annotation (Line(points={{930,28},
          {920,28},{920,-240},{504,-240},{504,-238.667},{90,-238.667}},
                                                  color={0,127,255}));
  connect(nor.port_bHotWat, sinHea.ports[5]) annotation (Line(points={{1090,28},
          {1080,28},{1080,-240},{90,-240}}, color={0,127,255}));
  connect(wes.port_bHotWat, sinHea.ports[6]) annotation (Line(points={{1290,28},
          {1280,28},{1280,-240},{90,-240},{90,-241.333}}, color={0,127,255}));
  connect(souHeaCor.m_flow_in, gaiHeaCoiCor.y)
    annotation (Line(points={{528,46},{516,46}}, color={0,0,127}));
  connect(souHeaSou.m_flow_in, gaiHeaCoiSou.y)
    annotation (Line(points={{710,44},{702,44}}, color={0,0,127}));
  connect(souHeaEas.m_flow_in, gaiHeaCoiEas.y)
    annotation (Line(points={{884,44},{874,44}}, color={0,0,127}));
  connect(souHeaNor.m_flow_in, gaiHeaCoiNor.y)
    annotation (Line(points={{1046,44},{1040,44}}, color={0,0,127}));
  connect(souHeaWes.m_flow_in, gaiHeaCoiWes.y)
    annotation (Line(points={{1240,44},{1230,44}}, color={0,0,127}));
  connect(souHeaCor.ports[1], cor.port_aHotWat) annotation (Line(points={{550,38},
          {560,38},{560,42},{570,42}},         color={0,127,255}));
  connect(souHeaSou.ports[1], sou.port_aHotWat) annotation (Line(points={{732,36},
          {740,36},{740,40},{750,40}},         color={0,127,255}));
  connect(souHeaEas.ports[1], eas.port_aHotWat) annotation (Line(points={{906,36},
          {920,36},{920,40},{930,40}},         color={0,127,255}));
  connect(souHeaNor.ports[1], nor.port_aHotWat) annotation (Line(points={{1068,36},
          {1080,36},{1080,40},{1090,40}},         color={0,127,255}));
  connect(souHeaWes.ports[1], wes.port_aHotWat) annotation (Line(points={{1262,36},
          {1280,36},{1280,40},{1290,40}},         color={0,127,255}));
  connect(conVAVCor.TZon, TRooAir.y5[1]) annotation (Line(
      points={{528,94},{520,94},{520,275},{480,275}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(conVAVSou.TZon, TRooAir.y1[1]) annotation (Line(
      points={{700,94},{656,94},{656,40},{680,40},{680,275},{496,275}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TRooAir.y2[1], conVAVEas.TZon) annotation (Line(
      points={{492,275},{868,275},{868,94},{878,94}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TRooAir.y3[1], conVAVNor.TZon) annotation (Line(
      points={{488,275},{1028,275},{1028,94},{1036,94}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TRooAir.y4[1], conVAVWes.TZon) annotation (Line(
      points={{484,275},{1220,275},{1220,94},{1238,94}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(conVAVCor.TDis, cor.TSup) annotation (Line(points={{528,88},{466,88},{
          466,74},{620,74},{620,50},{612,50}},  color={0,0,127}));
  connect(sou.TSup, conVAVSou.TDis) annotation (Line(points={{792,48},{800,48},{
          800,72},{684,72},{684,88},{700,88}},
                              color={0,0,127}));
  connect(eas.TSup, conVAVEas.TDis) annotation (Line(points={{972,48},{980,48},{
          980,74},{870,74},{870,88},{878,88}},
                              color={0,0,127}));
  connect(nor.TSup, conVAVNor.TDis) annotation (Line(points={{1132,48},{1140,48},
          {1140,74},{1032,74},{1032,88},{1036,88}},
                                    color={0,0,127}));
  connect(wes.TSup, conVAVWes.TDis) annotation (Line(points={{1332,48},{1340,48},
          {1340,74},{1228,74},{1228,88},{1238,88}},
                                    color={0,0,127}));
  connect(cor.yVAV, conVAVCor.yDam) annotation (Line(points={{566,54},{556,54},{
          556,100},{552,100}},
                             color={0,0,127}));
  connect(conVAVSou.yDam, sou.yVAV) annotation (Line(points={{724,100},{730,100},
          {730,52},{746,52}},color={0,0,127}));
  connect(conVAVEas.yDam, eas.yVAV) annotation (Line(points={{902,100},{910,100},
          {910,52},{926,52}},color={0,0,127}));
  connect(conVAVNor.yDam, nor.yVAV) annotation (Line(points={{1060,100},{1072.5,
          100},{1072.5,52},{1086,52}},color={0,0,127}));
  connect(wes.yVAV, conVAVWes.yDam) annotation (Line(points={{1286,52},{1274,52},
          {1274,100},{1262,100}},
                                color={0,0,127}));
  connect(conVAVCor.yZonTemResReq, TZonResReq.u[1]) annotation (Line(points={{552,90},
          {554,90},{554,220},{280,220},{280,375.6},{298,375.6}},         color=
          {255,127,0}));
  connect(conVAVSou.yZonTemResReq, TZonResReq.u[2]) annotation (Line(points={{724,90},
          {726,90},{726,220},{280,220},{280,372.8},{298,372.8}},         color=
          {255,127,0}));
  connect(conVAVEas.yZonTemResReq, TZonResReq.u[3]) annotation (Line(points={{902,90},
          {904,90},{904,220},{280,220},{280,370},{298,370}},         color={255,
          127,0}));
  connect(conVAVNor.yZonTemResReq, TZonResReq.u[4]) annotation (Line(points={{1060,90},
          {1064,90},{1064,220},{280,220},{280,367.2},{298,367.2}},
        color={255,127,0}));
  connect(conVAVWes.yZonTemResReq, TZonResReq.u[5]) annotation (Line(points={{1262,90},
          {1266,90},{1266,220},{280,220},{280,364.4},{298,364.4}},
        color={255,127,0}));
  connect(conVAVCor.yZonPreResReq, PZonResReq.u[1]) annotation (Line(points={{552,86},
          {558,86},{558,214},{288,214},{288,335.6},{298,335.6}},         color=
          {255,127,0}));
  connect(conVAVSou.yZonPreResReq, PZonResReq.u[2]) annotation (Line(points={{724,86},
          {728,86},{728,214},{288,214},{288,332.8},{298,332.8}},         color=
          {255,127,0}));
  connect(conVAVEas.yZonPreResReq, PZonResReq.u[3]) annotation (Line(points={{902,86},
          {906,86},{906,214},{288,214},{288,330},{298,330}},         color={255,
          127,0}));
  connect(conVAVNor.yZonPreResReq, PZonResReq.u[4]) annotation (Line(points={{1060,86},
          {1066,86},{1066,214},{288,214},{288,327.2},{298,327.2}},
        color={255,127,0}));
  connect(conVAVWes.yZonPreResReq, PZonResReq.u[5]) annotation (Line(points={{1262,86},
          {1268,86},{1268,214},{288,214},{288,324.4},{298,324.4}},
        color={255,127,0}));
  connect(cor.VSup_flow, VDis_flow.u1[1]) annotation (Line(points={{612,58},{620,
          58},{620,74},{472,74},{472,206},{180,206},{180,340},{218,340}},
                                                                   color={0,0,
          127}));
  connect(sou.VSup_flow, VDis_flow.u2[1]) annotation (Line(points={{792,56},{800,
          56},{800,72},{744,72},{744,216},{182,216},{182,335},{218,335}},
                                                                   color={0,0,
          127}));
  connect(eas.VSup_flow, VDis_flow.u3[1]) annotation (Line(points={{972,56},{980,
          56},{980,74},{914,74},{914,206},{180,206},{180,330},{218,330}},
                                                                   color={0,0,
          127}));
  connect(nor.VSup_flow, VDis_flow.u4[1]) annotation (Line(points={{1132,56},{1140,
          56},{1140,74},{1082,74},{1082,206},{180,206},{180,325},{218,325}},
                                                                     color={0,0,
          127}));
  connect(wes.VSup_flow, VDis_flow.u5[1]) annotation (Line(points={{1332,56},{1340,
          56},{1340,74},{1286,74},{1286,204},{164,204},{164,320},{218,320}},
                                                                     color={0,0,
          127}));
  connect(cor.TSup, TDis.u1[1]) annotation (Line(points={{612,50},{620,50},{620,
          74},{466,74},{466,230},{176,230},{176,380},{218,380}},
                                                   color={0,0,127}));
  connect(sou.TSup, TDis.u2[1]) annotation (Line(points={{792,48},{800,48},{800,
          72},{688,72},{688,210},{176,210},{176,375},{218,375}},     color={0,0,
          127}));
  connect(eas.TSup, TDis.u3[1]) annotation (Line(points={{972,48},{980,48},{980,
          74},{872,74},{872,210},{176,210},{176,370},{218,370}},
                                                   color={0,0,127}));
  connect(nor.TSup, TDis.u4[1]) annotation (Line(points={{1132,48},{1140,48},{1140,
          74},{1032,74},{1032,210},{176,210},{176,365},{218,365}},
                                                    color={0,0,127}));
  connect(wes.TSup, TDis.u5[1]) annotation (Line(points={{1332,48},{1340,48},{1340,
          74},{1228,74},{1228,210},{176,210},{176,360},{218,360}},
                                                    color={0,0,127}));
  connect(conVAVCor.VDis_flow, cor.VSup_flow) annotation (Line(points={{528,92},
          {522,92},{522,74},{620,74},{620,58},{612,58}},
                                         color={0,0,127}));
  connect(sou.VSup_flow, conVAVSou.VDis_flow) annotation (Line(points={{792,56},
          {800,56},{800,72},{690,72},{690,92},{700,92}},
                                             color={0,0,127}));
  connect(eas.VSup_flow, conVAVEas.VDis_flow) annotation (Line(points={{972,56},
          {980,56},{980,74},{874,74},{874,92},{878,92}},
                                             color={0,0,127}));
  connect(nor.VSup_flow, conVAVNor.VDis_flow) annotation (Line(points={{1132,56},
          {1140,56},{1140,74},{1034,74},{1034,92},{1036,92}},
                                                color={0,0,127}));
  connect(wes.VSup_flow, conVAVWes.VDis_flow) annotation (Line(points={{1332,56},
          {1340,56},{1340,74},{1230,74},{1230,92},{1238,92}},
                                                color={0,0,127}));
  connect(TSup.T, conVAVCor.TSupAHU) annotation (Line(points={{340,-29},{340,-20},
          {462,-20},{462,86},{528,86}}, color={0,0,127}));
  connect(TSup.T, conVAVSou.TSupAHU) annotation (Line(points={{340,-29},{340,-20},
          {624,-20},{624,86},{700,86}}, color={0,0,127}));
  connect(TSup.T, conVAVEas.TSupAHU) annotation (Line(points={{340,-29},{340,-20},
          {806,-20},{806,86},{878,86}}, color={0,0,127}));
  connect(TSup.T, conVAVNor.TSupAHU) annotation (Line(points={{340,-29},{340,-20},
          {986,-20},{986,86},{1036,86}},   color={0,0,127}));
  connect(TSup.T, conVAVWes.TSupAHU) annotation (Line(points={{340,-29},{340,-20},
          {1180,-20},{1180,86},{1238,86}}, color={0,0,127}));
  connect(yExhDam.y, eco.yExh)
    annotation (Line(points={{-18,-10},{-3,-10},{-3,-34}}, color={0,0,127}));
  connect(swiFreSta.y, gaiHeaCoi.u) annotation (Line(points={{82,-192},{88,-192},
          {88,-184},{124,-184}},color={0,0,127}));
  connect(freSta.y, swiFreSta.u2) annotation (Line(points={{22,-90},{40,-90},{
          40,-192},{58,-192}}, color={255,0,255}));
  connect(yFreHeaCoi.y, swiFreSta.u1) annotation (Line(points={{22,-182},{40,-182},
          {40,-184},{58,-184}}, color={0,0,127}));
  connect(zonToSys.ySumDesZonPop, conAHU.sumDesZonPop) annotation (Line(points={{302,589},
          {308,589},{308,609.778},{336,609.778}},           color={0,0,127}));
  connect(zonToSys.VSumDesPopBreZon_flow, conAHU.VSumDesPopBreZon_flow)
    annotation (Line(points={{302,586},{310,586},{310,604.444},{336,604.444}},
        color={0,0,127}));
  connect(zonToSys.VSumDesAreBreZon_flow, conAHU.VSumDesAreBreZon_flow)
    annotation (Line(points={{302,583},{312,583},{312,599.111},{336,599.111}},
        color={0,0,127}));
  connect(zonToSys.yDesSysVenEff, conAHU.uDesSysVenEff) annotation (Line(points={{302,580},
          {314,580},{314,593.778},{336,593.778}},           color={0,0,127}));
  connect(zonToSys.VSumUncOutAir_flow, conAHU.VSumUncOutAir_flow) annotation (
      Line(points={{302,577},{316,577},{316,588.444},{336,588.444}}, color={0,0,
          127}));
  connect(zonToSys.VSumSysPriAir_flow, conAHU.VSumSysPriAir_flow) annotation (
      Line(points={{302,571},{318,571},{318,583.111},{336,583.111}}, color={0,0,
          127}));
  connect(zonToSys.uOutAirFra_max, conAHU.uOutAirFra_max) annotation (Line(
        points={{302,574},{320,574},{320,577.778},{336,577.778}}, color={0,0,127}));
  connect(zonOutAirSet.yDesZonPeaOcc, zonToSys.uDesZonPeaOcc) annotation (Line(
        points={{242,599},{270,599},{270,588},{278,588}},     color={0,0,127}));
  connect(zonOutAirSet.VDesPopBreZon_flow, zonToSys.VDesPopBreZon_flow)
    annotation (Line(points={{242,596},{268,596},{268,586},{278,586}},
                                                     color={0,0,127}));
  connect(zonOutAirSet.VDesAreBreZon_flow, zonToSys.VDesAreBreZon_flow)
    annotation (Line(points={{242,593},{266,593},{266,584},{278,584}},
        color={0,0,127}));
  connect(zonOutAirSet.yDesPriOutAirFra, zonToSys.uDesPriOutAirFra) annotation (
     Line(points={{242,590},{264,590},{264,578},{278,578}},     color={0,0,127}));
  connect(zonOutAirSet.VUncOutAir_flow, zonToSys.VUncOutAir_flow) annotation (
      Line(points={{242,587},{262,587},{262,576},{278,576}},     color={0,0,127}));
  connect(zonOutAirSet.yPriOutAirFra, zonToSys.uPriOutAirFra)
    annotation (Line(points={{242,584},{260,584},{260,574},{278,574}},
                                                     color={0,0,127}));
  connect(zonOutAirSet.VPriAir_flow, zonToSys.VPriAir_flow) annotation (Line(
        points={{242,581},{258,581},{258,572},{278,572}},     color={0,0,127}));
  connect(conAHU.yAveOutAirFraPlu, zonToSys.yAveOutAirFraPlu) annotation (Line(
        points={{424,586.667},{440,586.667},{440,468},{270,468},{270,582},{278,
          582}},
        color={0,0,127}));
  connect(conAHU.VDesUncOutAir_flow, reaRep1.u) annotation (Line(points={{424,
          597.333},{440,597.333},{440,590},{458,590}},
                                              color={0,0,127}));
  connect(reaRep1.y, zonOutAirSet.VUncOut_flow_nominal) annotation (Line(points={{482,590},
          {490,590},{490,464},{210,464},{210,581},{218,581}},          color={0,
          0,127}));
  connect(conAHU.yReqOutAir, booRep1.u) annotation (Line(points={{424,565.333},
          {444,565.333},{444,560},{458,560}},color={255,0,255}));
  connect(booRep1.y, zonOutAirSet.uReqOutAir) annotation (Line(points={{482,560},
          {496,560},{496,460},{206,460},{206,593},{218,593}}, color={255,0,255}));
  connect(floTRooAir, zonOutAirSet.TZon) annotation (Line(points={{1219,509},{1284,
          509},{1284,662},{330,662},{330,590},{218,590}},           color={0,0,127}));
  connect(TDis.y, zonOutAirSet.TDis) annotation (Line(points={{241,370},{252,
          370},{252,414},{200,414},{200,587},{218,587}},
                                                    color={0,0,127}));
  connect(VDis_flow.y, zonOutAirSet.VDis_flow) annotation (Line(points={{241,330},
          {260,330},{260,420},{194,420},{194,584},{218,584}}, color={0,0,127}));
  connect(TZonResReq.y, conAHU.uZonTemResReq) annotation (Line(points={{322,370},
          {330,370},{330,526.222},{336,526.222}}, color={255,127,0}));
  connect(PZonResReq.y, conAHU.uZonPreResReq) annotation (Line(points={{322,330},
          {326,330},{326,520.889},{336,520.889}}, color={255,127,0}));
  connect(TOut.y, conAHU.TOut) annotation (Line(points={{-279,180},{-260,180},{
          -260,625.778},{336,625.778}},
                                   color={0,0,127}));
  connect(dpDisSupFan.p_rel, conAHU.ducStaPre) annotation (Line(points={{311,0},
          {160,0},{160,620.444},{336,620.444}}, color={0,0,127}));
  connect(TSup.T, conAHU.TSup) annotation (Line(points={{340,-29},{340,-20},{
          152,-20},{152,567.111},{336,567.111}},
                                             color={0,0,127}));
  connect(TRet.T, conAHU.TOutCut) annotation (Line(points={{100,151},{100,
          561.778},{336,561.778}},
                          color={0,0,127}));
  connect(VOut1.V_flow, conAHU.VOut_flow) annotation (Line(points={{-61,-20.9},
          {-61,545.778},{336,545.778}},color={0,0,127}));
  connect(TMix.T, conAHU.TMix) annotation (Line(points={{40,-29},{40,538.667},{
          336,538.667}},
                     color={0,0,127}));
  connect(conAHU.yOutDamPos, eco.yOut) annotation (Line(points={{424,522.667},{
          448,522.667},{448,36},{-10,36},{-10,-34}},
                                                 color={0,0,127}));
  connect(conAHU.yRetDamPos, eco.yRet) annotation (Line(points={{424,533.333},{
          442,533.333},{442,40},{-16.8,40},{-16.8,-34}},
                                                     color={0,0,127}));
  connect(conAHU.yCoo, gaiCooCoi.u) annotation (Line(points={{424,544},{452,544},
          {452,-274},{222,-274},{222,-186}},         color={0,0,127}));
  connect(conAHU.yHea, swiFreSta.u3) annotation (Line(points={{424,554.667},{
          458,554.667},{458,-280},{40,-280},{40,-200},{58,-200}},
                                                              color={0,0,127}));
  connect(conAHU.ySupFanSpe, fanSup.y) annotation (Line(points={{424,618.667},{
          432,618.667},{432,-14},{310,-14},{310,-28}},
                                                   color={0,0,127}));
  connect(cor.y_actual,conVAVCor.yDam_actual)  annotation (Line(points={{612,42},
          {620,42},{620,74},{518,74},{518,90},{528,90}}, color={0,0,127}));
  connect(sou.y_actual,conVAVSou.yDam_actual)  annotation (Line(points={{792,40},
          {800,40},{800,72},{684,72},{684,90},{700,90}}, color={0,0,127}));
  connect(eas.y_actual,conVAVEas.yDam_actual)  annotation (Line(points={{972,40},
          {980,40},{980,74},{864,74},{864,90},{878,90}}, color={0,0,127}));
  connect(nor.y_actual,conVAVNor.yDam_actual)  annotation (Line(points={{1132,40},
          {1140,40},{1140,74},{1024,74},{1024,90},{1036,90}},     color={0,0,
          127}));
  connect(wes.y_actual,conVAVWes.yDam_actual)  annotation (Line(points={{1332,40},
          {1340,40},{1340,74},{1224,74},{1224,90},{1238,90}},     color={0,0,
          127}));
  connect(warCooTim.y, zonSta.cooDowTim) annotation (Line(points={{-278,380},{-240,
          380},{-240,290},{-222,290}}, color={0,0,127}));
  connect(warCooTim.y, zonSta.warUpTim) annotation (Line(points={{-278,380},{-240,
          380},{-240,286},{-222,286}}, color={0,0,127}));
  connect(floTRooAir, zonSta.TZon) annotation (Line(points={{1219,509},{1284,509},
          {1284,662},{-130,662},{-130,274},{-222,274}},                color={0,
          0,127}));
  connect(zonSta.yCooTim, zonGroSta.uCooTim) annotation (Line(points={{-198,295},
          {-176,295},{-176,291},{-162,291}}, color={0,0,127}));
  connect(zonSta.yWarTim, zonGroSta.uWarTim) annotation (Line(points={{-198,293},
          {-178,293},{-178,289},{-162,289}}, color={0,0,127}));
  connect(zonSta.yOccHeaHig, zonGroSta.uOccHeaHig) annotation (Line(points={{-198,
          288},{-180,288},{-180,285},{-162,285}}, color={255,0,255}));
  connect(zonSta.yHigOccCoo, zonGroSta.uHigOccCoo)
    annotation (Line(points={{-198,283},{-162,283}}, color={255,0,255}));
  connect(zonSta.THeaSetOff, zonGroSta.THeaSetOff) annotation (Line(points={{-198,
          280},{-182,280},{-182,277},{-162,277}}, color={0,0,127}));
  connect(zonSta.yUnoHeaHig, zonGroSta.uUnoHeaHig) annotation (Line(points={{-198,
          278},{-188,278},{-188,279},{-162,279}}, color={255,0,255}));
  connect(zonSta.yEndSetBac, zonGroSta.uEndSetBac) annotation (Line(points={{-198,
          276},{-188,276},{-188,275},{-162,275}}, color={255,0,255}));
  connect(zonSta.TCooSetOff, zonGroSta.TCooSetOff) annotation (Line(points={{-198,
          273},{-190,273},{-190,269},{-162,269}}, color={0,0,127}));
  connect(zonSta.yHigUnoCoo, zonGroSta.uHigUnoCoo)
    annotation (Line(points={{-198,271},{-162,271}}, color={255,0,255}));
  connect(zonSta.yEndSetUp, zonGroSta.uEndSetUp) annotation (Line(points={{-198,
          269},{-192,269},{-192,267},{-162,267}}, color={255,0,255}));
  connect(floTRooAir, zonGroSta.TZon) annotation (Line(points={{1219,509},{1284,
          509},{1284,662},{-130,662},{-130,263},{-162,263}},
        color={0,0,127}));
  connect(falSta.y, zonGroSta.uWin) annotation (Line(points={{-278,340},{-172,
          340},{-172,261},{-162,261}}, color={255,0,255}));
  connect(occSch.tNexOcc, reaRep.u) annotation (Line(points={{-297,-204},{-236,
          -204},{-236,-180},{-202,-180}}, color={0,0,127}));
  connect(reaRep.y, zonGroSta.tNexOcc) annotation (Line(points={{-178,-180},{-164,
          -180},{-164,295},{-162,295}}, color={0,0,127}));
  connect(occSch.occupied, booRep.u) annotation (Line(points={{-297,-216},{-220,
          -216},{-220,-140},{-202,-140}}, color={255,0,255}));
  connect(booRep.y, zonGroSta.uOcc) annotation (Line(points={{-178,-140},{-166,
          -140},{-166,297},{-162,297}}, color={255,0,255}));
  connect(falSta.y, zonGroSta.zonOcc) annotation (Line(points={{-278,340},{-172,
          340},{-172,299},{-162,299}}, color={255,0,255}));
  connect(zonGroSta.uGroOcc, opeModSel.uOcc) annotation (Line(points={{-138,299},
          {-136,299},{-136,314},{-102,314}}, color={255,0,255}));
  connect(zonGroSta.nexOcc, opeModSel.tNexOcc) annotation (Line(points={{-138,
          297},{-134,297},{-134,312},{-102,312}}, color={0,0,127}));
  connect(zonGroSta.yCooTim, opeModSel.maxCooDowTim) annotation (Line(points={{
          -138,293},{-132,293},{-132,310},{-102,310}}, color={0,0,127}));
  connect(zonGroSta.yWarTim, opeModSel.maxWarUpTim) annotation (Line(points={{-138,
          291},{-128,291},{-128,306},{-102,306}}, color={0,0,127}));
  connect(zonGroSta.yOccHeaHig, opeModSel.uOccHeaHig) annotation (Line(points={
          {-138,287},{-126,287},{-126,304},{-102,304}}, color={255,0,255}));
  connect(zonGroSta.yHigOccCoo, opeModSel.uHigOccCoo) annotation (Line(points={
          {-138,285},{-130,285},{-130,308},{-102,308}}, color={255,0,255}));
  connect(zonGroSta.yColZon, opeModSel.totColZon) annotation (Line(points={{-138,
          282},{-122,282},{-122,300},{-102,300}}, color={255,127,0}));
  connect(zonGroSta.ySetBac, opeModSel.uSetBac) annotation (Line(points={{-138,280},
          {-120,280},{-120,298},{-102,298}},      color={255,0,255}));
  connect(zonGroSta.yEndSetBac, opeModSel.uEndSetBac) annotation (Line(points={{-138,
          278},{-118,278},{-118,296},{-102,296}},       color={255,0,255}));
  connect(zonGroSta.TZonMax, opeModSel.TZonMax) annotation (Line(points={{-138,267},
          {-116,267},{-116,294},{-102,294}},      color={0,0,127}));
  connect(zonGroSta.TZonMin, opeModSel.TZonMin) annotation (Line(points={{-138,265},
          {-114,265},{-114,292},{-102,292}},      color={0,0,127}));
  connect(zonGroSta.yHotZon, opeModSel.totHotZon) annotation (Line(points={{-138,
          275},{-112,275},{-112,290},{-102,290}}, color={255,127,0}));
  connect(zonGroSta.ySetUp, opeModSel.uSetUp) annotation (Line(points={{-138,273},
          {-110,273},{-110,288},{-102,288}},      color={255,0,255}));
  connect(zonGroSta.yEndSetUp, opeModSel.uEndSetUp) annotation (Line(points={{-138,
          271},{-108,271},{-108,286},{-102,286}}, color={255,0,255}));
  connect(zonSta.THeaSetOn, TZonSet.TZonHeaSetOcc) annotation (Line(points={{
          -198,290},{-186,290},{-186,198},{-102,198}}, color={0,0,127}));
  connect(zonSta.THeaSetOff, TZonSet.TZonHeaSetUno) annotation (Line(points={{
          -198,280},{-182,280},{-182,196},{-102,196}}, color={0,0,127}));
  connect(zonSta.TCooSetOn, TZonSet.TZonCooSetOcc) annotation (Line(points={{
          -198,285},{-184,285},{-184,203},{-102,203}}, color={0,0,127}));
  connect(zonSta.TCooSetOff, TZonSet.TZonCooSetUno) annotation (Line(points={{
          -198,273},{-190,273},{-190,201},{-102,201}}, color={0,0,127}));
  connect(demLimLev.y, TZonSet.uCooDemLimLev) annotation (Line(points={{-278,
          240},{-220,240},{-220,188},{-102,188}}, color={255,127,0}));
  connect(demLimLev.y, TZonSet.uHeaDemLimLev) annotation (Line(points={{-278,
          240},{-220,240},{-220,186},{-102,186}}, color={255,127,0}));
  connect(opeModSel.yOpeMod, conVAVCor.uOpeMod) annotation (Line(points={{-78,300},
          {-16,300},{-16,76},{506,76},{506,84},{528,84}},      color={255,127,0}));
  connect(opeModSel.yOpeMod, conVAVSou.uOpeMod) annotation (Line(points={{-78,300},
          {-18,300},{-18,76},{676,76},{676,84},{700,84}},      color={255,127,0}));
  connect(opeModSel.yOpeMod, conVAVEas.uOpeMod) annotation (Line(points={{-78,300},
          {-18,300},{-18,76},{860,76},{860,84},{878,84}},      color={255,127,0}));
  connect(opeModSel.yOpeMod, conVAVNor.uOpeMod) annotation (Line(points={{-78,300},
          {-18,300},{-18,76},{1020,76},{1020,84},{1036,84}},      color={255,
          127,0}));
  connect(opeModSel.yOpeMod, conVAVWes.uOpeMod) annotation (Line(points={{-78,300},
          {-18,300},{-18,76},{1216,76},{1216,84},{1238,84}},      color={255,
          127,0}));
  connect(opeModSel.yOpeMod, conAHU.uOpeMod) annotation (Line(points={{-78,300},
          {-18,300},{-18,531.556},{336,531.556}}, color={255,127,0}));
  connect(TZonSet[1].TZonHeaSet, conAHU.TZonHeaSet) annotation (Line(points={{-78,194},
          {-36,194},{-36,636.444},{336,636.444}},          color={0,0,127}));
  connect(TZonSet[1].TZonCooSet, conAHU.TZonCooSet) annotation (Line(points={{-78,202},
          {-26,202},{-26,631.111},{336,631.111}},          color={0,0,127}));
  connect(TZonSet[1].TZonHeaSet, conVAVCor.TZonHeaSet) annotation (Line(points={{-78,194},
          {482,194},{482,104},{528,104}},          color={0,0,127}));
  connect(TZonSet[2].TZonHeaSet, conVAVSou.TZonHeaSet) annotation (Line(points={{-78,194},
          {672,194},{672,104},{700,104}},          color={0,0,127}));
  connect(TZonSet[3].TZonHeaSet, conVAVEas.TZonHeaSet) annotation (Line(points={{-78,194},
          {852,194},{852,104},{878,104}},          color={0,0,127}));
  connect(TZonSet[4].TZonHeaSet, conVAVNor.TZonHeaSet) annotation (Line(points={{-78,194},
          {1016,194},{1016,104},{1036,104}},          color={0,0,127}));
  connect(TZonSet[5].TZonHeaSet, conVAVWes.TZonHeaSet) annotation (Line(points={{-78,194},
          {1186,194},{1186,104},{1238,104}},          color={0,0,127}));
  connect(TZonSet[1].TZonCooSet, conVAVCor.TZonCooSet) annotation (Line(points={{-78,202},
          {476,202},{476,102},{528,102}},          color={0,0,127}));
  connect(TZonSet[2].TZonCooSet, conVAVSou.TZonCooSet) annotation (Line(points={{-78,202},
          {666,202},{666,102},{700,102}},          color={0,0,127}));
  connect(TZonSet[3].TZonCooSet, conVAVEas.TZonCooSet) annotation (Line(points={{-78,202},
          {844,202},{844,102},{878,102}},          color={0,0,127}));
  connect(TZonSet[4].TZonCooSet, conVAVNor.TZonCooSet) annotation (Line(points={{-78,202},
          {1010,202},{1010,102},{1036,102}},          color={0,0,127}));
  connect(TZonSet[5].TZonCooSet, conVAVWes.TZonCooSet) annotation (Line(points={{-78,202},
          {1180,202},{1180,102},{1238,102}},          color={0,0,127}));
  connect(opeModSel.yOpeMod, intRep.u) annotation (Line(points={{-78,300},{-18,
          300},{-18,250},{-160,250},{-160,230},{-142,230}}, color={255,127,0}));
  connect(intRep.y, TZonSet.uOpeMod) annotation (Line(points={{-118,230},{-110,
          230},{-110,207},{-102,207}}, color={255,127,0}));
  connect(zonGroSta.yOpeWin, opeModSel.uOpeWin) annotation (Line(points={{-138,261},
          {-124,261},{-124,302},{-102,302}}, color={255,127,0}));
  connect(conVAVCor.yVal, gaiHeaCoiCor.u)
    annotation (Line(points={{552,95},{552,68},{478,68},{478,46},{492,46}},
                                                           color={0,0,127}));
  connect(conVAVSou.yVal, gaiHeaCoiSou.u) annotation (Line(points={{724,95},{724,
          68},{664,68},{664,44},{678,44}},
                                  color={0,0,127}));
  connect(conVAVEas.yVal, gaiHeaCoiEas.u) annotation (Line(points={{902,95},{902,
          80},{838,80},{838,44},{850,44}},
                                  color={0,0,127}));
  connect(conVAVNor.yVal, gaiHeaCoiNor.u) annotation (Line(points={{1060,95},{1060,
          80},{1008,80},{1008,44},{1016,44}},
                                    color={0,0,127}));
  connect(conVAVWes.yVal, gaiHeaCoiWes.u) annotation (Line(points={{1262,95},{1262,
          82},{1196,82},{1196,44},{1206,44}},
                                    color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-380,-320},{1400,
            680}})),
    Documentation(info="<html>
<p>
This model is for a variable air volume (VAV) flow system with economizer
and a heating and cooling coil in the air handler unit. There is also a
reheat coil and an air damper in each of the five zone inlet branches.
</p>
<p>
The control is based on ASHRAE Guideline 36, and implemented
using the sequences from the library
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1\">
Buildings.Controls.OBC.ASHRAE.G36_PR1</a> for
multi-zone VAV systems with economizer. The schematic diagram of the HVAC and control
sequence is shown in the figure below.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Examples/VAVReheat/vavControlSchematics.png\" border=\"1\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
March 25, 2021, by Baptiste Ravache:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Examples/VAVReheat/Guideline36.mos"
        "Simulate and plot"),
    experiment(StopTime=172800, Tolerance=1e-06),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end Guideline36VAV;
