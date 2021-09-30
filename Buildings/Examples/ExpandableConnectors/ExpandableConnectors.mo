within Buildings.Examples.ExpandableConnectors;
model ExpandableConnectors
  extends Modelica.Icons.Example;
  BaseClasses.Equipment equipment
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  BaseClasses.Sensor sensor
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  BaseClasses.Controller controller
    annotation (Placement(transformation(extent={{-10,40},{10,60}})));
  BaseClasses.BusInterface busInterface
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(controller.busInterface, busInterface) annotation (Line(
      points={{0,40},{0,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(busInterface.equBus, equipment.subBusInterface) annotation (Line(
      points={{0.05,0.05},{30,0.05},{30,-40}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(busInterface.senBus, sensor.subBusInterface) annotation (Line(
      points={{0,0},{-30,0},{-30,-40}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    __Dymola_Commands(file="Resources/Scripts/Dymola/Examples/ExpandableConnectors/ExpandableConnectors.mos"
        "Simulate and plot"),
    experiment(
      StopTime=10,
      Tolerance=1e-06));
end ExpandableConnectors;
