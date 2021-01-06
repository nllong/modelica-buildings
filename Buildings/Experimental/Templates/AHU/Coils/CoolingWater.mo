within Buildings.Experimental.Templates.AHU.Coils;
model CoolingWater
  extends Interfaces.Coil(
    final typ=Types.Coil.CoolingWater);
  Fluid.HeatExchangers.WetCoilCounterFlow cooCoi(
    redeclare final package Medium1 = MediumSou,
    redeclare final package Medium2 = MediumAir)
    "Heat exchanger"
    annotation (Placement(transformation(extent={{10,4},{-10,-16}})));
equation
  connect(port_a, cooCoi.port_a2)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(cooCoi.port_b2, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(port_aSou, cooCoi.port_a1) annotation (Line(points={{-40,-100},{-40,-20},
          {20,-20},{20,-12},{10,-12}}, color={0,127,255}));
  connect(cooCoi.port_b1, port_bSou) annotation (Line(points={{-10,-12},{-20,-12},
          {-20,-40},{40,-40},{40,-100}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end CoolingWater;
