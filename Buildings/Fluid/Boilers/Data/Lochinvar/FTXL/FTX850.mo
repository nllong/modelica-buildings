within Buildings.Fluid.Boilers.Data.Lochinvar.FTXL;
record FTX850 "Specifications for Lochinvar FTXL FTX850 boiler"
  extends Buildings.Fluid.Boilers.Data.Lochinvar.FTXL.Curves(
    Q_flow_nominal=241637.0972,
    VWat=0.060566589,
    mDry=273.9697915,
    dT_nominal=11.111111,
    m_flow_nominal=5.236486,
    dp_nominal=17037.19);
  annotation (Documentation(info="<html>
Performance data for boiler model.
See the documentation 
<a href=\"modelica://Buildings.Fluid.Boilers.Data.Lochinvar\">
Buildings.Fluid.Boilers.Data.Lochinvar</a>.
</html>"));
end FTX850;
