within Buildings.Experimental.Templates.Commercial.VAV.Controller.Validation;
model ControlBusArrayManual
  "Validates that an array structure is compatible with control bus"
  extends Modelica.Icons.Example;
  parameter Integer nCon = 5
    "Number of connected components";
  DummyTerminal dummyTerminal[nCon](
    indTer={i for i in 1:nCon})
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  DummyCentral dummyCentralSystem(final nCon=nCon)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
equation

  connect(dummyTerminal.terBus, dummyCentralSystem.ahuBus.ahuTer);

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
          extent={{-78,48},{84,30}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="Bug Dymola expandable connector:

GUI does not allow connecting directly dummyTerminal[:].ahuTer to dummyCentral.ahuBus.ahuTer[:]

I do not see what prevents that syntax in Modelica specification. 
To the contrary I read \"expandable connectors can be connected even if they do not contain the same components\".

When manually specifying the connect statement as above the model:
- fails to translate with Dymola with the message \"Connect argument was not one of the valid forms, since dummyCentralSystem is not a connector\".
- translates and simulates with OCT.")}));
end ControlBusArrayManual;
