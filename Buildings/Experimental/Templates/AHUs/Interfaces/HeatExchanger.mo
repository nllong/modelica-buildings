within Buildings.Experimental.Templates.AHUs.Interfaces;
model HeatExchanger
  extends Fluid.Interfaces.PartialFourPortInterface;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                                              Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end HeatExchanger;
