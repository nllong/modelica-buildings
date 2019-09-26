within Buildings.Experimental.Templates.Commercial.VAV.AHUs.Validation;
model OpenLoopControlBus "Open loop test for air handler unit"
  extends Modelica.Icons.Example;
  CoolingCoilHeatingCoilEconomizerNoReturnFanControlBus
                                              ahu
    annotation (Placement(transformation(extent={{-34,-42},{46,38}})));
  Fluid.Sources.Boundary_pT out(nPorts=3) "Outside conditions"
    annotation (Placement(transformation(extent={{-90,-12},{-70,8}})));
equation
  connect(out.ports[1], ahu.port_freAir) annotation (Line(points={{-70,0.666667},{-56,0.666667},{-56,6},{-34,6}},
                               color={0,127,255}));
  connect(out.ports[2], ahu.port_exhAir) annotation (Line(points={{-70,-2},{-56,-2},{-56,-10},{-34,-10}},
                                  color={0,127,255}));
end OpenLoopControlBus;
