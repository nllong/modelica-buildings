within Buildings.Examples.ScalableBenchmarks.ZoneScaling.MixedAir.BaseClasses;
model LargeOfficeFloor "Model of a floor of the building"
  extends Buildings.Examples.VAVReheat.BaseClasses.Floor(
    final AFloCor = 2536.49,
    final AFloSou = 313.86,
    final AFloNor = 313.86,
    final AFloEas = 198.91,
    final AFloWes = 198.91);
end LargeOfficeFloor;
