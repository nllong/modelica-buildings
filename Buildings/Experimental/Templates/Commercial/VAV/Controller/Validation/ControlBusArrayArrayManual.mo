within Buildings.Experimental.Templates.Commercial.VAV.Controller.Validation;
model ControlBusArrayArrayManual
  "Validates that an array structure is compatible with control bus"
  extends Modelica.Icons.Example;
  parameter Integer nTerAhu = 5
    "Number of terminal units per AHU";
  parameter Integer nAhu = 5
    "Number of AHU";
  final parameter Integer nTer = nTerAhu * nAhu
    "Number of terminal units";
  DummyTerminal dummyTerminal[nAhu,nTerAhu](indTer={{i*j for i in 1:nTerAhu} for j in 1:nAhu})
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  DummyCentral dummyCentral[nAhu](final nTer=fill(nTerAhu, nAhu))
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
equation

  connect(dummyTerminal.terBus, dummyCentral.ahuBus.ahuTer);

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
Diagram(coordinateSystem(extent={{-80,-60},{80,60}}), graphics={
                                                               Text(
          extent={{-78,48},{12,36}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="Bug in Dymola.

Simulates with OCT.")}));
end ControlBusArrayArrayManual;
