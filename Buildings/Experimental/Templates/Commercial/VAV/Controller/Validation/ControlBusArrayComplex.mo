within Buildings.Experimental.Templates.Commercial.VAV.Controller.Validation;
model ControlBusArrayComplex
  "Validates that an array structure is compatible with control bus"
  extends Modelica.Icons.Example;
  parameter Integer nCon = 5
    "Number of connected components";
  DummyTerminalComplex
                dummyTerminalComplex
                             [nCon](
    indTer={i for i in 1:nCon})
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  DummyCentralComplex dummyCentralSystemComplex(final nCon=nCon)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
equation
  connect(dummyCentralSystemComplex.ahuBus, dummyTerminalComplex.ahuBus)
    annotation (Line(
      points={{-29.6,-0.2},{0.2,-0.2},{0.2,0},{30.6,0}},
      color={255,204,51},
      thickness=0.5));
annotation (experiment(StopTime=3600.0, Tolerance=1e-06),
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
Diagram(coordinateSystem(extent={{-80,-60},{80,60}})));
end ControlBusArrayComplex;
