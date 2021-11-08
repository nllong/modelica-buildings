within Buildings.Fluid.Boilers.Data.Lochinvar.KnightXL;
record KBXdash0650 "Specifications for Lochinvar Knight XL KBX-0650 boiler"
  extends Buildings.Fluid.Boilers.Data.Lochinvar.KnightXL.Curves(
    Q_flow_nominal = 184781.3096,
    VWat = 0.023469553,
    dT_nominal =  11.111111,
    m_flow_nominal = 3.911592,
    dp_nominal = 47823.68);
  annotation (Documentation(info="<html>
<p>
Performance data for boiler model.
See the documentation 
<a href=\"modelica://Buildings.Fluid.Boilers.Data.Lochinvar\">
Buildings.Fluid.Boilers.Data.Lochinvar</a>.
</p>
</html>"));
end KBXdash0650;
