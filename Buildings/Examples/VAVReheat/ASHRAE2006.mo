within Buildings.Examples.VAVReheat;
model ASHRAE2006
  "Variable air volume flow system with terminal reheat and five thermal zones"
  extends Modelica.Icons.Example;

  BaseClasses.ASHRAE2006VAV vav(
    VRooCor=flo.VRooCor,
    VRooSou=flo.VRooSou,
    VRooNor=flo.VRooNor,
    VRooEas=flo.VRooEas,
    VRooWes=flo.VRooWes,
    AFloCor=flo.cor.AFlo,
    AFloSou=flo.sou.AFlo,
    AFloNor=flo.nor.AFlo,
    AFloEas=flo.eas.AFlo,
    AFloWes=flo.wes.AFlo,
    heaCoi(show_T=true),
    cooCoi(show_T=true),
    cor(ratVFloHea=ratVFloHea),
    sou(ratVFloHea=ratVFloHea),
    eas(ratVFloHea=ratVFloHea),
    nor(ratVFloHea=ratVFloHea),
    wes(ratVFloHea=ratVFloHea))
    annotation (Placement(transformation(extent={{0,20},{60,80}})));

  replaceable Buildings.Examples.VAVReheat.BaseClasses.Floor flo(
    final lat=lat,
    final use_windPressure=use_windPressure,
    final sampleModel=sampleModel) constrainedby
    Buildings.Examples.VAVReheat.BaseClasses.PartialFloor(
      redeclare final package Medium = MediumA)
    "Model of a floor of the building that is served by this VAV system"
    annotation (Placement(transformation(extent={{-58,-78},{76,-2}})),    choicesAllMatching=true);

  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"),
      computeWetBulbTemperature=false)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
equation

  connect(flo.TRooAir, vav.TRooAir) annotation (Line(points={{78.913,-40},{88,
          -40},{88,90},{-14,90},{-14,50},{-3,50}},
                                              color={0,0,127}));
  connect(vav.portsWes, flo.portsWes) annotation (Line(points={{48,74},{4,74},{
          4,-40.5846},{-42.2696,-40.5846}},
                                color={0,127,255}));
  connect(vav.portsNor, flo.portsNor) annotation (Line(points={{48,62},{22,62},{22,
          -20.7077},{-6.14783,-20.7077}}, color={0,127,255}));
  connect(vav.portsEas, flo.portsEas) annotation (Line(points={{48,50},{56,50},
          {56,-40.5846},{60.2696,-40.5846}},
                                         color={0,127,255}));
  connect(vav.portsSou, flo.portsSou) annotation (Line(points={{48,38},{22,38},
          {22,-61.6308},{-6.14783,-61.6308}},
                                          color={0,127,255}));
  connect(vav.portsCor, flo.portsCor) annotation (Line(points={{48,26},{22,26},
          {22,-40.5846},{-6.14783,-40.5846}},
                                          color={0,127,255}));
  connect(weaDat.weaBus, vav.weaBus) annotation (Line(
      points={{-60,70},{-26,70},{-26,71},{9,71}},
      color={255,204,51},
      thickness=0.5));
  connect(weaDat.weaBus, flo.weaBus) annotation (Line(
      points={{-60,70},{-40,70},{-40,3.84615},{26.4783,3.84615}},
      color={255,204,51},
      thickness=0.5));
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
          "modelica://Buildings/Resources/Scripts/Dymola/Examples/VAVReheat/ASHRAE2006.mos"
        "Simulate and plot"),
    experiment(
      StopTime=172800,
      Tolerance=1e-06),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=false)));
end ASHRAE2006;
