within Buildings.Experimental.Templates.AHUs.Validation;
package Data "Package with data records"
  extends Modelica.Icons.MaterialPropertiesPackage;


  record CoolingCoilEffectivenessNTU3WayValve
    extends AHUs.Main.Data.VAVSingleDuct(
      redeclare record RecordCoiCoo = Coils.Data.WaterBased (
        redeclare
        Buildings.Experimental.Templates.AHUs.Coils.HeatExchangers.Data.EffectivenessNTU
        datHex, redeclare
        Buildings.Experimental.Templates.AHUs.Coils.Actuators.Data.ThreeWayValve
        datAct(dpValve_nominal=5000)));
    annotation (
      defaultComponentName='datAhu');
  end CoolingCoilEffectivenessNTU3WayValve;
end Data;
