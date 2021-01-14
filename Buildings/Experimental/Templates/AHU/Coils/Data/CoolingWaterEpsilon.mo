within Buildings.Experimental.Templates.AHU.Coils.Data;
record CoolingWaterEpsilon
  extends CoolingWater;

  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal(min=0)
    "Nominal heat flow rate"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Temperature Ta1_nominal
    "Nominal inlet temperature"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Temperature Ta2_nominal
    "Nominal inlet temperature"
    annotation(Dialog(group = "Nominal condition"));

  annotation (
    defaultComponentName="datCoi",
    defaultComponentPrefixes="outer parameter",
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end CoolingWaterEpsilon;
