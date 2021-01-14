within Buildings.Experimental.Templates.AHU.Coils.Data;
record None
  extends Modelica.Icons.Record;

  constant Types.Coil typ
    "Equipment type"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  annotation (
    defaultComponentName="datCoi",
    defaultComponentPrefixes="outer parameter",
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end None;
