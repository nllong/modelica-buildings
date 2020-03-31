within Buildings.Experimental.Templates.Commercial.VAV.Controller.Validation;
model ControlBusArrayArray
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
  BaseClasses.AhuBus ahuBus[nAhu](nTer=fill(nTerAhu, nAhu)) annotation (
      Placement(transformation(extent={{-20,-40},{20,0}}), iconTransformation(
          extent={{-144,-52},{-124,-32}})));
equation

  connect(ahuBus.ahuTer, dummyTerminal.terBus) annotation (Line(
      points={{0.1,-19.9},{34,-19.9},{34,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
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
          extent={{-64,68},{136,8}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="Bug Dymola

Unmatched dimension in connect(ahuBus.ahuTer, dummyTerminal.terBus);

The first argument, ahuBus.ahuTer, is a connector with 1 dimensions
and the second, dummyTerminal.terBus, is a connector with 2 dimensions.


Bug in OCT, similar as before:
Error at line 296, column 5, in file '/opt/oct/ThirdParty/MSL/Modelica/Blocks/Interfaces.mo':
  Cannot find class declaration for RealInput

")}));
end ControlBusArrayArray;
