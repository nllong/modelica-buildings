within Districts.BuildingLoads.Examples;
model LinearRegressionCampus
  "Example model for the linear regression building load as part of a campus"
  import Districts;
  extends Modelica.Icons.Example;
  parameter Modelica.SIunits.Voltage VTra = 50e3 "Voltage of transmission grid";
  parameter Modelica.SIunits.Voltage VDis = 480
    "Voltage of the distribution grid";
  parameter Modelica.SIunits.Voltage VDC = 240 "Voltage of DC grid";

  // Rated power that is used to size cables
  parameter Modelica.SIunits.Power P_a = 1e5 "Rated power for sizing";
  parameter Modelica.SIunits.Power P_b = 1e5 "Rated power for sizing";
  parameter Modelica.SIunits.Power P_c = 1e5 "Rated power for sizing";
  parameter Modelica.SIunits.Power P_d = 1e5 "Rated power for sizing";
  parameter Modelica.SIunits.Power P_e = 1e5 "Rated power for sizing";
  parameter Modelica.SIunits.Power P_bc = P_a  + P_b "Rated power for sizing";
  parameter Modelica.SIunits.Power P_ce = P_bc + P_c "Rated power for sizing";
  parameter Modelica.SIunits.Power P_de = P_ce + P_e "Rated power for sizing";
  parameter Modelica.SIunits.Power P_dt = P_de + P_d "Rated power for sizing";
  // Declaration of the line model
  // Set the instance 'line' either to 'DummyLine' or to 'Districts.Electrical.AC.AC3ph.Lines.Line'
  model line = Districts.Electrical.AC.AC3ph.Lines.Line "Line model";

  Districts.BuildingLoads.LinearRegression buiA(fileName="Resources/Data/BuildingLoads/Examples/smallOffice_1.txt")
    "Building A"
    annotation (Placement(transformation(extent={{230,30},{250,50}})));
  Districts.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        "Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    annotation (Placement(transformation(extent={{-220,60},{-200,80}})));
  Districts.Electrical.AC.AC3ph.Sources.Grid gri(
    f=60,
    Phi=0,
    V=VTra)
           annotation (Placement(transformation(extent={{-160,0},{-140,20}})));
  Districts.Electrical.AC.AC3ph.Conversion.ACACConverter acac(eta=0.9,
      conversionFactor=VDis/VTra) "AC/AC converter"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
  line dt(
    P_nominal=P_dt,
    V_nominal=VDis,
    l=40,
    cable=Districts.Electrical.Transmission.Cables.mmq_4_0(),
    wireMaterial=Districts.Electrical.Transmission.Materials.Copper())
    "Distribution line"
    annotation (Placement(transformation(extent={{-22,-30},{-2,-10}})));
  line de(
    V_nominal=VDis,
    P_nominal=P_de,
    l=400,
    cable=Districts.Electrical.Transmission.Cables.mmq_4_0(),
    wireMaterial=Districts.Electrical.Transmission.Materials.Copper())
    "Distribution line"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  line d(
    V_nominal=VDis,
    P_nominal=P_d,
    l=20,
    cable=Districts.Electrical.Transmission.Cables.mmq_4_0(),
    wireMaterial=Districts.Electrical.Transmission.Materials.Copper())
    "Distribution line"       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={20,-50})));
  line e(
    V_nominal=VDis,
    P_nominal=P_e,
    l=20,
    cable=Districts.Electrical.Transmission.Cables.mmq_4_0(),
    wireMaterial=Districts.Electrical.Transmission.Materials.Copper())
    "Distribution line"       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={80,-50})));
  line ce(
    V_nominal=VDis,
    P_nominal=P_ce,
    l=50,
    cable=Districts.Electrical.Transmission.Cables.mmq_4_0(),
    wireMaterial=Districts.Electrical.Transmission.Materials.Copper())
    "Distribution line"
    annotation (Placement(transformation(extent={{100,-30},{120,-10}})));
  line c(
    V_nominal=VDis,
    P_nominal=P_c,
    l=60,
    cable=Districts.Electrical.Transmission.Cables.mmq_4_0(),
    wireMaterial=Districts.Electrical.Transmission.Materials.Copper())
    "Distribution line"       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={140,10})));
  line bc(
    V_nominal=VDis,
    P_nominal=P_bc,
    l=40,
    cable=Districts.Electrical.Transmission.Cables.mmq_4_0(),
    wireMaterial=Districts.Electrical.Transmission.Materials.Copper())
    "Distribution line"
    annotation (Placement(transformation(extent={{160,-30},{180,-10}})));
  line b(
    V_nominal=VDis,
    P_nominal=P_b,
    l=20,
    cable=Districts.Electrical.Transmission.Cables.mmq_4_0(),
    wireMaterial=Districts.Electrical.Transmission.Materials.Copper())
    "Distribution line"       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={200,10})));
  line a(
    V_nominal=VDis,
    P_nominal=P_a,
    l=120,
    cable=Districts.Electrical.Transmission.Cables.mmq_4_0(),
    wireMaterial=Districts.Electrical.Transmission.Materials.Copper())
    "Distribution line"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={250,-20})));
  Districts.BuildingLoads.LinearRegression buiB(fileName="Resources/Data/BuildingLoads/Examples/smallOffice_1.txt")
    "Building B"
    annotation (Placement(transformation(extent={{170,30},{190,50}})));
  Districts.BuildingLoads.LinearRegression buiC(fileName="Resources/Data/BuildingLoads/Examples/smallOffice_1.txt")
    "Building C"
    annotation (Placement(transformation(extent={{108,30},{128,50}})));
  Districts.BuildingLoads.LinearRegression buiD(fileName="Resources/Data/BuildingLoads/Examples/smallOffice_1.txt")
    "Building D"
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));
  Districts.BuildingLoads.LinearRegression buiE(fileName="Resources/Data/BuildingLoads/Examples/smallOffice_1.txt")
    "Building E"
    annotation (Placement(transformation(extent={{50,-90},{70,-70}})));

