within Buildings.Experimental.Templates.AHU.Coil;
model None
  extends Interfaces.Coil(
    final typ=Types.Coil.None);
  BaseClasses.PassThrough pas(
    redeclare final package Medium=MediumAir)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(port_a, pas.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(pas.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end None;
