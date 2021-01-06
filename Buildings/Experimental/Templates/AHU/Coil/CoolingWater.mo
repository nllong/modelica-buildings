within Buildings.Experimental.Templates.AHU.Coil;
model CoolingWater
  extends Interfaces.Coil(
    final typ=Types.Coil.CoolingWater);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end CoolingWater;
