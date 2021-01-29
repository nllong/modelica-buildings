within Buildings.Experimental.Templates.AHUs.Validation.UserProject.AHUs.Data;
record CoolingCoilDiscretized =
  Templates.AHUs.Main.Data.VAVSingleDuct (
    redeclare record RecordFanSup = Fans.Data.None,
    redeclare record RecordEco = Economizers.Data.None,
    redeclare record RecordCoiCoo = Coils.Data.WaterBased (redeclare
          Buildings.Experimental.Templates.AHUs.Coils.HeatExchangers.Data.Discretized
          datHex))
  annotation (
  defaultComponentName="datAhu");
