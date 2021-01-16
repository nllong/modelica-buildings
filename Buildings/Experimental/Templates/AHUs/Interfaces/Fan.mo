within Buildings.Experimental.Templates.AHUs.Interfaces;
partial model Fan
  extends Buildings.Fluid.Interfaces.PartialTwoPort(
    redeclare final package Medium=MediumAir);
  replaceable package MediumAir=Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Air medium";
  constant Types.Fan typ
    "Equipment type"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  constant Boolean have_y = false
    annotation (Evaluate=true, Dialog(group="Configuration"));
  constant Boolean have_yBoo = false
    annotation (Evaluate=true, Dialog(group="Configuration"));
  constant Boolean have_yInt = false
    annotation (Evaluate=true, Dialog(group="Configuration"));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Fan;
