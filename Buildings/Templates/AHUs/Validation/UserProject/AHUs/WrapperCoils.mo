within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model WrapperCoils
  extends Buildings.Templates.AHUs.VAVSingleDuctWrapper(
    typActCoiHea=Buildings.Templates.Types.Actuator.TwoWayValve,
    typCoiHea=Buildings.Templates.Types.Coil.WaterBased,
    typFanSupPos=Buildings.Templates.Types.FanSupplyPosition.DrawThrough,
    nZon=1,
    nGro=1,
    id="VAV_1");
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end WrapperCoils;
