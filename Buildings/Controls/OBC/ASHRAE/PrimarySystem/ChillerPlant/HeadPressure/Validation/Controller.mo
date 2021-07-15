within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Validation;
model Controller "Validation head pressure controller"
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Controller
    enaWSE "Head pressure for plant with waterside economizer that is enabled"
    annotation (Placement(transformation(extent={{60,70},{80,90}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Controller
    disWSE "Head pressure for plant with waterside economizer that is disabled"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Controller
    conSpePum(
    final have_WSE=false)
    "Head pressure for plant without waterside economizer, constant speed condenser water pump"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Controller
    varSpePum(
    final have_WSE=false, final fixSpeConWatPum=false)
    "Head pressure for plant without waterside economizer, variable speed condenser water pump"
    annotation (Placement(transformation(extent={{100,-110},{120,-90}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.7,
    final period=5,
    final shift=0.5) "Head pressure control enabling status"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TConWatRet(
    final amplitude=-11,
    final freqHz=2/10,
    final offset=273.15 + 27) "Measured condenser water return temperature"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TChiWatSup(
    final amplitude=1,
    final freqHz=1/5,
    final offset=273.15 + 6) "Measured chilled water supply temperature"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant runWSE(
    final k=true) "Constant true"
    annotation (Placement(transformation(extent={{-120,-70},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant desPumSpe(
    final k=0.75) "Design condenser water pump speed at current stage"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));

equation
  connect(booPul.y,enaWSE.uChiHeaCon)
    annotation (Line(points={{-98,100},{20,100},{20,90},{58,90}}, color={255,0,255}));
  connect(TConWatRet.y, enaWSE.TConWatRet)
    annotation (Line(points={{-98,60},{-20,60},{-20,86},{58,86}}, color={0,0,127}));
  connect(TChiWatSup.y, enaWSE.TChiWatSup)
    annotation (Line(points={{-98,20},{-10,20},{-10,82},{58,82}}, color={0,0,127}));
  connect(desPumSpe.y, enaWSE.desConWatPumSpe)
    annotation (Line(points={{-98,-20},{10,-20},{10,78},{58,78}}, color={0,0,127}));
  connect(runWSE.y, enaWSE.uWSE)
    annotation (Line(points={{-98,-60},{0,-60},{0,74},{58,74}}, color={255,0,255}));
  connect(booPul.y,disWSE.uChiHeaCon)
    annotation (Line(points={{-98,100},{20,100},{20,-50},{58,-50}}, color={255,0,255}));
  connect(TConWatRet.y, disWSE.TConWatRet)
    annotation (Line(points={{-98,60},{-20,60},{-20,-54},{58,-54}}, color={0,0,127}));
  connect(TChiWatSup.y, disWSE.TChiWatSup)
    annotation (Line(points={{-98,20},{-10,20},{-10,-58},{58,-58}}, color={0,0,127}));
  connect(desPumSpe.y, disWSE.desConWatPumSpe)
    annotation (Line(points={{-98,-20},{10,-20},{10,-62},{58,-62}}, color={0,0,127}));
  connect(runWSE.y, not1.u)
    annotation (Line(points={{-98,-60},{-80,-60},{-80,-80},{-62,-80}}, color={255,0,255}));
  connect(not1.y, disWSE.uWSE)
    annotation (Line(points={{-38,-80},{-28,-80},{-28,-66},{58,-66}}, color={255,0,255}));
  connect(booPul.y,conSpePum.uChiHeaCon)
    annotation (Line(points={{-98,100},{20,100},{20,50},{98,50}}, color={255,0,255}));
  connect(booPul.y,varSpePum.uChiHeaCon)
    annotation (Line(points={{-98,100},{20,100},{20,-90},{98,-90}}, color={255,0,255}));
  connect(TConWatRet.y, conSpePum.TConWatRet)
    annotation (Line(points={{-98,60},{-20,60},{-20,46},{98,46}}, color={0,0,127}));
  connect(TChiWatSup.y, conSpePum.TChiWatSup)
    annotation (Line(points={{-98,20},{-10,20},{-10,42},{98,42}}, color={0,0,127}));
  connect(TConWatRet.y, varSpePum.TConWatRet)
    annotation (Line(points={{-98,60},{-20,60},{-20,-94},{98,-94}}, color={0,0,127}));
  connect(TChiWatSup.y, varSpePum.TChiWatSup)
    annotation (Line(points={{-98,20},{-10,20},{-10,-98},{98,-98}}, color={0,0,127}));
  connect(desPumSpe.y, varSpePum.desConWatPumSpe)
    annotation (Line(points={{-98,-20},{10,-20},{10,-102},{98,-102}}, color={0,0,127}));

  connect(desPumSpe.y, conSpePum.desConWatPumSpe) annotation (Line(points={{-98,
          -20},{10,-20},{10,38},{98,38}}, color={0,0,127}));
annotation (
  experiment(StopTime=5.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/HeadPressure/Validation/Controller.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Controller\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Controller</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 2, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
       graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-120},{140,120}})));
end Controller;
