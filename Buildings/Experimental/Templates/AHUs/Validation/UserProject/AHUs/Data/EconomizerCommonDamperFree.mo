within Buildings.Experimental.Templates.AHUs.Validation.UserProject.AHUs.Data;
record EconomizerCommonDamperFree =
  Buildings.Experimental.Templates.AHUs.Data.VAVSingleDuct (
    redeclare Economizers.Data.CommonDamperFree datEco)
  annotation (
  defaultComponentName="datAhu");
