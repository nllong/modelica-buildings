within Buildings.Experimental.Templates.Commercial.VAV.Controller.Validation;
model ControllerConfigurationTest "Validates multizone controller model for boolean parameter values"

  Buildings.Experimental.Templates.Commercial.VAV.Controller.Controller
                                                                      conAHU(
    numZon=2,
    AFlo={50,50},
    have_winSen=false,
    have_perZonRehBox=true,
    controllerTypeMinOut=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    controllerTypeFre=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    controllerTypeFanSpe=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    minZonPriFlo={(50*3/3600)*6,(50*3/3600)*6},
    VPriSysMax_flow=0.7*(50*3/3600)*6*2,
    have_occSen=true,
    controllerTypeTSup=Buildings.Controls.OBC.CDL.Types.SimpleController.PI)
    "Multiple zone AHU controller"
    annotation (Placement(transformation(extent={{-260,48},{-180,152}})));

  Buildings.Experimental.Templates.Commercial.VAV.Controller.Controller
                                                                      conAHU1(
    numZon=2,
    AFlo={50,50},
    have_winSen=false,
    have_perZonRehBox=false,
    have_duaDucBox=true,
    controllerTypeMinOut=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    controllerTypeFre=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    controllerTypeFanSpe=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    minZonPriFlo={(50*3/3600)*6,(50*3/3600)*6},
    VPriSysMax_flow=0.7*(50*3/3600)*6*2,
    have_occSen=true,
    controllerTypeTSup=Buildings.Controls.OBC.CDL.Types.SimpleController.PI)
    "Multiple zone AHU controller"
    annotation (Placement(transformation(extent={{-120,48},{-40,152}})));

  Buildings.Experimental.Templates.Commercial.VAV.Controller.Controller conAHU2(
    numZon=2,
    AFlo={50,50},
    have_winSen=true,
    have_perZonRehBox=true,
    have_duaDucBox=false,
    controllerTypeMinOut=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    controllerTypeFre=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    controllerTypeFanSpe=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    minZonPriFlo={(50*3/3600)*6,(50*3/3600)*6},
    VPriSysMax_flow=0.7*(50*3/3600)*6*2,
    have_occSen=false,
    controllerTypeTSup=Buildings.Controls.OBC.CDL.Types.SimpleController.PI)
    "Multiple zone AHU controller"
    annotation (Placement(transformation(extent={{40,48},{120,152}})));

  Buildings.Experimental.Templates.Commercial.VAV.Controller.Controller conAHU3(
    numZon=2,
    AFlo={50,50},
    have_winSen=false,
    have_perZonRehBox=true,
    use_enthalpy=true,
    controllerTypeMinOut=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    controllerTypeFre=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    controllerTypeFanSpe=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    minZonPriFlo={(50*3/3600)*6,(50*3/3600)*6},
    VPriSysMax_flow=0.7*(50*3/3600)*6*2,
    have_occSen=false,
    controllerTypeTSup=Buildings.Controls.OBC.CDL.Types.SimpleController.PI)
    "Multiple zone AHU controller"
    annotation (Placement(transformation(extent={{222,48},{302,152}})));

  Buildings.Experimental.Templates.Commercial.VAV.Controller.Controller conAHU4(
    numZon=2,
    AFlo={50,50},
    have_winSen=false,
    have_perZonRehBox=true,
    use_enthalpy=false,
    controllerTypeMinOut=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    use_TMix=false,
    use_G36FrePro=true,
    controllerTypeFre=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    controllerTypeFanSpe=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    minZonPriFlo={(50*3/3600)*6,(50*3/3600)*6},
    VPriSysMax_flow=0.7*(50*3/3600)*6*2,
    have_occSen=false,
    controllerTypeTSup=Buildings.Controls.OBC.CDL.Types.SimpleController.PI)
    "Multiple zone AHU controller"
    annotation (Placement(transformation(extent={{462,48},{542,152}})));

  BaseClasses.AhuSubBusI ahuSubBusI annotation (Placement(transformation(extent={{-350,322},{-330,342}}),
        iconTransformation(extent={{-258,96},{-238,116}})));
  BaseClasses.AhuBus ahuBus annotation (Placement(transformation(extent={{-296,178},{-256,218}}), iconTransformation(
          extent={{-656,112},{-636,132}})));
  BaseClasses.AhuBus ahuBus1
                            annotation (Placement(transformation(extent={{-150,182},{-110,222}}), iconTransformation(
          extent={{-656,112},{-636,132}})));
  BaseClasses.AhuBus ahuBus2
                            annotation (Placement(transformation(extent={{8,180},{48,220}}),      iconTransformation(
          extent={{-656,112},{-636,132}})));
  BaseClasses.AhuBus ahuBus3
                            annotation (Placement(transformation(extent={{190,180},{230,220}}),   iconTransformation(
          extent={{-656,112},{-636,132}})));
  BaseClasses.AhuBus ahuBus4
                            annotation (Placement(transformation(extent={{384,180},{424,220}}),   iconTransformation(
          extent={{-656,112},{-636,132}})));
protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetRooCooOn(
    final k=273.15 + 24)
    "Cooling on setpoint"
    annotation (Placement(transformation(extent={{-420,280},{-400,300}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetRooHeaOn(
    final k=273.15 + 20)
    "Heating on setpoint"
    annotation (Placement(transformation(extent={{-460,300},{-440,320}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOutCut(
    final k=297.15) "Outdoor temperature high limit cutoff"
    annotation (Placement(transformation(extent={{-420,190},{-400,210}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TZon[2](
    each final height=6,
    each final offset=273.15 + 17,
    each final duration=3600) "Measured zone temperature"
    annotation (Placement(transformation(extent={{-458,250},{-438,270}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TDis[2](
    each final height=4,
    each final duration=3600,
    each final offset=273.15 + 18) "Terminal unit discharge air temperature"
    annotation (Placement(transformation(extent={{-460,160},{-440,180}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TSup(
    final height=4,
    final duration=3600,
    final offset=273.15 + 14) "AHU supply air temperature"
    annotation (Placement(transformation(extent={{-460,210},{-440,230}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp VOut_flow(
    final duration=1800,
    final offset=0.02,
    final height=0.0168) "Measured outdoor airflow rate"
    annotation (Placement(transformation(extent={{-460,-18},{-440,2}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp vavBoxFlo1(
    final height=1.5,
    final offset=1,
    final duration=3600) "Ramp signal for generating VAV box flow rate"
    annotation (Placement(transformation(extent={{-460,-70},{-440,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp vavBoxFlo2(
    final offset=1,
    final height=0.5,
    final duration=3600) "Ramp signal for generating VAV box flow rate"
    annotation (Placement(transformation(extent={{-460,-102},{-440,-82}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TMixMea(
    final height=4,
    final duration=1,
    final offset=273.15 + 2,
    final startTime=0) "Measured mixed air temperature"
    annotation (Placement(transformation(extent={{-360,-100},{-340,-80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TOut(
    final amplitude=5,
    final offset=18 + 273.15,
    final freqHz=1/3600) "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-420,230},{-400,250}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine ducStaPre(
    final offset=200,
    final amplitude=150,
    final freqHz=1/3600) "Duct static pressure"
    annotation (Placement(transformation(extent={{-380,-18},{-360,2}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sine(
    final offset=3,
    final amplitude=2,
    final freqHz=1/9600) "Duct static pressure setpoint reset requests"
    annotation (Placement(transformation(extent={{-460,-222},{-440,-202}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sine1(
    final amplitude=6,
    final freqHz=1/9600)
    "Maximum supply temperature setpoint reset"
    annotation (Placement(transformation(extent={{-460,-180},{-440,-160}})));

  Buildings.Controls.OBC.CDL.Continuous.Abs abs
    "Block generates absolute value of input"
    annotation (Placement(transformation(extent={{-420,-180},{-400,-160}})));

  Buildings.Controls.OBC.CDL.Continuous.Abs abs1
    "Block generates absolute value of input"
    annotation (Placement(transformation(extent={{-420,-222},{-400,-202}})));

  Buildings.Controls.OBC.CDL.Continuous.Round round1(final n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-380,-180},{-360,-160}})));

  Buildings.Controls.OBC.CDL.Continuous.Round round2(final n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-380,-222},{-360,-202}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger ducPreResReq
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-340,-222},{-320,-202}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger maxSupResReq
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-340,-180},{-320,-160}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant winSta[2](
    final k={true,false}) "Window status for each zone"
    annotation (Placement(transformation(extent={{-30,90},{-10,110}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp numOfOcc1(
    final height=2,
    final duration=3600) "Occupant number in zone 1"
    annotation (Placement(transformation(extent={{-460,80},{-440,100}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger occConv1
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-400,80},{-380,100}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp numOfOcc2(
    final duration=3600,
    final height=3) "Occupant number in zone 2"
    annotation (Placement(transformation(extent={{-460,40},{-440,60}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger occConv2
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-400,40},{-380,60}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    final period=10000,
    final startTime=500) "Logical pulse"
    annotation (Placement(transformation(extent={{382,0},{362,20}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger freProSta1(
    final integerTrue=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.FreezeProtectionStages.stage2,
    final integerFalse=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.FreezeProtectionStages.stage1)
    "Freeze protection stage changes from stage 1 to stage 2"
    annotation (Placement(transformation(extent={{340,0},{320,20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ram(
    final duration=3600,
    final height=6) "Ramp signal for generating operation mode"
    annotation (Placement(transformation(extent={{-460,-140},{-440,-120}})));

  Buildings.Controls.OBC.CDL.Continuous.Abs abs2
    "Block generates absolute value of input"
    annotation (Placement(transformation(extent={{-420,-140},{-400,-120}})));

  Buildings.Controls.OBC.CDL.Continuous.Round round3(final n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-380,-140},{-360,-120}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-340,-140},{-320,-120}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant hOutBelowCutoff(
    final k=45000)
    "Outdoor air enthalpy is slightly below the cutoff"
    annotation (Placement(transformation(extent={{140,140},{160,160}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant hOutCut(final k=65100)
    "Outdoor air enthalpy cutoff"
    annotation (Placement(transformation(extent={{142,100},{162,120}})));

equation
  connect(ram.y, abs2.u)
    annotation (Line(points={{-438,-130},{-422,-130}},color={0,0,127}));
  connect(abs2.y, round3.u)
    annotation (Line(points={{-398,-130},{-382,-130}},color={0,0,127}));
  connect(round3.y, reaToInt2.u)
    annotation (Line(points={{-358,-130},{-342,-130}},color={0,0,127}));
  connect(sine1.y, abs.u)
    annotation (Line(points={{-438,-170},{-422,-170}},color={0,0,127}));
  connect(abs.y, round1.u)
    annotation (Line(points={{-398,-170},{-382,-170}},color={0,0,127}));
  connect(round1.y, maxSupResReq.u)
    annotation (Line(points={{-358,-170},{-342,-170}},color={0,0,127}));
  connect(round2.y, ducPreResReq.u)
    annotation (Line(points={{-358,-212},{-354,-212},{-354,-214},{-350,-214},{-350,-212},{-342,-212}},
                             color={0,0,127}));
  connect(abs1.y, round2.u)
    annotation (Line(points={{-398,-212},{-394,-212},{-394,-214},{-390,-214},{-390,-212},{-382,-212}},
                             color={0,0,127}));
  connect(sine.y, abs1.u)
    annotation (Line(points={{-438,-212},{-434,-212},{-434,-214},{-430,-214},{-430,-212},{-422,-212}},
                              color={0,0,127}));
  connect(numOfOcc2.y, occConv2.u)
    annotation (Line(points={{-438,50},{-402,50}}, color={0,0,127}));
  connect(numOfOcc1.y, occConv1.u)
    annotation (Line(points={{-438,90},{-402,90}}, color={0,0,127}));
  connect(TSetRooHeaOn.y, ahuSubBusI.TZonHeaSet) annotation (Line(points={{-438,310},{-390,310},{-390,332},{-340,332}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(TSetRooCooOn.y, ahuSubBusI.TZonCooSet) annotation (Line(points={{-398,290},{-370,290},{-370,332},{-340,332}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(TZon.y, ahuSubBusI.TZon) annotation (Line(points={{-436,260},{-360,260},{-360,332},{-340,332}}, color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(TOut.y, ahuSubBusI.TOut) annotation (Line(points={{-398,240},{-370,240},{-370,332},{-340,332}}, color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(TSup.y, ahuSubBusI.TSup) annotation (Line(points={{-438,220},{-388,220},{-388,332},{-340,332}}, color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(TOutCut.y, ahuSubBusI.TOutCut) annotation (Line(points={{-398,200},{-370,200},{-370,332},{-340,332}}, color={
          0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(TDis.y, ahuSubBusI.TDis) annotation (Line(points={{-438,170},{-388,170},{-388,332},{-340,332}}, color={0,0,
          127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(occConv1.y, ahuSubBusI.nOcc[1]) annotation (Line(points={{-378,90},{-358,90},{-358,332},{-340,332}}, color={
          255,127,0}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(occConv2.y, ahuSubBusI.nOcc[2]) annotation (Line(points={{-378,50},{-358,50},{-358,332},{-340,332}}, color={
          255,127,0}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(VOut_flow.y, ahuSubBusI.VOut_flow) annotation (Line(points={{-438,-8},{-388,-8},{-388,332},{-340,332}}, color=
         {0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(ducStaPre.y, ahuSubBusI.ducStaPre) annotation (Line(points={{-358,-8},{-350,-8},{-350,332},{-340,332}}, color=
         {0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(vavBoxFlo1.y, ahuSubBusI.VDis_flow[1]) annotation (Line(points={{-438,-60},{-388,-60},{-388,332},{-340,332}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(vavBoxFlo2.y, ahuSubBusI.VDis_flow[2]) annotation (Line(points={{-438,-92},{-368,-92},{-368,332},{-340,332}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(TMixMea.y, ahuSubBusI.TMix) annotation (Line(points={{-338,-90},{-338,332},{-340,332}}, color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(reaToInt2.y, ahuSubBusI.uOpeMod) annotation (Line(points={{-318,-130},{-300,-130},{-300,332},{-340,332}},
        color={255,127,0}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(maxSupResReq.y, ahuSubBusI.uZonTemResReq) annotation (Line(points={{-318,-170},{-300,-170},{-300,332},{-340,
          332}}, color={255,127,0}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(ducPreResReq.y, ahuSubBusI.uZonPreResReq) annotation (Line(points={{-318,-212},{-300,-212},{-300,332},{-340,
          332}}, color={255,127,0}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(ahuBus, conAHU.ahuBus) annotation (Line(
      points={{-276,198},{-270,198},{-270,100},{-260,100}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(winSta.y, ahuSubBusI.uWin) annotation (Line(points={{-8,100},{0,100},{0,332},{-340,332}}, color={255,0,255}),
      Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(hOutBelowCutoff.y, ahuSubBusI.hOut) annotation (Line(points={{162,150},{180,150},{180,332},{-340,332}}, color=
         {0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(hOutCut.y, ahuSubBusI.hOutCut) annotation (Line(points={{164,110},{180,110},{180,332},{-340,332}}, color={0,0,
          127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(freProSta1.y, ahuSubBusI.uFreProSta) annotation (Line(points={{318,10},{-300,10},{-300,332},{-340,332}},
                                                                                                                 color=
          {255,127,0}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(ahuSubBusI, ahuBus.ahuI) annotation (Line(
      points={{-340,332},{-308,332},{-308,198.1},{-275.9,198.1}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(ahuSubBusI, ahuBus2.ahuI) annotation (Line(
      points={{-340,332},{-60,332},{-60,200.1},{28.1,200.1}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(ahuSubBusI, ahuBus3.ahuI) annotation (Line(
      points={{-340,332},{122,332},{122,200.1},{210.1,200.1}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(ahuSubBusI, ahuBus4.ahuI) annotation (Line(
      points={{-340,332},{380,332},{380,200.1},{404.1,200.1}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(ahuBus2, conAHU2.ahuBus) annotation (Line(
      points={{28,200},{36,200},{36,100},{40,100}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(ahuBus3, conAHU3.ahuBus) annotation (Line(
      points={{210,200},{216,200},{216,100},{222,100}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(ahuBus4, conAHU4.ahuBus) annotation (Line(
      points={{404,200},{420,200},{420,100},{462,100}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(booPul1.y, freProSta1.u) annotation (Line(points={{360,10},{342,10}}, color={255,0,255}));
  connect(ahuSubBusI, ahuBus1.ahuI) annotation (Line(
      points={{-340,332},{-160,332},{-160,202.1},{-129.9,202.1}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(ahuBus1, conAHU1.ahuBus) annotation (Line(
      points={{-130,202},{-130,99},{-120,99},{-120,100}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
annotation (experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36_PR1/AHUs/MultiZone/VAV/Validation/ControllerConfigurationTest.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller</a>.
It tests the controller for different configurations of the Boolean parameters, such as
for controllers with occupancy sensors, with window status sensors, with single or dual duct boxes etc.
</p>
</html>", revisions="<html>
<ul>
<li>
July 19, 2019, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"),
Diagram(coordinateSystem(extent={{-520,-240},{560,340}})),
    Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}));
end ControllerConfigurationTest;
