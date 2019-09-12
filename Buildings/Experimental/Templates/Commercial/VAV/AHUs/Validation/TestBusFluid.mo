within Buildings.Experimental.Templates.Commercial.VAV.AHUs.Validation;
model TestBusFluid
  package Medium = Buildings.Media.Water "Medium model for water";

  BaseClasses.AhuBusFluid ahuBusFluid annotation (Placement(transformation(extent={{-22,-20},{18,20}}),
        iconTransformation(extent={{-178,-24},{-158,-4}})));
  Fluid.Sources.MassFlowSource_T boundary(redeclare package Medium = Medium, m_flow=1)
                                          annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Fluid.Sources.Boundary_pT bou(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{70,-10},{50,10}})));
equation
  connect(boundary.ports[1], ahuBusFluid.souPor) annotation (Line(points={{-60,0},{-2,0}}, color={0,127,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(ahuBusFluid.souPor, bou.ports[1]) annotation (Line(
      points={{-2,0},{50,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end TestBusFluid;
