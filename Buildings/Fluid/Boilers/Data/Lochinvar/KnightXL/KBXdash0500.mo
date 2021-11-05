within Buildings.Fluid.Boilers.Data.Lochinvar.KnightXL;
record KBXdash0500 "Specifications for Lochinvar Knight XL KBX-0500 boiler"
  extends Buildings.Fluid.Boilers.Data.Lochinvar.KnightXL.Curves(
    Q_flow_nominal = 142139.469,
    VWat = 0.018548518,
    dT_nominal =  11.111111,
    m_flow_nominal = 3.028329,
    dp_nominal = 41845.72);
  annotation (Documentation(info="<html>
Performance data for boiler model.
See the documentation 
<a href=\"modelica://Buildings.Fluid.Boilers.Data.Lochinvar\">
Buildings.Fluid.Boilers.Data.Lochinvar</a>.
</html>"));
end KBXdash0500;
