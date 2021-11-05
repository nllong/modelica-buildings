within Buildings.Fluid.Boilers.Data.Lochinvar.Crest;
record FBdash3501 "Specifications for Lochinvar Crest FB-3501 boiler"
  extends Buildings.Fluid.Boilers.Data.Lochinvar.Crest.Curves(
    Q_flow_nominal = 985891.0795,
    VWat = 0.76465318,
    mDry = 1459.660247,
    dT_nominal = 11.111111,
    m_flow_nominal = 21.198306,
    dp_nominal = 29590.90);
  annotation (Documentation(info="<html>
Performance data for boiler model.
See the documentation 
<a href=\"modelica://Buildings.Fluid.Boilers.Data.Lochinvar\">
Buildings.Fluid.Boilers.Data.Lochinvar</a>.
</html>"));
end FBdash3501;
