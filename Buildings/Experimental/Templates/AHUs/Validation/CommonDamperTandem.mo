within Buildings.Experimental.Templates.AHUs.Validation;
model CommonDamperTandem
  extends NoEquipment(ahu(redeclare Economizers.Data.CommonDamperTandem datEco(
          mExh_flow_nominal=1), redeclare replaceable
        Economizers.CommonDamperTandem eco
        "Single common OA damper - Dampers actuated in tandem"));

  Templates_V0.BaseClasses.AhuBus ahuBus
    annotation (Placement(transformation(extent={{-40,40},{0,80}}),
      iconTransformation(extent={{-254,122},{-234,142}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one(k=1)
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
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
end CommonDamperTandem;
