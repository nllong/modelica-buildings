within Buildings.Fluid.Boilers.Data.Lochinvar.Crest;
record FBdash6001 "Specifications for Lochinvar Crest FB-6001 boiler"
  extends Buildings.Fluid.Boilers.Data.Lochinvar.Crest.Curves(
    Q_flow_nominal = 1689847.79,
    VWat = 1.150765182,
    mDry = 2136.873655,
    dT_nominal = 11.111111,
    m_flow_nominal = 36.339953,
    dp_nominal = 51410.46);
  annotation (Documentation(info="<html>
Performance data for boiler model.
See the documentation 
<a href=\"modelica://Buildings.Fluid.Boilers.Data.Lochinvar\">
Buildings.Fluid.Boilers.Data.Lochinvar</a>
</html>"));
end FBdash6001;
