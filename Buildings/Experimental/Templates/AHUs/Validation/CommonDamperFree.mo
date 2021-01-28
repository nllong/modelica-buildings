within Buildings.Experimental.Templates.AHUs.Validation;
model CommonDamperFree
  extends NoEquipment(ahu(redeclare record RecordEco =
          Economizers.Data.CommonDamperFree (mExh_flow_nominal=1),
                          redeclare replaceable
        Economizers.CommonDamperFree eco
        "Single common OA damper - Dampers actuated in tandem"));
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end CommonDamperFree;
