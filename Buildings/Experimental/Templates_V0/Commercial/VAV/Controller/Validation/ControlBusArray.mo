within Buildings.Experimental.Templates_V0.Commercial.VAV.Controller.Validation;
model ControlBusArray
  "Validates that an array structure is compatible with control bus"
  extends Modelica.Icons.Example;
  parameter Integer nTer = 5
    "Number of connected components";
  DummyTerminal dummyTerminal[nTer](
    indTer={i for i in 1:nTer})
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  DummyCentral dummyCentral(final nTer=nTer)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  BaseClasses.AhuBus ahuBus(nTer=nTer) annotation (Placement(transformation(
          extent={{-20,-40},{20,0}}), iconTransformation(extent={{-144,-52},{
            -124,-32}})));
equation

  connect(dummyTerminal.terBus, ahuBus.ahuTer) annotation (Line(
      points={{34,0},{34,-19.9},{0.1,-19.9}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(dummyCentral.ahuBus, ahuBus) annotation (Line(
      points={{-26,-0.1},{-26,-20},{0,-20}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
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
Diagram(coordinateSystem(extent={{-60,-40},{60,20}}), graphics={
                                                               Text(
          extent={{-48,60},{152,0}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="Improvement: connectorSizing does not work for nested expandable connector. Need to specify the dimension manually in ahuBus.

BUG in OCT

In components:
    dummyCentralSystem.ahuBus.ahuTer[2]
    dummyCentralSystem.ahuBus.ahuTer[3]
    dummyCentralSystem.ahuBus.ahuTer[4]
    dummyCentralSystem.ahuBus.ahuTer[5]
  Cannot find class declaration for RealInput")}));
end ControlBusArray;
