within Buildings.Experimental.Templates.AHUs.Main.Data;
record VAVSingleDuct
  extends Modelica.Icons.Record;

  replaceable record RecordCoiCoo = Coils.Data.None
    constrainedby Coils.Data.None
    "Cooling coil data record"
    annotation (Placement(transformation(extent={{-40,-150},{-20,-130}})),
      choicesAllMatching=true,
      Dialog(
        group="Cooling coil"));

  /*
  The following gives an error with Dymola (not OCT) because a lookup
  at RecordCoiCoo is done in the AHU model but the class has non 
  constant elements, so cannot be considered as a package.
  */
  /*
  parameter RecordCoiCoo datCoiCoo
    "Cooling coil parameters";
  */

  replaceable record RecordFanSup = Fans.Data.None
    constrainedby Fans.Data.None
    "Supply fan data record"
    annotation (Placement(transformation(extent={{-40,-150},{-20,-130}})),
      choicesAllMatching=true,
      Dialog(
        group="Supply fan"));

end VAVSingleDuct;
