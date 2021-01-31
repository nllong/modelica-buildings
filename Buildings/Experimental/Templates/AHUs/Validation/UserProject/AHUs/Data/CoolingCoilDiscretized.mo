within Buildings.Experimental.Templates.AHUs.Validation.UserProject.AHUs.Data;
record CoolingCoilDiscretized =
  Buildings.Experimental.Templates.AHUs.Data.VAVSingleDuct (
    redeclare Fans.Data.None datFanSup,
    redeclare Economizers.Data.None datEco,
    redeclare Coils.Data.WaterBased datCoiCoo(redeclare
          Buildings.Experimental.Templates.AHUs.Coils.HeatExchangers.Data.Discretized
          datHex))
  annotation (
  defaultComponentName="datAhu");
