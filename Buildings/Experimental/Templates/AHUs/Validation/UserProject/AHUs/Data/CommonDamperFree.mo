within Buildings.Experimental.Templates.AHUs.Validation.UserProject.AHUs.Data;
record CommonDamperFree =
  Templates.AHUs.Main.Data.VAVSingleDuct (
    redeclare record RecordEco = Economizers.Data.CommonDamperFree)
  annotation (
  defaultComponentName="datAhu");
