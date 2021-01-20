within Buildings.Experimental.Templates.AHUs.Validation;
model CommonDamperFree
  extends NoEquipment_outer(
                      ahu(redeclare Economizers.Data.CommonDamperFree datEco(
          mExh_flow_nominal=1), redeclare replaceable
        Economizers.CommonDamperFree eco
        "Single common OA damper - Dampers actuated individually"));
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end CommonDamperFree;
