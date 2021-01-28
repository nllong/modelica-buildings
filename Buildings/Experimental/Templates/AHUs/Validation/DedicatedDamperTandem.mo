within Buildings.Experimental.Templates.AHUs.Validation;
model DedicatedDamperTandem
  extends NoEquipment(ahu(redeclare record RecordEco =
          Economizers.Data.DedicatedDamperTandem (mExh_flow_nominal=1),
                          redeclare replaceable
        Economizers.DedicatedDamperTandem eco
        "Separate dedicated OA damper - Dampers actuated in tandem"));
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end DedicatedDamperTandem;
