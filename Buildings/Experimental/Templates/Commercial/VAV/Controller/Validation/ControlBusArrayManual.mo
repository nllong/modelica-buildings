within Buildings.Experimental.Templates.Commercial.VAV.Controller.Validation;
model ControlBusArrayManual
  "Validates that an array structure is compatible with control bus"
  extends Modelica.Icons.Example;
  parameter Integer nTer = 5
    "Number of connected components";
  DummyTerminal dummyTerminal[nTer](
    indTer={i for i in 1:nTer})
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  DummyCentral dummyCentral(final nTer=nTer)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
equation

  connect(dummyTerminal.terBus, dummyCentral.ahuBus.ahuTer);

annotation (experiment(StopTime=3600.0, Tolerance=1e-06),
Diagram(coordinateSystem(extent={{-60,-20},{60,20}}), graphics={
                                                               Text(
          extent={{-42,54},{120,36}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="Bug Dymola expandable connector:

GUI does not allow connecting directly dummyTerminal[:].ahuTer to dummyCentral.ahuBus.ahuTer[:]

I do not see what prevents that syntax in Modelica specification. 
To the contrary I read \"expandable connectors can be connected even if they do not contain the same components\".

When manually specifying the connect statement as above the model:
- fails to translate with Dymola with the message \"Connect argument was not one of the valid forms, since dummyCentral is not a connector\".
- translates and simulates with OCT.")}));
end ControlBusArrayManual;
