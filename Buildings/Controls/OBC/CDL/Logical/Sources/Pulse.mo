within Buildings.Controls.OBC.CDL.Logical.Sources;
block Pulse "Generate pulse signal of type Boolean"

  parameter Real width(
    final min=Constants.small,
    final max=1,
    final unit = "1") = 0.5 "Width of pulse in fraction of period";
  parameter Modelica.SIunits.Time period(
    final min=Constants.small) "Time for one period";
  parameter Modelica.SIunits.Time delay=0
    "Delay time for output";
  Interfaces.BooleanOutput y "Connector of Boolean output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

protected
  parameter Modelica.SIunits.Time t0(fixed=false)
    "First sample time instant";
  parameter Modelica.SIunits.Time t1(fixed=false)
    "First end of amplitude";
initial equation
  t0 = Buildings.Utilities.Math.Functions.round(
         x = integer((time)/period)*period+mod(delay, period),
         n = 6);
  t1 = t0 + width*period;
  y = time >= t0 and time < t1;

equation
  when sample(t0, period) then
    y = true;
  elsewhen sample(t1, period) then
    y = false;
  end when;


  annotation (
    defaultComponentName="booPul",
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
                                         Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={210,210,210},
          lineThickness=5.0,
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),     Text(
          extent={{-150,-140},{150,-110}},
          lineColor={0,0,0},
          textString="%period"), Line(points={{79,-70},{39,-70},{39,44},{-1,44},
              {-1,-70},{-41,-70},{-41,44},{-80,44}}),
        Polygon(
          points={{-80,88},{-88,66},{-72,66},{-80,88}},
          lineColor={255,0,255},
          fillColor={255,0,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,66},{-80,-82}}, color={255,0,255}),
        Line(points={{-90,-70},{72,-70}}, color={255,0,255}),
        Polygon(
          points={{90,-70},{68,-62},{68,-78},{90,-70}},
          lineColor={255,0,255},
          fillColor={255,0,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{71,7},{85,-7}},
          lineColor=DynamicSelect({235,235,235}, if y then {0,255,0}
               else {235,235,235}),
          fillColor=DynamicSelect({235,235,235}, if y then {0,255,0}
               else {235,235,235}),
          fillPattern=FillPattern.Solid),
        Text(
          lineColor={0,0,255},
          extent={{-150,110},{150,150}},
          textString="%name"),
        Text(
          extent={{-66,78},{-14,56}},
          lineColor={135,135,135},
          textString="%period"),
        Polygon(
          points={{-2,52},{-14,56},{-14,48},{-2,52}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Line(points={{-80,52},{-4,52}},   color={135,135,135}),
        Polygon(
          points={{-80,52},{-68,56},{-68,48},{-80,52}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Line(points={{40,34},{72,34}},    color={135,135,135}),
        Polygon(
          points={{74,34},{62,38},{62,30},{74,34}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Text(
          extent={{44,62},{96,40}},
          lineColor={135,135,135},
          textString="%delay")}),
      Documentation(info="<html>
<p>
Block that outputs a pulse signal as shown below.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Controls/OBC/CDL/Logical/Sources/Pulse.png\"
     alt=\"BooleanPulse.png\" />
</p>
<p>
The pulse signal is generated an infinite number of times, and aligned with time <code>time=delay</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
October 19, 2020, by Michael Wetter:<br/>
Refactored implementation, avoided state events.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2170\">#2170</a>.
</li>
<li>
September 8, 2020, by Milica Grahovac:<br/>
Enabled specification of number of periods as a parameter.
</li>
<li>
September 1, 2020, by Milica Grahovac:<br/>
Revised initial equation section to ensure expected simulation results when <code>startTime</code> is before simulation start time.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2110\">#2110</a>.
</li>
<li>
March 23, 2017, by Jianjun Hu:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
end Pulse;
