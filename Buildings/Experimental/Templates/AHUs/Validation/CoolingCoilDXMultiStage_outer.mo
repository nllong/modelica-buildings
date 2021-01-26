within Buildings.Experimental.Templates.AHUs.Validation;
model CoolingCoilDXMultiStage_outer
  extends NoEquipment_outer(
                      ahu(redeclare Coils.Data.DXMultiStage datCoi(redeclare
          Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.DoubleSpeed.Lennox_KCA120S4
          datCoi), redeclare Coils.DXMultiStage coiCoo),
    bou(nPorts=4),
    bou1(nPorts=4));

  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Main.VAVSingleDuct_outer ahu1(redeclare Coils.Data.WaterBased datCoi(
        redeclare
        Buildings.Experimental.Templates.AHUs.Coils.HeatExchangers.Data.Discretized
        datHex(UA_nominal=500)), redeclare Coils.WaterBased_outer coiCoo(
        redeclare
        Buildings.Experimental.Templates.AHUs.Coils.HeatExchangers.Discretized
        coi))
    annotation (Placement(transformation(extent={{-20,-80},{20,-40}})));
  Fluid.Sources.Boundary_pT bou2(redeclare final package Medium = MediumCoo,
      nPorts=2)
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
equation
  connect(weaDat.weaBus, ahu.weaBus) annotation (Line(
      points={{-60,60},{0,60},{0,20}},
      color={255,204,51},
      thickness=0.5));
  connect(bou.ports[3], ahu1.port_Out) annotation (Line(points={{-60,0},{-48,0},
          {-48,-70},{-20,-70}}, color={0,127,255}));
  connect(ahu1.port_Sup, bou1.ports[3])
    annotation (Line(points={{20,-70},{60,-70},{60,0}}, color={0,127,255}));
  connect(ahu1.port_Exh, bou.ports[4]) annotation (Line(points={{-20,-50},{-44,
          -50},{-44,0},{-60,0}}, color={0,127,255}));
  connect(ahu1.port_Ret, bou1.ports[4]) annotation (Line(points={{20,-50},{56,
          -50},{56,0},{60,0}}, color={0,127,255}));
  connect(bou2.ports[1], ahu1.port_coiCooSup) annotation (Line(points={{-60,-78},
          {-32,-78},{-32,-88},{-4,-88},{-4,-80},{-2,-80}}, color={0,127,255}));
  connect(bou2.ports[2], ahu1.port_coiCooRet) annotation (Line(points={{-60,-82},
          {-40,-82},{-40,-92},{2,-92},{2,-80}}, color={0,127,255}));
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end CoolingCoilDXMultiStage_outer;
