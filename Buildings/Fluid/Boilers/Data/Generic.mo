within Buildings.Fluid.Boilers.Data;
record Generic "Generic data record for boiler efficiency curves"
  extends Modelica.Icons.Record;

  parameter Modelica.SIunits.Efficiency effCur[:,:]=
    [0, 1; 1, 1]
    "Efficiency curves as a table: First row = inlet temp(K), First column = firing rates or PLR";

  parameter Modelica.SIunits.Power Q_flow_nominal = 3000 "Nominal heating power";
  parameter Modelica.SIunits.ThermalConductance UA=0.05*Q_flow_nominal/30
    "Overall UA value";
  parameter Modelica.SIunits.Volume VWat = 1.5E-6*Q_flow_nominal
    "Water volume of boiler";
  parameter Modelica.SIunits.Mass mDry =   1.5E-3*Q_flow_nominal
    "Mass of boiler that will be lumped to water heat capacity";

  parameter Modelica.SIunits.Temperature dT_nominal = 20
    "Nominal temperature difference";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=
    Q_flow_nominal/dT_nominal/4200
    "Nominal mass flow rate";
  parameter Modelica.SIunits.PressureDifference dp_nominal = 3000
    "Pressure drop at m_flow_nominal";

  annotation (
  defaultComponentName="per",
  defaultComponentPrefixes = "parameter",
  Documentation(info="<html>
<p>
This record is used as a template for performance data
for the boiler model
<a href=\"Modelica://Buildings.Fluid.Boilers.BoilerTable\">
Buildings.Fluid.Boilers.BoilerTable</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
November 2, 2021 by Hongxiang Fu:<br/>
First implementation. 
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2651\">#2651</a>.
</li>
</ul>
</html>"));
end Generic;
