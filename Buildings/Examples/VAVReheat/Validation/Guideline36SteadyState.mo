within Buildings.Examples.VAVReheat.Validation;
model Guideline36SteadyState
  "Validation of detailed model that is at steady state with constant weather data"
  extends Buildings.Examples.VAVReheat.Guideline36(
      redeclare replaceable Buildings.Examples.VAVReheat.BaseClasses.Floor flo(
        final lat=lat,
        final sampleModel=sampleModel,
        gai(K=0*[0.4; 0.4; 0.2])),
      weaDat(
      pAtmSou=Buildings.BoundaryConditions.Types.DataSource.Parameter,
      ceiHeiSou=Buildings.BoundaryConditions.Types.DataSource.Parameter,
      totSkyCovSou=Buildings.BoundaryConditions.Types.DataSource.Parameter,
      opaSkyCovSou=Buildings.BoundaryConditions.Types.DataSource.Parameter,
      TDryBulSou=Buildings.BoundaryConditions.Types.DataSource.Parameter,
      TDewPoiSou=Buildings.BoundaryConditions.Types.DataSource.Parameter,
      TBlaSkySou=Buildings.BoundaryConditions.Types.DataSource.Parameter,
      TBlaSky=293.15,
      relHumSou=Buildings.BoundaryConditions.Types.DataSource.Parameter,
      winSpeSou=Buildings.BoundaryConditions.Types.DataSource.Parameter,
      winDirSou=Buildings.BoundaryConditions.Types.DataSource.Parameter,
      HInfHorSou=Buildings.BoundaryConditions.Types.DataSource.Parameter,
      HSou=Buildings.BoundaryConditions.Types.RadiationDataSource.Input_HGloHor_HDifHor),
      use_windPressure=false,
      sampleModel=false,
      vav(occSch(
        occupancy=3600*24*365*{1,2},
        period=2*3600*24*365)));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant solRad(k=0) "Solar radiation"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
equation
  connect(solRad.y, weaDat.HGloHor_in) annotation (Line(points={{-78,50},{-70,50},
          {-70,37},{-61,37}}, color={0,0,127}));
  connect(solRad.y, weaDat.HDifHor_in) annotation (Line(points={{-78,50},{-70,50},
          {-70,40.5},{-61,40.5}}, color={0,0,127}));
  annotation (
    experiment(
      StopTime=604800,
      Tolerance=1e-06),
      __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Examples/VAVReheat/Validation/Guideline36SteadyState.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model validates that the detailed model of multiple rooms and an HVAC system
starts at and remains at exactly <i>20</i>&deg;C room air temperature
if there is no solar radiation, constant outdoor conditions, no internal gains and
no HVAC operation.
</p>
</html>", revisions="<html>
<ul>
<li>
April 30, 2021, by Michael Wetter:<br/>
Reformulated replaceable class and introduced floor areas in base class
to avoid access of components that are not in the constraining type.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2471\">issue #2471</a>.
</li>
<li>
April 18, 2020, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Guideline36SteadyState;