model DummyLine
  extends Districts.Electrical.Interfaces.PartialTwoPort(
      redeclare package PhaseSystem_p =
        Districts.Electrical.PhaseSystems.ThreePhase_dq,
      redeclare package PhaseSystem_n =
        Districts.Electrical.PhaseSystems.ThreePhase_dq,
      redeclare Districts.Electrical.AC.AC3ph.Interfaces.Terminal_n terminal_n,
      redeclare Districts.Electrical.AC.AC3ph.Interfaces.Terminal_n terminal_p);

  parameter Modelica.SIunits.Distance l(min=0) "Length of the line";
  parameter Modelica.SIunits.Power P_nominal(min=0) "Nominal power of the line";
  parameter Modelica.SIunits.Voltage V_nominal "Nominal voltage of the line";
  parameter Districts.Electrical.Transmission.Cables.Cable cable=
      Functions.selectCable(P_nominal, V_nominal) "Type of cable"
  annotation (choicesAllMatching=true,Dialog(tab="Tech. specification"), Placement(transformation(extent={{20,60},
              {40,80}})));
  parameter Districts.Electrical.Transmission.Materials.Material wireMaterial=
      Functions.selectMaterial(0.0) "Material of the cable"
    annotation (choicesAllMatching=true,Dialog(tab="Tech. specification"), Placement(transformation(extent={{60,60},
              {80,80}})));
equation

  connect(terminal_n, terminal_p) annotation (Line(
      points={{-100,2.22045e-16},{-4,2.22045e-16},{-4,0},{100,0}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
            preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
          graphics={
          Rectangle(extent={{-80,12},{80,-12}}, lineColor={0,0,0}),
          Line(
            points={{-80,0},{-100,0}},
            color={0,0,0},
            smooth=Smooth.None),
          Line(
            points={{80,0},{100,0}},
            color={0,0,0},
            smooth=Smooth.None)}));
end DummyLine;
  Districts.Electrical.AC.AC3ph.Sensors.GeneralizedSensor senAC
    "Sensor in AC line after the transformer"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Districts.Electrical.AC.AC3ph.Conversion.ACDCConverter acdc(conversionFactor=
        VDC/VDis, eta=0.9) "AC/DC converter"
    annotation (Placement(transformation(extent={{300,-30},{320,-10}})));
  Districts.Electrical.AC.AC3ph.Sensors.GeneralizedSensor senA
    "Sensor in AC line at building A"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={280,10})));
  Districts.Electrical.DC.Storage.Battery bat(EMax=P_dt*24*3600*0.1) "Battery"
    annotation (Placement(transformation(extent={{376,-30},{396,-10}})));
