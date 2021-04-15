within Buildings.Examples.ScalableBenchmarks.ZoneScaling.EnergyPlus;
model Large2Floors
  "Open loop model of a large building with 2 floors and 10 zones"
  extends Modelica.Icons.Example;

  replaceable package Medium = Buildings.Media.Air "Medium for air";
  parameter Integer floCou = 2 "Number of floors";

  parameter String weaName = Modelica.Utilities.Files.loadResource(
    "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    "Name of the weather file";

  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=weaName,
    computeWetBulbTemperature=false)
    "Weather data reader"
  annotation (Placement(transformation(extent={{-92,-14},{-72,6}})));

  replaceable BaseClasses.MultiFloors flo(
    floCou=floCou,
    redeclare package Medium = Medium,
    floors(
      each sou(T_start=275.15),
      each eas(T_start=275.15),
      each nor(T_start=275.15),
      each wes(T_start=275.15),
      each cor(T_start=275.15))) "One floor of the office building"
    annotation (Placement(transformation(extent={{-38,0},{82,80}})));

  // The ACHCor is perturbed below so that the floors evolve with different state trajectories
  Buildings.Examples.ScalableBenchmarks.ZoneScaling.BaseClasses.Guideline36VAV
    vav[floCou](
    ACHCor={6 * (0.95 + (0.1 * (i-1)/(floCou-1) * i)) for i in 1:floCou},
    VRooCor=flo.floors.VRooCor,
    VRooSou=flo.floors.VRooSou,
    VRooEas=flo.floors.VRooEas,
    VRooWes=flo.floors.VRooWes,
    VRooNor=flo.floors.VRooNor,
    AFloCor=flo.floors.AFloCor,
    AFloSou=flo.floors.AFloSou,
    AFloEas=flo.floors.AFloEas,
    AFloWes=flo.floors.AFloWes,
    AFloNor=flo.floors.AFloNor)                   "Guideline 36 controlled VAV"
    annotation (Placement(transformation(extent={{0,-100},{80,-20}})));

equation
  connect(weaDat.weaBus, flo.weaBus) annotation (Line(
    points={{-72,-4},{-58,-4},{-58,72},{44.2222,72}},
    color={255,204,51},
    thickness=0.5));
  for fl in 1:floCou loop
    connect(vav[fl].portsWes, flo.portsWes[fl, :]) annotation (Line(points={{68.4,
            -28},{30,-28},{30,41.6},{-8.22222,41.6}},            color={0,127,
            255}));
    connect(vav[fl].portsNor, flo.portsNor[fl, :]) annotation (Line(points={{68.4,
            -44},{44,-44},{44,55.2},{19.3333,55.2}},            color={0,127,
            255}));
    connect(vav[fl].portsEas, flo.portsEas[fl, :]) annotation (Line(points={{68.4,
            -60},{70,-60},{70,41.6}},         color={0,127,255}));
    connect(vav[fl].portsSou, flo.portsSou[fl, :]) annotation (Line(points={{68.4,
            -76},{44,-76},{44,27.2},{19.3333,27.2}},  color={0,127,255}));
    connect(vav[fl].portsCor, flo.portsCor[fl, :]) annotation (Line(points={{68.4,
            -92},{44,-92},{44,41.6},{19.3333,41.6}},            color={0,127,
            255}));
    connect(flo.TRooAir[fl, :], vav[fl].floTRooAir) annotation (Line(points={{84.2222,
            42},{84.2222,-6},{-12,-6},{-12,-60},{4,-60}},              color={0,
            0,127}));
    connect(weaDat.weaBus, vav[fl].weaBus) annotation (Line(
        points={{-72,-4},{-58,-4},{-58,-28.8},{8.8,-28.8}},
        color={255,204,51},
        thickness=0.5));
  end for;

    annotation (
experiment(
      StopTime=432000,
      Tolerance=1e-05,
      __Dymola_Algorithm="Cvode"),
Documentation(info="<html>
</html>", revisions="<html>
<ul>
<li>
March 25, 2021, by Baptiste Ravache:<br/>
First implementation.
</li>
</ul>
</html>"));
end Large2Floors;
