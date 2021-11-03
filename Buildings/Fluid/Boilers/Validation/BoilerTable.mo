within Buildings.Fluid.Boilers.Validation;
model BoilerTable
  "Boilers with efficiency curves specified by look-up table"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water "Medium model";
  parameter Modelica.SIunits.Power Q_flow_nominal = 3000
    "Nominal power";
  parameter Modelica.SIunits.Temperature dT_nominal = 20
    "Nominal temperature difference";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=
    Q_flow_nominal/dT_nominal/4200
    "Nominal mass flow rate";
  parameter Modelica.SIunits.PressureDifference dp_nominal = 3000
    "Pressure drop at m_flow_nominal";
  parameter Buildings.Fluid.Boilers.Data.LochinvarCrest effCur
    "Record containing a table that describes the efficiency curves"
    annotation(choicesAllMatching=true);

  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    nPorts=3,
    p(displayUnit="Pa") = 300000,
    T=354.15) "Sink"
    annotation (Placement(transformation(extent={{82,-30},{62,-10}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    p=300000 + dp_nominal,
    use_T_in=true,
    nPorts=3) "Source"
    annotation (Placement(transformation(extent={{-32,-30},{-12,-10}})));
  Buildings.Fluid.Boilers.BoilerTable boi1(
    Q_flow_nominal=Q_flow_nominal,
    m_flow_nominal=m_flow_nominal,
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal=dp_nominal,
    fue=Buildings.Fluid.Data.Fuels.NaturalGasLowerHeatingValue(),
    from_dp=true,
    T_start=293.15,
    effCur=effCur,
    TIn_nominal=323.15) "Boiler 1 set at 5% firing rate"
    annotation (Placement(transformation(extent={{20,44},{40,64}})));
  Buildings.HeatTransfer.Sources.FixedTemperature
    TAmb1(T=288.15) "Ambient temperature in boiler room"
    annotation (Placement(transformation(extent={{0,72},{20,92}})));
  Buildings.Fluid.Boilers.BoilerTable boi2(
    Q_flow_nominal=Q_flow_nominal,
    m_flow_nominal=m_flow_nominal,
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal=dp_nominal,
    fue=Buildings.Fluid.Data.Fuels.NaturalGasLowerHeatingValue(),
    from_dp=true,
    T_start=293.15,
    effCur=effCur,
    TIn_nominal=323.15) "Boiler 2 set at 50% firing rate"
    annotation (Placement(transformation(extent={{20,-16},{40,4}})));
  Buildings.HeatTransfer.Sources.FixedTemperature
    TAmb2(T=288.15) "Ambient temperature in boiler room"
    annotation (Placement(transformation(extent={{0,12},{20,32}})));
  Buildings.Fluid.Boilers.BoilerTable boi3(
    Q_flow_nominal=Q_flow_nominal,
    m_flow_nominal=m_flow_nominal,
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal=dp_nominal,
    fue=Buildings.Fluid.Data.Fuels.NaturalGasLowerHeatingValue(),
    from_dp=true,
    T_start=293.15,
    effCur=effCur,
    TIn_nominal=323.15) "Boiler 3 set at 100% firing rate"
    annotation (Placement(transformation(extent={{20,-76},{40,-56}})));
  HeatTransfer.Sources.FixedTemperature
    TAmb3(T=288.15) "Ambient temperature in boiler room"
    annotation (Placement(transformation(extent={{0,-48},{20,-28}})));

  Modelica.Blocks.Sources.Constant y1(k=0.05)
    "Setting the firing rate at constant 5%"
    annotation (Placement(transformation(extent={{-90,52},{-70,72}})));
  Modelica.Blocks.Sources.Constant y2(k=0.5)
    "Setting the firing rate at constant 50%"
    annotation (Placement(transformation(extent={{-90,-8},{-70,12}})));
  Modelica.Blocks.Sources.Constant y3(k=1)
    "Setting the firing rate at constant 100%"
    annotation (Placement(transformation(extent={{-90,-68},{-70,-48}})));
  Modelica.Blocks.Sources.Ramp TIn(
    height=effCur.effCur[1,end]-effCur.effCur[1,2],
    duration=3600,
    offset=effCur.effCur[1,2])
    "Ramps the T_inlet from the first to the last temperature provided by the efficiency curve table"
    annotation (Placement(transformation(extent={{-62,-26},{-42,-6}})));
equation
  connect(TAmb1.port, boi1.heatPort) annotation (Line(
      points={{20,82},{30,82},{30,61.2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TAmb2.port, boi2.heatPort) annotation (Line(
      points={{20,22},{30,22},{30,1.2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(boi2.port_b, sin.ports[2]) annotation (Line(
      points={{40,-6},{52,-6},{52,-20},{62,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(boi1.port_b, sin.ports[1]) annotation (Line(
      points={{40,54},{52,54},{52,-17.3333},{62,-17.3333}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TAmb3.port, boi3.heatPort)
    annotation (Line(points={{20,-38},{30,-38},{30,-58.8}}, color={191,0,0}));
  connect(boi3.port_b, sin.ports[3]) annotation (Line(points={{40,-66},{52,-66},
          {52,-22.6667},{62,-22.6667}}, color={0,127,255}));
  connect(boi1.port_a, sou.ports[1]) annotation (Line(points={{20,54},{-6,54},{
          -6,-17.3333},{-12,-17.3333}},
                              color={0,127,255}));
  connect(boi3.port_a, sou.ports[2]) annotation (Line(points={{20,-66},{-6,-66},
          {-6,-20},{-12,-20}},           color={0,127,255}));
  connect(boi2.port_a, sou.ports[3]) annotation (Line(points={{20,-6},{-6,-6},{
          -6,-22.6667},{-12,-22.6667}},
                             color={0,127,255}));
  connect(y1.y, boi1.y) annotation (Line(points={{-69,62},{18,62}},
                color={0,0,127}));
  connect(y2.y, boi2.y) annotation (Line(points={{-69,2},{18,2}},
        color={0,0,127}));
  connect(y3.y, boi3.y) annotation (Line(points={{-69,-58},{18,-58}},
                    color={0,0,127}));
  connect(TIn.y, sou.T_in)
    annotation (Line(points={{-41,-16},{-34,-16}}, color={0,0,127}));
  annotation (__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Boilers/Validation/BoilerTable.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=3600),
    Documentation(info="<html>
<p>    
This simple model displays the efficiency curves supplied to
<a href=\"Buildings.Fluid.Boilers.BoilerTable\">
Buildings.Fluid.Boilers.BoilerTable</a>
at firing rates of 5%, 50%, and 100%.
</p>
</html>", revisions="<html>
<ul>
<li>
October 13, 2021, by Hongxiang Fu:<br/>
First implementation. This is for 
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2651\">#2651</a>.
</li>
</ul>
</html>"));
end BoilerTable;
