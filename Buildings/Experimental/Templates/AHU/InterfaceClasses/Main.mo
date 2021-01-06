within Buildings.Experimental.Templates.AHU.InterfaceClasses;
partial model Main "Main interface class"
  import TypesAHU = Buildings.Experimental.Templates.AHU.Types
    "Enumerations";
  replaceable package MediumAir=Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Air medium";
  replaceable package MediumCoo=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Cooling medium (such as CHW)";
  replaceable package MediumHea=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Heating medium (such as HHW)";
  constant TypesAHU.Main typ
    "Type of system"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  constant TypesAHU.SupplyBranch typSup = braSup.typ
    "Type of supply branch"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  Modelica.Fluid.Interfaces.FluidPort_a port_Out(
    redeclare package Medium = MediumAir)
    "Outdoor air intake" annotation (Placement(transformation(
          extent={{-310,-210},{-290,-190}}), iconTransformation(extent={{-250,-130},
            {-230,-110}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bSupCol(
    redeclare package Medium = MediumAir)
    "Dual duct cold deck air supply"
    annotation (Placement(transformation(extent={{290,-250},{310,-230}}),
        iconTransformation(extent={{230,-200},{250,-180}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bSup(
    redeclare package Medium = MediumAir)
    "Supply air"
    annotation (Placement(
        transformation(extent={{290,-210},{310,-190}}), iconTransformation(
          extent={{230,-130},{250,-110}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_OutMin(
    redeclare package Medium = MediumAir)
    "Minimum outdoor air intake"
    annotation (Placement(transformation(extent={{-310,
            -150},{-290,-130}}), iconTransformation(extent={{-250,-10},{-230,10}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aRet(
    redeclare package Medium = MediumAir)
    "Return air"
    annotation (Placement(
      transformation(extent={{290,-90},{310,-70}}),
      iconTransformation(extent={{230,110}, {250,130}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bExh(
    redeclare package Medium = MediumAir)
    "Exhaust/relief air" annotation (
      Placement(transformation(extent={{-310,-90},{-290,-70}}),
        iconTransformation(extent={{-250,110},{-230,130}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bSupHot(
    redeclare package Medium = MediumAir)
    "Dual duct hot deck air supply"
    annotation (Placement(transformation(extent={{290,-170},{310,-150}}),
        iconTransformation(extent={{230,-60},{250,-40}})));
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
end Main;
