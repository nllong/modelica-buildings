within Buildings.Examples.ScalableBenchmarks.ZoneScaling.MixedAir.BaseClasses;
model LargeOfficeFloor "Model of a floor of the building"
  extends Buildings.Air.Systems.MultiZone.VAVReheat.Examples.BaseClasses.Floor(
    final AFloCor = 2536.49,
    final AFloSou = 313.86,
    final AFloNor = 313.86,
    final AFloEas = 198.91,
    final AFloWes = 198.91);

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorSou
    "Heat port to air volume South"
    annotation (Placement(transformation(extent={{106,-46},{126,-26}}),
        iconTransformation(extent={{128,-36},{148,-16}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorEas
    "Heat port to air volume East"
    annotation (Placement(transformation(extent={{320,42},{340,62}}),
        iconTransformation(extent={{318,64},{338,84}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorNor
    "Heat port to air volume North"
    annotation (Placement(transformation(extent={{106,114},{126,134}}),
        iconTransformation(extent={{126,106},{146,126}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorWes
    "Heat port to air volume West"
    annotation (Placement(transformation(extent={{-40,56},{-20,76}}),
        iconTransformation(extent={{-36,64},{-16,84}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorCor
    "Heat port to air volume Core"
    annotation (Placement(transformation(extent={{106,36},{126,56}}),
        iconTransformation(extent={{130,38},{150,58}})));

equation
  connect(sou.heaPorAir, heaPorSou)
    annotation (Line(points={{163,-24},{140,-24},{140,-36},{116,-36}},
    color={191,0,0}));
  connect(eas.heaPorAir, heaPorEas)
    annotation (Line(points={{323,76},{330,76},{330,52}},
    color={191,0,0}));
  connect(nor.heaPorAir, heaPorNor)
    annotation (Line(points={{163,136},{116,136},{116,124}},
    color={191,0,0}));
  connect(wes.heaPorAir, heaPorWes)
    annotation (Line(points={{31,56},{-30,56},{-30,66}},
    color={191,0,0}));
  connect(cor.heaPorAir, heaPorCor)
    annotation (Line(points={{163,56},{116,56},{116,46}},
    color={191,0,0}));
  annotation (Documentation(revisions="<html>
<ul>
<li>
March 25, 2021, by Baptiste Ravache:<br/>
First implementation.
</li>
</ul>
</html>"));
end LargeOfficeFloor;
