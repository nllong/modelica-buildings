within Buildings.Examples.ScalableBenchmarks.NoHVAC.MixedAir;
model Large3FloorsNoHVAC
  "Open loop model of a large building with 3 floors and 15 zones"
  extends Large2FloorsNoHVAC(final floCou=3);

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
__Dymola_Commands(file="Resources/Scripts/Dymola/ThermalZones/EnergyPlus/Examples/ScalableBenchmark/Large3FloorsNoHVAC.mos"
        "Simulate and plot"));
end Large3FloorsNoHVAC;
