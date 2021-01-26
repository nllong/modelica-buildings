within Buildings.Experimental.Templates.AHUs.Validation.UserProject.AHUs;
model CoolingCoilEffectivenessNTU3WayValve
  extends Templates.AHUs.Main.VAVSingleDuct(
    redeclare Coils.WaterBased coiCoo(redeclare
      Buildings.Experimental.Templates.AHUs.Coils.Actuators.ThreeWayValve
      act, redeclare
      Buildings.Experimental.Templates.AHUs.Coils.HeatExchangers.EffectivenessNTU
      coi));
end CoolingCoilEffectivenessNTU3WayValve;
