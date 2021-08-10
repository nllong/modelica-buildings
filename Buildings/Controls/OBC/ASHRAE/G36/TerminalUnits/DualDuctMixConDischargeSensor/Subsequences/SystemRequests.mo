within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctMixConDischargeSensor.Subsequences;
block SystemRequests "Output system requests for VAV terminal unit with reheat"

  parameter Boolean have_hotWatCoi
    "True: the system has hot water coil";
  parameter Real thrTemDif(
    final unit="K",
    final quantity="TemperatureDifference")=3
    "Threshold difference between zone temperature and cooling setpoint for generating 3 cooling SAT reset requests";
  parameter Real twoTemDif(
    final unit="K",
    final quantity="TemperatureDifference")=2
    "Threshold difference between zone temperature and cooling setpoint for generating 2 cooling SAT reset requests";
  parameter Real thrTDis_1(
    final unit="K",
    final quantity="TemperatureDifference")=17
    "Threshold difference between discharge air temperature and its setpoint for generating 3 hot water reset requests"
    annotation(Dialog(enable=have_hotWatCoi));
  parameter Real thrTDis_2(
    final unit="K",
    final quantity="TemperatureDifference")=8
    "Threshold difference between discharge air temperature and its setpoint for generating 2 hot water reset requests"
    annotation(Dialog(enable=have_hotWatCoi));
  parameter Real durTimTem(
    final unit="s",
    final quantity="Time")=120
    "Duration time of zone temperature exceeds setpoint"
    annotation(Dialog(group="Duration times"));
  parameter Real durTimFlo(
    final unit="s",
    final quantity="Time")=60
    "Duration time of airflow rate less than setpoint"
    annotation(Dialog(group="Duration times"));
  parameter Real durTimDisAir(
    final unit="s",
    final quantity="Time")=300
    "Duration time of discharge air temperature less than setpoint"
    annotation(Dialog(group="Duration times", enable=have_hotWatCoi));
  parameter Real dTHys(
    final unit="K",
    final quantity="TemperatureDifference")=0.25
    "Near zero temperature difference, below which the difference will be seen as zero"
    annotation (Dialog(tab="Advanced", enable=have_hotWatCoi));
  parameter Real floHys(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Near zero flow rate, below which the flow rate or difference will be seen as zero"
    annotation (Dialog(tab="Advanced"));
  parameter Real damPosHys(
    final unit="1")
    "Near zero damper position, below which the damper will be seen as closed"
    annotation (Dialog(tab="Advanced"));
  parameter Real valPosHys(
    final unit="1")
    "Near zero valve position, below which the valve will be seen as closed"
    annotation (Dialog(tab="Advanced", enable=have_hotWatCoi));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uAftSup
    "After suppression period due to the setpoint change"
    annotation (Placement(transformation(extent={{-220,238},{-180,278}}),
        iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonCooSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone cooling setpoint temperature"
    annotation (Placement(transformation(extent={{-220,198},{-180,238}}),
        iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone temperature"
    annotation (Placement(transformation(extent={{-220,138},{-180,178}}),
        iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCoo(
    final min=0,
    final max=1,
    final unit="1")
    "Cooling loop signal"
    annotation (Placement(transformation(extent={{-220,108},{-180,148}}),
        iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VSet_flow(
    final min=0,
    final unit="m3/s",
    quantity="VolumeFlowRate")
    "Discharge airflow rate setpoint"
    annotation (Placement(transformation(extent={{-220,60},{-180,100}}),
        iconTransformation(extent={{-140,-10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VDis_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Measured discharge airflow rate"
    annotation (Placement(transformation(extent={{-220,-30},{-180,10}}),
        iconTransformation(extent={{-140,-30},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uDam(
    final min=0,
    final max=1,
    final unit="1")
    "Actual damper position"
    annotation (Placement(transformation(extent={{-220,-70},{-180,-30}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDisSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature") if have_hotWatCoi
    "Discharge airflow setpoint temperature for heating"
    annotation (Placement(transformation(extent={{-220,-130},{-180,-90}}),
        iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDis(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature") if have_hotWatCoi
    "Measured discharge airflow temperature"
    annotation (Placement(transformation(extent={{-220,-160},{-180,-120}}),
        iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uVal(
    final min=0,
    final max=1,
    final unit="1") if have_hotWatCoi "Hot water valve position"
    annotation (Placement(transformation(extent={{-220,-240},{-180,-200}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yZonTemResReq
    "Zone cooling supply air temperature reset request"
    annotation (Placement(transformation(extent={{180,218},{220,258}}),
        iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yZonPreResReq
    "Zone static pressure reset requests"
    annotation (Placement(transformation(extent={{180,40},{220,80}}),
        iconTransformation(extent={{100,10},{140,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHeaValResReq if have_hotWatCoi
    "Hot water reset requests"
    annotation (Placement(transformation(extent={{180,-160},{220,-120}}),
        iconTransformation(extent={{100,-50},{140,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHotWatPlaReq if have_hotWatCoi
    "Request to heating hot-water plant"
    annotation (Placement(transformation(extent={{180,-290},{220,-250}}),
        iconTransformation(extent={{100,-100},{140,-60}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Less les(
    final h=dTHys) if have_hotWatCoi
    "Check if discharge temperature is less than setpoint by a threshold"
    annotation (Placement(transformation(extent={{-60,-150},{-40,-130}})));
  Buildings.Controls.OBC.CDL.Continuous.Less les1(
    final h=dTHys) if have_hotWatCoi
    "Check if discharge temperature is less than setpoint by a threshold"
    annotation (Placement(transformation(extent={{-60,-190},{-40,-170}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr1(
    final t=thrTemDif,
    final h=dTHys)
    "Check if zone temperature is greater than cooling setpoint by threshold"
    annotation (Placement(transformation(extent={{-60,208},{-40,228}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr2(
    final t=twoTemDif,
    final h=dTHys)
    "Check if zone temperature is greater than cooling setpoint by threshold"
    annotation (Placement(transformation(extent={{-60,168},{-40,188}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr3(
    final t=0.95,
    final h=damPosHys)
    "Check if damper position is greater than 0.95"
    annotation (Placement(transformation(extent={{-160,-60},{-140,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(
    final t=0.95,
    final h=0.1)
    "Check if cooling loop signal is greater than 0.95"
    annotation (Placement(transformation(extent={{-60,118},{-40,138}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr4(
    final t=floHys,
    final h=0.5*floHys)
    "Check if discharge airflow setpoint is greater than 0"
    annotation (Placement(transformation(extent={{-140,70},{-120,90}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt
    "Convert boolean to integer"
    annotation (Placement(transformation(extent={{40,118},{60,138}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1
    "Convert boolean to integer"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai1(
    final k=0.5)
    "50% of setpoint"
    annotation (Placement(transformation(extent={{-140,40},{-120,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai2(
    final k=0.7)
    "70% of setpoint"
    annotation (Placement(transformation(extent={{-140,0},{-120,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2(
    final k1=-1)
    "Calculate difference between zone temperature and cooling setpoint"
    annotation (Placement(transformation(extent={{-100,208},{-80,228}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add3(
    final k1=-1)
    "Calculate difference between zone temperature and cooling setpoint"
    annotation (Placement(transformation(extent={{-100,168},{-80,188}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    "Logical and"
    annotation (Placement(transformation(extent={{40,168},{60,188}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Logical and"
    annotation (Placement(transformation(extent={{40,228},{60,248}})));
  Buildings.Controls.OBC.CDL.Logical.And and3
    "Logical and"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
  Buildings.Controls.OBC.CDL.Logical.And and4
    "Logical and"
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant thrCooResReq(
    final k=3)
    "Constant 3"
    annotation (Placement(transformation(extent={{100,268},{120,288}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant twoCooResReq(
    final k=2) "Constant 2"
    annotation (Placement(transformation(extent={{40,268},{60,288}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant thrPreResReq(
    final k=3)
    "Constant 3"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant twoPreResReq(
    final k=2)
    "Constant 2"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
  Buildings.Controls.OBC.CDL.Logical.IntegerSwitch intSwi
    "Output 3 or other request "
    annotation (Placement(transformation(extent={{140,228},{160,248}})));
  Buildings.Controls.OBC.CDL.Logical.IntegerSwitch intSwi1
    "Output 2 or other request "
    annotation (Placement(transformation(extent={{100,168},{120,188}})));
  Buildings.Controls.OBC.CDL.Logical.IntegerSwitch swi4
    "Output 3 or other request "
    annotation (Placement(transformation(extent={{140,50},{160,70}})));
  Buildings.Controls.OBC.CDL.Logical.IntegerSwitch swi5
    "Output 2 or other request "
    annotation (Placement(transformation(extent={{100,-20},{120,0}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay tim1(
    final delayTime=durTimTem) "Check if it is more than threshold time"
    annotation (Placement(transformation(extent={{-20,208},{0,228}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay tim2(
    final delayTime=durTimTem) "Check if it is more than threshold time"
    annotation (Placement(transformation(extent={{-20,168},{0,188}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay tim3(
    final delayTime=durTimFlo) "Check if it is more than threshold time"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater greEqu
    "Check if discharge airflow is less than 50% of setpoint"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater greEqu1
    "Check if discharge airflow is less than 70% of setpoint"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Buildings.Controls.OBC.CDL.Logical.And and5
    "Logical and"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(
    final k=1,
    final p=thrTDis_1) if have_hotWatCoi
    "Discharge temperature plus threshold"
    annotation (Placement(transformation(extent={{-140,-150},{-120,-130}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar1(
    final k=1,
    final p=thrTDis_2) if have_hotWatCoi
    "Discharge temperature plus threshold"
    annotation (Placement(transformation(extent={{-140,-190},{-120,-170}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant thrHeaResReq(
    final k=3) if have_hotWatCoi
    "Constant 3"
    annotation (Placement(transformation(extent={{100,-120},{120,-100}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant twoHeaResReq(
    final k=2) if have_hotWatCoi
    "Constant 2"
    annotation (Placement(transformation(extent={{40,-120},{60,-100}})));
  Buildings.Controls.OBC.CDL.Logical.IntegerSwitch intSwi2 if
       have_hotWatCoi
    "Output 3 or other request "
    annotation (Placement(transformation(extent={{140,-150},{160,-130}})));
  Buildings.Controls.OBC.CDL.Logical.IntegerSwitch intSwi3 if
       have_hotWatCoi
    "Output 2 or other request "
    annotation (Placement(transformation(extent={{100,-190},{120,-170}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay tim4(
    final delayTime=durTimDisAir) if have_hotWatCoi
    "Check if it is more than threshold time"
    annotation (Placement(transformation(extent={{0,-150},{20,-130}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay tim5(
    final delayTime=durTimDisAir) if have_hotWatCoi
    "Check if it is more than threshold time"
    annotation (Placement(transformation(extent={{0,-190},{20,-170}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr5(
    final t=0.95,
    final h=valPosHys) if have_hotWatCoi
    "Check if valve position is greater than 0.95"
    annotation (Placement(transformation(extent={{-140,-230},{-120,-210}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt2 if
       have_hotWatCoi
    "Convert boolean to integer"
    annotation (Placement(transformation(extent={{0,-230},{20,-210}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr6(
    final t=0.95,
    final h=0.85) if have_hotWatCoi
    "Check if valve position is greater than 0.95"
    annotation (Placement(transformation(extent={{-140,-280},{-120,-260}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt3 if
       have_hotWatCoi
    "Convert boolean to integer"
    annotation (Placement(transformation(extent={{0,-280},{20,-260}})));

equation
  connect(add2.y, greThr1.u)
    annotation (Line(points={{-78,218},{-62,218}}, color={0,0,127}));
  connect(and2.y, intSwi.u2)
    annotation (Line(points={{62,238},{138,238}},color={255,0,255}));
  connect(add3.y, greThr2.u)
    annotation (Line(points={{-78,178},{-62,178}}, color={0,0,127}));
  connect(and1.y, intSwi1.u2)
    annotation (Line(points={{62,178},{98,178}}, color={255,0,255}));
  connect(and3.y, swi4.u2)
    annotation (Line(points={{62,60},{138,60}},  color={255,0,255}));
  connect(and4.y, swi5.u2)
    annotation (Line(points={{62,-10},{98,-10}},   color={255,0,255}));
  connect(greThr2.y, tim2.u)
    annotation (Line(points={{-38,178},{-22,178}}, color={255,0,255}));
  connect(tim2.y, and1.u2)
    annotation (Line(points={{2,178},{10,178},{10,170},{38,170}},
      color={255,0,255}));
  connect(greThr1.y, tim1.u)
    annotation (Line(points={{-38,218},{-22,218}}, color={255,0,255}));
  connect(tim1.y, and2.u2)
    annotation (Line(points={{2,218},{10,218},{10,230},{38,230}},
      color={255,0,255}));
  connect(greThr4.u, VSet_flow)
    annotation (Line(points={{-142,80},{-200,80}},   color={0,0,127}));
  connect(add2.u2, TZon)
    annotation (Line(points={{-102,212},{-150,212},{-150,158},{-200,158}},
      color={0,0,127}));
  connect(add3.u2, TZon)
    annotation (Line(points={{-102,172},{-150,172},{-150,158},{-200,158}},
      color={0,0,127}));
  connect(greEqu.u1, gai1.y)
    annotation (Line(points={{-62,50},{-118,50}},  color={0,0,127}));
  connect(greEqu.y, and3.u2)
    annotation (Line(points={{-38,50},{0,50},{0,52},{38,52}},
      color={255,0,255}));
  connect(gai2.y, greEqu1.u1)
    annotation (Line(points={{-118,10},{-62,10}},
      color={0,0,127}));
  connect(greEqu1.y, and4.u2)
    annotation (Line(points={{-38,10},{0,10},{0,-18},{38,-18}},
      color={255,0,255}));
  connect(TZonCooSet, add2.u1) annotation (Line(points={{-200,218},{-160,218},{
          -160,224},{-102,224}}, color={0,0,127}));
  connect(TZonCooSet, add3.u1) annotation (Line(points={{-200,218},{-160,218},{
          -160,184},{-102,184}}, color={0,0,127}));
  connect(uCoo, greThr.u)
    annotation (Line(points={{-200,128},{-62,128}}, color={0,0,127}));
  connect(uAftSup, and2.u1) annotation (Line(points={{-200,258},{20,258},{20,
          238},{38,238}}, color={255,0,255}));
  connect(uAftSup, and1.u1) annotation (Line(points={{-200,258},{20,258},{20,
          178},{38,178}}, color={255,0,255}));
  connect(thrCooResReq.y, intSwi.u1) annotation (Line(points={{122,278},{130,
          278},{130,246},{138,246}}, color={255,127,0}));
  connect(twoCooResReq.y, intSwi1.u1) annotation (Line(points={{62,278},{80,278},
          {80,186},{98,186}}, color={255,127,0}));
  connect(intSwi1.y, intSwi.u3) annotation (Line(points={{122,178},{130,178},{
          130,230},{138,230}}, color={255,127,0}));
  connect(intSwi.y, yZonTemResReq)
    annotation (Line(points={{162,238},{200,238}}, color={255,127,0}));
  connect(greThr.y, booToInt.u)
    annotation (Line(points={{-38,128},{38,128}}, color={255,0,255}));
  connect(booToInt.y, intSwi1.u3) annotation (Line(points={{62,128},{80,128},{
          80,170},{98,170}}, color={255,127,0}));
  connect(uDam, greThr3.u)
    annotation (Line(points={{-200,-50},{-162,-50}},   color={0,0,127}));
  connect(VSet_flow, gai1.u) annotation (Line(points={{-200,80},{-160,80},{-160,
          50},{-142,50}},   color={0,0,127}));
  connect(VSet_flow, gai2.u) annotation (Line(points={{-200,80},{-160,80},{-160,
          10},{-142,10}},     color={0,0,127}));
  connect(VDis_flow, greEqu.u2) annotation (Line(points={{-200,-10},{-100,-10},
          {-100,42},{-62,42}},   color={0,0,127}));
  connect(VDis_flow, greEqu1.u2) annotation (Line(points={{-200,-10},{-100,-10},
          {-100,2},{-62,2}},       color={0,0,127}));
  connect(greThr3.y, tim3.u) annotation (Line(points={{-138,-50},{-80,-50},{-80,
          -30},{-62,-30}},   color={255,0,255}));
  connect(greThr4.y, and5.u1)
    annotation (Line(points={{-118,80},{-22,80}},   color={255,0,255}));
  connect(tim3.y, and5.u2) annotation (Line(points={{-38,-30},{-30,-30},{-30,72},
          {-22,72}},  color={255,0,255}));
  connect(and5.y, and3.u1) annotation (Line(points={{2,80},{20,80},{20,60},{38,
          60}},  color={255,0,255}));
  connect(and5.y, and4.u1) annotation (Line(points={{2,80},{20,80},{20,-10},{38,
          -10}},     color={255,0,255}));
  connect(greThr3.y, booToInt1.u) annotation (Line(points={{-138,-50},{38,-50}},
          color={255,0,255}));
  connect(booToInt1.y, swi5.u3) annotation (Line(points={{62,-50},{80,-50},{80,
          -18},{98,-18}},   color={255,127,0}));
  connect(twoPreResReq.y, swi5.u1) annotation (Line(points={{62,20},{80,20},{80,
          -2},{98,-2}},         color={255,127,0}));
  connect(thrPreResReq.y, swi4.u1) annotation (Line(points={{122,80},{130,80},{
          130,68},{138,68}},    color={255,127,0}));
  connect(swi5.y, swi4.u3) annotation (Line(points={{122,-10},{130,-10},{130,52},
          {138,52}},  color={255,127,0}));
  connect(swi4.y, yZonPreResReq) annotation (Line(points={{162,60},{200,60}},
          color={255,127,0}));
  connect(TDis,addPar. u)
    annotation (Line(points={{-200,-140},{-142,-140}},
      color={0,0,127}));
  connect(TDis,addPar1. u)
    annotation (Line(points={{-200,-140},{-160,-140},{-160,-180},{-142,-180}},
      color={0,0,127}));
  connect(tim5.y, intSwi3.u2)
    annotation (Line(points={{22,-180},{98,-180}}, color={255,0,255}));
  connect(tim4.y, intSwi2.u2)
    annotation (Line(points={{22,-140},{138,-140}}, color={255,0,255}));
  connect(addPar.y, les.u1)
    annotation (Line(points={{-118,-140},{-62,-140}}, color={0,0,127}));
  connect(TDisSet, les.u2) annotation (Line(points={{-200,-110},{-80,-110},{-80,
          -148},{-62,-148}}, color={0,0,127}));
  connect(les.y, tim4.u)
    annotation (Line(points={{-38,-140},{-2,-140}}, color={255,0,255}));
  connect(TDisSet, les1.u2) annotation (Line(points={{-200,-110},{-80,-110},{-80,
          -188},{-62,-188}}, color={0,0,127}));
  connect(addPar1.y, les1.u1)
    annotation (Line(points={{-118,-180},{-62,-180}}, color={0,0,127}));
  connect(les1.y, tim5.u)
    annotation (Line(points={{-38,-180},{-2,-180}}, color={255,0,255}));
  connect(yHeaValResReq, intSwi2.y)
    annotation (Line(points={{200,-140},{162,-140}}, color={255,127,0}));
  connect(thrHeaResReq.y, intSwi2.u1) annotation (Line(points={{122,-110},{130,
          -110},{130,-132},{138,-132}}, color={255,127,0}));
  connect(twoHeaResReq.y, intSwi3.u1) annotation (Line(points={{62,-110},{80,
          -110},{80,-172},{98,-172}}, color={255,127,0}));
  connect(intSwi3.y, intSwi2.u3) annotation (Line(points={{122,-180},{130,-180},
          {130,-148},{138,-148}}, color={255,127,0}));
  connect(uVal, greThr5.u)
    annotation (Line(points={{-200,-220},{-142,-220}}, color={0,0,127}));
  connect(greThr5.y, booToInt2.u)
    annotation (Line(points={{-118,-220},{-2,-220}}, color={255,0,255}));
  connect(booToInt2.y, intSwi3.u3) annotation (Line(points={{22,-220},{80,-220},
          {80,-188},{98,-188}}, color={255,127,0}));
  connect(uVal, greThr6.u) annotation (Line(points={{-200,-220},{-160,-220},{-160,
          -270},{-142,-270}}, color={0,0,127}));
  connect(greThr6.y, booToInt3.u)
    annotation (Line(points={{-118,-270},{-2,-270}}, color={255,0,255}));
  connect(booToInt3.y, yHotWatPlaReq)
    annotation (Line(points={{22,-270},{200,-270}}, color={255,127,0}));

annotation (
  defaultComponentName="sysReqRehBox",
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-180,-300},{180,320}}),
      graphics={
        Rectangle(
          extent={{-178,298},{178,122}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-178,98},{178,-78}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-146,292},{-24,268}},
          lineColor={0,0,255},
          horizontalAlignment=TextAlignment.Left,
          textString="Cooling SAT reset requests"),
        Text(
          extent={{-134,-56},{10,-84}},
          lineColor={0,0,255},
          horizontalAlignment=TextAlignment.Left,
          textString="Static pressure reset requests"),
        Rectangle(
          extent={{-178,-102},{178,-278}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{40,-220},{166,-240}},
          lineColor={0,0,255},
          horizontalAlignment=TextAlignment.Left,
          textString="Hot water reset requests")}),
     Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
          graphics={
        Text(
          extent={{-100,140},{100,100}},
          lineColor={0,0,255},
          textString="%name"),
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-98,80},{-52,62}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZonCooSet"),
        Text(
          extent={{-102,56},{-74,46}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZon"),
        Text(
          extent={{-98,36},{-74,26}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uCoo"),
        Text(
          extent={{-98,18},{-60,4}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VSet_flow"),
        Text(
          extent={{-98,-4},{-60,-14}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VDis_flow"),
        Text(
          extent={{-98,-24},{-72,-34}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uDam"),
        Text(
          extent={{36,88},{98,72}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="yZonTemResReq"),
        Text(
          extent={{40,40},{98,24}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="yZonPreResReq"),
        Text(
          extent={{-98,98},{-64,84}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uAftSup"),
        Text(
          visible=have_hotWatCoi,
          extent={{-98,-42},{-68,-56}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TDisSet"),
        Text(
          visible=have_hotWatCoi,
          extent={{-102,-64},{-76,-74}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TDis"),
        Text(
          extent={{-98,-84},{-80,-94}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uVal"),
        Text(
          visible=have_hotWatCoi,
          extent={{40,-20},{98,-36}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="yHeaValResReq"),
        Text(
          visible=have_hotWatCoi,
          extent={{40,-70},{98,-86}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="yHotWatPlaReq")}),
  Documentation(info="<html>
<p>
This sequence outputs the system reset requests for terminal unit with reheat. The
implementation is according to the Section 5.6.8 of ASHRAE Guideline 36, May 2020. 
</p>
<h4>Cooling SAT reset requests <code>yZonTemResReq</code></h4>
<ol>
<li>
If the zone temperature <code>TZon</code> exceeds the zone cooling setpoint
<code>TZonCooSet</code> by 3 &deg;C (5 &deg;F)) for 2 minutes and after suppression
period (<code>uAftSup=true</code>) due to setpoint change per G36 Part 5.1.20,
send 3 requests (<code>yZonTemResReq=3</code>).
</li>
<li>
Else if the zone temperature <code>TZon</code> exceeds the zone cooling setpoint
<code>TZonCooSet</code> by 2 &deg;C (3 &deg;F) for 2 minutes and after suppression
period (<code>uAftSup=true</code>) due to setpoint change per G36 Part 5.1.20,
send 2 requests (<code>yZonTemResReq=3</code>).
</li>
<li>
Else if the cooling loop <code>uCoo</code> is greater than 95%, send 1 request
(<code>yZonTemResReq=1</code>) until <code>uCoo</code> is less than 85%.
</li>
<li>
Else if <code>uCoo</code> is less than 95%, send 0 request (<code>yZonTemResReq=0</code>).
</li>
</ol>
<h4>Static pressure reset requests <code>yZonPreResReq</code></h4>
<ol>
<li>
If the measured airflow <code>VDis_flow</code> is less than 50% of setpoint
<code>VSet_flow</code> while the setpoint is greater than zero and the damper position
<code>uDam</code> is greater than 95% for 1 minute, send 3 requests (<code>yZonPreResReq=3</code>).
</li>
<li>
Else if the measured airflow <code>VDis_flow</code> is less than 70% of setpoint
<code>VSet_flow</code> while the setpoint is greater than zero and the damper position
<code>uDam</code> is greater than 95% for 1 minute, send 2 requests (<code>yZonPreResReq=2</code>).
</li>
<li>
Else if the damper position <code>uDam</code> is greater than 95%, send 1 request
(<code>yZonPreResReq=1</code>) until <code>uDam</code> is less than 85%.
</li>
<li>
Else if the damper position <code>uDam</code> is less than 95%, send 0 request
(<code>yZonPreResReq=0</code>).
</li>
</ol>

<h4>If there is a hot-water coil (<code>have_hotWatCoi=true</code>), hot-water reset requests
<code>yHeaValResReq</code></h4></h4>
<ol>
<li>
If the discharging air temperature <code>TDis</code> is 17 &deg;C (30 &deg;F)
<code>thrTDis_1</code> less than the setpoint <code>TDisSet</code>
for 5 minutes, send 3 requests.
</li>
<li>
Else ff the discharging air temperature <code>TDis</code> is 8 &deg;C (15 &deg;F)
<code>thrTDis_1</code> less than the setpoint <code>TDisSet</code>
for 5 minutes, send 2 requests.
</li>
<li>
Else if the hot water valve position <code>uVal</code> is greater than 95%, send 1
request until the hot water valve position is less than 85%.
</li>
<li>
Else if the hot water valve position <code>uVal</code> is less than 95%, send 0 request.
</li>
</ol>
<h4>If there is a hot-water coil and heating hot-water plant, heating hot-water
plant reqeusts. Send the heating hot-water plant that serves the zone a heating
hot-water plant request as follows:</h4>
<ol>
<li>
If the hot water valve position <code>uVal</code> is greater than 95%, send 1
request until the hot water valve position is less than 10%.
</li>
<li>
If the hot water valve position <code>uVal</code> is less than 95%, send 0 requests.
</li>
</ol>
</html>", revisions="<html>
<ul>
<li>
August 1, 2020, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end SystemRequests;