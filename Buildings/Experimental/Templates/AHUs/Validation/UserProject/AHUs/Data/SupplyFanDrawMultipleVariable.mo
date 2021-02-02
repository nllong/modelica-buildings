within Buildings.Experimental.Templates.AHUs.Validation.UserProject.AHUs.Data;
record SupplyFanDrawMultipleVariable =
  Buildings.Experimental.Templates.AHUs.Data.VAVSingleDuct (
    typEco=Types.Economizer.None,
    typCoiCoo=Types.Coil.None,
    typFanSup=Types.Fan.MultipleVariable,
    redeclare Fans.Data.MultipleVariable datFanSup)
  annotation (
  defaultComponentName="datAhu");
