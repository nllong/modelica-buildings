within Buildings.Fluid.Boilers.Data.Lochinvar.Crest;
record FBdash2501 "Specifications for Lochinvar Crest FB-2501 boiler"
  extends Buildings.Fluid.Boilers.Data.Lochinvar.Crest.Curves(
    Q_flow_nominal = 703370.568,
    VWat = 0.59430965,
    mDry = 1168.907537,
    dT_nominal = 11.111111,
    m_flow_nominal = 15.141647,
    dp_nominal = 25107.43);
  annotation (Documentation(info="<html>
<p>
Performance data for boiler model.
See the documentation 
<a href=\"modelica://Buildings.Fluid.Boilers.Data.Lochinvar\">
Buildings.Fluid.Boilers.Data.Lochinvar</a>.
</p>
</html>"));
end FBdash2501;
