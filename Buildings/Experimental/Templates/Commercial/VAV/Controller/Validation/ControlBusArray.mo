within Buildings.Experimental.Templates.Commercial.VAV.Controller.Validation;
model ControlBusArray
  "Validates that an array structure is compatible with control bus"
  extends Modelica.Icons.Example;
  parameter Integer nCon = 5
    "Number of connected components";
  DummyTerminal dummyTerminal[nCon](
    indTer={i for i in 1:nCon})
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  DummyCentral dummyCentralSystem(final nCon=nCon)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  BaseClasses.AhuBus ahuBus(nTer=nCon) annotation (Placement(transformation(
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
  connect(ahuBus, dummyCentralSystem.ahuBus) annotation (Line(
      points={{0,-20},{-26,-20},{-26,-0.1}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
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
Diagram(coordinateSystem(extent={{-80,-60},{80,60}}), graphics={
                                                               Text(
          extent={{-64,68},{136,8}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="Bugs GUI Dymola expandable connector:

- terBus.inpSig is considered as an array if terBus[].inpSig has been connected to an array of scalar variables. 
Need to update the code manually to suppress the index and simulate.
- If the connection is made at the terminal unit first: OK.

Improvement: connectorSizing does not work for nested expandable connector. Need to specify the dimension manually in ahuBus.

BUG in OCT

In components:
    dummyCentralSystem.ahuBus.ahuTer[2]
    dummyCentralSystem.ahuBus.ahuTer[3]
    dummyCentralSystem.ahuBus.ahuTer[4]
    dummyCentralSystem.ahuBus.ahuTer[5]
  Cannot find class declaration for RealInput")}));
end ControlBusArray;
