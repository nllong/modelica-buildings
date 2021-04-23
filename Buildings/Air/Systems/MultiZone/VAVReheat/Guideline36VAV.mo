within Buildings.Air.Systems.MultiZone.VAVReheat;
model Guideline36VAV
  "Variable air volume flow system with terminal reheat"
  extends Guideline36VAVNoExhaust(
    redeclare BaseClasses.MixingBox eco(
      mExh_flow_nominal=m_flow_nominal,
      dpExh_nominal=10,
      from_dp=false));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yExhDam(k=1)
    "Exhaust air damper control signal"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));

equation
  connect(yExhDam.y, eco.yExh)
    annotation (Line(points={{-18,-10},{-3,-10},{-3,-34}}, color={0,0,127}));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Guideline36VAV;
