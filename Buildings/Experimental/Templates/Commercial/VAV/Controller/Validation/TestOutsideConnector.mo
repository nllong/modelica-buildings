within Buildings.Experimental.Templates.Commercial.VAV.Controller.Validation;
model TestOutsideConnector
  BaseClasses.AhuBusTest bus annotation (Placement(transformation(extent={{32,-20},{72,20}}), iconTransformation(extent={{-50,-10},
            {-30,10}})));
  Controls.OBC.CDL.Continuous.Sources.Sine yNotDeclaredPresent(
    amplitude=5,
    offset=18 + 273.15,
    freqHz=1/5) "Outdoor air temperature" annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  BaseClasses.AhuSubBusITestDec subBus annotation (Placement(transformation(extent={{-34,-10},{-14,10}}),
        iconTransformation(extent={{-10,-10},{10,10}})));
  Controls.OBC.CDL.Continuous.Sources.Ramp yDeclaredPresent(
    height=4,
    duration=3600,
    offset=273.15 + 14) "AHU supply air temperature" annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
equation
  connect(yDeclaredPresent.y, subBus.yDeclaredPresent) annotation (Line(points={{-58,30},{-44,30},{-44,0.05},{-23.95,
          0.05}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(yNotDeclaredPresent.y, subBus.yNotDeclaredPresent) annotation (Line(points={{-58,-30},{-44,-30},{-44,0},{-24,0}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(subBus, bus.ahuI) annotation (Line(
      points={{-24,0},{14,0},{14,0.1},{52.1,0.1}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(yDeclaredPresent.y, bus.yAct) annotation (Line(points={{-58,30},{52,30},{52,0.1},{52.1,0.1}}, color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-40,-40},{40,40}})),
                                                                 Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -60},{80,60}})));
end TestOutsideConnector;
