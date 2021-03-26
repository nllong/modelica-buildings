within Buildings.Examples.ScalableBenchmarks.NoHVAC;
package EnergyPlus
  "Package with scalable large office buildings modeled with EnergyPlus"
  extends Modelica.Icons.ExamplesPackage;

  model Large2FloorsNoHVAC
    "Open loop model of a large building with 2 floors and 10 zones"
    extends Modelica.Icons.Example;

    replaceable package Medium = Buildings.Media.Air "Medium for air";
    parameter Integer floCou = 2 "Number of floors";

    parameter String weaName = Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")
      "Name of the weather file";
    BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
      filNam=weaName,
      computeWetBulbTemperature=false)
      "Weather data reader";
    BoundaryConditions.WeatherData.Bus weaBus "Weather data bus";

    BaseClasses.MultiFloors flo(
      floCou=floCou,
      redeclare package Medium = Medium,
      floors(
        each sou(T_start=275.15),
        each eas(T_start=275.15),
        each nor(T_start=275.15),
        each wes(T_start=275.15),
        each cor(T_start=275.15))) "One floor of the office building";

    final parameter Modelica.SIunits.MassFlowRate mOut_flow[4] = 1.2*0.3/3600*{
        flo.floors[1].VRooSou,
        flo.floors[1].VRooEas,
        flo.floors[1].VRooNor,
        flo.floors[1].VRooWes}
      "Outside air infiltration for each exterior room";

    // Currently all floors have the same layout, so the infiltration
    // as determined by the equation above is the same for all floors

    Fluid.Sources.MassFlowSource_WeatherData bou[4](
      redeclare each package Medium = Medium,
      m_flow=mOut_flow,
      each nPorts=floCou)
      "Infiltration, used to avoid that the absolute humidity is continuously increasing";

    Fluid.Sources.Outside out(
      redeclare package Medium = Medium,
      nPorts=floCou)
      "Outside condition";

    Fluid.FixedResistances.PressureDrop res[floCou](
      redeclare each package Medium = Medium,
      each m_flow_nominal=sum(mOut_flow),
      each dp_nominal=10,
      each linearized=true) "Small flow resistance for inlet";
    Fluid.FixedResistances.PressureDrop res1[floCou, 4](
      redeclare each package Medium = Medium,
      each m_flow_nominal=sum(mOut_flow),
      each dp_nominal=10,
      each linearized=true) "Small flow resistance for inlet";

  equation
    connect(weaBus, weaDat.weaBus);
    connect(weaBus, flo.weaBus);
    connect(weaBus, out.weaBus);
    connect(weaBus, bou[1].weaBus);
    connect(weaBus, bou[2].weaBus);
    connect(weaBus, bou[3].weaBus);
    connect(weaBus, bou[4].weaBus);

    connect(out.ports[:], res[:].port_a);

    for fl in 1:floCou loop
      connect(bou[:].ports[fl], res1[fl,:].port_a);
      connect(res[fl].port_b, flo.portsCor[fl,1]);
      connect(res1[fl,1].port_b, flo.portsSou[fl,1]);
      connect(res1[fl,2].port_b, flo.portsEas[fl,1]);
      connect(res1[fl,3].port_b, flo.portsNor[fl,1]);
      connect(res1[fl,4].port_b, flo.portsWes[fl,1]);
    end for;

      annotation (
  experiment(
        StopTime=172800,
        Tolerance=1e-06),
  Documentation(info="<html>
</html>",   revisions="<html>
<ul>
<li>
March 25, 2021, by Baptiste Ravache:<br/>
First implementation.
</li>
</ul>
</html>"),
      __Dymola_Commands(file="Resources/Scripts/Dymola/ThermalZones/EnergyPlus/Examples/ScalableBenchmark/Large2FloorsNoHVAC.mos"
          "Simulate and plot"));
  end Large2FloorsNoHVAC;

  model Large3FloorsNoHVAC
    "Open loop model of a large building with 3 floors and 15 zones"
    extends Large2FloorsNoHVAC(final floCou=3);

      annotation (
  experiment(
        StopTime=172800,
        Tolerance=1e-06),
  Documentation(info="<html>
</html>",   revisions="<html>
<ul>
<li>
March 25, 2021, by Baptiste Ravache:<br/>
First implementation.
</li>
</ul>
</html>"),
  __Dymola_Commands(file="Resources/Scripts/Dymola/ThermalZones/EnergyPlus/Examples/ScalableBenchmark/Large3FloorsNoHVAC.mos"
          "Simulate and plot"));
  end Large3FloorsNoHVAC;

  model Large4FloorsNoHVAC
    "Open loop model of a large building with 4 floors and 15 zones"
    extends Large2FloorsNoHVAC(final floCou=4);

      annotation (
  experiment(
        StopTime=31536000,
        Tolerance=1e-06,
        __Dymola_Algorithm="Radau"),
  Documentation(info="<html>
</html>",   revisions="<html>
<ul>
<li>
March 25, 2021, by Baptiste Ravache:<br/>
First implementation.
</li>
</ul>
</html>"),
  __Dymola_Commands(file="Resources/Scripts/Dymola/ThermalZones/EnergyPlus/Examples/ScalableBenchmark/Large4FloorsNoHVAC.mos"
          "Simulate and plot"));
  end Large4FloorsNoHVAC;

  package BaseClasses "Package with base classes"
    extends Modelica.Icons.BasesPackage;

    model LargeOfficeFloor "Model of a single floor of a large office building"
      parameter Integer floId "Floor id";

      extends Buildings.Examples.VAVReheat.BaseClasses.PartialFloor(
          final VRooSou=859.98,
          final VRooEas=545.33,
          final VRooNor=859.42,
          final VRooWes=554.18,
          final VRooCor=6949.43,
          opeWesCor(wOpe=4),
          opeSouCor(wOpe=9),
          opeNorCor(wOpe=9),
          opeEasCor(wOpe=4),
          leaWes(s=18.46/27.69),
          leaSou(s=27.69/18.46),
          leaNor(s=27.69/18.46),
          leaEas(s=18.46/27.69));

      final parameter Modelica.SIunits.Area AFloCor=cor.AFlo "Floor area Core";
      final parameter Modelica.SIunits.Area AFloSou=sou.AFlo "Floor area South";
      final parameter Modelica.SIunits.Area AFloNor=nor.AFlo "Floor area North";
      final parameter Modelica.SIunits.Area AFloEas=eas.AFlo "Floor area East";
      final parameter Modelica.SIunits.Area AFloWes=wes.AFlo "Floor area West";
      final parameter Modelica.SIunits.Area AFlo=AFloCor+AFloSou+AFloNor+AFloEas+AFloWes "Total floor area";

      Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorSou
        "Heat port to air volume South"
        annotation (Placement(transformation(extent={{106,-46},{126,-26}}),
            iconTransformation(extent={{128,-36},{148,-16}})));
      Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorEas
        "Heat port to air volume East"
        annotation (Placement(transformation(extent={{320,42},{340,62}}),
            iconTransformation(extent={{318,64},{338,84}})));
      Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorNor
        "Heat port to air volume North"
        annotation (Placement(transformation(extent={{106,114},{126,134}}),
            iconTransformation(extent={{126,106},{146,126}})));
      Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorWes
        "Heat port to air volume West"
        annotation (Placement(transformation(extent={{-40,56},{-20,76}}),
            iconTransformation(extent={{-36,64},{-16,84}})));
      Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorCor
        "Heat port to air volume Core"
        annotation (Placement(transformation(extent={{106,36},{126,56}}),
            iconTransformation(extent={{130,38},{150,58}})));

      Modelica.SIunits.Temperature TAirCor = cor.TAir
        "Air temperature corridor";
      Modelica.SIunits.Temperature TAirSou = sou.TAir
        "Air temperature south zone";
      Modelica.SIunits.Temperature TAirNor = nor.TAir
        "Air temperature north zone";
      Modelica.SIunits.Temperature TAirEas = eas.TAir
        "Air temperature east zone";
      Modelica.SIunits.Temperature TAirWes = wes.TAir
        "Air temperature west zone";

      ThermalZones.EnergyPlus.ThermalZone sou(
        redeclare package Medium = Medium,
        nPorts=5,
        zoneName="Perimeter_fl" + String(floId) + "_ZN_1") "South zone"
        annotation (Placement(transformation(extent={{144,-44},{184,-4}})));
      ThermalZones.EnergyPlus.ThermalZone eas(
        redeclare package Medium = Medium,
        nPorts=5,
        zoneName="Perimeter_fl" + String(floId) + "_ZN_2") "East zone"
        annotation (Placement(transformation(extent={{300,68},{340,108}})));
      ThermalZones.EnergyPlus.ThermalZone nor(
        redeclare package Medium = Medium,
        nPorts=5,
        zoneName="Perimeter_fl" + String(floId) + "_ZN_3") "North zone"
        annotation (Placement(transformation(extent={{144,116},{184,156}})));
      ThermalZones.EnergyPlus.ThermalZone wes(
        redeclare package Medium = Medium,
        nPorts=5,
        zoneName="Perimeter_fl" + String(floId) + "_ZN_4") "West zone"
        annotation (Placement(transformation(extent={{12,58},{52,98}})));
      ThermalZones.EnergyPlus.ThermalZone cor(
        redeclare package Medium = Medium,
        nPorts=11,
        zoneName="Core_fl" + String(floId)) "Core zone"
        annotation (Placement(transformation(extent={{144,60},{184,100}})));

      ThermalZones.EnergyPlus.ThermalZone att(
        redeclare package Medium = Medium,
        zoneName="Plenum_fl" + String(floId),
        T_start=275.15) "Attic zone"
        annotation (Placement(transformation(extent={{300,-60},{340,-20}})));

    protected
      Buildings.Controls.OBC.CDL.Continuous.Sources.Constant qGai_flow[3](k={0, 0, 0})
        "Internal heat gain (computed already in EnergyPlus"
        annotation (Placement(transformation(extent={{-140,-40},{-120,-20}})));

    initial equation
    //  assert(abs(cor.V-VRooCor) < 0.01, "Volumes don't match. These had to be entered manually to avoid using a non-literal value.");
    //  assert(abs(sou.V-VRooSou) < 0.01, "Volumes don't match. These had to be entered manually to avoid using a non-literal value.");
    //  assert(abs(nor.V-VRooNor) < 0.01, "Volumes don't match. These had to be entered manually to avoid using a non-literal value.");
    //  assert(abs(eas.V-VRooEas) < 0.01, "Volumes don't match. These had to be entered manually to avoid using a non-literal value.");
    //  assert(abs(wes.V-VRooWes) < 0.01, "Volumes don't match. These had to be entered manually to avoid using a non-literal value.");
      assert(abs(opeWesCor.wOpe-4) < 0.01, "wOpe in west zone doesn't match");

    equation
      connect(sou.heaPorAir, temAirSou.port) annotation (Line(
          points={{164,-24},{224,-24},{224,100},{264,100},{264,350},{290,350}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(eas.heaPorAir, temAirEas.port) annotation (Line(
          points={{320,88},{286,88},{286,320},{292,320}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(nor.heaPorAir, temAirNor.port) annotation (Line(
          points={{164,136},{164,136},{164,290},{292,290}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(wes.heaPorAir, temAirWes.port) annotation (Line(
          points={{32,78},{70,78},{70,114},{186,114},{186,258},{292,258}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(cor.heaPorAir, temAirCor.port) annotation (Line(
          points={{164,80},{164,228},{294,228}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(sou.ports[1], portsSou[1]) annotation (Line(
          points={{160.8,-43.1},{164,-43.1},{164,-54},{86,-54},{86,-36},{80,-36}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(sou.ports[2], portsSou[2]) annotation (Line(
          points={{162.4,-43.1},{164,-43.1},{164,-54},{86,-54},{86,-36},{100,-36}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(eas.ports[1], portsEas[1]) annotation (Line(
          points={{316.8,68.9},{300,68.9},{300,36},{320,36}},
          color={0,127,255},
          smooth=Smooth.None,
          thickness=0.5));
      connect(eas.ports[2], portsEas[2]) annotation (Line(
          points={{318.4,68.9},{300,68.9},{300,36},{340,36}},
          color={0,127,255},
          smooth=Smooth.None,
          thickness=0.5));
      connect(nor.ports[1], portsNor[1]) annotation (Line(
          points={{160.8,116.9},{164,116.9},{164,106},{88,106},{88,124},{80,124}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(nor.ports[2], portsNor[2]) annotation (Line(
          points={{162.4,116.9},{164,116.9},{164,106},{88,106},{88,124},{100,124}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(wes.ports[1], portsWes[1]) annotation (Line(
          points={{28.8,58.9},{30,58.9},{30,44},{-40,44}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(wes.ports[2], portsWes[2]) annotation (Line(
          points={{30.4,58.9},{-2,58.9},{-2,44},{-20,44}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(cor.ports[1], portsCor[1]) annotation (Line(
          points={{160.364,60.9},{164,60.9},{164,26},{90,26},{90,46},{80,46}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(cor.ports[2], portsCor[2]) annotation (Line(
          points={{161.091,60.9},{164,60.9},{164,26},{90,26},{90,46},{100,46}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(leaSou.port_b, sou.ports[3]) annotation (Line(
          points={{-22,400},{-2,400},{-2,-72},{134,-72},{134,-54},{164,-54},{164,-43.1}},
          color={0,127,255},
          smooth=Smooth.None,
          thickness=0.5));
      connect(leaEas.port_b, eas.ports[3]) annotation (Line(
          points={{-22,360},{246,360},{246,68.9},{320,68.9}},
          color={0,127,255},
          smooth=Smooth.None,
          thickness=0.5));
      connect(leaNor.port_b, nor.ports[3]) annotation (Line(
          points={{-20,320},{138,320},{138,116.9},{164,116.9}},
          color={0,127,255},
          smooth=Smooth.None,
          thickness=0.5));
      connect(leaWes.port_b, wes.ports[3]) annotation (Line(
          points={{-20,280},{2,280},{2,58.9},{32,58.9}},
          color={0,127,255},
          smooth=Smooth.None,
          thickness=0.5));
      connect(opeSouCor.port_b1, cor.ports[3]) annotation (Line(
          points={{104,16},{164,16},{164,34},{161.818,34},{161.818,60.9}},
          color={0,127,255},
          smooth=Smooth.None,
          thickness=0.5));
      connect(opeSouCor.port_a2, cor.ports[4]) annotation (Line(
          points={{104,4},{164,4},{164,60.9},{162.545,60.9}},
          color={0,127,255},
          smooth=Smooth.None,
          thickness=0.5));
      connect(opeSouCor.port_a1, sou.ports[4]) annotation (Line(
          points={{84,16},{74,16},{74,-20},{134,-20},{134,-54},{162,-54},{162,-46},{
              164,-46},{164,-43.1},{165.6,-43.1}},
          color={0,127,255},
          smooth=Smooth.None,
          thickness=0.5));
      connect(opeSouCor.port_b2, sou.ports[5]) annotation (Line(
          points={{84,4},{74,4},{74,-20},{134,-20},{134,-54},{164,-54},{164,-43.1},{
              167.2,-43.1}},
          color={0,127,255},
          smooth=Smooth.None,
          thickness=0.5));
      connect(opeEasCor.port_b1, eas.ports[4]) annotation (Line(
          points={{270,54},{290,54},{290,68.9},{321.6,68.9}},
          color={0,127,255},
          smooth=Smooth.None,
          thickness=0.5));
      connect(opeEasCor.port_a2, eas.ports[5]) annotation (Line(
          points={{270,42},{290,42},{290,68.9},{323.2,68.9}},
          color={0,127,255},
          smooth=Smooth.None,
          thickness=0.5));
      connect(opeEasCor.port_a1, cor.ports[5]) annotation (Line(
          points={{250,54},{190,54},{190,34},{142,34},{142,60.9},{163.273,60.9}},
          color={0,127,255},
          smooth=Smooth.None,
          thickness=0.5));
      connect(opeEasCor.port_b2, cor.ports[6]) annotation (Line(
          points={{250,42},{190,42},{190,34},{142,34},{142,60.9},{164,60.9}},
          color={0,127,255},
          smooth=Smooth.None,
          thickness=0.5));
      connect(opeNorCor.port_b1, nor.ports[4]) annotation (Line(
          points={{100,90},{108,90},{108,106},{164,106},{164,116.9},{165.6,116.9}},
          color={0,127,255},
          smooth=Smooth.None,
          thickness=0.5));
      connect(opeNorCor.port_a2, nor.ports[5]) annotation (Line(
          points={{100,78},{108,78},{108,106},{164,106},{164,116.9},{167.2,116.9}},
          color={0,127,255},
          smooth=Smooth.None,
          thickness=0.5));
      connect(opeNorCor.port_a1, cor.ports[7]) annotation (Line(
          points={{80,90},{76,90},{76,60},{142,60},{142,60.9},{164.727,60.9}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(opeNorCor.port_b2, cor.ports[8]) annotation (Line(
          points={{80,78},{76,78},{76,60},{142,60},{142,60.9},{165.455,60.9}},
          color={0,127,255},
          smooth=Smooth.None,
          thickness=0.5));
      connect(opeWesCor.port_b1, cor.ports[9]) annotation (Line(
          points={{40,-4},{56,-4},{56,26},{164,26},{164,36},{166.182,36},{
              166.182,60.9}},
          color={0,127,255},
          smooth=Smooth.None,
          thickness=0.5));
      connect(opeWesCor.port_a2, cor.ports[10]) annotation (Line(
          points={{40,-16},{56,-16},{56,26},{164,26},{164,60.9},{166.909,60.9}},
          color={0,127,255},
          smooth=Smooth.None,
          thickness=0.5));
      connect(opeWesCor.port_a1, wes.ports[4]) annotation (Line(
          points={{20,-4},{14,-4},{14,44},{30,44},{30,58.9},{33.6,58.9}},
          color={0,127,255},
          smooth=Smooth.None,
          thickness=0.5));
      connect(opeWesCor.port_b2, wes.ports[5]) annotation (Line(
          points={{20,-16},{14,-16},{14,44},{30,44},{30,58.9},{35.2,58.9}},
          color={0,127,255},
          smooth=Smooth.None,
          thickness=0.5));
      connect(cor.ports[11], senRelPre.port_a) annotation (Line(
          points={{167.636,60.9},{164,60.9},{164,24},{128,24},{128,250},{60,250}},
          color={0,127,255},
          smooth=Smooth.None,
          thickness=0.5));
      connect(sou.qGai_flow, qGai_flow.y) annotation (Line(points={{142,-14},{64,
              -14},{64,-30},{-118,-30}}, color={0,0,127}));
      connect(wes.qGai_flow, qGai_flow.y) annotation (Line(points={{10,88},{-60,88},
              {-60,-30},{-118,-30}}, color={0,0,127}));
      connect(eas.qGai_flow, qGai_flow.y) annotation (Line(points={{298,98},{200,98},
              {200,110},{-60,110},{-60,-30},{-118,-30}}, color={0,0,127}));
      connect(cor.qGai_flow, qGai_flow.y) annotation (Line(points={{142,90},{130,90},
              {130,110},{-60,110},{-60,-30},{-118,-30}}, color={0,0,127}));
      connect(nor.qGai_flow, qGai_flow.y) annotation (Line(points={{142,146},{-60,
              146},{-60,-30},{-118,-30}}, color={0,0,127}));
      connect(att.qGai_flow, qGai_flow.y) annotation (Line(points={{298,-30},{240,
              -30},{240,-80},{-60,-80},{-60,-30},{-118,-30}}, color={0,0,127}));
      connect(sou.heaPorAir, heaPorSou) annotation (Line(points={{164,-24},{140,-24},
              {140,-36},{116,-36}}, color={191,0,0}));
      connect(eas.heaPorAir, heaPorEas)
        annotation (Line(points={{320,88},{330,88},{330,52}}, color={191,0,0}));
      connect(nor.heaPorAir, heaPorNor)
        annotation (Line(points={{164,136},{116,136},{116,124}}, color={191,0,0}));
      connect(wes.heaPorAir, heaPorWes)
        annotation (Line(points={{32,78},{-30,78},{-30,66}}, color={191,0,0}));
      connect(cor.heaPorAir, heaPorCor)
        annotation (Line(points={{164,80},{116,80},{116,46}}, color={191,0,0}));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=true,
            extent={{-160,-100},{380,500}},
            initialScale=0.1)),     Icon(coordinateSystem(
              preserveAspectRatio=true, extent={{-80,-80},{380,180}}),   graphics={
            Rectangle(
              extent={{-80,-80},{380,180}},
              lineColor={95,95,95},
              fillColor={95,95,95},
              fillPattern=FillPattern.Solid),
            Rectangle(
              extent={{-60,160},{360,-60}},
              pattern=LinePattern.None,
              lineColor={117,148,176},
              fillColor={170,213,255},
              fillPattern=FillPattern.Sphere),
            Rectangle(
              extent={{0,-80},{294,-60}},
              lineColor={95,95,95},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
            Rectangle(
              extent={{0,-74},{294,-66}},
              lineColor={95,95,95},
              fillColor={170,213,255},
              fillPattern=FillPattern.Solid),
            Rectangle(
              extent={{8,8},{294,100}},
              lineColor={95,95,95},
              fillColor={95,95,95},
              fillPattern=FillPattern.Solid),
            Rectangle(
              extent={{20,88},{280,22}},
              pattern=LinePattern.None,
              lineColor={117,148,176},
              fillColor={170,213,255},
              fillPattern=FillPattern.Sphere),
            Polygon(
              points={{-56,170},{20,94},{12,88},{-62,162},{-56,170}},
              smooth=Smooth.None,
              fillColor={95,95,95},
              fillPattern=FillPattern.Solid,
              pattern=LinePattern.None),
            Polygon(
              points={{290,16},{366,-60},{358,-66},{284,8},{290,16}},
              smooth=Smooth.None,
              fillColor={95,95,95},
              fillPattern=FillPattern.Solid,
              pattern=LinePattern.None),
            Polygon(
              points={{284,96},{360,168},{368,162},{292,90},{284,96}},
              smooth=Smooth.None,
              fillColor={95,95,95},
              fillPattern=FillPattern.Solid,
              pattern=LinePattern.None),
            Rectangle(
              extent={{-80,120},{-60,-20}},
              lineColor={95,95,95},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
            Rectangle(
              extent={{-74,120},{-66,-20}},
              lineColor={95,95,95},
              fillColor={170,213,255},
              fillPattern=FillPattern.Solid),
            Polygon(
              points={{-64,-56},{18,22},{26,16},{-58,-64},{-64,-56}},
              smooth=Smooth.None,
              fillColor={95,95,95},
              fillPattern=FillPattern.Solid,
              pattern=LinePattern.None),
            Rectangle(
              extent={{360,122},{380,-18}},
              lineColor={95,95,95},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
            Rectangle(
              extent={{366,122},{374,-18}},
              lineColor={95,95,95},
              fillColor={170,213,255},
              fillPattern=FillPattern.Solid),
            Rectangle(
              extent={{2,170},{296,178}},
              lineColor={95,95,95},
              fillColor={170,213,255},
              fillPattern=FillPattern.Solid),
            Rectangle(
              extent={{2,160},{296,180}},
              lineColor={95,95,95},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
            Rectangle(
              extent={{2,166},{296,174}},
              lineColor={95,95,95},
              fillColor={170,213,255},
              fillPattern=FillPattern.Solid),
              Bitmap(extent={{192,-58},{342,-18}},
              fileName="modelica://Buildings/Resources/Images/ThermalZones/EnergyPlus/spawn_icon_darkbluetxmedres.png",
              visible=not usePrecompiledFMU)}),
        Documentation(info="<html>
</html>",
    revisions="<html>
<ul>
<li>
March 25, 2021, by Baptiste Ravache:<br/>
First implementation.
</li>
</ul>
</html>"));
    end LargeOfficeFloor;

    model MultiFloors

      parameter Integer floCou(start=2) "Number of floors";

      replaceable package Medium =  Buildings.Media.Air
        "Medium model for air";

      Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorSou[floCou]
        "Heat port to air volume South"
        annotation (Placement(transformation(extent={{106,-46},{126,-26}}),
            iconTransformation(extent={{128,-36},{148,-16}})));
      Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorEas[floCou]
        "Heat port to air volume East"
        annotation (Placement(transformation(extent={{320,42},{340,62}}),
            iconTransformation(extent={{318,64},{338,84}})));
      Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorNor[floCou]
        "Heat port to air volume North"
        annotation (Placement(transformation(extent={{106,114},{126,134}}),
            iconTransformation(extent={{126,106},{146,126}})));
      Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorWes[floCou]
        "Heat port to air volume West"
        annotation (Placement(transformation(extent={{-40,56},{-20,76}}),
            iconTransformation(extent={{-36,64},{-16,84}})));
      Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorCor[floCou]
        "Heat port to air volume Core"
        annotation (Placement(transformation(extent={{106,36},{126,56}}),
            iconTransformation(extent={{130,38},{150,58}})));

      Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b portsSou[floCou, 2](
          redeclare package Medium = Medium) "Fluid inlets and outlets"
        annotation (Placement(transformation(extent={{70,-44},{110,-28}}),
            iconTransformation(extent={{78,-32},{118,-16}})));

      Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b portsEas[floCou, 2](
          redeclare package Medium = Medium) "Fluid inlets and outlets"
        annotation (Placement(transformation(extent={{310,28},{350,44}}),
            iconTransformation(extent={{306,40},{346,56}})));

      Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b portsNor[floCou, 2](
          redeclare package Medium = Medium) "Fluid inlets and outlets"
        annotation (Placement(transformation(extent={{70,116},{110,132}}),
            iconTransformation(extent={{78,108},{118,124}})));

      Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b portsWes[floCou, 2](
          redeclare package Medium = Medium) "Fluid inlets and outlets"
        annotation (Placement(transformation(extent={{-46,40},{-6,56}}),
            iconTransformation(extent={{-46,40},{-6,56}})));

      Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b portsCor[floCou, 2](
          redeclare package Medium = Medium) "Fluid inlets and outlets"
        annotation (Placement(transformation(extent={{70,38},{110,54}}),
            iconTransformation(extent={{78,40},{118,56}})));

      Modelica.Blocks.Interfaces.RealOutput TRooAir[floCou, 5](
        each unit="K",
        each displayUnit="degC") "Room air temperatures"
        annotation (Placement(transformation(extent={{380,150},{400,170}}),
            iconTransformation(extent={{380,40},{400,60}})));

      Modelica.Blocks.Interfaces.RealOutput p_rel[floCou]
        "Relative pressure signal of building static pressure" annotation (
          Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=180,
            origin={-170,220}), iconTransformation(
            extent={{-10,-10},{10,10}},
            rotation=180,
            origin={-170,-30})));

      BoundaryConditions.WeatherData.Bus weaBus "Weather bus"
        annotation (Placement(transformation(extent={{200,190},{220,210}}),
            iconTransformation(extent={{200,190},{220,210}})));

      replaceable LargeOfficeFloor floors[floCou](
        floId=0:(floCou - 1),
        redeclare each package Medium = Medium) "Floors";

    protected
      parameter String idfName=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/ThermalZones/EnergyPlus/Validation/" +
        "ScalableLargeOffice/ScaledLargeOfficeNew2004_SanFrancisco_" + String(floCou) + "floors.idf")
        "Name of the IDF file";

      parameter String weaName = Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")
        "Name of the weather file";

      inner Buildings.ThermalZones.EnergyPlus.Building building(
        idfName=idfName,
        weaName=weaName,
        computeWetBulbTemperature=false)
        "Building-level declarations"
        annotation (Placement(transformation(extent={{140,458},{160,478}})));

    equation
      connect(heaPorSou[:], floors[:].heaPorSou);
      connect(heaPorEas[:], floors[:].heaPorEas);
      connect(heaPorNor[:], floors[:].heaPorNor);
      connect(heaPorWes[:], floors[:].heaPorWes);
      connect(heaPorCor[:], floors[:].heaPorCor);
      connect(p_rel[:], floors[:].p_rel);

      for flo in 1:floCou loop
        connect(portsSou[flo, :], floors[flo].portsSou[:]);
        connect(portsEas[flo, :], floors[flo].portsEas[:]);
        connect(portsNor[flo, :], floors[flo].portsNor[:]);
        connect(portsWes[flo, :], floors[flo].portsWes[:]);
        connect(portsCor[flo, :], floors[flo].portsCor[:]);
        connect(TRooAir[flo, :], floors[flo].TRooAir[:]);
        connect(weaBus, floors[flo].weaBus);
      end for;

      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-160,-160},
                {380,180}}), graphics={
                       Rectangle(
              extent={{-160,80},{300,-160}},
              lineColor={95,95,95},
              fillColor={215,215,215},
              fillPattern=FillPattern.Solid),
            Rectangle(
              extent={{-160,-160},{300,100}},
              lineColor={95,95,95},
              fillColor={95,95,95},
              fillPattern=FillPattern.Solid),
            Rectangle(
              extent={{-140,80},{280,-140}},
              pattern=LinePattern.None,
              lineColor={117,148,176},
              fillColor={170,213,255},
              fillPattern=FillPattern.Sphere),
            Rectangle(
              extent={{-80,-160},{214,-140}},
              lineColor={95,95,95},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
            Rectangle(
              extent={{-80,-154},{214,-146}},
              lineColor={95,95,95},
              fillColor={170,213,255},
              fillPattern=FillPattern.Solid),
            Polygon(
              points={{-136,90},{-60,14},{-68,8},{-142,82},{-136,90}},
              smooth=Smooth.None,
              fillColor={95,95,95},
              fillPattern=FillPattern.Solid,
              pattern=LinePattern.None),
            Polygon(
              points={{210,-64},{286,-140},{278,-146},{204,-72},{210,-64}},
              smooth=Smooth.None,
              fillColor={95,95,95},
              fillPattern=FillPattern.Solid,
              pattern=LinePattern.None),
            Rectangle(
              extent={{-160,40},{-140,-100}},
              lineColor={95,95,95},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
            Rectangle(
              extent={{-154,40},{-146,-100}},
              lineColor={95,95,95},
              fillColor={170,213,255},
              fillPattern=FillPattern.Solid),
            Polygon(
              points={{-144,-136},{-62,-58},{-54,-64},{-138,-144},{-144,-136}},
              smooth=Smooth.None,
              fillColor={95,95,95},
              fillPattern=FillPattern.Solid,
              pattern=LinePattern.None),
                       Rectangle(
              extent={{-120,120},{340,-120}},
              lineColor={95,95,95},
              fillColor={215,215,215},
              fillPattern=FillPattern.Solid),
            Rectangle(
              extent={{-120,-120},{340,140}},
              lineColor={95,95,95},
              fillColor={95,95,95},
              fillPattern=FillPattern.Solid),
            Rectangle(
              extent={{-100,120},{320,-100}},
              pattern=LinePattern.None,
              lineColor={117,148,176},
              fillColor={170,213,255},
              fillPattern=FillPattern.Sphere),
            Rectangle(
              extent={{-40,-120},{254,-100}},
              lineColor={95,95,95},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
            Rectangle(
              extent={{-40,-114},{254,-106}},
              lineColor={95,95,95},
              fillColor={170,213,255},
              fillPattern=FillPattern.Solid),
            Polygon(
              points={{-96,130},{-20,54},{-28,48},{-102,122},{-96,130}},
              smooth=Smooth.None,
              fillColor={95,95,95},
              fillPattern=FillPattern.Solid,
              pattern=LinePattern.None),
            Polygon(
              points={{250,-24},{326,-100},{318,-106},{244,-32},{250,-24}},
              smooth=Smooth.None,
              fillColor={95,95,95},
              fillPattern=FillPattern.Solid,
              pattern=LinePattern.None),
            Rectangle(
              extent={{-120,80},{-100,-60}},
              lineColor={95,95,95},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
            Rectangle(
              extent={{-114,80},{-106,-60}},
              lineColor={95,95,95},
              fillColor={170,213,255},
              fillPattern=FillPattern.Solid),
            Polygon(
              points={{-104,-96},{-22,-18},{-14,-24},{-98,-104},{-104,-96}},
              smooth=Smooth.None,
              fillColor={95,95,95},
              fillPattern=FillPattern.Solid,
              pattern=LinePattern.None),
                       Rectangle(
              extent={{-80,160},{380,-80}},
              lineColor={95,95,95},
              fillColor={215,215,215},
              fillPattern=FillPattern.Solid),
            Rectangle(
              extent={{-80,-80},{380,180}},
              lineColor={95,95,95},
              fillColor={95,95,95},
              fillPattern=FillPattern.Solid),
            Rectangle(
              extent={{-60,160},{360,-60}},
              pattern=LinePattern.None,
              lineColor={117,148,176},
              fillColor={170,213,255},
              fillPattern=FillPattern.Sphere),
            Rectangle(
              extent={{0,-80},{294,-60}},
              lineColor={95,95,95},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
            Rectangle(
              extent={{0,-74},{294,-66}},
              lineColor={95,95,95},
              fillColor={170,213,255},
              fillPattern=FillPattern.Solid),
            Rectangle(
              extent={{8,8},{294,100}},
              lineColor={95,95,95},
              fillColor={95,95,95},
              fillPattern=FillPattern.Solid),
            Rectangle(
              extent={{20,88},{280,22}},
              pattern=LinePattern.None,
              lineColor={117,148,176},
              fillColor={170,213,255},
              fillPattern=FillPattern.Sphere),
            Polygon(
              points={{-56,170},{20,94},{12,88},{-62,162},{-56,170}},
              smooth=Smooth.None,
              fillColor={95,95,95},
              fillPattern=FillPattern.Solid,
              pattern=LinePattern.None),
            Polygon(
              points={{290,16},{366,-60},{358,-66},{284,8},{290,16}},
              smooth=Smooth.None,
              fillColor={95,95,95},
              fillPattern=FillPattern.Solid,
              pattern=LinePattern.None),
            Polygon(
              points={{284,96},{360,168},{368,162},{292,90},{284,96}},
              smooth=Smooth.None,
              fillColor={95,95,95},
              fillPattern=FillPattern.Solid,
              pattern=LinePattern.None),
            Rectangle(
              extent={{-80,120},{-60,-20}},
              lineColor={95,95,95},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
            Rectangle(
              extent={{-74,120},{-66,-20}},
              lineColor={95,95,95},
              fillColor={170,213,255},
              fillPattern=FillPattern.Solid),
            Polygon(
              points={{-64,-56},{18,22},{26,16},{-58,-64},{-64,-56}},
              smooth=Smooth.None,
              fillColor={95,95,95},
              fillPattern=FillPattern.Solid,
              pattern=LinePattern.None),
            Rectangle(
              extent={{360,122},{380,-18}},
              lineColor={95,95,95},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
            Rectangle(
              extent={{366,122},{374,-18}},
              lineColor={95,95,95},
              fillColor={170,213,255},
              fillPattern=FillPattern.Solid),
            Rectangle(
              extent={{2,170},{296,178}},
              lineColor={95,95,95},
              fillColor={170,213,255},
              fillPattern=FillPattern.Solid),
            Rectangle(
              extent={{2,160},{296,180}},
              lineColor={95,95,95},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
            Rectangle(
              extent={{2,166},{296,174}},
              lineColor={95,95,95},
              fillColor={170,213,255},
              fillPattern=FillPattern.Solid),
              Bitmap(extent={{192,-58},{342,-18}},
              fileName="modelica://Buildings/Resources/Images/ThermalZones/EnergyPlus/spawn_icon_darkbluetxmedres.png",
              visible=not usePrecompiledFMU)}),                      Diagram(
            coordinateSystem(preserveAspectRatio=false, extent={{-160,-160},{380,180}})),
        Documentation(revisions="<html>
<ul>
<li>
March 25, 2021, by Baptiste Ravache:<br/>
First implementation.
</li>
</ul>
</html>"));
    end MultiFloors;
    annotation (
      preferredView="info",
      Documentation(
        info="<html>
<p>
This package contains base classes that are used to construct the models in
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus.Examples.SmallOffice\">
Buildings.ThermalZones.EnergyPlus.Examples.SmallOffice</a>.
</p>
</html>"));
  end BaseClasses;
  annotation (
    preferredView="info",
    Documentation(
      info="<html>
<p>
This package contains variable air volume flow models
for office buildings.
</p>
<h4>Note</h4>
<p>
The models
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus.Examples.SmallOffice.ASHRAE2006Winter\">
Buildings.ThermalZones.EnergyPlus.Examples.SmallOffice.ASHRAE2006Winter</a>
and
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus.Examples.SmallOffice.Guideline36Winter\">
Buildings.ThermalZones.EnergyPlus.Examples.SmallOffice.Guideline36Winter</a>
appear to be quite similar to
<a href=\"modelica://Buildings.Examples.VAVReheat.ASHRAE2006\">
Buildings.Examples.VAVReheat.ASHRAE2006</a>
and
<a href=\"modelica://Buildings.Examples.VAVReheat.Guideline36\">
Buildings.Examples.VAVReheat.Guideline36</a>,
respectively, because they all have the same HVAC system, control sequences,
and all have five thermal zones.
However, the models in
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus.Examples.SmallOffice\">
Buildings.ThermalZones.EnergyPlus.Examples.SmallOffice</a>
are from the
<i>DOE Commercial Reference Building,
Small Office, new construction, ASHRAE 90.1-2004,
Version 1.3_5.0</i>,
whereas the models in
<a href=\"modelica://Buildings.Examples.VAVReheat\">
Buildings.Examples.VAVReheat</a>
are from the
<i>DOE Commercial Building Benchmark,
Medium Office, new construction, ASHRAE 90.1-2004,
version 1.2_4.0</i>.
Therefore, the dimensions of the thermal zones in
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus.Examples.SmallOffice\">
Buildings.ThermalZones.EnergyPlus.Examples.SmallOffice</a>
are considerably smaller than in
<a href=\"modelica://Buildings.Examples.VAVReheat\">
Buildings.Examples.VAVReheat</a>.
As the sizing is scaled with the volumes of the thermal zones, the model <i>structure</i>
is the same, but the design capacities are different, as is the energy consumption.
</p>
</html>"));
end EnergyPlus;
