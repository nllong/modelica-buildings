within Buildings.Examples.DualFanDualDuct.Controls;
block HeatingCoilTemperatureSetpoint "Set point scheduler for heating coil"
  import Buildings.Air.Systems.MultiZone.VAVReheat.Controls.OperationModes;
  extends CoolingCoilTemperatureSetpoint(TSetPoi(
    y=if (mode.y == Integer(OperationModes.unoccupiedOff)) then TOff else TOn));
end HeatingCoilTemperatureSetpoint;
