within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model HeatingCoilEffectivenessNTU2WayValve
  extends VAVSingleDuct(final id="VAV_1", redeclare
      BaseClasses.Coils.WaterBased coiHea2(redeclare
        Buildings.Templates.AHUs.BaseClasses.Coils.Valves.TwoWayValve act,
        redeclare
        Buildings.Templates.AHUs.BaseClasses.Coils.HeatExchangers.DryCoilEffectivenessNTU
        hex));
  annotation (
    defaultComponentName="ahu");
end HeatingCoilEffectivenessNTU2WayValve;