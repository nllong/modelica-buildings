within Buildings.Experimental.Templates.AHUs.Validation;
model CommonDamperFree
  extends NoEquipment(ahu(redeclare Economizers.Data.CommonDamperFree datEco(
          mExh_flow_nominal=1), redeclare replaceable
        Economizers.CommonDamperFree eco
        "Single common OA damper - Dampers actuated individually"));

end CommonDamperFree;
