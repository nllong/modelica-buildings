within Buildings.Experimental.Templates.AHUs.Validation;
model CommonDamperTandemBinding
  extends NoEquipment(ahu(datEco=datEco,
                                redeclare replaceable
        Economizers.CommonDamperTandem eco
        "Single common OA damper - Dampers actuated in tandem"));

  parameter Economizers.Data.CommonDamperTandem datEco(mExh_flow_nominal=2)
    annotation (Placement(transformation(extent={{-10,46},{10,66}})));
  annotation (Diagram(graphics={Text(
          extent={{-40,36},{92,26}},
          lineColor={238,46,47},
          horizontalAlignment=TextAlignment.Left,
          textString="Incorrect with no redeclaration of record type.
See branch issue1374_redeclareRecord for correct syntax.")}));
end CommonDamperTandemBinding;
