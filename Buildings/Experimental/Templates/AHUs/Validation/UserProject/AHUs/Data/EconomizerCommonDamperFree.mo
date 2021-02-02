within Buildings.Experimental.Templates.AHUs.Validation.UserProject.AHUs.Data;
record EconomizerCommonDamperFree =
  Buildings.Experimental.Templates.AHUs.Data.VAVSingleDuct (
    typEco=Types.Economizer.CommonDamperFree,
    typCoiCoo=Types.Coil.None,
    typFanSup=Types.Fan.None,
    redeclare Economizers.Data.CommonDamperFree datEco)
  annotation (
    defaultComponentName="datAhu");
