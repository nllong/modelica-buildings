within Buildings.Experimental.Templates.AHU;
package Types "AHU types"
  extends Modelica.Icons.TypesPackage;
  type Actuator = enumeration(
      None
      "No actuator",
      TwoWayValve
      "Two-way valve",
      ThreeWayValve
      "Three-way valve",
      PumpedCoilTwoWayValve
      "Pumped coil with two-way valve",
      PumpedCoilThreeWayValve
      "Pumped coil with three-way valve") "Enumeration to configure the actuator";
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
      CommonDamperTandem
      "Single common OA damper - Dampers actuated in tandem",
      DedicatedDamperTandem
      "Separate dedicated OA damper - Dampers actuated in tandem",
      CommonDamperFree
      "Single common OA damper - Dampers actuated individually",
      CommonDamperFreeNoRelief
      "Single common OA damper - Dampers actuated individually, no relief") "Enumeration to configure the economizer";
  type Main = enumeration(
      SupplyOnly
      "Supply only system",
      ExhaustOnly
      "Exhaust only system",
      SupplyReturn
      "Supply and return system") "Enumeration to configure the AHU";
  type unused_Return = enumeration(
      NoRelief
      "No air relief",
      WithRelief
      "With air relief") "Enumeration to configure the return/exhaust branch";
  type unused_Supply = enumeration(
      SingleDuct
      "Single duct system",
      DualDuct
      "Dual duct system") "Enumeration to configure the supply branch";
end Types;
