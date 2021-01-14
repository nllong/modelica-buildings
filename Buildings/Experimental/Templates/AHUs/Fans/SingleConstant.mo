within Buildings.Experimental.Templates.AHUs.Fans;
model SingleConstant
  extends Interfaces.Fan(
    final typ=Types.Fan.SingleConstant,
    final have_yBoo=true);

  replaceable Fluid.Movers.SpeedControlled_y fan
    constrainedby Fluid.Movers.BaseClasses.PartialFlowMachine(
      redeclare final package Medium =MediumAir)
    annotation (
      choicesAllMatching=true,
      Placement(transformation(extent={{-10,-10},{10,10}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,50})));
equation
  connect(booToRea.y, fan.y)
    annotation (Line(points={{0,38},{0,12}}, color={0,0,127}));
  connect(yBoo, booToRea.u) annotation (Line(points={{40,120},{40,80},{0,80},{0,
          62}}, color={255,0,255}));
  connect(port_a, fan.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(fan.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  annotation (Placement(transformation(extent={{-10,-10},{10,10}})),
              Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SingleConstant;
