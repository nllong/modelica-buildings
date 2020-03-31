within Buildings.Experimental.Templates.Commercial.VAV.Controller.Validation;
model ControlBusArrayBug
  "Validates that an array structure is compatible with control bus"
  extends Modelica.Icons.Example;
  parameter Integer nTer = 5
    "Number of connected components";
  DummyTerminal dummyTerminal[nTer](
    indTer={i for i in 1:nTer})
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  DummyCentralBug
               dummyCentralBug(
                            final nTer=nTer)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
equation

  connect(dummyCentralBug.terBus, dummyTerminal.terBus) annotation (Line(
      points={{-26.8,0},{34,0}},
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
Diagram(coordinateSystem(extent={{-60,-20},{60,20}}), graphics={
                                                               Text(
          extent={{-52,60},{148,0}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="Bugs GUI Dymola expandable connector:

- terBus.inpSig is considered as an array if terBus[].inpSig has been connected to an array of scalar variables. 
Need to update the code manually to suppress the index and simulate.
- If the connection is made at the terminal unit first: OK.

")}));
end ControlBusArrayBug;