model BatteryControl_S
 extends Modelica.Blocks.Interfaces.SISO;
  parameter Modelica.SIunits.Power PMax=500e3 "Maximum power during discharge";
  Modelica.Blocks.Continuous.LimPID PI(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Ti=60,
    yMax=1,
      yMin=-1,
      Td=0) "PI controller"
    annotation (Placement(transformation(extent={{-70,20},{-50,40}})));
  Modelica.Blocks.Sources.Constant const(k=0)
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Modelica_StateGraph2.Step dischargeOnly(
      nOut=1,
      use_activePort=true,
      nIn=1,
      initialStep=false) "Allow battery to be discharged only"
    annotation (Placement(transformation(extent={{16,56},{24,64}})));
  Modelica_StateGraph2.Transition T1(
    delayedTransition=true,
    waitTime=1,
      use_conditionPort=false,
      condition=SOC < 0.8)
    annotation (Placement(transformation(extent={{16,36},{24,44}})));
  Modelica_StateGraph2.Step freeFloat(
      nOut=2,
      initialStep=false,
      use_activePort=true,
      nIn=2) "Drain or charge battery"
    annotation (Placement(transformation(extent={{-4,16},{4,24}})));
  Modelica.Blocks.Interfaces.RealInput SOC "State of charge" annotation (
      Placement(transformation(extent={{-140,60},{-100,100}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Modelica_StateGraph2.Transition T2(
    delayedTransition=true,
    waitTime=1,
      use_conditionPort=false,
    condition=SOC < 0.05)
    annotation (Placement(transformation(extent={{-24,-4},{-16,4}})));

  Modelica_StateGraph2.Step chargeOnly(
      nOut=1,
      use_activePort=true,
      nIn=1,
      initialStep=true) "Allow battery to be charged only"
    annotation (Placement(transformation(extent={{-24,56},{-16,64}})));
  Modelica_StateGraph2.Transition T3(
    delayedTransition=true,
    waitTime=1,
      use_conditionPort=false,
    condition=SOC > 0.95)
    annotation (Placement(transformation(extent={{16,-4},{24,4}})));
  Modelica_StateGraph2.Transition T4(
    delayedTransition=true,
    waitTime=1,
      use_conditionPort=false,
      condition=SOC > 0.2)
    annotation (Placement(transformation(extent={{-24,36},{-16,44}})));
    Modelica.Blocks.Sources.RealExpression realExpression(y=if chargeOnly.activePort
           then max(0, PI.y) else if dischargeOnly.activePort then min(0, PI.y)
           else PI.y)
      annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
    Modelica.Blocks.Math.Gain gain(k=PMax)
      annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T=60, initType=Modelica.Blocks.Types.Init.InitialState)
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));
equation

    connect(freeFloat.outPort[1], T2.inPort)  annotation (Line(
      points={{-1,15.4},{-1,10},{-20,10},{-20,4}},
      color={0,0,0},
      smooth=Smooth.None));
    connect(dischargeOnly.outPort[1], T1.inPort)
                                            annotation (Line(
      points={{20,55.4},{20,44}},
      color={0,0,0},
      smooth=Smooth.None));
    connect(T3.outPort, dischargeOnly.inPort[1]) annotation (Line(
        points={{20,-5},{20,-14},{60,-14},{60,74},{20,74},{20,64}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(T2.outPort, chargeOnly.inPort[1]) annotation (Line(
        points={{-20,-5},{-20,-10},{-40,-10},{-40,74},{-20,74},{-20,64}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(freeFloat.outPort[2], T3.inPort) annotation (Line(
        points={{1,15.4},{0,15.4},{0,10},{20,10},{20,4}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(chargeOnly.outPort[1], T4.inPort) annotation (Line(
        points={{-20,55.4},{-20,44}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(T4.outPort, freeFloat.inPort[1]) annotation (Line(
        points={{-20,35},{-20,30},{-1,30},{-1,24}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(T1.outPort, freeFloat.inPort[2]) annotation (Line(
        points={{20,35},{20,30},{1,30},{1,24}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(realExpression.y, gain.u) annotation (Line(
        points={{-19,-70},{18,-70}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(const.y, PI.u_s) annotation (Line(
        points={{-79,30},{-72,30}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(u, PI.u_m) annotation (Line(
        points={{-120,0},{-60,0},{-60,18}},
        color={0,0,127},
        smooth=Smooth.None));
  connect(firstOrder.u, gain.y) annotation (Line(
      points={{58,-70},{41,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(firstOrder.y, y) annotation (Line(
      points={{81,-70},{90,-70},{90,0},{110,0}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
            preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
          graphics={
          Text(
            extent={{-90,94},{-46,64}},
            lineColor={0,0,255},
            textString="SOC"),
        Rectangle(
          extent={{-74,52},{-8,8}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{20,52},{86,8}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{20,28},{10,36},{10,20},{20,28}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-74,30},{-84,38},{-84,22},{-74,30}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-8,28},{12,28}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-78,30},{-96,30}},
          color={0,0,0},
          smooth=Smooth.None),
        Rectangle(
          extent={{20,-12},{86,-56}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{20,-34},{10,-26},{10,-42},{20,-34}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{10,-36},{2,-36},{2,28}},
          color={0,0,0},
          smooth=Smooth.None)}));
end BatteryControl_S;
  BatteryControl_S conBat "Battery controller"
    annotation (Placement(transformation(extent={{360,20},{380,40}})));
  Districts.Electrical.DC.Sources.PVSimple pv(A=100*150) "PV array"
    annotation (Placement(transformation(extent={{376,80},{396,100}})));
  Modelica.Blocks.Math.Add G "Total irradiation on tilted surface"
    annotation (Placement(transformation(extent={{310,120},{330,140}})));
  Districts.BoundaryConditions.SolarIrradiation.DiffusePerez HDifTil(
    til=0.34906585039887,
    lat=0.65798912800186,
    azi=-0.78539816339745) "Diffuse irradiation on tilted surface"
    annotation (Placement(transformation(extent={{260,140},{280,160}})));
  Districts.BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil(
    til=0.34906585039887,
    lat=0.65798912800186,
    azi=-0.78539816339745) "Direct irradiation on tilted surface"
    annotation (Placement(transformation(extent={{260,100},{280,120}})));
  Districts.Electrical.DC.Sources.WindTurbine tur(h=50, scale=500e3)
    "Wind turbine"
    annotation (Placement(transformation(extent={{380,160},{400,180}})));
  Districts.BoundaryConditions.WeatherData.Bus weaBus
    annotation (Placement(transformation(extent={{270,188},{290,208}})));
equation
  connect(weaDat.weaBus,buiA. weaBus)             annotation (Line(
      points={{-200,70},{220,70},{220,40},{230,40}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(gri.terminal, acac.terminal_n)          annotation (Line(
      points={{-150,-4.44089e-16},{-150,-20},{-120,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(dt.terminal_p, de.terminal_n) annotation (Line(
      points={{-2,-20},{40,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(dt.terminal_p, d.terminal_p) annotation (Line(
      points={{-2,-20},{20,-20},{20,-40}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(de.terminal_p, ce.terminal_n) annotation (Line(
      points={{60,-20},{100,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(e.terminal_p, de.terminal_p) annotation (Line(
      points={{80,-40},{80,-20},{60,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(ce.terminal_p, bc.terminal_n) annotation (Line(
      points={{120,-20},{160,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(c.terminal_n, ce.terminal_p) annotation (Line(
      points={{140,0},{140,-20},{120,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(bc.terminal_p, a.terminal_n) annotation (Line(
      points={{180,-20},{240,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(b.terminal_n, bc.terminal_p) annotation (Line(
      points={{200,-4.44089e-16},{200,-20},{180,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(b.terminal_p, buiB.terminal) annotation (Line(
      points={{200,20},{200,40},{190.4,40}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(c.terminal_p, buiC.terminal) annotation (Line(
      points={{140,20},{140,40},{128.4,40}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(buiE.terminal, e.terminal_n) annotation (Line(
      points={{70.4,-80},{80,-80},{80,-60}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(buiD.terminal, d.terminal_n) annotation (Line(
      points={{10.4,-80},{20,-80},{20,-60}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(weaDat.weaBus, buiB.weaBus) annotation (Line(
      points={{-200,70},{160,70},{160,40},{170,40}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaDat.weaBus, buiC.weaBus) annotation (Line(
      points={{-200,70},{100,70},{100,40},{108,40}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaDat.weaBus, buiE.weaBus) annotation (Line(
      points={{-200,70},{-180,70},{-180,-100},{40,-100},{40,-80},{50,-80}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaDat.weaBus, buiD.weaBus) annotation (Line(
      points={{-200,70},{-180,70},{-180,-100},{-20,-100},{-20,-80},{-10,-80}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(acac.terminal_p, senAC.terminal_n)  annotation (Line(
      points={{-100,-20},{-80,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(senAC.terminal_p, dt.terminal_n)  annotation (Line(
      points={{-60,-20},{-22,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(a.terminal_p, senA.terminal_n) annotation (Line(
      points={{260,-20},{280,-20},{280,-4.44089e-16}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(senA.terminal_p, buiA.terminal) annotation (Line(
      points={{280,20},{280,40},{250.4,40}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(a.terminal_p, acdc.terminal_n) annotation (Line(
      points={{260,-20},{300,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(acdc.terminal_p, buiC.terminal_dc) annotation (Line(
      points={{320,-20},{340,-20},{340,24},{136,24},{136,34},{128,34}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(buiB.terminal_dc, buiC.terminal_dc) annotation (Line(
      points={{190,34},{194,34},{194,24},{136,24},{136,34},{128,34}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(buiA.terminal_dc, buiC.terminal_dc) annotation (Line(
      points={{250,34},{256,34},{256,24},{136,24},{136,34},{128,34}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(acdc.terminal_p, buiD.terminal_dc) annotation (Line(
      points={{320,-20},{340,-20},{340,-94},{20,-94},{20,-86},{10,-86}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(buiE.terminal_dc, buiD.terminal_dc) annotation (Line(
      points={{70,-86},{80,-86},{80,-94},{20,-94},{20,-86},{10,-86}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(bat.terminal, buiC.terminal_dc)     annotation (Line(
      points={{376,-20},{340,-20},{340,24},{136,24},{136,34},{128,34}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(bat.SOC, conBat.SOC) annotation (Line(
      points={{397,-14},{410,-14},{410,50},{346,50},{346,38},{358,38}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senAC.S[1], conBat.u) annotation (Line(
      points={{-76,-29},{-76,-110},{348,-110},{348,30},{358,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conBat.y, bat.P) annotation (Line(
      points={{381,30},{386,30},{386,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDifTil.H,G. u1) annotation (Line(
      points={{281,150},{300,150},{300,136},{308,136}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDirTil.H,G. u2) annotation (Line(
      points={{281,110},{300,110},{300,124},{308,124}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(G.y, pv.G) annotation (Line(
      points={{331,130},{386,130},{386,102}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pv.terminal, buiD.terminal_dc) annotation (Line(
      points={{376,90},{340,90},{340,-94},{20,-94},{20,-86},{10,-86}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(weaDat.weaBus, HDifTil.weaBus) annotation (Line(
      points={{-200,70},{220,70},{220,150},{260,150}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(HDirTil.weaBus, HDifTil.weaBus) annotation (Line(
      points={{260,110},{220,110},{220,150},{260,150}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(tur.vWin, weaBus.winSpe) annotation (Line(
      points={{390,182},{390,198},{280,198}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-200,70},{220,70},{220,198},{280,198}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(tur.terminal, acdc.terminal_p) annotation (Line(
      points={{380,170},{340,170},{340,-20},{320,-20}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-240,
            -120},{420,220}}), graphics),
    experiment(
      StopTime=864000,
      Tolerance=1e-05,
      __Dymola_Algorithm="Radau"),
      Commands(file=
          "Resources/Scripts/Dymola/BuildingLoads/Examples/LinearRegressionCampus.mos"
        "Simulate and plot"));
end LinearRegressionCampus;
