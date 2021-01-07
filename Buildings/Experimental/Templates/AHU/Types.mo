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
      CoolingDXMultiStage
      "Cooling coil - Direct expansion, multi-stage",
      CoolingDXVariableSpeed
      "Cooling coil - Direct expansion, variable speed",
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
  type Fan = enumeration(
      SingleConstant
      "Single fan - Constant speed",
      SingleTwoSpeed
      "Single fan - Two speed",
      SingleVariable
      "Single fan - Variable speed",
      SingleDischargeDamper
      "Single fan - Discharge damper",
      MultipleConstant
      "Multiple fan - Constant speed",
      MultipleTwoSpeed
      "Multiple fan - Two speed",
      MultipleVariable
      "Multiple fan - Variable speed",
      MultipleDischargeDamper
      "Multiple fan - Discharge damper") "Enumeration to configure the fan";
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
