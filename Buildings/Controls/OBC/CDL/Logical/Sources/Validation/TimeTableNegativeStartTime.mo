within Buildings.Controls.OBC.CDL.Logical.Sources.Validation;
model TimeTableNegativeStartTime
  "Validation model for TimeTable block with negative start time"

  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable booTimTab(
    table=[0,1,0; 1.3,1,1; 2.9,0,0; 4,1,0; 5,1,1],
    extrapolation=Buildings.Controls.OBC.CDL.Types.Extrapolation.HoldLastPoint,
    timeScale=2) "Time table with boolean output"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable booTimTabPer(
    table=[0,1,0;1.3,1,1; 2.9,0,0; 4,1,0; 5,1,1],
    extrapolation=Buildings.Controls.OBC.CDL.Types.Extrapolation.Periodic)
    "Time table with boolean output and periodic repetition"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  annotation (experiment(Tolerance=1e-6, StartTime=-5.0, StopTime=5.0),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Logical/Sources/Validation/TimeTableNegativeStartTime.mos"
       "Simulate and plot"),
  Documentation(info="<html>
<p>
This model validates the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable\">
Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable</a>.
The model is identical to
<a href=\"modelica://Buildings.Controls.OBC.CDL.Logical.Sources.Validation.TimeTable\">
Buildings.Controls.OBC.CDL.Logical.Sources.Validation.TimeTable</a>
except that the start time is negative.
</html>",
revisions="<html>
<ul>
<li>
September 14, 2020, by Milica Grahovac:<br/>
Initial CDL implementation.
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
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}));

end TimeTableNegativeStartTime;