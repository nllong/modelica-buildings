within Buildings.Experimental.Templates.AHUs.Validation;
model CommonDamperTandem
  extends NoEquipment(ahu(redeclare Economizers.Data.CommonDamperTandem datEco(
          mExh_flow_nominal=1), redeclare replaceable
        Economizers.CommonDamperTandem eco
        "Single common OA damper - Dampers actuated in tandem"));
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end CommonDamperTandem;
