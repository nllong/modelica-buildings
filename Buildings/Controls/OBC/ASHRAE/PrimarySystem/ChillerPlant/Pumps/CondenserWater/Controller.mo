﻿within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater;
block Controller "Condenser water pump controller"

  parameter Boolean isHeadered = true
    "Flag of headered condenser water pumps design: true=headered, false=dedicated";
  parameter Boolean haveWSE = true
    "Flag of waterside economizer: true=have WSE, false=no WSE";
  parameter Integer nSta = 3
    "Total number of stages, zero stage should be counted as one stage";
  parameter Real chiNum[nSta] = {0, 1, 2}
    "Vector of number of operating chillers at each stage";
  parameter Integer nChi=2 "Total number of chiller"
    annotation (Dialog(group="No waterside economizer", enable=not haveWSE));
  parameter Real conWatPumSpeSet_noWse[nChi + 1]={0,0.5,0.75}
    "Vector of condenser water pump speed setpoint, the size should be total number of chiller plus one. number of operating pumps matchs number of operating chillers"
    annotation (Dialog(group="No waterside economizer", enable=not haveWSE));
  parameter Real conWatPumSpeSet_haveWse[2*nSta]={0,0.5,0.75,0.6,0.75,0.9}
    "Vector of condenser water pump speed setpoint, the size should be doule of total stage numbers"
    annotation (Dialog(group="Have waterside economizer", enable=haveWSE));
  parameter Real conWatPumOnSet[2*nSta]={0,1,1,2,2,2}
    "Vector of number of condenser water pumps that should be ON, the size should be doule of total stage numbers"
    annotation (Dialog(group="Have waterside economizer", enable=haveWSE));
  parameter Real uLow = 0.005 "if y=true and u<uLow, switch to y=false"
    annotation (Dialog(group="Speed equality check"));
  parameter Real uHigh = 0.015 "if y=false and u>uHigh, switch to y=true"
    annotation (Dialog(group="Speed equality check"));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uChiSta
    "Current chiller stage"
    annotation (Placement(transformation(extent={{-160,60},{-120,100}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWSE if haveWSE
    "Water side economizer status: true = ON, false = OFF"
    annotation (Placement(transformation(extent={{-160,-70},{-120,-30}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uLeaChiOn
    "Lead chiller status: true=lead chiller proven on"
    annotation (Placement(transformation(extent={{-160,-10},{-120,30}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uLeaConWatReq
    "Status indicating if chiller is requesting condenser water"
    annotation (Placement(transformation(extent={{-160,-40},{-120,0}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uConWatPumSpe(
    final min=0,
    final max=1,
    final unit="1") "Current condenser water pump speed"
    annotation (Placement(transformation(extent={{-160,-150},{-120,-110}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yLeaPum
    "Lead pump status"
    annotation (Placement(transformation(extent={{120,120},{140,140}}),
      iconTransformation(extent={{100,80},{120,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yConWatPumSpeSet
    "Condenser water pump speed"
    annotation (Placement(transformation(extent={{120,40},{140,60}}),
      iconTransformation(extent={{100,20},{120,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yConWatPumNum
    "Number of operating condenser water pumps"
    annotation (Placement(transformation(extent={{120,-10},{140,10}}),
      iconTransformation(extent={{100,-40},{120,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yPumSpeChe
    "Flag to indicate if pump speed achieve setpoint"
    annotation (Placement(transformation(extent={{120,-90},{140,-70}}),
        iconTransformation(extent={{100,-100},{120,-80}})));

protected
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Subsequences.EnableLead_headered
    enaLeaHeaPum(final haveWSE=haveWSE) if isHeadered
    "Enable lead pumps for plants with headered condenser water pump"
    annotation (Placement(transformation(extent={{20,120},{40,140}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Subsequences.EnableLead_dedicated
    enaLeaDedPum if not isHeadered
    "Enable lead pumps for plants with dedicated condenser water pump"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Subsequences.Speed_noWSE
    pumSpeNoWse(
    final nChi=nChi,
    final conWatPumSpeSet=conWatPumSpeSet_noWse) if not haveWSE
    "Operating speed of condenser water pump for plants without waterside economizer"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Subsequences.Speed_haveWSE
    pumSpeWitWse(
    final nSta=nSta,
    final conWatPumSpeSet=conWatPumSpeSet_haveWse,
    final conWatPumOnSet=conWatPumOnSet) if haveWSE
    "Operating speed of condenser water pump for plants with waterside economizer"
    annotation (Placement(transformation(extent={{22,-60},{42,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr(
    final threshold=0.5)
    "Check if there is any chiller operating"
    annotation (Placement(transformation(extent={{-20,120},{0,140}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt if not haveWSE
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con[nSta](
    final k=chiNum) "Number of operating chillers at each stage"
    annotation (Placement(transformation(extent={{-100,120},{-80,140}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor curOpeChi(
    final nin=nSta)
    "Current number of operating chillers"
    annotation (Placement(transformation(extent={{-60,120},{-40,140}})));
  Buildings.Controls.OBC.CDL.Continuous.Feedback speDif
    "Calculate difference between speed setpoint and operating speed"
    annotation (Placement(transformation(extent={{-80,-120},{-60,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.Abs abs "Absolute value"
    annotation (Placement(transformation(extent={{-40,-120},{-20,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(
    final uLow=uLow,
    final uHigh=uHigh)
    "Check if operating speed equals to setpoint"
    annotation (Placement(transformation(extent={{0,-120},{20,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{40,-120},{60,-100}})));
  Buildings.Controls.OBC.CDL.Integers.Add addInt "Add inputs"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(final k=1)
    "Integer constant"
    annotation (Placement(transformation(extent={{-110,90},{-90,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant zer1(final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi "Real switch"
    annotation (Placement(transformation(extent={{80,40},{100,60}})));
  Buildings.Controls.OBC.CDL.Logical.IntegerSwitch intSwi "Integer switch"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "Logical and"
    annotation (Placement(transformation(extent={{80,-90},{100,-70}})));

equation
  connect(con.y, curOpeChi.u)
    annotation (Line(points={{-79,130},{-62,130}}, color={0,0,127}));
  connect(curOpeChi.y, greEquThr.u)
    annotation (Line(points={{-39,130},{-22,130}}, color={0,0,127}));
  connect(uWSE, enaLeaHeaPum.uWseConIsoVal)
    annotation (Line(points={{-140,-50},{6,-50},{6,126},{18,126}},
      color={255,0,255}));
  connect(greEquThr.y, enaLeaHeaPum.uChiConIsoVal)
    annotation (Line(points={{1,130},{12,130},{12,134},{18,134}},
      color={255,0,255}));
  connect(greEquThr.y, enaLeaDedPum.uLeaChiEna)
    annotation (Line(points={{1,130},{12,130},{12,78},{18,78}},
      color={255,0,255}));
  connect(enaLeaDedPum.uLeaChiOn, uLeaChiOn)
    annotation (Line(points={{18,70},{-92,70},{-92,10},{-140,10}}, color={255,0,255}));
  connect(enaLeaDedPum.uLeaConWatReq, uLeaConWatReq)
    annotation (Line(points={{18,62},{-84,62},{-84,-20},{-140,-20}},
      color={255,0,255}));
  connect(uWSE, pumSpeWitWse.uWSE)
    annotation (Line(points={{-140,-50},{6,-50},{6,-54},{20,-54}},
      color={255,0,255}));
  connect(curOpeChi.y, reaToInt.u)
    annotation (Line(points={{-39,130},{-30,130},{-30,10},{-22,10}},
      color={0,0,127}));
  connect(reaToInt.y, pumSpeNoWse.uOpeChiNum)
    annotation (Line(points={{1,10},{18,10}},   color={255,127,0}));
  connect(enaLeaHeaPum.yLeaPum, yLeaPum)
    annotation (Line(points={{41,130},{130,130}}, color={255,0,255}));
  connect(enaLeaDedPum.yLeaPum, yLeaPum)
    annotation (Line(points={{41,70},{50,70},{50,130},{130,130}},
      color={255,0,255}));
  connect(uConWatPumSpe, speDif.u2)
    annotation (Line(points={{-140,-130},{-70,-130},{-70,-122}},color={0,0,127}));
  connect(pumSpeNoWse.yConWatPumSpeSet, speDif.u1)
    annotation (Line(points={{41,16},{60,16},{60,-70},{-100,-70},{-100,-110},
      {-82,-110}}, color={0,0,127}));
  connect(pumSpeWitWse.yConWatPumSpeSet, speDif.u1)
    annotation (Line(points={{43,-44},{60,-44},{60,-70},{-100,-70},{-100,-110},
      {-82,-110}}, color={0,0,127}));
  connect(speDif.y, abs.u)
    annotation (Line(points={{-59,-110},{-42,-110}}, color={0,0,127}));
  connect(abs.y, hys.u)
    annotation (Line(points={{-19,-110},{-2,-110}}, color={0,0,127}));
  connect(hys.y, not1.u)
    annotation (Line(points={{21,-110},{38,-110}}, color={255,0,255}));
  connect(uChiSta, pumSpeWitWse.uChiSta)
    annotation (Line(points={{-140,80},{-100,80},{-100,-46},{20,-46}},
      color={255,127,0}));
  connect(uChiSta, addInt.u2)
    annotation (Line(points={{-140,80},{-100,80},{-100,84},{-82,84}},
      color={255,127,0}));
  connect(conInt.y, addInt.u1)
    annotation (Line(points={{-89,100},{-86,100},{-86,96},{-82,96}},
      color={255,127,0}));
  connect(addInt.y, curOpeChi.index)
    annotation (Line(points={{-59,90},{-50,90},{-50,118}},color={255,127,0}));
  connect(swi.y, yConWatPumSpeSet)
    annotation (Line(points={{101,50},{130,50}}, color={0,0,127}));
  connect(pumSpeNoWse.yConWatPumSpeSet, swi.u1)
    annotation (Line(points={{41,16},{60,16},{60,58},{78,58}}, color={0,0,127}));
  connect(pumSpeWitWse.yConWatPumSpeSet, swi.u1)
    annotation (Line(points={{43,-44},{60,-44},{60,58},{78,58}}, color={0,0,127}));
  connect(enaLeaDedPum.yLeaPum, swi.u2)
    annotation (Line(points={{41,70},{50,70},{50,50},{78,50}}, color={255,0,255}));
  connect(enaLeaHeaPum.yLeaPum, swi.u2)
    annotation (Line(points={{41,130},{50,130},{50,50},{78,50}}, color={255,0,255}));
  connect(zer.y, swi.u3)
    annotation (Line(points={{-39,40},{20,40},{20,42},{78,42}}, color={0,0,127}));
  connect(enaLeaHeaPum.yLeaPum, intSwi.u2)
    annotation (Line(points={{41,130},{50,130},{50,0},{78,0}}, color={255,0,255}));
  connect(enaLeaDedPum.yLeaPum, intSwi.u2)
    annotation (Line(points={{41,70},{50,70},{50,0},{78,0}}, color={255,0,255}));
  connect(pumSpeNoWse.yConWatPumNum, intSwi.u1)
    annotation (Line(points={{41,10},{68,10},{68,8},{78,8}}, color={255,127,0}));
  connect(pumSpeWitWse.yConWatPumNum, intSwi.u1)
    annotation (Line(points={{43,-50},{68,-50},{68,8},{78,8}}, color={255,127,0}));
  connect(intSwi.y, yConWatPumNum)
    annotation (Line(points={{101,0},{130,0}}, color={255,127,0}));
  connect(zer1.y, intSwi.u3)
    annotation (Line(points={{-39,-20},{20,-20},{20,-8},{78,-8}}, color={255,127,0}));
  connect(and2.y, yPumSpeChe)
    annotation (Line(points={{101,-80},{130,-80}}, color={255,0,255}));
  connect(not1.y, and2.u2)
    annotation (Line(points={{61,-110},{70,-110},{70,-88},{78,-88}},
      color={255,0,255}));
  connect(enaLeaHeaPum.yLeaPum, and2.u1)
    annotation (Line(points={{41,130},{50,130},{50,-80},{78,-80}},
      color={255,0,255}));
  connect(enaLeaDedPum.yLeaPum, and2.u1)
    annotation (Line(points={{41,70},{50,70},{50,-80},{78,-80}},
      color={255,0,255}));

annotation (
  defaultComponentName="conWatPumCon",
  Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
       graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-80,60},{82,-60}},
          lineColor={28,108,200},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Polygon(
          points={{-80,60},{-14,4},{-80,-60},{-80,60}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid)}),
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-120,-160},{120,160}})),
  Documentation(info="<html>
<p>
Block that generates control signals for condenser water pumps control, 
according to ASHRAE RP-1711 Advanced Sequences of Operation for HVAC Systems Phase II –
Central Plants and Hydronic Systems (Draft 4 on January 7, 2019), 
section 5.2.9 Condenser water pumps. 
</p>
<p>
This sequence contains four subsequences:
</p>
<ul>
<li>
Enabling and disabling lead pump should be controlled based on weather the pumps
are configurated as headered or dedicated. If it is headered, 
<code>isHeadered</code> = true, then use block <code>enaLeaHeaPum</code>. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pump.CondenserWaterP.Subsequences.EnableLead_headered\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pump.CondenserWaterP.Subsequences.EnableLead_headered</a>
for a description. Otherwise, use block <code>enaLeaDedPum</code>. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pump.CondenserWaterP.Subsequences.EnableLead_dedicated\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pump.CondenserWaterP.Subsequences.EnableLead_dedicated</a>
for a description.
</li>
<li>
The operating speed <code>yConWatPumSpe</code> and number of operating pumps
<code>yConWatPumNum</code> should be controlled based on whether the plant has 
waterside economizer or not (<code>haveWSE</code>). When it has economizer, then 
use block <code>pumSpeWitWse</code>. See 
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pump.CondenserWaterP.Subsequences.Speed_haveWSE\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pump.CondenserWaterP.Subsequences.Speed_haveWSE</a>
for a description. Otherwise, use block <code>pumSpeNoWse</code>. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pump.CondenserWaterP.Subsequences.Speed_noWSE\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pump.CondenserWaterP.Subsequences.Speed_noWSE</a>
for a description.
</li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
Febuary 4, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Controller;
