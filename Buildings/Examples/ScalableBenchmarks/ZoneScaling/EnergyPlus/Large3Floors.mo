within Buildings.Examples.ScalableBenchmarks.ZoneScaling.EnergyPlus;
model Large3Floors
  "Open loop model of a large building with 3 floors and 15 zones"
  extends Large2Floors(      final floCou=3);

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
end Large3Floors;
