within Buildings.Experimental.Templates.AHUs.Validation;
model CoolingCoilDiscretized
  extends NoEquipment(
    ahu(redeclare Coils.Data.CoolingWaterDiscretized datCoiCoo(UA_nominal=500),
        redeclare Coils.CoolingWater coiCoo(redeclare
          Buildings.Experimental.Templates.AHUs.Coils.HeatExchangers.WetCoilCounterFlow
          coi)));

  Templates_V0.BaseClasses.AhuBus ahuBus
    annotation (Placement(transformation(extent={{-40,40},{0,80}}),
      iconTransformation(extent={{-254,122},{-234,142}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one(k=1)
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Fluid.Sources.Boundary_pT bou2(
    redeclare final package Medium = MediumCoo,
      nPorts=2)
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
equation
  connect(one.y, ahuBus.ahuO.yEcoOut) annotation (Line(points={{-58,60},{-38,60},
          {-38,60.1},{-19.9,60.1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(ahuBus, ahu.ahuBus) annotation (Line(
      points={{-20,60},{-20,38},{-20,16},{-19.9,16}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(bou2.ports[1], ahu.port_coiCooSup)
    annotation (Line(points={{-40,-48},{-2,-48},{-2,-20}}, color={0,127,255}));
  connect(bou2.ports[2], ahu.port_coiCooRet)
    annotation (Line(points={{-40,-52},{2,-52},{2,-20}}, color={0,127,255}));
end CoolingCoilDiscretized;
