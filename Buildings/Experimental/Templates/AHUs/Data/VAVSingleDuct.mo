within Buildings.Experimental.Templates.AHUs.Data;
record VAVSingleDuct
  extends Modelica.Icons.Record;

  /*
  The constants are declared only to use the Dialog(enable) annotation
  since there is no mechanism for type introspection in Modelica.
  However Dymola does not take it into account.
  */
  constant Types.Economizer typEco
    "Type of economizer"
    annotation (Evaluate=true,
      Dialog(group="Economizer"));
  constant Types.Coil typCoiCoo
    "Type of cooling coil"
    annotation (Evaluate=true,
      Dialog(group="Cooling coil"));
  constant Types.Fan typFanSup
    "Type of supply fan"
    annotation (Evaluate=true,
      Dialog(group="Supply fan"));

  replaceable parameter Templates.AHUs.Economizers.Data.None datEco
    constrainedby Buildings.Experimental.Templates.AHUs.Economizers.Data.None
    "Economizer parameters"
    annotation (Placement(transformation(extent={{-40,-150},{-20,-130}})),
      choicesAllMatching=true,
      Dialog(
        enable=typEco<>Types.Economizer.None,
        group="Economizer"));

  replaceable parameter Templates.AHUs.Coils.Data.None datCoiCoo
    constrainedby Buildings.Experimental.Templates.AHUs.Coils.Data.None
    "Cooling coil parameters"
    annotation (Placement(transformation(extent={{-40,-150},{-20,-130}})),
      choicesAllMatching=true,
      Dialog(
        enable=typCoiCoo<>Types.Coil.None,
        group="Cooling coil"));

  replaceable parameter Templates.AHUs.Fans.Data.None datFanSup
    constrainedby Buildings.Experimental.Templates.AHUs.Fans.Data.None
    "Supply fan parameters";
    annotation (Placement(transformation(extent={{-40,-150},{-20,-130}})),
      choicesAllMatching=true,
      Dialog(
        enable=typFanSup<>Types.Fan.None,
        group="Supply fan"));

end VAVSingleDuct;
