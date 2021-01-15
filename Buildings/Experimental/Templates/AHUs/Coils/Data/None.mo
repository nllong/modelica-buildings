within Buildings.Experimental.Templates.AHUs.Coils.Data;
record None
  extends Modelica.Icons.Record;

  constant Types.Actuator typAct
    "Type of actuator"
    annotation (Dialog(group="Actuator"));
  constant Types.HeatExchanger typHex
    "Type of HX"
    annotation (Dialog(group="Heat exchanger"));

  annotation (
    defaultComponentName="datCoi",
    defaultComponentPrefixes="outer parameter",
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end None;
