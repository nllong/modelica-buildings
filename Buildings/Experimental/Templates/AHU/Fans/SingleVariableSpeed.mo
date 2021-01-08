within Buildings.Experimental.Templates.AHU.Fans;
model SingleVariableSpeed
  extends Interfaces.Fan(
    final typ=Types.Fan.SingleConstant,
    final have_y=true);

  replaceable Fluid.Movers.SpeedControlled_y fan
    constrainedby Fluid.Movers.BaseClasses.PartialFlowMachine(
      redeclare final package Medium =MediumAir)
    annotation (
      choicesAllMatching=true,
      Placement(transformation(extent={{-10,-10},{10,10}})));

equation
  connect(port_a, fan.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(fan.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(y, fan.y) annotation (Line(points={{0,120},{0,12}}, color={0,0,127}));
  annotation (Placement(transformation(extent={{-10,-10},{10,10}})),
              Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SingleVariableSpeed;
