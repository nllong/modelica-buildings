within Buildings.Experimental.Templates.AHUs.Economizers.Data;
record None
  extends Modelica.Icons.Record;

  constant Types.Economizer typ
    "Equipment type"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  annotation (
    defaultComponentName="datEco",
    defaultComponentPrefixes="outer parameter",
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end None;
