within Buildings.Experimental.Templates.AHU.Economizers;
model CommonDamperFreeNoRelief
  extends Interfaces.Economizer(
    final typ=Types.Economizer.CommonDamperFreeNoRelief);

  // FIXME: Dummy default values fo testing purposes only.
  parameter Modelica.SIunits.MassFlowRate mOut_flow_nominal = 1
    "Mass flow rate outside air damper"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dpDamOut_nominal(
    min=0, displayUnit="Pa") = 20
    "Pressure drop of damper in outside air leg"
     annotation (Dialog(group="Nominal condition"));

  parameter Modelica.SIunits.MassFlowRate mRec_flow_nominal = 1
    "Mass flow rate recirculation air damper"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dpDamRec_nominal(
    min=0, displayUnit="Pa") = 20
    "Pressure drop of damper in recirculation air leg"
     annotation (Dialog(group="Nominal condition"));

  BaseClasses.MixingBoxFreeNoRelief mix(
    redeclare final package Medium = Medium,
    final mOut_flow_nominal=mOut_flow_nominal,
    final mRec_flow_nominal=mRec_flow_nominal,
    final dpOut_nominal=dpDamOut_nominal,
    final dpRec_nominal=dpDamRec_nominal)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

equation
  connect(port_Out, mix.port_Out) annotation (Line(points={{-100,-60},{-20,-60},
          {-20,6},{-10,6}}, color={0,127,255}));
  connect(mix.port_Sup, port_Sup) annotation (Line(points={{10,6},{20,6},{20,-60},
          {100,-60}}, color={0,127,255}));
  connect(mix.port_Ret, port_Ret) annotation (Line(points={{10,-6},{40,-6},{40,60},
          {100,60}},     color={0,127,255}));
  connect(yOut, mix.yOut)
    annotation (Line(points={{0,120},{0,12}}, color={0,0,127}));
  connect(yRet, mix.yRet) annotation (Line(points={{80,120},{80,20},{-6.8,20},{-6.8,
          12}}, color={0,0,127}));
  annotation (
  defaultComponentName="eco",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end CommonDamperFreeNoRelief;
