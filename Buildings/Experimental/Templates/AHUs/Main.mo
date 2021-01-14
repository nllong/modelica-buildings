within Buildings.Experimental.Templates.AHUs;
package Main
  model VAVSingleDuct
    "VAV single duct with relief"
    extends Interfaces.Main(
      final typ=Types.Main.SupplyReturn,
      final typSup=Types.Supply.SingleDuct,
      typRet=Types.Return.WithRelief);

    final constant Types.Economizer typEco = eco.typ
      "Type of economizer"
      annotation (Evaluate=true,
        Dialog(group="Economizer"));

    inner replaceable parameter Economizers.Data.None datEco
      constrainedby Economizers.Data.None(
        final typ=typEco)
      annotation (Placement(transformation(extent={{-40,-148},{-20,-128}})),
        choicesAllMatching=true,
        Dialog(
          enable=typEco<>Types.Economizer.None,
          group="Economizer"),
        __Linkage(
          select(
            condition=typEco==Types.Economizer.DedicatedDamperTandem,
            redeclare parameter Economizers.Data.None datEco "No economizer")));

    final constant Boolean have_souCoiCoo = coiCoo.have_sou
      "Set to true for fluid ports on the source side"
      annotation (Evaluate=true, Dialog(group="Cooling coil"));

    Modelica.Fluid.Interfaces.FluidPort_a port_OutMin(
      redeclare package Medium = MediumAir) if
      typEco==Types.Economizer.DedicatedDamperTandem
      "Minimum outdoor air intake"
      annotation (Placement(transformation(extent={{-310,
              -150},{-290,-130}}), iconTransformation(extent={{-210,-10},{-190,10}})));
    Modelica.Fluid.Interfaces.FluidPort_b port_coiCooRet(
      redeclare package Medium = MediumCoo) if have_souCoiCoo
      "Cooling coil return port"
      annotation (Placement(
        transformation(extent={{10,-290},{30,-270}}),
        iconTransformation(extent={{10,-210},{30,-190}})));
    Modelica.Fluid.Interfaces.FluidPort_a port_coiCooSup(
      redeclare package Medium = MediumCoo) if have_souCoiCoo
      "Cooling coil supply port"
      annotation (Placement(
          transformation(extent={{-30,-290},{-10,-270}}), iconTransformation(
            extent={{-30,-210},{-10,-190}})));

    BoundaryConditions.WeatherData.Bus weaBus if
      coiCoo.typ == Types.Coil.CoolingDXVariableSpeed or
      coiCoo.typ == Types.Coil.CoolingDXMultiStage
      annotation (Placement(
          transformation(extent={{-20,240},{20,280}}), iconTransformation(extent={{-20,182},
              {20,218}})));

    replaceable Economizers.None eco
      constrainedby Interfaces.Economizer(
      redeclare final package Medium = MediumAir)
      "Economizer"
      annotation (
        choices(
          choice(redeclare Economizers.None eco
            "No economizer"),
          choice(redeclare Economizers.CommonDamperTandem eco
            "Single common OA damper - Dampers actuated in tandem"),
          choice(redeclare Economizers.CommonDamperFree  eco
            "Single common OA damper - Dampers actuated individually"),
          choice(redeclare Economizers.DedicatedDamperTandem eco
            "Separate dedicated OA damper - Dampers actuated in tandem")),
        Dialog(group="Economizer"),
        __Linkage(
          choicesConditional(
            condition=typRet==Types.Return.NoRelief,
            choices(
              choice(redeclare Economizers.None eco
                "No economizer"),
              choice(redeclare Economizers.CommonDamperTandem eco
                "Single common OA damper - Dampers actuated in tandem"),
              choice(redeclare Economizers.CommonDamperFree  eco
                "Single common OA damper - Dampers actuated individually"),
              choice(redeclare Economizers.DedicatedDamperTandem eco
                "Separate dedicated OA damper - Dampers actuated in tandem")),
            condition=typRet==Types.Return.NoRelief,
            choices(
              choice(redeclare Economizers.None eco
                "No economizer"),
              choice(redeclare Economizers.CommonDamperFreeNoRelief eco
                "Single common OA damper - Dampers actuated individually, no relief")))),
        Placement(transformation(extent={{-222,-150},{-202,-130}})));

    replaceable Coils.None coiCoo
      constrainedby Interfaces.Coil(
      redeclare final package MediumAir = MediumAir,
      redeclare final package MediumSou = MediumCoo)
      "Cooling coil"
      annotation (
        choicesAllMatching=true,
        Placement(transformation(extent={{-10,-210},{10,-190}})));

    // FIXME: Dummy default values fo testing purposes only.
    Fluid.FixedResistances.PressureDrop resRet(
      redeclare package Medium = MediumAir,
      m_flow_nominal=1,
      dp_nominal=100)
      annotation (Placement(transformation(extent={{262,-90},{242,-70}})));
    Fluid.FixedResistances.PressureDrop resSup(
      redeclare package Medium = MediumAir,
      m_flow_nominal=1,
      dp_nominal=100)
      annotation (Placement(transformation(extent={{242,-210},{262,-190}})));

  equation
    connect(port_OutMin, eco.port_OutMin)
      annotation (Line(points={{-300,-140},{-222,-140}}, color={0,127,255}));
    connect(ahuBus.ahuO.yEcoOut, eco.yOut) annotation (Line(
        points={{-300.1,0.1},{-212,0.1},{-212,-129}},
        color={255,204,51},
        thickness=0.5));
    connect(ahuBus.ahuO.yEcoRet, eco.yRet) annotation (Line(
        points={{-300.1,0.1},{-300.1,0.135135},{-204,0.135135},{-204,-129}},
        color={255,204,51},
        thickness=0.5));
    connect(ahuBus.ahuO.yEcoExh, eco.yExh) annotation (Line(
        points={{-300.1,0.1},{-220,0.1},{-220,-129}},
        color={255,204,51},
        thickness=0.5));
    connect(port_Exh, eco.port_Exh) annotation (Line(points={{-300,-80},{-240,-80},
            {-240,-133},{-222,-133}}, color={0,127,255}));
    connect(port_Out, eco.port_Out) annotation (Line(points={{-300,-200},{-240,-200},
            {-240,-147},{-222,-147}}, color={0,127,255}));
    connect(eco.port_Sup, coiCoo.port_a) annotation (Line(points={{-202,-147},{-180,
            -147},{-180,-200},{-10,-200}}, color={0,127,255}));
    connect(port_coiCooSup, coiCoo.port_aSou) annotation (Line(points={{-20,-280},
            {-20,-220},{-4,-220},{-4,-210}}, color={0,127,255}));
    connect(coiCoo.port_bSou, port_coiCooRet) annotation (Line(points={{4,-210},{4,
            -220},{20,-220},{20,-280}}, color={0,127,255}));

    connect(weaBus, coiCoo.weaBus) annotation (Line(
        points={{0,260},{20,260},{20,-190},{0,-190}},
        color={255,204,51},
        thickness=0.5));
    connect(ahuBus.ahuO.yCoo, coiCoo.y) annotation (Line(
        points={{-300.1,0.1},{-7,0.1},{-7,-189}},
        color={255,204,51},
        thickness=0.5));
    connect(ahuBus.ahuO.yEcoOutMin, eco.yOutMin) annotation (Line(
        points={{-300.1,0.1},{-216,0.1},{-215,-129}},
        color={255,204,51},
        thickness=0.5));
    connect(coiCoo.port_b, resSup.port_a)
      annotation (Line(points={{10,-200},{242,-200}}, color={0,127,255}));
    connect(resSup.port_b, port_Sup)
      annotation (Line(points={{262,-200},{300,-200}}, color={0,127,255}));
    connect(eco.port_Ret, resRet.port_b) annotation (Line(points={{-202,-132.8},{-180,
            -132.8},{-180,-80},{242,-80}}, color={0,127,255}));
    connect(resRet.port_a, port_Ret)
      annotation (Line(points={{262,-80},{300,-80}}, color={0,127,255}));
    annotation (
      defaultComponentName="ahu",
      Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
      coordinateSystem(preserveAspectRatio=false)));
  end VAVSingleDuct;

  model VAVSingleDuctBus "VAV single duct with relief"
    extends Interfaces.Main(
      final typ=Types.Main.SupplyReturn,
      final typSup=Types.Supply.SingleDuct,
      typRet=Types.Return.WithRelief);

    final constant Types.Economizer typEco = eco.typ
      "Type of economizer"
      annotation (Evaluate=true,
        Dialog(group="Economizer"));

    inner replaceable parameter Economizers.Data.None datEco
      constrainedby Economizers.Data.None(
        final typ=typEco)
      annotation (Placement(transformation(extent={{-40,-148},{-20,-128}})),
        choicesAllMatching=true,
        Dialog(
          enable=typEco<>Types.Economizer.None,
          group="Economizer"),
        __Linkage(
          select(
            condition=typEco==Types.Economizer.DedicatedDamperTandem,
            redeclare parameter Economizers.Data.None datEco "No economizer")));

    final constant Boolean have_souCoiCoo = coiCoo.have_sou
      "Set to true for fluid ports on the source side"
      annotation (Evaluate=true, Dialog(group="Cooling coil"));

    Modelica.Fluid.Interfaces.FluidPort_a port_OutMin(
      redeclare package Medium = MediumAir) if
      typEco==Types.Economizer.DedicatedDamperTandem
      "Minimum outdoor air intake"
      annotation (Placement(transformation(extent={{-310,
              -150},{-290,-130}}), iconTransformation(extent={{-210,-10},{-190,10}})));
    Modelica.Fluid.Interfaces.FluidPort_b port_coiCooRet(
      redeclare package Medium = MediumCoo) if have_souCoiCoo
      "Cooling coil return port"
      annotation (Placement(
        transformation(extent={{10,-290},{30,-270}}),
        iconTransformation(extent={{10,-210},{30,-190}})));
    Modelica.Fluid.Interfaces.FluidPort_a port_coiCooSup(
      redeclare package Medium = MediumCoo) if have_souCoiCoo
      "Cooling coil supply port"
      annotation (Placement(
          transformation(extent={{-30,-290},{-10,-270}}), iconTransformation(
            extent={{-30,-210},{-10,-190}})));

    BoundaryConditions.WeatherData.Bus weaBus if
      coiCoo.typ == Types.Coil.CoolingDXVariableSpeed or
      coiCoo.typ == Types.Coil.CoolingDXMultiStage
      annotation (Placement(
          transformation(extent={{-20,240},{20,280}}), iconTransformation(extent={{-20,182},
              {20,218}})));

    replaceable EconomizersBus.None eco
      constrainedby Interfaces.EconomizerBus(
      redeclare final package Medium = MediumAir)
      "Economizer"
      annotation (
        choices(
          choice(redeclare EconomizersBus.None eco
            "No economizer"),
          choice(redeclare EconomizersBus.CommonDamperTandem eco
            "Single common OA damper - Dampers actuated in tandem"),
          choice(redeclare EconomizersBus.CommonDamperFree  eco
            "Single common OA damper - Dampers actuated individually"),
          choice(redeclare EconomizersBus.DedicatedDamperTandem eco
            "Separate dedicated OA damper - Dampers actuated in tandem")),
        Dialog(group="Economizer"),
        __Linkage(
          choicesConditional(
            condition=typRet==Types.Return.NoRelief,
            choices(
              choice(redeclare EconomizersBus.None eco
                "No economizer"),
              choice(redeclare EconomizersBus.CommonDamperTandem eco
                "Single common OA damper - Dampers actuated in tandem"),
              choice(redeclare EconomizersBus.CommonDamperFree  eco
                "Single common OA damper - Dampers actuated individually"),
              choice(redeclare EconomizersBus.DedicatedDamperTandem eco
                "Separate dedicated OA damper - Dampers actuated in tandem")),
            condition=typRet==Types.Return.NoRelief,
            choices(
              choice(redeclare EconomizersBus.None eco
                "No economizer"),
              choice(redeclare EconomizersBus.CommonDamperFreeNoRelief eco
                "Single common OA damper - Dampers actuated individually, no relief")))),
        Placement(transformation(extent={{-222,-150},{-202,-130}})));

    replaceable Coils.None coiCoo
      constrainedby Interfaces.Coil(
      redeclare final package MediumAir = MediumAir,
      redeclare final package MediumSou = MediumCoo)
      "Cooling coil"
      annotation (
        choicesAllMatching=true,
        Placement(transformation(extent={{-10,-210},{10,-190}})));

    // FIXME: Dummy default values fo testing purposes only.
    Fluid.FixedResistances.PressureDrop resRet(
      redeclare package Medium = MediumAir,
      m_flow_nominal=1,
      dp_nominal=100)
      annotation (Placement(transformation(extent={{262,-90},{242,-70}})));
    Fluid.FixedResistances.PressureDrop resSup(
      redeclare package Medium = MediumAir,
      m_flow_nominal=1,
      dp_nominal=100)
      annotation (Placement(transformation(extent={{242,-210},{262,-190}})));

  equation
    connect(port_OutMin, eco.port_OutMin)
      annotation (Line(points={{-300,-140},{-222,-140}}, color={0,127,255}));
    connect(port_Exh, eco.port_Exh) annotation (Line(points={{-300,-80},{-240,-80},
            {-240,-133},{-222,-133}}, color={0,127,255}));
    connect(port_Out, eco.port_Out) annotation (Line(points={{-300,-200},{-240,-200},
            {-240,-147},{-222,-147}}, color={0,127,255}));
    connect(eco.port_Sup, coiCoo.port_a) annotation (Line(points={{-202,-147},{-180,
            -147},{-180,-200},{-10,-200}}, color={0,127,255}));
    connect(port_coiCooSup, coiCoo.port_aSou) annotation (Line(points={{-20,-280},
            {-20,-220},{-4,-220},{-4,-210}}, color={0,127,255}));
    connect(coiCoo.port_bSou, port_coiCooRet) annotation (Line(points={{4,-210},{4,
            -220},{20,-220},{20,-280}}, color={0,127,255}));

    connect(weaBus, coiCoo.weaBus) annotation (Line(
        points={{0,260},{20,260},{20,-190},{0,-190}},
        color={255,204,51},
        thickness=0.5));
    connect(ahuBus.ahuO.yCoo, coiCoo.y) annotation (Line(
        points={{-300.1,0.1},{-7,0.1},{-7,-189}},
        color={255,204,51},
        thickness=0.5));
    connect(coiCoo.port_b, resSup.port_a)
      annotation (Line(points={{10,-200},{242,-200}}, color={0,127,255}));
    connect(resSup.port_b, port_Sup)
      annotation (Line(points={{262,-200},{300,-200}}, color={0,127,255}));
    connect(eco.port_Ret, resRet.port_b) annotation (Line(points={{-202,-132.8},{-180,
            -132.8},{-180,-80},{242,-80}}, color={0,127,255}));
    connect(resRet.port_a, port_Ret)
      annotation (Line(points={{262,-80},{300,-80}}, color={0,127,255}));
    connect(ahuBus, eco.ahuBus) annotation (Line(
        points={{-300,0},{-211.9,0},{-211.9,-130}},
        color={255,204,51},
        thickness=0.5));
    annotation (
      defaultComponentName="ahu",
      Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
      coordinateSystem(preserveAspectRatio=false)));
  end VAVSingleDuctBus;
end Main;
