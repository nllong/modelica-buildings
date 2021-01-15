within Buildings.Experimental.Templates_V0.BaseClasses;
model AhuBusGateway
  "Model to connect scalar variables from main bus to an array of sub-bus"

  parameter Integer nTer=0
    "Number of terminal units";
    // annotation(Dialog(connectorSizing=true)) is not interpreted properly in Dymola.

  AhuBus ahuBus(nTer=nTer) annotation (Placement(transformation(extent={{-20,-20},{20,20}}),
        iconTransformation(extent={{-100,-88},{100,72}})));
  TerminalBus terBus[nTer]
    annotation (Placement(transformation(extent={{-20,-80},{20,-40}})));
equation
  for i in 1:nTer loop
    connect(ahuBus.staAhu, ahuBus.ahuTer[i].staAhu);
  end for;
  connect(ahuBus.ahuTer, terBus)
    annotation (Line(
      points={{0.1,0.1},{0,0.1},{0,-60}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}})),
    Diagram(coordinateSystem(extent={{-40,-80},{40,20}})));
end AhuBusGateway;
