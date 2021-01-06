within Buildings.Experimental.Templates.AHU.Economizers;
model CommonDamperTandem
  extends Interfaces.Economizer(
    final typ=Types.Economizer.CommonDamperTandem);

  Fluid.Actuators.Dampers.MixingBox mix
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

equation
  connect(port_Out, mix.port_Out) annotation (Line(points={{-100,-60},{-20,-60},
          {-20,6},{-10,6}}, color={0,127,255}));
  connect(mix.port_Sup, port_Sup) annotation (Line(points={{10,6},{20,6},{20,-60},
          {100,-60}}, color={0,127,255}));
  connect(mix.port_Ret, port_Ret) annotation (Line(points={{10,-6},{40,-6},{40,60},
          {100,60}},     color={0,127,255}));
  connect(yOut, mix.y)
    annotation (Line(points={{0,120},{0,12}}, color={0,0,127}));
  connect(port_Exh, mix.port_Exh) annotation (Line(points={{-100,60},{-40,60},{-40,
          -6},{-10,-6}}, color={0,127,255}));
  annotation (
  defaultComponentName="eco",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end CommonDamperTandem;
