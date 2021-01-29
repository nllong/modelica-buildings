within Buildings.Experimental.Templates.AHUs.Validation.UserProject.AHUs.Data;
record SupplyFanDrawMultipleVariable =
  Templates.AHUs.Main.Data.VAVSingleDuct (redeclare record RecordFanSup =
        Fans.Data.MultipleVariable)
  annotation (
  defaultComponentName="datAhu");
