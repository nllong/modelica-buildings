within Buildings.Experimental.Templates.AHUs.Main.Data;
record VAVSingleDuct
  extends Modelica.Icons.Record;

  replaceable record RecordEco =
      Buildings.Experimental.Templates.AHUs.Economizers.Data.None
    constrainedby Buildings.Experimental.Templates.AHUs.Economizers.Data.None
    "Economizer data record (type)"
    annotation (
      Dialog(group="Economizer"),
      choicesAllMatching=true);

  parameter RecordEco datEco
    "Economizer parameters"
  annotation (Placement(transformation(extent={{-40,-150},{-20,-130}})),
      choicesAllMatching=true,
      Dialog(
        group="Economizer",
        enable=RecordEco<>Buildings.Experimental.Templates.AHUs.Economizers.Data.None));

  replaceable record RecordCoiCoo =
      Buildings.Experimental.Templates.AHUs.Coils.Data.None
    constrainedby Buildings.Experimental.Templates.AHUs.Coils.Data.None
    "Cooling coil data record"
    annotation (
      choicesAllMatching=true,
      Dialog(
        group="Cooling coil"));

  parameter RecordCoiCoo datCoiCoo
    "Cooling coil parameters"
    annotation (Placement(transformation(extent={{-40,-150},{-20,-130}})),
      choicesAllMatching=true,
      Dialog(
        group="Cooling coil",
        enable=RecordCoiCoo<>Buildings.Experimental.Templates.AHUs.Coils.Data.None));

  replaceable record RecordFanSup =
      Buildings.Experimental.Templates.AHUs.Fans.Data.None
    constrainedby Buildings.Experimental.Templates.AHUs.Fans.Data.None
    "Supply fan data record"
    annotation (
      choicesAllMatching=true,
      Dialog(
        group="Supply fan"));

  parameter RecordFanSup datFanSup
    "Supply fan parameters";
    annotation (Placement(transformation(extent={{-40,-150},{-20,-130}})),
      choicesAllMatching=true,
      Dialog(
        group="Supply fan",
        enable=RecordFanSup<>Buildings.Experimental.Templates.AHUs.Fans.Data.None));

end VAVSingleDuct;
