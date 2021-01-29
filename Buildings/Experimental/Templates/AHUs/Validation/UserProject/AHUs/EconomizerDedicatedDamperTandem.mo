within Buildings.Experimental.Templates.AHUs.Validation.UserProject.AHUs;
model EconomizerDedicatedDamperTandem
  extends Templates.AHUs.Main.VAVSingleDuct(redeclare
      Economizers.DedicatedDamperTandem eco
      "Separate dedicated OA damper - Dampers actuated in tandem",
                                            redeclare record RecordEco =
        Economizers.Data.DedicatedDamperTandem);

  annotation (
    defaultComponentName="ahu");
end EconomizerDedicatedDamperTandem;
