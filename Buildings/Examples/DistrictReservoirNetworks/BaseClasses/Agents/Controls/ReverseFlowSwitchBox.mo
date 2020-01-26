within Buildings.Examples.DistrictReservoirNetworks.BaseClasses.Agents.Controls;
block ReverseFlowSwitchBox "Controller for the flow switch"
  extends Modelica.Blocks.Icons.Block;
  Modelica.Blocks.Interfaces.RealInput mSpaHea_flow(
    final unit="kg/s")
    "Mass flow rate for space heating"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput mDomHotWat_flow(
    final unit="kg/s")
    "Mass flow rate for domestic hot water"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput mFreCoo_flow(
    final unit="kg/s")
    "Mass flow rate for free cooling"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  Modelica.Blocks.Interfaces.RealOutput m_flow(
    final unit="kg/s") "Mass flow rate"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Math.Add mHea_flow "Mass flow rate for heating"
    annotation (Placement(transformation(extent={{-72,64},{-52,84}})));
  Modelica.Blocks.Logical.GreaterEqual heaDom
    "Output true if heating mass flow rate dominates"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Modelica.Blocks.Logical.Switch switchMode "Switch to select the mode"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Blocks.Sources.Constant heatingModeOn(final k=0) "Signal for heating mode"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));

  Modelica.Blocks.Math.Add mNet_flow(k1=-1) "Net mass flow rate"
    annotation (Placement(transformation(extent={{0,-84},{20,-64}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol(
    trueHoldDuration=5*60)
    "True/false hold to remove the risk of chattering"
    annotation (Placement(transformation(extent={{12,-10},{32,10}})));
equation
  connect(mHea_flow.y, heaDom.u1) annotation (Line(points={{-51,74},{-40,74},{-40,
          0},{-22,0}},color={0,0,127}));
  connect(heatingModeOn.y, switchMode.u1) annotation (Line(points={{21,40},{40,
          40},{40,8},{58,8}},     color={0,0,127}));
  connect(switchMode.y, m_flow)
    annotation (Line(points={{81,0},{110,0}}, color={0,0,127}));
  connect(mSpaHea_flow, mHea_flow.u1)
    annotation (Line(points={{-120,80},{-74,80}}, color={0,0,127}));
  connect(mDomHotWat_flow, mHea_flow.u2) annotation (Line(points={{-120,0},{-94,
          0},{-94,68},{-74,68}}, color={0,0,127}));
  connect(mFreCoo_flow, heaDom.u2) annotation (Line(points={{-120,-80},{-74,-80},
          {-74,-8},{-22,-8}},color={0,0,127}));
  connect(mFreCoo_flow, mNet_flow.u2)
    annotation (Line(points={{-120,-80},{-2,-80}}, color={0,0,127}));
  connect(mHea_flow.y, mNet_flow.u1) annotation (Line(points={{-51,74},{-40,74},
          {-40,-68},{-2,-68}}, color={0,0,127}));
  connect(mNet_flow.y, switchMode.u3) annotation (Line(points={{21,-74},{40,-74},
          {40,-8},{58,-8}}, color={0,0,127}));
  connect(heaDom.y, truFalHol.u)
    annotation (Line(points={{1,0},{11,0}}, color={255,0,255}));
  connect(truFalHol.y, switchMode.u2)
    annotation (Line(points={{33,0},{58,0}}, color={255,0,255}));
  annotation (Documentation(info="<html>
<p>
Controller for the mass flow rate for the switching box.
</p>
</html>", revisions="<html>
<ul>
<li>
January 23, 2020, by Michael Wetter:<br/>
Added <a href=\"modelica://Buildings.Controls.OBC.CDL.Logical.TrueFalseHold\">
Buildings.Controls.OBC.CDL.Logical.TrueFalseHold</a>
to avoid the risk of chattering.
</li>
<li>
January 12, 2020, by Michael Wetter:<br/>
Added documentation.
</li>
</ul>
</html>"));
end ReverseFlowSwitchBox;