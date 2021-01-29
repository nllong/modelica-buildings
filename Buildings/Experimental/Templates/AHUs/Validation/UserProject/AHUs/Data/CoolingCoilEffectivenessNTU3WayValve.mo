within Buildings.Experimental.Templates.AHUs.Validation.UserProject.AHUs.Data;
record CoolingCoilEffectivenessNTU3WayValve =
  Templates.AHUs.Main.Data.VAVSingleDuct (
    redeclare record RecordCoiCoo = Coils.Data.WaterBased (redeclare
        Buildings.Experimental.Templates.AHUs.Coils.HeatExchangers.Data.EffectivenessNTU
        datHex, redeclare
        Buildings.Experimental.Templates.AHUs.Coils.Actuators.Data.ThreeWayValve
        datAct(dpValve_nominal=5000)))
  annotation (
  defaultComponentName="datAhu");
