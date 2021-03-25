within Buildings.ThermalZones.EnergyPlus.Examples.ScalableBenchmark;
model Large2FloorsNoHVAC
  "Open loop model of a large building with 2 floors and 10 zones"
  extends Modelica.Icons.Example;

  replaceable package Medium = Buildings.Media.Air "Medium for air";
  parameter Integer floCou = 2 "Number of floors";

  parameter String weaName = Modelica.Utilities.Files.loadResource(
    "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")
    "Name of the weather file";
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=weaName,
    computeWetBulbTemperature=false)
    "Weather data reader";
  BoundaryConditions.WeatherData.Bus weaBus "Weather data bus";

  BaseClasses.MultiFloors flo(
    floCou=floCou,
    redeclare package Medium = Medium,
    floors(
      each sou(T_start=275.15),
      each eas(T_start=275.15),
      each nor(T_start=275.15),
      each wes(T_start=275.15),
      each cor(T_start=275.15)))
    "One floor of the office building";

  final parameter Modelica.SIunits.MassFlowRate mOut_flow[4] = 1.2*0.3/3600*{
      flo.floors[1].VRooSou,
      flo.floors[1].VRooEas,
      flo.floors[1].VRooNor,
      flo.floors[1].VRooWes}
    "Outside air infiltration for each exterior room";

  // Currently all floors have the same layout, so the infiltration
  // as determined by the equation above is the same for all floors

  Fluid.Sources.MassFlowSource_WeatherData bou[4](
    redeclare each package Medium = Medium,
    m_flow=mOut_flow,
    each nPorts=floCou)
    "Infiltration, used to avoid that the absolute humidity is continuously increasing";

  Fluid.Sources.Outside out(
    redeclare package Medium = Medium,
    nPorts=floCou)
    "Outside condition";

  Fluid.FixedResistances.PressureDrop res[floCou](
    redeclare each package Medium = Medium,
    each m_flow_nominal=sum(mOut_flow),
    each dp_nominal=10,
    each linearized=true) "Small flow resistance for inlet";
  Fluid.FixedResistances.PressureDrop res1[floCou, 4](
    redeclare each package Medium = Medium,
    each m_flow_nominal=sum(mOut_flow),
    each dp_nominal=10,
    each linearized=true) "Small flow resistance for inlet";

equation
  connect(weaBus, weaDat.weaBus);
  connect(weaBus, flo.weaBus);
  connect(weaBus, out.weaBus);
  connect(weaBus, bou[1].weaBus);
  connect(weaBus, bou[2].weaBus);
  connect(weaBus, bou[3].weaBus);
  connect(weaBus, bou[4].weaBus);

  connect(out.ports[:], res[:].port_a);

  for fl in 1:floCou loop
    connect(bou[:].ports[fl], res1[fl,:].port_a);
    connect(res[fl].port_b, flo.portsCor[fl,1]);
    connect(res1[fl,1].port_b, flo.portsSou[fl,1]);
    connect(res1[fl,2].port_b, flo.portsEas[fl,1]);
    connect(res1[fl,3].port_b, flo.portsNor[fl,1]);
    connect(res1[fl,4].port_b, flo.portsWes[fl,1]);
  end for;

    annotation (
experiment(
      StopTime=172800,
      Tolerance=1e-06),
Documentation(info="<html>
</html>", revisions="<html>
<ul>
<li>
March 25, 2021, by Baptiste Ravache:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(file="Resources/Scripts/Dymola/ThermalZones/EnergyPlus/Examples/ScalableBenchmark/Large2FloorsNoHVAC.mos"
        "Simulate and plot"));
end Large2FloorsNoHVAC;
