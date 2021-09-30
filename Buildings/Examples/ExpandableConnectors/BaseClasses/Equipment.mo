within Buildings.Examples.ExpandableConnectors.BaseClasses;
model Equipment
  EquipmentSubBusInterface subBusInterface
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  Modelica.Blocks.Sources.Constant const(k=1)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  HeatTransfer.Sources.PrescribedTemperature preTem
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
equation
  connect(const.y, subBusInterface.inp) annotation (Line(points={{-39,0},{0,0},
          {0,100}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(subBusInterface.out, preTem.T) annotation (Line(
      points={{0,100},{0,0},{38,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-100,20},{100,-20}},
          lineColor={28,108,200},
          textString="Equipment")}), Diagram(coordinateSystem(
          preserveAspectRatio=false)));
end Equipment;
