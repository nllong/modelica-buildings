within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Validation;
model FailsafeCondition "Validate failsafe condition sequence"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.FailsafeCondition
    faiSafCon0
    "Failsafe condition to test for the current stage availability input"
    annotation (Placement(transformation(extent={{-40,120},{-20,140}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.FailsafeCondition
    faiSafCon1
    "Failsafe condition to test for the chilled water supply temperature and differential pressure inputs"
    annotation (Placement(transformation(extent={{120,120},{140,140}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.FailsafeCondition
    faiSafCon2(final serChi=true)
    "Failsafe condition to test for the chilled water supply temperature input for series chillers plant"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));

  CDL.Logical.Sources.Pulse booPul(period=3600)
    "Current stage becomes unavailable during the test"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  CDL.Logical.Sources.Constant con(k=true)
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  CDL.Logical.Sources.Constant con1(k=true)
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TCWSup(
    final k=273.15 + 18)
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-140,100},{-120,120}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TCWSupSet(
    final k=273.15 + 14)
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-140,140},{-120,160}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dpChiWat(
    final k=64.1*6895)
    "Chilled water differential pressure"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dpChiWatSet(
    final k=65*6895)
    "Chilled water differential pressure setpoint"
    annotation (Placement(transformation(extent={{-100,100},{-80,120}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TCWSupSet1(
    final k=273.15 + 14)
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{20,140},{40,160}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dpChiWatSet1(
    final k=65*6895)
    "Chilled water differential pressure setpoint"
    annotation (Placement(transformation(extent={{60,100},{80,120}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TCWSup1(
    final amplitude=1.5,
    final offset=273.15 + 15.5,
    final freqHz=1/900) "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{20,100},{40,120}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine dpChiWat2(
    final amplitude=6895,
    final offset=63*6895,
    final freqHz=1/1500,
    final startTime=0,
    phase=0.78539816339745)
    "Chilled water differential pressure"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TCWSupSet2(
    final k=273.15 + 14)
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-140,-60},{-120,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TCWSup2(
    final amplitude=1.5,
    final offset=273.15 + 15.5,
    final freqHz=1/2100)
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-140,-100},{-120,-80}})));

equation
  connect(TCWSup.y, faiSafCon0.TChiWatSup) annotation (Line(points={{-118,110},
          {-110,110},{-110,133},{-42,133}},                color={0,0,127}));
  connect(TCWSupSet.y, faiSafCon0.TChiWatSupSet) annotation (Line(points={{-118,
          150},{-60,150},{-60,137},{-42,137}},                   color={0,0,127}));
  connect(dpChiWatSet.y, faiSafCon0.dpChiWatPumSet) annotation (Line(points={{-78,110},
          {-60,110},{-60,130},{-42,130}},    color={0,0,127}));
  connect(dpChiWat.y, faiSafCon0.dpChiWatPum) annotation (Line(points={{-78,70},
          {-56,70},{-56,127},{-42,127}},color={0,0,127}));
  connect(TCWSupSet1.y, faiSafCon1.TChiWatSupSet) annotation (Line(points={{42,150},
          {100,150},{100,137},{118,137}},               color={0,0,127}));
  connect(dpChiWatSet1.y, faiSafCon1.dpChiWatPumSet) annotation (Line(points={{82,110},
          {90,110},{90,130},{118,130}}, color={0,0,127}));
  connect(TCWSup1.y, faiSafCon1.TChiWatSup) annotation (Line(points={{42,110},{
          50,110},{50,133},{118,133}},                 color={0,0,127}));
  connect(dpChiWat2.y, faiSafCon1.dpChiWatPum) annotation (Line(points={{82,70},
          {100,70},{100,127},{118,127}},color={0,0,127}));
  connect(TCWSupSet2.y,faiSafCon2. TChiWatSupSet) annotation (Line(points={{-118,
          -50},{-100,-50},{-100,-43},{-42,-43}},                       color={0,0,127}));
  connect(TCWSup2.y,faiSafCon2. TChiWatSup) annotation (Line(points={{-118,-90},
          {-100,-90},{-100,-60},{-80,-60},{-80,-47},{-42,-47}},  color={0,0,127}));
  connect(booPul.y, faiSafCon0.uAvaCur) annotation (Line(points={{-78,30},{-50,
          30},{-50,123},{-42,123}}, color={255,0,255}));
  connect(con.y, faiSafCon1.uAvaCur) annotation (Line(points={{82,30},{110,30},
          {110,123},{118,123}}, color={255,0,255}));
  connect(con1.y, faiSafCon2.uAvaCur) annotation (Line(points={{-58,-90},{-50,
          -90},{-50,-57},{-42,-57}}, color={255,0,255}));
annotation (
 experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Subsequences/Validation/FailsafeCondition.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.FailsafeCondition\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Generic.FailsafeCondition</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 21, 2019, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"),
Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-180},{160,180}})));
end FailsafeCondition;