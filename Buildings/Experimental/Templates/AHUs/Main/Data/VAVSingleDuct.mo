within Buildings.Experimental.Templates.AHUs.Main.Data;
record VAVSingleDuct
  extends Modelica.Icons.Record;

  replaceable record RecordCoiCoo = Coils.Data.None
    constrainedby Coils.Data.None(
      final typAct=coiCoo.typAct,
      final typHex=coiCoo.typHex)
    "Cooling coil data record"
    annotation (Placement(transformation(extent={{-40,-150},{-20,-130}})),
      choicesAllMatching=true,
      Dialog(
        enable=typCoiCoo<>Types.Coil.None,
        group="Cooling coil"));

  replaceable record RecordFanSup = Fans.Data.None
    constrainedby Fans.Data.None
    "Supply fan data record"
    annotation (Placement(transformation(extent={{-40,-150},{-20,-130}})),
      choicesAllMatching=true,
      Dialog(
        enable=typFanSup<>Types.Fan.None,
        group="Supply fan"));

  annotation (
  defaultComponentName="datAhu");
end VAVSingleDuct;
