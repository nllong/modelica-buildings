within Buildings.Experimental.Templates.AHU;
package Interfaces "Base classes defining the component interfaces"
  extends Modelica.Icons.InterfacesPackage;
  partial model Actuator
    replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
      constrainedby Modelica.Media.Interfaces.PartialMedium
      "Medium";

    constant Types.Actuator typ
      "Equipment type"
      annotation (Evaluate=true, Dialog(group="Configuration"));

    Modelica.Fluid.Interfaces.FluidPort_a port_aSup(
      redeclare final package Medium = Medium)
      "Fluid connector a (positive design flow direction is from port_a to port_b)"
      annotation (Placement(transformation(extent={{-50,-110},{-30,-90}})));
    Modelica.Fluid.Interfaces.FluidPort_b port_bRet(
      redeclare final package Medium = Medium)
      "Fluid connector b (positive design flow direction is from port_a to port_b)"
      annotation (Placement(transformation(extent={{50,-110},{30,-90}})));
    Modelica.Blocks.Interfaces.RealInput y(min=0, max=1) if typ <> Types.Actuator.None
      "Actuator control signal"
      annotation (Placement(
        transformation(extent={{-20,-20},{20,20}}, rotation=0,   origin={-120,0}),
        iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-110,0})));
    Modelica.Fluid.Interfaces.FluidPort_a port_aRet(redeclare final package
        Medium = Medium)
      "Fluid connector a (positive design flow direction is from port_a to port_b)"
      annotation (Placement(transformation(extent={{30,90},{50,110}})));
    Modelica.Fluid.Interfaces.FluidPort_b port_bSup(redeclare final package
        Medium = Medium)
      "Fluid connector b (positive design flow direction is from port_a to port_b)"
      annotation (Placement(transformation(extent={{-30,90},{-50,110}})));
    annotation (
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
            Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-145,-116},{155,-156}},
            lineColor={0,0,255},
            textString="%name")}),            Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end Actuator;

  partial model Coil
    extends Buildings.Fluid.Interfaces.PartialTwoPort(
      redeclare final package Medium=MediumAir);
    replaceable package MediumAir=Buildings.Media.Air
      constrainedby Modelica.Media.Interfaces.PartialMedium
      "Air medium";
    replaceable package MediumSou=Buildings.Media.Water
      constrainedby Modelica.Media.Interfaces.PartialMedium
      "Source side medium"
      annotation(dialog(enable=have_sou));

    constant Types.Coil typ
      "Equipment type"
      annotation (Evaluate=true, Dialog(group="Configuration"));
    constant Boolean have_sou = false
      "Set to true for fluid ports on the source side"
      annotation (Evaluate=true, Dialog(group="Configuration"));
    constant Boolean have_weaBus = false
      annotation (Evaluate=true, Dialog(group="Configuration"));
    constant Boolean have_y = false
      annotation (Evaluate=true, Dialog(group="Configuration"));
    constant Boolean have_yBoo = false
      annotation (Evaluate=true, Dialog(group="Configuration"));
    constant Boolean have_yInt = false
      annotation (Evaluate=true, Dialog(group="Configuration"));

    // Conditional
    Modelica.Fluid.Interfaces.FluidPort_a port_aSou(
      redeclare final package Medium = MediumSou) if have_sou
      "Fluid connector a (positive design flow direction is from port_a to port_b)"
      annotation (Placement(transformation(extent={{-50,-110},{-30,-90}})));
    Modelica.Fluid.Interfaces.FluidPort_b port_bSou(
      redeclare final package Medium = MediumSou) if have_sou
      "Fluid connector b (positive design flow direction is from port_a to port_b)"
      annotation (Placement(transformation(extent={{50,-110},{30,-90}})));
    BoundaryConditions.WeatherData.Bus weaBus if have_weaBus
      annotation (Placement(
          transformation(extent={{-20,80},{20,120}}),  iconTransformation(extent={{-10,90},
              {10,110}})));
    Modelica.Blocks.Interfaces.RealInput y(min=0, max=1) if have_y
      "Actuator control signal"
      annotation (Placement(
        transformation(extent={{-20,-20},{20,20}}, rotation=270, origin={-80,120}),
        iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=270,
          origin={-70,110})));
    Modelica.Blocks.Interfaces.IntegerInput yInt(min=0) if have_yInt
      "Actuator control signal"
      annotation (Placement(
        transformation(extent={{-20,-20},{20,20}}, rotation=270, origin={-60,120}),
        iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=270,
          origin={-50,110})));
    Modelica.Blocks.Interfaces.BooleanInput yBoo if have_yBoo
      "Actuator control signal"
      annotation (Placement(
        transformation(extent={{-20,-20},{20,20}}, rotation=270, origin={-40,120}),
        iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=270,
          origin={-30,110})));

    annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
            Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid)}),                      Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end Coil;

  partial model Economizer
    replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
      constrainedby Modelica.Media.Interfaces.PartialMedium
      "Medium";
    constant Types.Economizer typ
      "Equipment type"
      annotation (Evaluate=true, Dialog(group="Configuration"));

    Modelica.Fluid.Interfaces.FluidPort_a port_Out(
      redeclare package Medium = Medium)
      "Outdoor air intake"
      annotation (Placement(transformation(
        extent={{-110,-70},{-90,-50}}),
        iconTransformation(extent={{-110,-80},{-90,-60}})));
    Modelica.Fluid.Interfaces.FluidPort_a port_Ret(
      redeclare package Medium = Medium)
      "Return air" annotation (Placement(transformation(extent={{90,50},
              {110,70}}), iconTransformation(extent={{90,62},{110,82}})));
    Modelica.Fluid.Interfaces.FluidPort_b port_Sup(
      redeclare package Medium = Medium)
      "Supply air" annotation (Placement(transformation(extent={{90,-70},
              {110,-50}}), iconTransformation(extent={{90,-80},{110,-60}})));
    Modelica.Fluid.Interfaces.FluidPort_b port_Exh(
      redeclare package Medium = Medium) if typ <> Types.Economizer.CommonDamperFreeNoRelief
      "Exhaust/relief air" annotation (Placement(transformation(
            extent={{-110,50},{-90,70}}), iconTransformation(extent={{-110,60},{-90,
              80}})));
    // Conditional
    Modelica.Fluid.Interfaces.FluidPort_a port_OutMin(
      redeclare package Medium = Medium) if typ == Types.Economizer.DedicatedDamperTandem
      "Minimum outdoor air intake"
      annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
        iconTransformation(extent={{-110,-10},{-90,10}})));
    Modelica.Blocks.Interfaces.RealInput yOut(min=0, max=1) if
      typ <> Types.Economizer.None
      "Actuator position (0: closed, 1: open)" annotation (Placement(
          transformation(
          extent={{-20,-20},{20,20}},
          rotation=270,
          origin={0,120}), iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=270,
          origin={0,110})));
    Modelica.Blocks.Interfaces.RealInput yExh if
      typ == Types.Economizer.CommonDamperFree
      "Relief/exhaust damper control signal" annotation (Placement(
          transformation(
          extent={{-20,-20},{20,20}},
          rotation=270,
          origin={-80,120}), iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=270,
          origin={-80,110})));
    Modelica.Blocks.Interfaces.RealInput yRet if
      typ == Types.Economizer.CommonDamperFree or
      typ == Types.Economizer.CommonDamperFreeNoRelief
      "Return damper control signal" annotation (Placement(transformation(
          extent={{-20,-20},{20,20}},
          rotation=270,
          origin={80,120}), iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=270,
          origin={80,110})));
    Modelica.Blocks.Interfaces.RealInput yOutMin if
      typ == Types.Economizer.DedicatedDamperTandem
      "Damper position minimum outside air (0: closed, 1: open)"
      annotation (
        Placement(transformation(extent={{-20,-20},{20,20}},rotation=270, origin={-40,120}),
        iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=270,
          origin={-30,110})));

    annotation (
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-151,-116},{149,-156}},
            lineColor={0,0,255},
            textString="%name")}),                     Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end Economizer;

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
    Modelica.Blocks.Interfaces.RealInput y(min=0, max=1) if have_y
      "s control signal"
      annotation (Placement(
        transformation(extent={{-20,-20},{20,20}}, rotation=270, origin={0,120}),
        iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=270,
          origin={0,110})));
    Modelica.Blocks.Interfaces.IntegerInput yInt(min=0) if have_yInt
      "Actuator control signal"
      annotation (Placement(
        transformation(extent={{-20,-20},{20,20}}, rotation=270, origin={20,120}),
        iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=270,
          origin={-50,110})));
    Modelica.Blocks.Interfaces.BooleanInput yBoo if have_yBoo
      "Actuator control signal"
      annotation (Placement(
        transformation(extent={{-20,-20},{20,20}}, rotation=270, origin={40,120}),
        iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=270,
          origin={-30,110})));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
            Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid)}),                      Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end Fan;

  partial model Main "Main interface class"
    replaceable package MediumAir=Buildings.Media.Air
      constrainedby Modelica.Media.Interfaces.PartialMedium
      "Air medium";
    replaceable package MediumCoo=Buildings.Media.Water
      constrainedby Modelica.Media.Interfaces.PartialMedium
      "Cooling medium (such as CHW)";
    replaceable package MediumHea=Buildings.Media.Water
      constrainedby Modelica.Media.Interfaces.PartialMedium
      "Heating medium (such as HHW)";

    constant Types.Main typ
      "Type of system"
      annotation (Evaluate=true,
        Dialog(group="Configuration"));
    constant Types.Supply typSup "Type of supply branch"
      annotation (Evaluate=true,
        Dialog(group="Configuration", enable=typ <> Types.Main.ExhaustOnly));
    constant Types.Return typRet "Type of return branch"
      annotation (Evaluate=true,
        Dialog(group="Configuration", enable=typ <> Types.Main.SupplyOnly));
    parameter Integer nTer = 0
      "Number of terminal units served by the AHU";

    Modelica.Fluid.Interfaces.FluidPort_a port_Out(
      redeclare package Medium = MediumAir) if typ <> Types.Main.ExhaustOnly
      "Outdoor air intake"
      annotation (Placement(transformation(
            extent={{-310,-210},{-290,-190}}), iconTransformation(extent={{-210,
              -110},{-190,-90}})));
    Modelica.Fluid.Interfaces.FluidPort_b port_Sup(
      redeclare package Medium =MediumAir) if
      typ <> Types.Main.ExhaustOnly and typSup == Types.Supply.SingleDuct
      "Supply air" annotation (
        Placement(transformation(extent={{290,-210},{310,-190}}),
          iconTransformation(extent={{190,-110},{210,-90}})));
    Modelica.Fluid.Interfaces.FluidPort_b port_SupCol(
      redeclare package Medium =MediumAir) if
      typ <> Types.Main.ExhaustOnly and typSup == Types.Supply.DualDuct
      "Dual duct cold deck air supply"
      annotation (Placement(transformation(
            extent={{290,-250},{310,-230}}), iconTransformation(extent={{190,
              -180},{210,-160}})));
    Modelica.Fluid.Interfaces.FluidPort_b port_SupHot(
      redeclare package Medium =MediumAir) if
      typ <> Types.Main.ExhaustOnly and typSup == Types.Supply.DualDuct
      "Dual duct hot deck air supply"
      annotation (Placement(
          transformation(extent={{290,-170},{310,-150}}), iconTransformation(
            extent={{190,-40},{210,-20}})));
    Modelica.Fluid.Interfaces.FluidPort_a port_Ret(
      redeclare package Medium =MediumAir) if
      typ <> Types.Main.SupplyOnly
      "Return air"
      annotation (Placement(transformation(extent={{290,-90},{310,-70}}),
          iconTransformation(extent={{190,90},{210,110}})));
    Modelica.Fluid.Interfaces.FluidPort_b port_Exh(
      redeclare package Medium = MediumAir) if
      typ == Types.Main.ExhaustOnly or
      (typ == Types.Main.SupplyReturn and typRet == Types.Return.WithRelief)
      "Exhaust/relief air"
      annotation (Placement(transformation(
            extent={{-310,-90},{-290,-70}}), iconTransformation(extent={{-210,90},
              {-190,110}})));

    Templates_V1.BaseClasses.AhuBus ahuBus(
      final nTer=nTer)
      annotation (Placement(transformation(
          extent={{-20,-20},{20,20}},
          rotation=90,
          origin={-300,0}),   iconTransformation(extent={{-20,-19},{20,19}},
          rotation=90,
          origin={-199,160})));
    Templates_V1.BaseClasses.TerminalBus terBus[nTer] "Terminal unit bus" annotation (
        Placement(transformation(
          extent={{-20,-20},{20,20}},
          rotation=-90,
          origin={300,0}), iconTransformation(
          extent={{-20,-20},{20,20}},
          rotation=-90,
          origin={198,160})));

    annotation (Icon(coordinateSystem(preserveAspectRatio=false,
      extent={{-200,-200},{200,200}}), graphics={
          Text(
            extent={{-155,-218},{145,-258}},
            lineColor={0,0,255},
            textString="%name"), Rectangle(
            extent={{-200,200},{200,-200}},
            lineColor={0,0,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid)}),
                                         Diagram(
          coordinateSystem(preserveAspectRatio=false, extent={{-300,-280},{300,
              280}}), graphics={
          Rectangle(
            extent={{-300,40},{300,-40}},
            lineColor={0,0,0},
            fillPattern=FillPattern.Solid,
            fillColor={245,239,184},
            pattern=LinePattern.None),
          Text(
            extent={{-300,40},{-66,18}},
            lineColor={0,0,0},
            textString="Control bus section",
            horizontalAlignment=TextAlignment.Left)}));
  end Main;

  partial model unused_SupplyBranch "Supply branch interface class"
    import TypeSupply = Buildings.Experimental.Templates.AHU.Types.Supply
      "System type enumeration";
    replaceable package MediumAir=Buildings.Media.Air
      constrainedby Modelica.Media.Interfaces.PartialMedium
      "Air medium";
    replaceable package MediumCoo=Buildings.Media.Water
      constrainedby Modelica.Media.Interfaces.PartialMedium
      "Cooling medium (such as CHW)";
    replaceable package MediumHea=Buildings.Media.Water
      constrainedby Modelica.Media.Interfaces.PartialMedium
      "Heating medium (such as HHW)";
    constant TypeSupply typ
      "Type of system"
      annotation (Evaluate=true, Dialog(group="Configuration"));

    Modelica.Fluid.Interfaces.FluidPort_a port_Out(
      redeclare package Medium =MediumAir) "Outdoor air intake"
          annotation (Placement(transformation(
            extent={{-310,-10},{-290,10}}),    iconTransformation(extent={{-250,
              -10},{-230,10}})));
    Modelica.Fluid.Interfaces.FluidPort_b port_bSupCol(
      redeclare package Medium = MediumAir)
      "Dual duct cold deck air supply"
      annotation (Placement(transformation(extent={{290,-50},{310,-30}}),
          iconTransformation(extent={{230,-140},{250,-120}})));
    Modelica.Fluid.Interfaces.FluidPort_b port_bSup(
      redeclare package Medium = MediumAir)
      "Supply air"
      annotation (Placement(
          transformation(extent={{290,-10},{310,10}}),    iconTransformation(
            extent={{230,-10},{250,10}})));
    Modelica.Fluid.Interfaces.FluidPort_a port_OutMin(
      redeclare package Medium = MediumAir)
      "Minimum outdoor air intake"
      annotation (Placement(transformation(extent={{-310,50},
              {-290,70}}),         iconTransformation(extent={{-250,120},{-230,
              140}})));
    Modelica.Fluid.Interfaces.FluidPort_b port_bSupHot(
      redeclare package Medium = MediumAir)
      "Dual duct hot deck air supply"
      annotation (Placement(transformation(extent={{290,30},{310,50}}),
          iconTransformation(extent={{230,120},{250,140}})));
    Modelica.Fluid.Interfaces.FluidPort_b port_coiPreHeaRet(
      redeclare package Medium = MediumHea)
      "Preheat coil return port"
        annotation (Placement(
          transformation(extent={{-150,-290},{-130,-270}}), iconTransformation(
            extent={{-150,-250},{-130,-230}})),
          __Linkage(Connect(path="chw_sup")));
    Modelica.Fluid.Interfaces.FluidPort_a port_coiPreHeaSup(
      redeclare package Medium = MediumHea)
      "Preheat coil supply port"
      annotation (Placement(
        transformation(extent={{-110,-290},{-90,-270}}),  iconTransformation(
          extent={{-110,-250},{-90,-230}})),
        __Linkage(Connect(path="phw_sup")));
    Modelica.Fluid.Interfaces.FluidPort_b port_coiCooRet(
      redeclare package Medium = MediumCoo)
      "Cooling coil return port"
      annotation (Placement(
        transformation(extent={{-30,-290},{-10,-270}}),
        iconTransformation(extent={{-30,-250},{-10,-230}})));
    Modelica.Fluid.Interfaces.FluidPort_a port_coiCooSup(
      redeclare package Medium = MediumCoo)
      "Cooling coil supply port"
      annotation (Placement(
          transformation(extent={{10,-290},{30,-270}}),   iconTransformation(
            extent={{10,-250},{30,-230}})));
    Modelica.Fluid.Interfaces.FluidPort_b port_coiReHeaRet(
      redeclare package Medium = MediumHea)
      "Reheat coil return port"
      annotation (Placement(
          transformation(extent={{90,-290},{110,-270}}), iconTransformation(
            extent={{90,-250},{110,-230}})));
    Modelica.Fluid.Interfaces.FluidPort_a port_coiReHeaSup(
      redeclare package Medium = MediumHea)
      "Reheat coil supply port"
      annotation (Placement(
          transformation(extent={{130,-290},{150,-270}}), iconTransformation(
            extent={{130,-250},{150,-230}})));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false,
      extent={{-240,-240},{240,240}})),  Diagram(
          coordinateSystem(preserveAspectRatio=false, extent={{-300,-280},{300,280}})));
  end unused_SupplyBranch;
end Interfaces;
