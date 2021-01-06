within Buildings.Experimental.Templates.AHU;
package Types "AHU types"
  extends Modelica.Icons.TypesPackage;
  type Coil = enumeration(
      None
      "No economizer",
      CoolingWater
      "Cooling coil - Chilled water",
      CoolingDX
      "Cooling coil - Direct expansion",
      HeatingWater
      "Heating coil - Heating water") "Enumeration to configure the coil";
  type Economizer = enumeration(
      None
      "No economizer",
      CommonDamper
      "Single common damper",
      DedicatedDamper
      "Separate dedicated damper") "Enumeration to configure the economizer";
  type Main = enumeration(
      SupplyOnly
      "Supply only system",
      ExhaustOnly
      "Exhaust only system",
      SupplyReturn
      "Supply and return system") "Enumeration to configure the AHU";
  type Return = enumeration(
      NoRelief
      "No air relief",
      WithRelief
      "With air relief") "Enumeration to configure the return/exhaust branch";
  type Supply = enumeration(
      SingleDuct
      "Single duct system",
      DualDuct
      "Dual duct system") "Enumeration to configure the supply branch";
end Types;
