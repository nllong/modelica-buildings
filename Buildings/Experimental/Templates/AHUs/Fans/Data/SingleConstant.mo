within Buildings.Experimental.Templates.AHUs.Fans.Data;
record SingleConstant
  extends None;

  // FIXME: Dummy default values fo testing purposes only.
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal= 1
    "Nominal mass flow rate";
  parameter Modelica.SIunits.PressureDifference dp_nominal = 500
    "Nominal pressure rise";
  replaceable parameter Buildings.Fluid.Movers.Data.Generic per(
    pressure(V_flow={0,m_flow_nominal,2*m_flow_nominal}/1.2,
             dp={2*dp_nominal,dp_nominal,0}))
    constrainedby Buildings.Fluid.Movers.Data.Generic
    "Record with performance data"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{-10,-8},{10,12}})));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SingleConstant;
