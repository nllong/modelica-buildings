within Buildings.Fluid.Boilers;
model BoilerPolynomial
  "Boiler with efficiency curve described by a polynomial of the control signal and/or temperature"
  extends Buildings.Fluid.Boilers.BaseClasses.PartialBoiler;
  parameter Buildings.Fluid.Types.EfficiencyCurves
    effCur=Buildings.Fluid.Types.EfficiencyCurves.Constant
    "Curve used to compute the efficiency";
  parameter Real a[:] = {0.9} "Coefficients for efficiency curve";

  parameter Real aQuaLin[6] = if size(a, 1) == 6 then a else fill(0, 6)
  "Auxiliary variable for efficiency curve 
  because quadraticLinear requires exactly 6 elements";

initial equation
  if  effCur == Buildings.Fluid.Types.EfficiencyCurves.QuadraticLinear then
    assert(size(a, 1) == 6,
    "The boiler has the efficiency curve set to 
    'Buildings.Fluid.Types.EfficiencyCurves.QuadraticLinear',
    and hence the parameter 'a' must have exactly 6 elements.
    The number of elements is " + String(size(a, 1)) + ".");
  end if;

  if effCur ==Buildings.Fluid.Types.EfficiencyCurves.Constant then
    eta_nominal = a[1];
  elseif effCur ==Buildings.Fluid.Types.EfficiencyCurves.Polynomial then
    eta_nominal = Buildings.Utilities.Math.Functions.polynomial(
                                                          a=a, x=1);
  elseif effCur ==Buildings.Fluid.Types.EfficiencyCurves.QuadraticLinear then
    // For this efficiency curve, a must have 6 elements.
    eta_nominal = Buildings.Utilities.Math.Functions.quadraticLinear(
                                                  a=aQuaLin, x1=1, x2=T_nominal);
  else
     eta_nominal = 999;
  end if;

equation
  eta=
    if effCur ==Buildings.Fluid.Types.EfficiencyCurves.Constant then
      a[1]
    elseif effCur ==Buildings.Fluid.Types.EfficiencyCurves.Polynomial then
      Buildings.Utilities.Math.Functions.polynomial(a=a, x=y)
    elseif effCur ==Buildings.Fluid.Types.EfficiencyCurves.QuadraticLinear then
      Buildings.Utilities.Math.Functions.quadraticLinear(a=aQuaLin, x1=y, x2=T)
    else
      0;
  annotation (Documentation(info="<html>
<p>
This is a model of a boiler whose efficiency is described by a polynomial. 
</p>
<p>
The parameter <span style=\"font-family: monospace;\">effCur</span> 
determines what polynomial is used to compute the efficiency 
with the following selections:
</p>
<table summary=\"Efficiency selections\" 
cellspacing=\"0\" cellpadding=\"2\" border=\"1\"><tr><td>
<p align=\"center\">
<b>Parameter <span style=\"font-family: monospace;\">effCur</span></b>
</p>
</td>
<td>
<p align=\"center\"><b>Efficiency curve</b>
</p>
</td></tr>
<tr>
<td>
<p>
Buildings.Fluid.Types.EfficiencyCurves.Constant
</p>
</td>
<td>
<p>
<i>&eta; = a<sub>1</sub></i>
</p>
</td></tr>
<tr><td>
<p>
Buildings.Fluid.Types.EfficiencyCurves.Polynomial
</p>
</td>
<td>
<p>
<i>&eta; = a<sub>1</sub> + a<sub>2</sub> y + a<sub>3</sub> y<sup>2</sup> + ...</i>
</p>
</td></tr>
<tr><td>
<p>
Buildings.Fluid.Types.EfficiencyCurves.QuadraticLinear
</p>
</td><td>
<p>
<i>&eta; = a<sub>1</sub> + a<sub>2</sub> y + a<sub>3</sub> y<sup>2</sup> + 
(a<sub>4</sub> + a<sub>5</sub> y + a<sub>6</sub> y<sup>2</sup>) 
T </i>
</p>
</td></tr>
</table>
<p>
<br><br><br>where <i>T</i> is the boiler outlet temperature in Kelvin. 
For <span style=\"font-family: monospace;\">
effCur = Buildings.Fluid.Types.EfficiencyCurves.Polynomial</span>, 
an arbitrary number of polynomial coefficients can be specified. 
</p>
</html>
", revisions="<html>
<ul>
<li>
October 4, 2021, by Hongxiang Fu:<br/>
For the implementation of 
<a href=\"Modelica://Buildings.Fluid.Boilers.BoilerTable\">
<code>Buildings.Fluid.Boilers.BoilerTable</code></a>, 
moved most of the code to the base model 
<a href=\"Modelica://Buildings.Fluid.Boilers.BaseClasses.PartialBoiler\">
<code>Buildings.Fluid.Boilers.BaseClasses.PartialBoiler</code></a>. 
This is for 
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2651\">#2651</a>.
</li>
<li>
May 27, 2016, by Michael Wetter:<br/>
Corrected size of input argument to
<code>Buildings.Utilities.Math.Functions.quadraticLinear</code>
for JModelica compliance check.
</li>
<li>
May 30, 2014, by Michael Wetter:<br/>
Removed undesirable annotation <code>Evaluate=true</code>.
</li>
<li>
October 9, 2013 by Michael Wetter:<br/>
Removed conditional declaration of <code>mDry</code> as the use of a conditional
parameter in an instance declaration is not correct Modelica syntax.
</li>
<li>
December 14, 2012 by Michael Wetter:<br/>
Renamed protected parameters for consistency with the naming conventions.
</li>
<li>
December 22, 2011 by Michael Wetter:<br/>
Added computation of fuel usage and improved the documentation.
</li>
<li>
May 25, 2011 by Michael Wetter:<br/>
<ul>
<li>
Removed parameter <code>dT_nominal</code>, and require instead
the parameter <code>m_flow_nominal</code> to be set by the user.
This was needed to avoid a non-literal value for the nominal attribute
of the pressure drop model.
</li>
<li>
Changed assignment of parameters in model instantiation, and updated
model for the new base class that does not have a temperature sensor.
</li>
</ul>
</li>
<li>
January 29, 2009 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end BoilerPolynomial;
