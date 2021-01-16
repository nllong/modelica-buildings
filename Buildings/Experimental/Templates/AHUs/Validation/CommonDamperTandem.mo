within Buildings.Experimental.Templates.AHUs.Validation;
model CommonDamperTandem
  extends NoEquipment(ahu(redeclare Economizers.Data.CommonDamperTandem datEco(
          mExh_flow_nominal=1), redeclare replaceable
        Economizers.CommonDamperTandem eco
        "Single common OA damper - Dampers actuated in tandem"));

end CommonDamperTandem;
