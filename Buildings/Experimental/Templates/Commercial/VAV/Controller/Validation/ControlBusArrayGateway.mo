within Buildings.Experimental.Templates.Commercial.VAV.Controller.Validation;
model ControlBusArrayGateway
  "Validates that an array structure is compatible with control bus"
  extends Modelica.Icons.Example;
  parameter Integer nTer = 5
    "Number of connected components";
  DummyTerminal dummyTerminal[nTer](
    indTer={i for i in 1:nTer}, tesStaAhu=true)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  DummyCentral dummyCentral(final nTer=nTer, tesStaAhu=true)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  BaseClasses.AhuBusGateway ahuBusGateway(nTer=nTer)
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
equation

  connect(dummyCentral.ahuBus, ahuBusGateway.ahuBus) annotation (Line(
      points={{-26,-0.1},{-26,-30.8},{0,-30.8}},
      color={255,204,51},
      thickness=0.5));
  connect(ahuBusGateway.terBus, dummyTerminal.terBus) annotation (Line(
      points={{0,-36},{34,-36},{34,0}},
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
Diagram(coordinateSystem(extent={{-80,-60},{80,60}}), graphics={Text(
          extent={{-78,50},{-14,24}},
          lineColor={28,108,200},
          textString="Bug in Dymola
The bus-input dummyTerminal[1].terBus.staAhu lacks a matching non-input in the connection sets. This means that it lacks a source writing the signal to the bus.


Simulates with OCT and correct results.",
          horizontalAlignment=TextAlignment.Left)}));
end ControlBusArrayGateway;
