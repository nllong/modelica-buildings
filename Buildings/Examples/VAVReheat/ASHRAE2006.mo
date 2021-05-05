within Buildings.Examples.VAVReheat;
model ASHRAE2006
  "Variable air volume flow system with terminal reheat and five thermal zones"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Air "Medium model for air";

  parameter Boolean use_windPressure=true "Set to true to enable wind pressure";
  parameter Boolean sampleModel=true
  "Set to true to time-sample the model, which can give shorter simulation time if there is already time sampling in the system model"
  annotation (Evaluate=true, Dialog(tab=
  "Experimental (may be changed in future releases)"));
  parameter Modelica.SIunits.Angle lat=41.98*3.14159/180 "Latitude";

  BaseClasses.MultiZoneVAV.ASHRAE2006VAV vav(
    numZon=5,
    VRoo={flo.VRooCor,flo.VRooSou,flo.VRooEas,flo.VRooNor,flo.VRooWes},
    AFlo={flo.cor.AFlo,flo.sou.AFlo,flo.eas.AFlo,flo.nor.AFlo,flo.wes.AFlo},
    ACH={6,6,9,6,7})
    annotation (Placement(transformation(extent={{-20,20},{60,100}})));

  replaceable Buildings.Examples.VAVReheat.BaseClasses.Floor flo(
    final lat=lat,
    final use_windPressure=use_windPressure,
    final sampleModel=sampleModel) constrainedby
    Buildings.Examples.VAVReheat.BaseClasses.PartialFloor(redeclare final
      package Medium = Medium)
    "Model of a floor of the building that is served by this VAV system"
    annotation (Placement(transformation(extent={{-78,-78},{58,-2}})),
      choicesAllMatching=true);

  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"),
      computeWetBulbTemperature=false)
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
equation

  connect(flo.TRooAir, vav.TRooAir) annotation (Line(points={{60.9565,-40},{80,
          -40},{80,60},{64,60}},              color={0,0,127}));
  connect(weaDat.weaBus, vav.weaBus) annotation (Line(
      points={{-40,50},{-30,50},{-30,88},{-8,88}},
      color={255,204,51},
      thickness=0.5));
  connect(weaDat.weaBus, flo.weaBus) annotation (Line(
      points={{-40,50},{-30,50},{-30,3.84615},{7.73913,3.84615}},
      color={255,204,51},
      thickness=0.5));
  connect(flo.portsCor, vav.portsZon[1, :]) annotation (Line(points={{-25.3739,
          -40.5846},{-25.3739,-40},{44,-40},{44,20.8}},
                                              color={0,127,255}));
  connect(flo.portsSou, vav.portsZon[2, :]) annotation (Line(points={{-25.3739,
          -61.6308},{-25.3739,-40},{44,-40},{44,20.8}},
                                              color={0,127,255}));
  connect(flo.portsEas, vav.portsZon[3, :]) annotation (Line(points={{42.0348,
          -40.5846},{42.0348,-40},{44,-40},{44,20.8}},
                                             color={0,127,255}));
  connect(flo.portsNor, vav.portsZon[4, :]) annotation (Line(points={{-25.3739,
          -20.7077},{-25.3739,-40},{44,-40},{44,20.8}},
                                              color={0,127,255}));
  connect(flo.portsWes, vav.portsZon[5, :]) annotation (Line(points={{-62.0348,
          -40.5846},{-26,-40.5846},{-26,-40},{44,-40},{44,20.8}},
                                                        color={0,127,255}));

  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This model consist of an HVAC system, a building envelope model and a model
for air flow through building leakage and through open doors.
</p>
<p>
The HVAC system is a variable air volume (VAV) flow system with economizer
and a heating and cooling coil in the air handler unit. There is also a
reheat coil and an air damper in each of the five zone inlet branches.
The figure below shows the schematic diagram of the HVAC system
</p>
<p>
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Examples/VAVReheat/vavSchematics.png\" border=\"1\"/>
</p>
<p>
See the model
<a href=\"modelica://Buildings.Examples.VAVReheat.BaseClasses.PartialOpenLoop\">
Buildings.Examples.VAVReheat.BaseClasses.PartialOpenLoop</a>
for a description of the HVAC system and the building envelope.
</p>
<p>
The control is an implementation of the control sequence
<i>VAV 2A2-21232</i> of the Sequences of Operation for
Common HVAC Systems (ASHRAE, 2006). In this control sequence, the
supply fan speed is modulated based on the duct static pressure.
The return fan controller tracks the supply fan air flow rate.
The duct static pressure set point is adjusted so that at least one
VAV damper is 90% open.
The heating coil valve, outside air damper, and cooling coil valve are
modulated in sequence to maintain the supply air temperature set point.
The economizer control provides the following functions:
freeze protection, minimum outside air requirement, and supply air cooling,
see
<a href=\"modelica://Buildings.Examples.VAVReheat.Controls.Economizer\">
Buildings.Examples.VAVReheat.Controls.Economizer</a>.
The controller of the terminal units tracks the room air temperature set point
based on a \"dual maximum with constant volume heating\" logic, see
<a href=\"modelica://Buildings.Examples.VAVReheat.Controls.RoomVAV\">
Buildings.Examples.VAVReheat.Controls.RoomVAV</a>.
</p>
<p>
There is also a finite state machine that transitions the mode of operation
of the HVAC system between the modes
<i>occupied</i>, <i>unoccupied off</i>, <i>unoccupied night set back</i>,
<i>unoccupied warm-up</i> and <i>unoccupied pre-cool</i>.
In the VAV model, all air flows are computed based on the
duct static pressure distribution and the performance curves of the fans.
Local loop control is implemented using proportional and proportional-integral
controllers, while the supervisory control is implemented
using a finite state machine.
</p>
<p>
A similar model but with a different control sequence can be found in
<a href=\"modelica://Buildings.Examples.VAVReheat.Guideline36\">
Buildings.Examples.VAVReheat.Guideline36</a>.
</p>
<h4>References</h4>
<p>
ASHRAE.
<i>Sequences of Operation for Common HVAC Systems</i>.
ASHRAE, Atlanta, GA, 2006.
</p>
</html>", revisions="<html>
<ul>
<li>
March 15, 2021, by David Blum:<br/>
Update documentation graphic to include relief damper.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2399\">#2399</a>.
</li>
<li>
October 27, 2020, by Antoine Gautier:<br/>
Refactored the supply air temperature control sequence.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2024\">#2024</a>.
</li>
<li>
July 10, 2020, by Antoine Gautier:<br/>
Changed design and control parameters for outdoor air flow.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2019\">#2019</a>.
</li>
<li>
April 20, 2020, by Jianjun Hu:<br/>
Exported actual VAV damper position as the measured input data for
defining duct static pressure setpoint.<br/>
This is
for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1873\">#1873</a>.
</li>
<li>
May 19, 2016, by Michael Wetter:<br/>
Changed chilled water supply temperature to <i>6&deg;C</i>.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/509\">#509</a>.
</li>
<li>
April 26, 2016, by Michael Wetter:<br/>
Changed controller for freeze protection as the old implementation closed
the outdoor air damper during summer.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/511\">#511</a>.
</li>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
September 24, 2015 by Michael Wetter:<br/>
Set default temperature for medium to avoid conflicting
start values for alias variables of the temperature
of the building and the ambient air.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/426\">issue 426</a>.
</li>
</ul>
</html>"),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Air/Systems/MultiZone/VAVReheat/Examples/ASHRAE2006.mos"
        "Simulate and plot"),
    experiment(
      StopTime=172800,
      Tolerance=1e-06),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=false)));
end ASHRAE2006;
