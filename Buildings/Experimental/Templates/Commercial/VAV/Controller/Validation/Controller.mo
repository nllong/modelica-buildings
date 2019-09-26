within Buildings.Experimental.Templates.Commercial.VAV.Controller.Validation;
model Controller "Validation controller model"

  Buildings.Experimental.Templates.Commercial.VAV.Controller.Controller
                                                                      conAHU(
    numZon=2,
    AFlo={50,50},
    have_perZonRehBox=false,
    controllerTypeMinOut=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    controllerTypeFre=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    controllerTypeFanSpe=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    minZonPriFlo={(50*3/3600)*6,(50*3/3600)*6},
    VPriSysMax_flow=0.7*(50*3/3600)*6*2,
    have_occSen=true,
    controllerTypeTSup=Buildings.Controls.OBC.CDL.Types.SimpleController.PI)
    "Multiple zone AHU controller"
    annotation (Placement(transformation(extent={{60,48},{140,152}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetRooCooOn(
    final k=273.15 + 24)
    "Cooling on setpoint"
    annotation (Placement(transformation(extent={{-100,133},{-80,154}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetRooHeaOn(
    final k=273.15 + 20)
    "Heating on setpoint"
    annotation (Placement(transformation(extent={{-220,149},{-200,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOutCut(
    final k=297.15)
    "Outdoor temperature high limit cutoff"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant opeMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.occupied)
    "AHU operation mode is occupied"
    annotation (Placement(transformation(extent={{20,50},{0,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TZon[2](
    each height=6,
    each offset=273.15 + 17,
    each duration=3600) "Measured zone temperature"
    annotation (Placement(transformation(extent={{-100,100},{-80,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TDis[2](
    each height=4,
    each duration=3600,
    each offset=273.15 + 18) "Terminal unit discharge air temperature"
    annotation (Placement(transformation(extent={{-220,82},{-200,102}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp numOfOcc1(
    height=2,
    duration=3600)
    "Occupant number in zone 1"
    annotation (Placement(transformation(extent={{-220,20},{-200,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp numOfOcc2(
    duration=3600,
    height=3)
    "Occupant number in zone 2"
    annotation (Placement(transformation(extent={{-150,20},{-130,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TSup(
    height=4,
    duration=3600,
    offset=273.15 + 14) "AHU supply air temperature"
    annotation (Placement(transformation(extent={{-220,52},{-200,72}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp VOut_flow(
    duration=1800,
    offset=0.02,
    height=0.0168)
    "Measured outdoor airflow rate"
    annotation (Placement(transformation(extent={{-220,-14},{-200,6}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp vavBoxFlo1(
    height=1.5,
    offset=1,
    duration=3600)
    "Ramp signal for generating VAV box flow rate"
    annotation (Placement(transformation(extent={{-220,-48},{-200,-28}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp vavBoxFlo2(
    offset=1,
    height=0.5,
    duration=3600)
    "Ramp signal for generating VAV box flow rate"
    annotation (Placement(transformation(extent={{-220,-80},{-200,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TMixMea(
    height=4,
    duration=1,
    offset=273.15 + 2,
    startTime=0)
    "Measured mixed air temperature"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TOut(
    amplitude=5,
    offset=18 + 273.15,
    freqHz=1/3600) "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-220,116},{-200,136}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine ducStaPre(
    offset=200,
    amplitude=150,
    freqHz=1/3600) "Duct static pressure"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sine(
    offset=3,
    amplitude=2,
    freqHz=1/9600) "Duct static pressure setpoint reset requests"
    annotation (Placement(transformation(extent={{-220,-150},{-200,-130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sine1(
    amplitude=6,
    freqHz=1/9600)
    "Maximum supply temperature setpoint reset"
    annotation (Placement(transformation(extent={{-220,-110},{-200,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Abs abs
    "Block generates absolute value of input"
    annotation (Placement(transformation(extent={{-180,-110},{-160,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Abs abs1
    "Block generates absolute value of input"
    annotation (Placement(transformation(extent={{-180,-150},{-160,-130}})));
  Buildings.Controls.OBC.CDL.Continuous.Round round1(n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-144,-110},{-124,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Round round2(n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-144,-150},{-124,-130}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger ducPreResReq "Convert real to integer"
    annotation (Placement(transformation(extent={{-110,-150},{-90,-130}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger maxSupResReq
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-110,-110},{-90,-90}})));

  Controls.OBC.CDL.Conversions.RealToInteger occConv1 "Convert real to integer"
    annotation (Placement(transformation(extent={{-190,20},{-170,40}})));
  Controls.OBC.CDL.Conversions.RealToInteger occConv2 "Convert real to integer"
    annotation (Placement(transformation(extent={{-120,20},{-100,40}})));
  BaseClasses.AhuBus ahuBus annotation (Placement(transformation(extent={{-30,152},{10,192}}), iconTransformation(
          extent={{-254,122},{-234,142}})));
  BaseClasses.AhuSubBusI ahuSubBusI annotation (Placement(transformation(extent={{-50,162},{-30,182}}),
        iconTransformation(extent={{-258,96},{-238,116}})));
equation
  connect(sine.y,abs1. u)
    annotation (Line(points={{-198,-140},{-182,-140}}, color={0,0,127}));
  connect(abs1.y,round2. u)
    annotation (Line(points={{-158,-140},{-146,-140}},color={0,0,127}));
  connect(round2.y, ducPreResReq.u)
    annotation (Line(points={{-122,-140},{-112,-140}},
                                                     color={0,0,127}));
  connect(sine1.y, abs.u)
    annotation (Line(points={{-198,-100},{-182,-100}}, color={0,0,127}));
  connect(abs.y,round1. u)
    annotation (Line(points={{-158,-100},{-146,-100}},color={0,0,127}));
  connect(round1.y, maxSupResReq.u)
    annotation (Line(points={{-122,-100},{-112,-100}},
                                                     color={0,0,127}));

  connect(numOfOcc1.y, occConv1.u)
    annotation (Line(points={{-198,30},{-192,30}}, color={0,0,127}));
  connect(numOfOcc2.y, occConv2.u)
    annotation (Line(points={{-128,30},{-122,30}},
                                                 color={0,0,127}));
  connect(TSetRooHeaOn.y, ahuSubBusI.TZonHeaSet) annotation (Line(points={{-198,159.5},{-120,159.5},{-120,172},{-40,172}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(TSetRooCooOn.y, ahuSubBusI.TZonCooSet) annotation (Line(points={{-78,143.5},{-62,143.5},{-62,172},{-40,172}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(TDis.y, ahuSubBusI.TDis) annotation (Line(points={{-198,92},{-120,92},{-120,172},{-40,172}}, color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(TZon.y, ahuSubBusI.TZon) annotation (Line(points={{-78,110},{-60,110},{-60,172},{-40,172}}, color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(TOutCut.y, ahuSubBusI.TOutCut) annotation (Line(points={{-78,70},{-58,70},{-58,172},{-40,172}}, color={0,0,
          127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(VOut_flow.y, ahuSubBusI.VOut_flow) annotation (Line(points={{-198,-4},{-118,-4},{-118,172},{-40,172}}, color=
          {0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(ducStaPre.y, ahuSubBusI.ducStaPre) annotation (Line(points={{-78,-10},{-60,-10},{-60,172},{-40,172}}, color={
          0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(occConv1.y, ahuSubBusI.nOcc[1]) annotation (Line(points={{-168,30},{-80,30},{-80,172},{-40,172}}, color={255,
          127,0}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(occConv2.y, ahuSubBusI.nOcc[2]) annotation (Line(points={{-98,30},{-46,30},{-46,172},{-40,172}}, color={255,
          127,0}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(vavBoxFlo1.y, ahuSubBusI.VDis_flow[1]) annotation (Line(points={{-198,-38},{-120,-38},{-120,172},{-40,172}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(vavBoxFlo2.y, ahuSubBusI.VDis_flow[2]) annotation (Line(points={{-198,-70},{-118,-70},{-118,172},{-40,172}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(ducPreResReq.y, ahuSubBusI.uZonPreResReq) annotation (Line(points={{-88,-140},{-40,-140},{-40,172}}, color={
          255,127,0}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(maxSupResReq.y, ahuSubBusI.uZonTemResReq) annotation (Line(points={{-88,-100},{-40,-100},{-40,172}}, color={
          255,127,0}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(opeMod.y, ahuSubBusI.uOpeMod) annotation (Line(points={{-2,60},{-30,60},{-30,172},{-40,172}}, color={255,127,
          0}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(TSup.y, ahuSubBusI.TSup) annotation (Line(points={{-198,62},{-120,62},{-120,172},{-40,172}}, color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(TMixMea.y, ahuSubBusI.TMix) annotation (Line(points={{-78,-50},{-58,-50},{-58,172},{-40,172}}, color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(TOut.y, ahuSubBusI.TOut) annotation (Line(points={{-198,126},{-120,126},{-120,172},{-40,172}}, color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(ahuSubBusI, ahuBus.ahuI) annotation (Line(
      points={{-40,172},{-24,172},{-24,172.1},{-9.9,172.1}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(ahuBus, conAHU.ahuBus) annotation (Line(
      points={{-10,172},{26,172},{26,100},{60,100}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
annotation (experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands,
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 12, 2019, by Michael Wetter:<br/>
Removed wrong use of <code>each</code>.
</li>
<li>
October 30, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
Diagram(coordinateSystem(extent={{-240,-180},{240,180}})),
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
end Controller;
