within Buildings.Experimental.Templates.AHUs.Validation;
model CoolingCoilDXMultiStage
  extends NoEquipment(ahu(redeclare Coils.Data.CoolingDXMultiStage datCoiCoo(
          redeclare
          Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.DoubleSpeed.Lennox_KCA120S4
          datCoi), redeclare Coils.CoolingDXMultiStage coiCoo));

  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
equation
  connect(weaDat.weaBus, ahu.weaBus) annotation (Line(
      points={{-60,60},{0,60},{0,20}},
      color={255,204,51},
      thickness=0.5));
end CoolingCoilDXMultiStage;
