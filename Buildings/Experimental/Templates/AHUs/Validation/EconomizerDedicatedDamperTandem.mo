within Buildings.Experimental.Templates.AHUs.Validation;
model EconomizerDedicatedDamperTandem
  extends BaseNoEquipment( redeclare
    UserProject.AHUs.EconomizerDedicatedDamperTandem ahu(datEco(
          mExh_flow_nominal=1)));
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end EconomizerDedicatedDamperTandem;
