within Buildings.Controls.OBC.CDL.Logical;
block IntegerSwitch "Integer Switch"

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput u1 "Integer input signal in case the switch is on"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u2 "Boolean switch input signal, with true = on and false = off"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput u3 "Integer input signal in case the switch is off"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput y "Integer output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

equation
  y = if u2 then u1 else u3;
  annotation (
defaultComponentName="intSwi",
Documentation(info="<html>
<p>
A block to switch between two integer signals.
</p>
<p>
If the input signal <code>u2</code> is <code>true</code>,
the block outputs <code>y = u1</code>.
Otherwise, it outputs <code>y = u3</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
July 10, 2019, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"),
         Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}),
          graphics={                     Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={210,210,210},
          lineThickness=5.0,
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Line(
          points={{12,0},{100,0}},
          color={244,125,35}),
        Line(
          points={{-100,0},{-40,0}},
          color={255,0,255}),
        Line(
          points={{-100,-80},{-40,-80},{-40,-80}},
          color={244,125,35}),
        Line(points={{-40,12},{-40,-10}}, color={255,0,255}),
        Line(points={{-100,80},{-40,80}}, color={244,125,35}),
        Line(
          points={{-40,80},{8,2}},
          color={244,125,35},
          thickness=1),
        Ellipse(lineColor={0,0,127},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          extent={{2.0,-6.0},{18.0,8.0}}),
        Ellipse(
          extent={{-71,7},{-85,-7}},
          lineColor=DynamicSelect({235,235,235}, if u2 then {0,255,0}
               else {235,235,235}),
          fillColor=DynamicSelect({235,235,235}, if u2 then {0,255,0}
               else {235,235,235}),
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-71,74},{-85,88}},
          lineColor=DynamicSelect({235,235,235}, if u1 then {0,255,0}
               else {235,235,235}),
          fillColor=DynamicSelect({235,235,235}, if u1 then {0,255,0}
               else {235,235,235}),
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-71,-74},{-85,-88}},
          lineColor=DynamicSelect({235,235,235}, if u3 then {0,255,0}
               else {235,235,235}),
          fillColor=DynamicSelect({235,235,235}, if u3 then {0,255,0}
               else {235,235,235}),
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{71,7},{85,-7}},
          lineColor=DynamicSelect({235,235,235}, if y then {0,255,0}
               else {235,235,235}),
          fillColor=DynamicSelect({235,235,235}, if y then {0,255,0}
               else {235,235,235}),
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
          lineColor={0,0,255},
          textString="%name")}));
end IntegerSwitch;