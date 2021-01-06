within Buildings.Experimental;
package Templates_V1 "fixme: add brief description"
  extends Modelica.Icons.Package;

  package Commercial "fixme: add brief description"
    extends Modelica.Icons.Package;

    package VAV "fixme: add brief description"
      extends Modelica.Icons.Package;

      package Controller
        block Controller
          "Multizone AHU controller that composes subsequences for controlling fan speed, dampers, and supply air temperature"

          parameter Modelica.SIunits.Time samplePeriod=120
            "Sample period of component, set to the same value to the trim and respond sequence";

          parameter Integer numZon(min=2) "Total number of served VAV boxes"
            annotation (Dialog(group="System and building parameters"));

          parameter Modelica.SIunits.Area AFlo[numZon] "Floor area of each zone"
            annotation (Dialog(group="System and building parameters"));

          parameter Boolean have_occSen=false
            "Set to true if zones have occupancy sensor"
            annotation (Dialog(group="System and building parameters"));

          parameter Boolean have_winSen=false
            "Set to true if zones have window status sensor"
            annotation (Dialog(group="System and building parameters"));

          parameter Boolean have_perZonRehBox=true
            "Check if there is any VAV-reheat boxes on perimeter zones"
            annotation (Dialog(group="System and building parameters"));

          parameter Boolean have_duaDucBox=false
            "Check if the AHU serves dual duct boxes"
            annotation (Dialog(group="System and building parameters"));

          parameter Boolean have_airFloMeaSta=false
            "Check if the AHU has AFMS (Airflow measurement station)"
            annotation (Dialog(group="System and building parameters"));

          // ----------- Parameters for economizer control -----------
          parameter Boolean use_enthalpy=false
            "Set to true if enthalpy measurement is used in addition to temperature measurement"
            annotation (Evaluate=true,Dialog(tab="Economizer"));

          parameter Modelica.SIunits.Time delta=5
            "Time horizon over which the outdoor air flow measurment is averaged"
            annotation (Evaluate=true,Dialog(tab="Economizer"));

          parameter Modelica.SIunits.TemperatureDifference delTOutHis=1
            "Delta between the temperature hysteresis high and low limit"
            annotation (Evaluate=true, Dialog(tab="Economizer"));

          parameter Modelica.SIunits.SpecificEnergy delEntHis=1000
            "Delta between the enthalpy hysteresis high and low limits"
            annotation (Evaluate=true, Dialog(tab="Economizer", enable=use_enthalpy));

          parameter Real retDamPhyPosMax(
            final min=0,
            final max=1,
            final unit="1") = 1
            "Physically fixed maximum position of the return air damper"
            annotation (Evaluate=true,
              Dialog(tab="Economizer", group="Damper limits"));

          parameter Real retDamPhyPosMin(
            final min=0,
            final max=1,
            final unit="1") = 0
            "Physically fixed minimum position of the return air damper"
            annotation (Evaluate=true,
              Dialog(tab="Economizer", group="Damper limits"));

          parameter Real outDamPhyPosMax(
            final min=0,
            final max=1,
            final unit="1") = 1
            "Physically fixed maximum position of the outdoor air damper"
            annotation (Evaluate=true,
              Dialog(tab="Economizer", group="Damper limits"));

          parameter Real outDamPhyPosMin(
            final min=0,
            final max=1,
            final unit="1") = 0
            "Physically fixed minimum position of the outdoor air damper"
            annotation (Evaluate=true,
              Dialog(tab="Economizer", group="Damper limits"));

          parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeMinOut=
            Buildings.Controls.OBC.CDL.Types.SimpleController.PI
            "Type of controller" annotation (Dialog(group="Economizer PID controller"));

          parameter Real kMinOut(final unit="1")=0.05
            "Gain of controller for minimum outdoor air intake"
            annotation (Dialog(group="Economizer PID controller"));

          parameter Modelica.SIunits.Time TiMinOut=1200
            "Time constant of controller for minimum outdoor air intake"
            annotation (Dialog(group="Economizer PID controller",
              enable=controllerTypeMinOut == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
                  or controllerTypeMinOut == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

          parameter Modelica.SIunits.Time TdMinOut=0.1
            "Time constant of derivative block for minimum outdoor air intake"
            annotation (Dialog(group="Economizer PID controller",
              enable=controllerTypeMinOut == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
                  or controllerTypeMinOut == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

          parameter Boolean use_TMix=true
            "Set to true if mixed air temperature measurement is enabled"
             annotation(Dialog(group="Economizer freeze protection"));

          parameter Boolean use_G36FrePro=false
            "Set to true to use G36 freeze protection"
            annotation(Dialog(group="Economizer freeze protection"));

          parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeFre=
            Buildings.Controls.OBC.CDL.Types.SimpleController.PI
            "Type of controller"
            annotation(Dialog(group="Economizer freeze protection", enable=use_TMix));

          parameter Real kFre(final unit="1/K") = 0.1
            "Gain for mixed air temperature tracking for freeze protection, used if use_TMix=true"
             annotation(Dialog(group="Economizer freeze protection", enable=use_TMix));

          parameter Modelica.SIunits.Time TiFre(max=TiMinOut)=120
            "Time constant of controller for mixed air temperature tracking for freeze protection. Require TiFre < TiMinOut"
             annotation(Dialog(group="Economizer freeze protection",
               enable=use_TMix
                 and (controllerTypeFre == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
                   or controllerTypeFre == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));

          parameter Modelica.SIunits.Time TdFre=0.1
            "Time constant of derivative block for freeze protection"
            annotation (Dialog(group="Economizer freeze protection",
              enable=use_TMix and
                  (controllerTypeFre == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
                  or controllerTypeFre == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));

          parameter Modelica.SIunits.Temperature TFreSet=279.15
            "Lower limit for mixed air temperature for freeze protection, used if use_TMix=true"
             annotation(Dialog(group="Economizer freeze protection", enable=use_TMix));

          parameter Real yMinDamLim=0
            "Lower limit of damper position limits control signal output"
            annotation (Evaluate=true,
              Dialog(tab="Economizer", group="Damper limits"));

          parameter Real yMaxDamLim=1
            "Upper limit of damper position limits control signal output"
            annotation (Evaluate=true,
              Dialog(tab="Economizer", group="Damper limits"));

          parameter Modelica.SIunits.Time retDamFulOpeTim=180
            "Time period to keep RA damper fully open before releasing it for minimum outdoor airflow control
    at disable to avoid pressure fluctuations"
            annotation (Evaluate=true, Dialog(tab="Economizer", group="Economizer delays at disable"));

          parameter Modelica.SIunits.Time disDel=15
            "Short time delay before closing the OA damper at disable to avoid pressure fluctuations"
            annotation (Evaluate=true,Dialog(tab="Economizer", group="Economizer delays at disable"));

          // ----------- parameters for fan speed control  -----------
          parameter Modelica.SIunits.PressureDifference pIniSet(displayUnit="Pa")=60
            "Initial pressure setpoint for fan speed control"
            annotation (Evaluate=true,
              Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));

          parameter Modelica.SIunits.PressureDifference pMinSet(displayUnit="Pa")=25
            "Minimum pressure setpoint for fan speed control"
            annotation (Evaluate=true,
              Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));

          parameter Modelica.SIunits.PressureDifference pMaxSet(displayUnit="Pa")=400
            "Maximum pressure setpoint for fan speed control"
            annotation (Evaluate=true,
              Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));

          parameter Modelica.SIunits.Time pDelTim=600
            "Delay time after which trim and respond is activated"
            annotation (Evaluate=true,
              Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));

          parameter Integer pNumIgnReq=2
            "Number of ignored requests for fan speed control"
            annotation (Evaluate=true,
              Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));

          parameter Modelica.SIunits.PressureDifference pTriAmo(displayUnit="Pa")=-12.0
            "Trim amount for fan speed control"
            annotation (Evaluate=true,
              Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));

          parameter Modelica.SIunits.PressureDifference pResAmo(displayUnit="Pa")=15
            "Respond amount (must be opposite in to triAmo) for fan speed control"
            annotation (Evaluate=true,
              Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));

          parameter Modelica.SIunits.PressureDifference pMaxRes(displayUnit="Pa")=32
            "Maximum response per time interval (same sign as resAmo) for fan speed control"
            annotation (Evaluate=true,
              Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));

          parameter Buildings.Controls.OBC.CDL.Types.SimpleController
            controllerTypeFanSpe=Buildings.Controls.OBC.CDL.Types.SimpleController.PI "Type of controller"
            annotation (Dialog(group="Fan speed PID controller"));

          parameter Real kFanSpe(final unit="1")=0.1
            "Gain of fan fan speed controller, normalized using pMaxSet"
            annotation (Dialog(group="Fan speed PID controller"));

          parameter Modelica.SIunits.Time TiFanSpe=60
            "Time constant of integrator block for fan speed"
            annotation (Dialog(group="Fan speed PID controller",
              enable=controllerTypeFanSpe == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
                  or controllerTypeFanSpe == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

          parameter Modelica.SIunits.Time TdFanSpe=0.1
            "Time constant of derivative block for fan speed"
            annotation (Dialog(group="Fan speed PID controller",
              enable=controllerTypeFanSpe == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
                  or controllerTypeFanSpe == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

          parameter Real yFanMax=1 "Maximum allowed fan speed"
            annotation (Evaluate=true,
              Dialog(group="Fan speed PID controller"));

          parameter Real yFanMin=0.1 "Lowest allowed fan speed if fan is on"
            annotation (Evaluate=true,
              Dialog(group="Fan speed PID controller"));

          // ----------- parameters for minimum outdoor airflow setting  -----------
          parameter Real zonDisEffHea[numZon]=
             fill(0.8, outAirSetPoi.numZon)
            "Zone air distribution effectiveness during heating"
            annotation (Evaluate=true,
              Dialog(tab="Minimum outdoor airflow rate"));

          parameter Real zonDisEffCoo[numZon]=
             fill(1.0, outAirSetPoi.numZon)
            "Zone air distribution effectiveness during cooling"
            annotation (Evaluate=true,
              Dialog(tab="Minimum outdoor airflow rate"));

          parameter Real occDen[numZon](each final unit="1/m2")=
             fill(0.05, outAirSetPoi.numZon)
            "Default number of person in unit area"
            annotation (Evaluate=true,
              Dialog(tab="Minimum outdoor airflow rate", group="Nominal conditions"));

          parameter Real VOutPerAre_flow[numZon](
            final unit = fill("m3/(s.m2)", outAirSetPoi.numZon))=fill(3e-4, outAirSetPoi.numZon)
            "Outdoor air rate per unit area"
            annotation (Evaluate=true,
              Dialog(tab="Minimum outdoor airflow rate", group="Nominal conditions"));

          parameter Modelica.SIunits.VolumeFlowRate VOutPerPer_flow[numZon]=
            fill(2.5e-3, outAirSetPoi.numZon)
            "Outdoor air rate per person"
            annotation (Evaluate=true,
              Dialog(tab="Minimum outdoor airflow rate", group="Nominal conditions"));

          parameter Modelica.SIunits.VolumeFlowRate minZonPriFlo[numZon]
            "Minimum expected zone primary flow rate"
            annotation (Evaluate=true,
              Dialog(tab="Minimum outdoor airflow rate", group="Nominal conditions"));

          parameter Modelica.SIunits.VolumeFlowRate VPriSysMax_flow
            "Maximum expected system primary airflow at design stage"
            annotation (Evaluate=true,
              Dialog(tab="Minimum outdoor airflow rate", group="Nominal conditions"));

          parameter Real desZonDisEff[numZon]=fill(1.0, outAirSetPoi.numZon)
            "Design zone air distribution effectiveness"
            annotation (Evaluate=true,
              Dialog(tab="Minimum outdoor airflow rate", group="Nominal conditions"));

          parameter Real desZonPop[numZon]={
            outAirSetPoi.occDen[i]*outAirSetPoi.AFlo[i]
            for i in 1:outAirSetPoi.numZon}
            "Design zone population during peak occupancy"
            annotation (Evaluate=true,
              Dialog(tab="Minimum outdoor airflow rate", group="Nominal conditions"));

          parameter Real peaSysPop=1.2*sum(
            {outAirSetPoi.occDen[iZon]*outAirSetPoi.AFlo[iZon]
            for iZon in 1:outAirSetPoi.numZon})
            "Peak system population"
            annotation (Evaluate=true,
              Dialog(tab="Minimum outdoor airflow rate", group="Nominal conditions"));

        //  parameter Real uLow=-0.5
        //    "If zone space temperature minus supply air temperature is less than uLow,
        //    then it should use heating supply air distribution effectiveness"
        //    annotation (Evaluate=true,
        //      Dialog(tab="Minimum outdoor airflow rate", group="Advanced"));
        //  parameter Real uHig=0.5
        //    "If zone space temperature minus supply air temperature is more than uHig,
        //    then it should use cooling supply air distribution effectiveness"
         //   annotation (Evaluate=true,
          //    Dialog(tab="Minimum outdoor airflow rate", group="Advanced"));

          // ----------- parameters for supply air temperature control  -----------
          parameter Modelica.SIunits.Temperature TSupSetMin=285.15
            "Lowest cooling supply air temperature setpoint"
            annotation (Evaluate=true,
              Dialog(tab="Supply air temperature", group="Temperature limits"));

          parameter Modelica.SIunits.Temperature TSupSetMax=291.15
            "Highest cooling supply air temperature setpoint. It is typically 18 degC (65 degF) in mild and dry climates, 16 degC (60 degF) or lower in humid climates"
            annotation (Evaluate=true,
              Dialog(tab="Supply air temperature", group="Temperature limits"));

          parameter Modelica.SIunits.Temperature TSupSetDes=286.15
            "Nominal supply air temperature setpoint"
            annotation (Evaluate=true,
              Dialog(tab="Supply air temperature", group="Temperature limits"));

          parameter Modelica.SIunits.Temperature TOutMin=289.15
            "Lower value of the outdoor air temperature reset range. Typically value is 16 degC (60 degF)"
            annotation (Evaluate=true,
              Dialog(tab="Supply air temperature", group="Temperature limits"));

          parameter Modelica.SIunits.Temperature TOutMax=294.15
            "Higher value of the outdoor air temperature reset range. Typically value is 21 degC (70 degF)"
            annotation (Evaluate=true,
              Dialog(tab="Supply air temperature", group="Temperature limits"));

          parameter Modelica.SIunits.Temperature iniSetSupTem=supTemSetPoi.maxSet
            "Initial setpoint for supply temperature control" annotation (Evaluate=true,
              Dialog(tab="Supply air temperature", group="Trim and respond for reseting TSup setpoint"));

          parameter Modelica.SIunits.Temperature maxSetSupTem=supTemSetPoi.TSupSetMax
            "Maximum setpoint for supply temperature control" annotation (Evaluate=true,
              Dialog(tab="Supply air temperature", group="Trim and respond for reseting TSup setpoint"));

          parameter Modelica.SIunits.Temperature minSetSupTem=supTemSetPoi.TSupSetDes
            "Minimum setpoint for supply temperature control" annotation (Evaluate=true,
              Dialog(tab="Supply air temperature", group="Trim and respond for reseting TSup setpoint"));

          parameter Modelica.SIunits.Time delTimSupTem=600
            "Delay timer for supply temperature control"
            annotation (Evaluate=true,
              Dialog(tab="Supply air temperature", group="Trim and respond for reseting TSup setpoint"));

          parameter Integer numIgnReqSupTem=2
            "Number of ignorable requests for supply temperature control"
            annotation (Evaluate=true,
              Dialog(tab="Supply air temperature", group="Trim and respond for reseting TSup setpoint"));

          parameter Modelica.SIunits.TemperatureDifference triAmoSupTem=0.1
            "Trim amount for supply temperature control"
            annotation (Evaluate=true,
              Dialog(tab="Supply air temperature", group="Trim and respond for reseting TSup setpoint"));

          parameter Modelica.SIunits.TemperatureDifference resAmoSupTem=-0.2
            "Response amount for supply temperature control"
            annotation (Evaluate=true,
              Dialog(tab="Supply air temperature", group="Trim and respond for reseting TSup setpoint"));

          parameter Modelica.SIunits.TemperatureDifference maxResSupTem=-0.6
            "Maximum response per time interval for supply temperature control"
            annotation (Evaluate=true,
              Dialog(tab="Supply air temperature", group="Trim and respond for reseting TSup setpoint"));

          parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeTSup=
              Buildings.Controls.OBC.CDL.Types.SimpleController.PI
            "Type of controller for supply air temperature signal"
            annotation (Dialog(group="Supply air temperature"));

          parameter Real kTSup(final unit="1/K")=0.05
            "Gain of controller for supply air temperature signal"
            annotation (Dialog(group="Supply air temperature"));

          parameter Modelica.SIunits.Time TiTSup=600
            "Time constant of integrator block for supply air temperature control signal"
            annotation (Dialog(group="Supply air temperature",
              enable=controllerTypeTSup == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
                  or controllerTypeTSup == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

          parameter Modelica.SIunits.Time TdTSup=0.1
            "Time constant of integrator block for supply air temperature control signal"
            annotation (Dialog(group="Supply air temperature",
              enable=controllerTypeTSup == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
                  or controllerTypeTSup == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

          parameter Real uHeaMax(min=-0.9)=-0.25
            "Upper limit of controller signal when heating coil is off. Require -1 < uHeaMax < uCooMin < 1."
            annotation (Dialog(group="Supply air temperature"));

          parameter Real uCooMin(max=0.9)=0.25
            "Lower limit of controller signal when cooling coil is off. Require -1 < uHeaMax < uCooMin < 1."
            annotation (Dialog(group="Supply air temperature"));
        protected
          Buildings.Controls.OBC.CDL.Interfaces.RealInput VDis_flow[numZon](
            each final unit="m3/s",
            each quantity="VolumeFlowRate",
            each min=0)
            "Primary airflow rate to the ventilation zone from the air handler, including outdoor air and recirculated air"
            annotation (Placement(transformation(extent={{-240,130},{-200,170}})));
          Buildings.Controls.OBC.CDL.Interfaces.RealInput TMix(
            final unit="K",
            final quantity = "ThermodynamicTemperature") if use_TMix
            "Measured mixed air temperature, used for freeze protection if use_TMix=true"
            annotation (Placement(transformation(extent={{-240,-150},{-200,-110}})));
          Buildings.Controls.OBC.CDL.Interfaces.RealInput ducStaPre(
            final unit="Pa",
            displayUnit="Pa")
            "Measured duct static pressure"
            annotation (Placement(transformation(extent={{-240,100},{-200,140}})));

          Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
            final unit="K",
            final quantity="ThermodynamicTemperature") "Outdoor air temperature"
            annotation (Placement(transformation(extent={{-240,160},{-200,200}})));
          Buildings.Controls.OBC.CDL.Interfaces.RealInput TOutCut(
            final unit="K",
            final quantity="ThermodynamicTemperature")
            "OA temperature high limit cutoff. For differential dry bulb temeprature condition use return air temperature measurement"
            annotation (Placement(transformation(extent={{-240,-30},{-200,10}})));
          Buildings.Controls.OBC.CDL.Interfaces.RealInput hOut(
            final unit="J/kg",
            final quantity="SpecificEnergy") if use_enthalpy "Outdoor air enthalpy"
            annotation (Placement(transformation(extent={{-240,-60},{-200,-20}})));
          Buildings.Controls.OBC.CDL.Interfaces.RealInput hOutCut(
            final unit="J/kg",
            final quantity="SpecificEnergy") if use_enthalpy
            "OA enthalpy high limit cutoff. For differential enthalpy use return air enthalpy measurement"
            annotation (Placement(transformation(extent={{-240,-90},{-200,-50}})));
          Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
            final unit="K",
            final quantity="ThermodynamicTemperature")
            "Measured supply air temperature"
            annotation (Placement(transformation(extent={{-240,0},{-200,40}})));
          Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonHeaSet(
            final unit="K",
            final quantity="ThermodynamicTemperature")
            "Zone air temperature heating setpoint"
            annotation (Placement(transformation(extent={{-240,250},{-200,290}})));
          Buildings.Controls.OBC.CDL.Interfaces.RealInput VOut_flow(
            final unit="m3/s",
            final quantity="VolumeFlowRate")
            "Measured outdoor volumetric airflow rate"
            annotation (Placement(transformation(extent={{-240,-120},{-200,-80}})));
          Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nOcc[numZon] if have_occSen
            "Number of occupants"
            annotation (Placement(transformation(extent={{-240,70},{-200,110}})));
          Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon[numZon](
            each final unit="K",
            each final quantity="ThermodynamicTemperature")
            "Measured zone air temperature"
            annotation (Placement(transformation(extent={{-240,50},{-200,90}})));
          Buildings.Controls.OBC.CDL.Interfaces.RealInput TDis[numZon](
            each final unit="K",
            each final quantity="ThermodynamicTemperature")
            "Discharge air temperature"
            annotation (Placement(transformation(extent={{-240,30},{-200,70}})));
          Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonCooSet(
            final unit="K",
            final quantity="ThermodynamicTemperature")
            "Zone air temperature cooling setpoint"
            annotation (Placement(transformation(extent={{-240,220},{-200,260}})));
          Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uZonTemResReq
            "Zone cooling supply air temperature reset request"
            annotation (Placement(transformation(extent={{-240,-210},{-200,-170}})));
          Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uZonPreResReq
            "Zone static pressure reset requests"
            annotation (Placement(transformation(extent={{-240,-240},{-200,-200}})));
          Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
            "AHU operation mode status signal"
            annotation (Placement(transformation(extent={{-240,-180},{-200,-140}})));
          Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWin[numZon] if have_winSen
            "Window status, true if open, false if closed"
            annotation (Placement(transformation(extent={{-240,190},{-200,230}})));

          Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uFreProSta if
              use_G36FrePro
           "Freeze protection status, used if use_G36FrePro=true"
            annotation (Placement(transformation(extent={{-240,-270},{-200,-230}})));

          Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSupSet(
            final unit="K",
            final quantity="ThermodynamicTemperature")
            "Setpoint for supply air temperature"
            annotation (Placement(transformation(extent={{200,70},{240,110}})));
          Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHea(
            final min=0,
            final max=1,
            final unit="1")
            "Control signal for heating"
            annotation (Placement(transformation(extent={{200,30},{240,70}})));
          Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCoo(
            final min=0,
            final max=1,
            final unit="1") "Control signal for cooling"
            annotation (Placement(transformation(extent={{200,-20},{240,20}})));
          Buildings.Controls.OBC.CDL.Interfaces.RealOutput ySupFanSpe(
            final min=0,
            final max=1,
            final unit="1") "Supply fan speed"
            annotation (Placement(transformation(extent={{200,110},{240,150}})));
          Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetDamPos(
            final min=0,
            final max=1,
            final unit="1") "Return air damper position"
            annotation (Placement(transformation(extent={{200,-60},{240,-20}})));
          Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOutDamPos(
            final min=0,
            final max=1,
            final unit="1") "Outdoor air damper position"
            annotation (Placement(transformation(extent={{200,-160},{240,-120}})));
          Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput ySupFan
            "Supply fan status, true if fan should be on"
            annotation (Placement(transformation(extent={{200,170},{240,210}})));

          Buildings.Controls.OBC.CDL.Continuous.Average TZonSetPoiAve
            "Average of all zone set points"
            annotation (Placement(transformation(extent={{-160,240},{-140,260}})));
          Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutsideAirFlow
            outAirSetPoi(
            final AFlo=AFlo,
            final VPriSysMax_flow=VPriSysMax_flow,
            final minZonPriFlo=minZonPriFlo,
            final numZon=numZon,
            final have_occSen=have_occSen,
            final VOutPerAre_flow=VOutPerAre_flow,
            final VOutPerPer_flow=VOutPerPer_flow,
            final occDen=occDen,
            final zonDisEffHea=zonDisEffHea,
            final zonDisEffCoo=zonDisEffCoo,
            final desZonDisEff=desZonDisEff,
            final desZonPop=desZonPop,
            final peaSysPop=peaSysPop,
            final have_winSen=have_winSen)
            "Controller for minimum outdoor airflow rate"
            annotation (Placement(transformation(extent={{-40,30},{-20,50}})));

          Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.SupplyFan
            supFan(
            final numZon=numZon,
            final samplePeriod=samplePeriod,
            final have_perZonRehBox=have_perZonRehBox,
            final have_duaDucBox=have_duaDucBox,
            final have_airFloMeaSta=have_airFloMeaSta,
            final iniSet=pIniSet,
            final minSet=pMinSet,
            final maxSet=pMaxSet,
            final delTim=pDelTim,
            final numIgnReq=pNumIgnReq,
            final triAmo=pTriAmo,
            final resAmo=pResAmo,
            final maxRes=pMaxRes,
            final controllerType=controllerTypeFanSpe,
            final k=kFanSpe,
            final Ti=TiFanSpe,
            final Td=TdFanSpe,
            final yFanMax=yFanMax,
            final yFanMin=yFanMin)
            "Supply fan controller"
            annotation (Placement(transformation(extent={{-160,100},{-140,120}})));

          Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.SupplyTemperature
            supTemSetPoi(
            final samplePeriod=samplePeriod,
            final TSupSetMin=TSupSetMin,
            final TSupSetMax=TSupSetMax,
            final TSupSetDes=TSupSetDes,
            final TOutMin=TOutMin,
            final TOutMax=TOutMax,
            final iniSet=iniSetSupTem,
            final maxSet=maxSetSupTem,
            final minSet=minSetSupTem,
            final delTim=delTimSupTem,
            final numIgnReq=numIgnReqSupTem,
            final triAmo=triAmoSupTem,
            final resAmo=resAmoSupTem,
            final maxRes=maxResSupTem) "Setpoint for supply temperature"
            annotation (Placement(transformation(extent={{0,60},{20,80}})));

          Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Economizers.Controller eco(
            final use_enthalpy=use_enthalpy,
            final delTOutHis=delTOutHis,
            final delEntHis=delEntHis,
            final retDamFulOpeTim=retDamFulOpeTim,
            final disDel=disDel,
            final controllerTypeMinOut=controllerTypeMinOut,
            final kMinOut=kMinOut,
            final TiMinOut=TiMinOut,
            final TdMinOut=TdMinOut,
            final retDamPhyPosMax=retDamPhyPosMax,
            final retDamPhyPosMin=retDamPhyPosMin,
            final outDamPhyPosMax=outDamPhyPosMax,
            final outDamPhyPosMin=outDamPhyPosMin,
            final uHeaMax=uHeaMax,
            final uCooMin=uCooMin,
            final uOutDamMax=(uHeaMax + uCooMin)/2,
            final uRetDamMin=(uHeaMax + uCooMin)/2,
            final TFreSet=TFreSet,
            final controllerTypeFre=controllerTypeFre,
            final kFre=kFre,
            final TiFre=TiFre,
            final TdFre=TdFre,
            final delta=delta,
            final use_TMix=use_TMix,
            final use_G36FrePro=use_G36FrePro) "Economizer controller"
            annotation (Placement(transformation(extent={{140,-80},{160,-60}})));

          Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.SupplySignals val(
            final controllerType=controllerTypeTSup,
            final kTSup=kTSup,
            final TiTSup=TiTSup,
            final TdTSup=TdTSup,
            final uHeaMax=uHeaMax,
            final uCooMin=uCooMin) "AHU coil valve control"
            annotation (Placement(transformation(extent={{80,0},{100,20}})));

          BaseClasses.AhuSubBusI ahuSubBusI annotation (Placement(transformation(extent={{-326,-12},{-306,8}}),
                iconTransformation(extent={{-628,-36},{-608,-16}})));
          BaseClasses.AhuSubBusO ahuSubBusO annotation (Placement(transformation(extent={{286,30},{306,50}}),
                iconTransformation(extent={{-620,-58},{-600,-38}})));
        public
          BaseClasses.AhuBus ahuBus annotation (Placement(transformation(extent={{-18,-444},{22,-404}}), iconTransformation(
                  extent={{-210,-10},{-190,10}})));
        protected
          Buildings.Controls.OBC.CDL.Continuous.Division VOut_flow_normalized(
            u1(final unit="m3/s"),
            u2(final unit="m3/s"),
            y(final unit="1"))
            "Normalization of outdoor air flow intake by design minimum outdoor air intake"
            annotation (Placement(transformation(extent={{20,-40},{40,-20}})));

        equation
          connect(eco.yRetDamPos, yRetDamPos)
            annotation (Line(points={{161.25,-67.5},{180,-67.5},{180,-40},{220,-40}},
              color={0,0,127}));
          connect(eco.yOutDamPos, yOutDamPos)
            annotation (Line(points={{161.25,-72.5},{180,-72.5},{180,-140},{220,-140}},
              color={0,0,127}));
          connect(eco.uSupFan, supFan.ySupFan)
            annotation (Line(points={{138.75,-75},{-84,-75},{-84,117},{-138,117}},
              color={255,0,255}));
          connect(supFan.ySupFanSpe, ySupFanSpe)
            annotation (Line(points={{-138,110},{42,110},{42,130},{220,130}},
              color={0,0,127}));
          connect(TOut, eco.TOut)
            annotation (Line(points={{-220,180},{-60,180},{-60,-60.625},{138.75,-60.625}},
              color={0,0,127}));
          connect(eco.TOutCut, TOutCut)
            annotation (Line(points={{138.75,-62.5},{-74,-62.5},{-74,-10},{-220,-10}},
              color={0,0,127}));
          connect(eco.hOut, hOut)
            annotation (Line(points={{138.75,-64.375},{-78,-64.375},{-78,-40},{-220,-40}},
              color={0,0,127}));
          connect(eco.hOutCut, hOutCut)
            annotation (Line(points={{138.75,-65.625},{-94,-65.625},{-94,-70},{-220,-70}},
              color={0,0,127}));
          connect(eco.uOpeMod, uOpeMod)
            annotation (Line(points={{138.75,-76.875},{60,-76.875},{60,-160},{-220,-160}},
              color={255,127,0}));
          connect(supTemSetPoi.TSupSet, TSupSet)
            annotation (Line(points={{22,70},{122,70},{122,90},{220,90}}, color={0,0,127}));
          connect(supTemSetPoi.TOut, TOut)
            annotation (Line(points={{-2,74},{-60,74},{-60,180},{-220,180}},
              color={0,0,127}));
          connect(supTemSetPoi.uSupFan, supFan.ySupFan)
            annotation (Line(points={{-2,66},{-84,66},{-84,117},{-138,117}},
              color={255,0,255}));
          connect(supTemSetPoi.uZonTemResReq, uZonTemResReq)
            annotation (Line(points={{-2,70},{-52,70},{-52,-190},{-220,-190}},
              color={255,127,0}));
          connect(supTemSetPoi.uOpeMod, uOpeMod)
            annotation (Line(points={{-2,62},{-48,62},{-48,-160},{-220,-160}},
              color={255,127,0}));
          connect(supFan.uOpeMod, uOpeMod)
            annotation (Line(points={{-162,118},{-180,118},{-180,-160},{-220,-160}},
              color={255,127,0}));
          connect(supFan.uZonPreResReq, uZonPreResReq)
            annotation (Line(points={{-162,107},{-176,107},{-176,-220},{-220,-220}},
              color={255,127,0}));
          connect(supFan.ducStaPre, ducStaPre)
            annotation (Line(points={{-162,102},{-192,102},{-192,120},{-220,120}},
              color={0,0,127}));
          connect(eco.VOutMinSet_flow_normalized, outAirSetPoi.VOutMinSet_flow)
            annotation (Line(points={{138.75,-71.25},{-4,-71.25},{-4,37},{-18,37}},
              color={0,0,127}));
          connect(outAirSetPoi.nOcc, nOcc)
            annotation (Line(points={{-42,49},{-128,49},{-128,90},{-220,90}},
              color={255,127,0}));
          connect(outAirSetPoi.TZon, TZon)
            annotation (Line(points={{-42,43},{-132,43},{-132,70},{-220,70}},
              color={0,0,127}));
          connect(outAirSetPoi.TDis, TDis)
            annotation (Line(points={{-42,40},{-126,40},{-126,50},{-220,50}},
              color={0,0,127}));
          connect(supFan.ySupFan, outAirSetPoi.uSupFan)
            annotation (Line(points={{-138,117},{-84,117},{-84,37},{-42,37}},
              color={255,0,255}));
          connect(supTemSetPoi.TZonSetAve, TZonSetPoiAve.y)
            annotation (Line(points={{-2,78},{-20,78},{-20,250},{-138,250}},
              color={0,0,127}));
          connect(outAirSetPoi.VDis_flow, VDis_flow)
            annotation (Line(points={{-42,31},{-184,31},{-184,150},{-220,150}},
              color={0,0,127}));
          connect(supFan.VDis_flow, VDis_flow)
            annotation (Line(points={{-162,113},{-184,113},{-184,150},{-220,150}},
              color={0,0,127}));
          connect(supFan.ySupFan, ySupFan)
            annotation (Line(points={{-138,117},{180,117},{180,190},{220,190}},
              color={255,0,255}));
          connect(outAirSetPoi.uOpeMod, uOpeMod)
            annotation (Line(points={{-42,34},{-120,34},{-120,-160},{-220,-160}},
              color={255,127,0}));
          connect(TZonSetPoiAve.u2, TZonCooSet)
            annotation (Line(points={{-162,244},{-180,244},{-180,240},{-220,240}},
              color={0,0,127}));
          connect(eco.TMix, TMix)
            annotation (Line(points={{138.75,-73.125},{-12,-73.125},{-12,-130},{-220,-130}},
              color={0,0,127}));
          connect(TSup, val.TSup)
            annotation (Line(points={{-220,20},{-66,20},{-66,5},{78,5}},
              color={0,0,127}));
          connect(supFan.ySupFan, val.uSupFan)
            annotation (Line(points={{-138,117},{-84,117},{-84,15},{78,15}},
              color={255,0,255}));
          connect(val.uTSup, eco.uTSup)
            annotation (Line(points={{102,14},{120,14},{120,-67.5},{138.75,-67.5}},
              color={0,0,127}));
          connect(val.yHea, yHea)
            annotation (Line(points={{102,10},{180,10},{180,50},{220,50}},
              color={0,0,127}));
          connect(val.yCoo, yCoo)
            annotation (Line(points={{102,6},{180,6},{180,0},{220,0}},
              color={0,0,127}));
          connect(outAirSetPoi.uWin, uWin)
            annotation (Line(points={{-42,46},{-120,46},{-120,210},{-220,210}},
              color={255,0,255}));
          connect(supTemSetPoi.TSupSet, val.TSupSet)
            annotation (Line(points={{22,70},{40,70},{40,10},{78,10}},
              color={0,0,127}));
          connect(TZonHeaSet, TZonSetPoiAve.u1)
            annotation (Line(points={{-220,270},{-180,270},{-180,256},{-162,256}},
              color={0,0,127}));
          connect(eco.uFreProSta, uFreProSta)
            annotation (Line(points={{138.75,-79.375},{66,-79.375},{66,-250},{-220,-250}},
              color={255,127,0}));
          connect(eco.VOut_flow_normalized, VOut_flow_normalized.y)
            annotation (Line(points={{138.75,-69.375},{60,-69.375},{60,-30},{42,-30}},
              color={0,0,127}));
          connect(outAirSetPoi.VDesOutMin_flow_nominal, VOut_flow_normalized.u2)
            annotation (Line(points={{-18,43},{0,43},{0,-36},{18,-36}}, color={0,0,127}));
          connect(VOut_flow_normalized.u1, VOut_flow)
            annotation (Line(points={{18,-24},{-160,-24},{-160,-100},{-220,-100}},
              color={0,0,127}));

          connect(ahuSubBusI.TZonHeaSet, TZonHeaSet) annotation (Line(
              points={{-316,-2},{-268,-2},{-268,270},{-220,270}},
              color={255,204,51},
              thickness=0.5), Text(
              string="%first",
              index=-1,
              extent={{-6,3},{-6,3}},
              horizontalAlignment=TextAlignment.Right));
          connect(ahuSubBusI.TZonCooSet, TZonCooSet) annotation (Line(
              points={{-316,-2},{-264,-2},{-264,240},{-220,240}},
              color={255,204,51},
              thickness=0.5), Text(
              string="%first",
              index=-1,
              extent={{-6,3},{-6,3}},
              horizontalAlignment=TextAlignment.Right));
          if have_winSen then
          connect(ahuSubBusI.uWin[1:numZon], uWin[1:numZon]) annotation (Line(
              points={{-316,-2},{-264,-2},{-264,210},{-220,210}},
              color={255,204,51},
              thickness=0.5), Text(
              string="%first",
              index=-1,
              extent={{-6,3},{-6,3}},
              horizontalAlignment=TextAlignment.Right));
          end if;
          connect(ahuSubBusI.VDis_flow[1:numZon], VDis_flow[1:numZon]) annotation (Line(
              points={{-316,-2},{-266,-2},{-266,150},{-220,150}},
              color={255,204,51},
              thickness=0.5), Text(
              string="%first",
              index=-1,
              extent={{-6,3},{-6,3}},
              horizontalAlignment=TextAlignment.Right));
          connect(ahuSubBusI.ducStaPre, ducStaPre) annotation (Line(
              points={{-316,-2},{-266,-2},{-266,120},{-220,120}},
              color={255,204,51},
              thickness=0.5), Text(
              string="%first",
              index=-1,
              extent={{-6,3},{-6,3}},
              horizontalAlignment=TextAlignment.Right));
          if have_occSen then
          connect(ahuSubBusI.nOcc[1:numZon], nOcc[1:numZon]) annotation (Line(
              points={{-316,-2},{-264,-2},{-264,90},{-220,90}},
              color={255,204,51},
              thickness=0.5), Text(
              string="%first",
              index=-1,
              extent={{-6,3},{-6,3}},
              horizontalAlignment=TextAlignment.Right));
          end if;
          connect(ahuSubBusI.TZon[1:numZon], TZon[1:numZon]) annotation (Line(
              points={{-316,-2},{-264,-2},{-264,70},{-220,70}},
              color={255,204,51},
              thickness=0.5), Text(
              string="%first",
              index=-1,
              extent={{-6,3},{-6,3}},
              horizontalAlignment=TextAlignment.Right));
          connect(ahuSubBusI.TDis, TDis) annotation (Line(
              points={{-316,-2},{-264,-2},{-264,50},{-220,50}},
              color={255,204,51},
              thickness=0.5), Text(
              string="%first",
              index=-1,
              extent={{-6,3},{-6,3}},
              horizontalAlignment=TextAlignment.Right));
          connect(ahuSubBusI.TOutCut, TOutCut) annotation (Line(
              points={{-316,-2},{-264,-2},{-264,-10},{-220,-10}},
              color={255,204,51},
              thickness=0.5), Text(
              string="%first",
              index=-1,
              extent={{-6,3},{-6,3}},
              horizontalAlignment=TextAlignment.Right));
          connect(ahuSubBusI.hOut, hOut) annotation (Line(
              points={{-316,-2},{-264,-2},{-264,-40},{-220,-40}},
              color={255,204,51},
              thickness=0.5), Text(
              string="%first",
              index=-1,
              extent={{-6,3},{-6,3}},
              horizontalAlignment=TextAlignment.Right));
          connect(ahuSubBusI.hOutCut, hOutCut) annotation (Line(
              points={{-316,-2},{-264,-2},{-264,-70},{-220,-70}},
              color={255,204,51},
              thickness=0.5), Text(
              string="%first",
              index=-1,
              extent={{-6,3},{-6,3}},
              horizontalAlignment=TextAlignment.Right));
          connect(ahuSubBusI.VOut_flow, VOut_flow) annotation (Line(
              points={{-316,-2},{-262,-2},{-262,-100},{-220,-100}},
              color={255,204,51},
              thickness=0.5), Text(
              string="%first",
              index=-1,
              extent={{-6,3},{-6,3}},
              horizontalAlignment=TextAlignment.Right));
          connect(ahuSubBusI.uOpeMod, uOpeMod) annotation (Line(
              points={{-316,-2},{-290,-2},{-290,0},{-264,0},{-264,-160},{-220,-160}},
              color={255,204,51},
              thickness=0.5), Text(
              string="%first",
              index=-1,
              extent={{-6,3},{-6,3}},
              horizontalAlignment=TextAlignment.Right));
          connect(ahuSubBusI.uZonTemResReq, uZonTemResReq) annotation (Line(
              points={{-316,-2},{-296,-2},{-296,-4},{-264,-4},{-264,-190},{-220,-190}},
              color={255,204,51},
              thickness=0.5), Text(
              string="%first",
              index=-1,
              extent={{-6,3},{-6,3}},
              horizontalAlignment=TextAlignment.Right));
          connect(ahuSubBusI.uZonPreResReq, uZonPreResReq) annotation (Line(
              points={{-316,-2},{-262,-2},{-262,-220},{-220,-220}},
              color={255,204,51},
              thickness=0.5), Text(
              string="%first",
              index=-1,
              extent={{-6,3},{-6,3}},
              horizontalAlignment=TextAlignment.Right));
          connect(ahuSubBusI.uFreProSta, uFreProSta) annotation (Line(
              points={{-316,-2},{-298,-2},{-298,0},{-262,0},{-262,-250},{-220,-250}},
              color={255,204,51},
              thickness=0.5), Text(
              string="%first",
              index=-1,
              extent={{-6,3},{-6,3}},
              horizontalAlignment=TextAlignment.Right));
          connect(ySupFan, ahuSubBusO.ySupFan) annotation (Line(points={{220,190},{296,190},{296,40}}, color={255,0,255}), Text(
              string="%second",
              index=1,
              extent={{6,3},{6,3}},
              horizontalAlignment=TextAlignment.Left));
          connect(ySupFanSpe, ahuSubBusO.ySupFanSpe) annotation (Line(points={{220,130},{258,130},{258,40},{296,40}}, color={0,0,
                  127}), Text(
              string="%second",
              index=1,
              extent={{6,3},{6,3}},
              horizontalAlignment=TextAlignment.Left));
          connect(TSupSet, ahuSubBusO.tSupSet) annotation (Line(points={{220,90},{258,90},{258,40},{296,40}}, color={0,0,127}),
              Text(
              string="%second",
              index=1,
              extent={{6,3},{6,3}},
              horizontalAlignment=TextAlignment.Left));
          connect(yHea, ahuSubBusO.yHea) annotation (Line(points={{220,50},{258,50},{258,40},{296,40}}, color={0,0,127}), Text(
              string="%second",
              index=1,
              extent={{6,3},{6,3}},
              horizontalAlignment=TextAlignment.Left));
          connect(yCoo, ahuSubBusO.yCoo) annotation (Line(points={{220,0},{258,0},{258,40},{296,40}}, color={0,0,127}), Text(
              string="%second",
              index=1,
              extent={{6,3},{6,3}},
              horizontalAlignment=TextAlignment.Left));
          connect(yRetDamPos, ahuSubBusO.yRetDamPos) annotation (Line(points={{220,-40},{296,-40},{296,40}}, color={0,0,127}),
              Text(
              string="%second",
              index=1,
              extent={{-3,6},{-3,6}},
              horizontalAlignment=TextAlignment.Right));
          connect(yOutDamPos, ahuSubBusO.yOutDamPos) annotation (Line(points={{220,-140},{296,-140},{296,40}}, color={0,0,127}),
              Text(
              string="%second",
              index=1,
              extent={{-3,6},{-3,6}},
              horizontalAlignment=TextAlignment.Right));
          connect(ahuSubBusI.TSup, TSup) annotation (Line(
              points={{-316,-2},{-266,-2},{-266,20},{-220,20}},
              color={255,204,51},
              thickness=0.5), Text(
              string="%first",
              index=-1,
              extent={{-6,3},{-6,3}},
              horizontalAlignment=TextAlignment.Right));
          connect(ahuSubBusI.TMix, TMix) annotation (Line(
              points={{-316,-2},{-264,-2},{-264,-130},{-220,-130}},
              color={255,204,51},
              thickness=0.5), Text(
              string="%first",
              index=-1,
              extent={{-3,6},{-3,6}},
              horizontalAlignment=TextAlignment.Right));
          connect(ahuSubBusI.TOut, TOut) annotation (Line(
              points={{-316,-2},{-266,-2},{-266,181},{-220,181},{-220,180}},
              color={255,204,51},
              thickness=0.5), Text(
              string="%first",
              index=-1,
              extent={{-3,-6},{-3,-6}},
              horizontalAlignment=TextAlignment.Right));
          connect(ahuSubBusI, ahuBus.ahuI) annotation (Line(
              points={{-316,-2},{-334,-2},{-334,-423.9},{2.1,-423.9}},
              color={255,204,51},
              thickness=0.5), Text(
              string="%second",
              index=-1,
              extent={{-6,3},{-6,3}},
              horizontalAlignment=TextAlignment.Right));
          connect(ahuSubBusO, ahuBus)
            annotation (Line(
              points={{296,40},{322,40},{322,-424},{2,-424}},
              color={255,204,51},
              thickness=0.5));
        annotation (defaultComponentName="conAHU",
            Diagram(coordinateSystem(extent={{-200,-280},{200,280}}, initialScale=0.2)),
            Icon(coordinateSystem(extent={{-200,-280},{200,280}}, initialScale=0.2),
                graphics={Rectangle(
                  extent={{200,280},{-200,-280}},
                  lineColor={0,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid), Text(
                  extent={{-148,328},{152,288}},
                  textString="%name",
                  lineColor={0,0,255})}),
        Documentation(info="<html>
<p>
Block that is applied for multizone VAV AHU control. It outputs the supply fan status
and the operation speed, outdoor and return air damper position, supply air
temperature setpoint and the valve position of the cooling and heating coils.
It is implemented according to the ASHRAE Guideline 36, PART5.N.
</p>
<p>
The sequence consists of five subsequences.
</p>
<h4>Supply fan speed control</h4>
<p>
The fan speed control is implemented according to PART5.N.1. It outputs
the boolean signal <code>ySupFan</code> to turn on or off the supply fan.
In addition, based on the pressure reset request <code>uZonPreResReq</code>
from the VAV zones controller, the
sequence resets the duct pressure setpoint, and uses this setpoint
to modulate the fan speed <code>ySupFanSpe</code> using a PI controller.
See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.SupplyFan\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.SupplyFan</a>
for more detailed description.
</p>
<h4>Minimum outdoor airflow setting</h4>
<p>
According to current occupany <code>nOcc</code>, supply operation status
<code>ySupFan</code>, zone temperatures <code>TZon</code> and the discharge
air temperature <code>TDis</code>, the sequence computes the minimum outdoor airflow rate
setpoint, which is used as input for the economizer control. More detailed
information can be found in
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutsideAirFlow\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutsideAirFlow</a>.
</p>
<h4>Economizer control</h4>
<p>
The block outputs outdoor and return air damper position, <code>yOutDamPos</code> and
<code>yRetDamPos</code>. First, it computes the position limits to satisfy the minimum
outdoor airflow requirement. Second, it determines the availability of the economizer based
on the outdoor condition. The dampers are modulated to track the supply air temperature
loop signal, which is calculated from the sequence below, subject to the minimum outdoor airflow
requirement and economizer availability. Optionally, there is also an override for freeze protection.
See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Economizers.Controller\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Economizers.Controller</a>
for more detailed description.
</p>
<h4>Supply air temperature setpoint</h4>
<p>
Based on PART5.N.2, the sequence first sets the maximum supply air temperature
based on reset requests collected from each zone <code>uZonTemResReq</code>. The
outdoor temperature <code>TOut</code> and operation mode <code>uOpeMod</code> are used
along with the maximum supply air temperature, for computing the supply air temperature
setpoint. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.SupplyTemperature\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.SupplyTemperature</a>
for more detailed description.
</p>
<h4>Coil valve control</h4>
<p>
The subsequence retrieves supply air temperature setpoint from previous sequence.
Along with the measured supply air temperature and the supply fan status, it
generates coil valve positions. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.SupplySignals\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.SupplySignals</a>
</p>
</html>",
        revisions="<html>
<ul>
<li>
October 27, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
        end Controller;

        model DummyCentral
          "Central system to which the terminal units are connected, e.g., AHU or plant"
          extends Modelica.Blocks.Icons.Block;
          parameter Integer nTer = 5
            "Number of connected terminal units";
          parameter Boolean tesStaAhu = false
            "Boolean flag for testing staAhu";
          Modelica.Blocks.Sources.RealExpression outSig[nTer](y={i for i in 1:nTer})
            "Output signal to terminal units"
            annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
          BaseClasses.AhuBus ahuBus(nTer=nTer)
            annotation (Placement(transformation(
                  extent={{20,-20},{60,20}}), iconTransformation(extent={{20,-22},{60,
                    20}})));
          Controls.OBC.CDL.Logical.Sources.Constant staAhu(k=true) if tesStaAhu
            annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
          Modelica.Blocks.Routing.RealPassThrough inpSig[nTer]
            annotation (Placement(transformation(extent={{-40,-50},{-60,-30}})));
        equation
          connect(outSig.y, ahuBus.ahuTer.outSig) annotation (Line(points={{-39,0},{0,0},
                  {0,0.1},{40.1,0.1}}, color={0,0,127}), Text(
              string="%second",
              index=1,
              extent={{6,3},{6,3}},
              horizontalAlignment=TextAlignment.Left));
          connect(staAhu.y, ahuBus.staAhu) annotation (Line(points={{-38,40},{40.1,40},{
                  40.1,0.1}}, color={255,0,255}), Text(
              string="%second",
              index=1,
              extent={{6,3},{6,3}},
              horizontalAlignment=TextAlignment.Left));
          connect(inpSig.u, ahuBus.ahuTer.inpSig) annotation (Line(points={{-38,-40},{
                  40.1,-40},{40.1,0.1}}, color={0,0,127}), Text(
              string="%second",
              index=1,
              extent={{6,3},{6,3}},
              horizontalAlignment=TextAlignment.Left));
          annotation (                                         Diagram(
                coordinateSystem(preserveAspectRatio=false, extent={{-80,-60},{60,60}})));
        end DummyCentral;

        model DummyCentralBug
          "Central system to which the terminal units are connected, e.g., AHU or plant"
          extends Modelica.Blocks.Icons.Block;
          parameter Integer nTer = 5
            "Number of connected terminal units";
          parameter Boolean tesStaAhu = false
            "Boolean flag for testing staAhu";
          Modelica.Blocks.Sources.RealExpression outSig[nTer](y={i for i in 1:nTer})
            "Output signal to terminal units"
            annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
          Modelica.Blocks.Routing.RealPassThrough inpSig[nTer]
            annotation (Placement(transformation(extent={{-40,-50},{-60,-30}})));
          BaseClasses.TerminalBus terBus[nTer]
            annotation (Placement(transformation(extent={{12,-20},{52,20}})));
        equation
          connect(outSig.y, terBus.outSig) annotation (Line(points={{-39,0},{32,0}},
                color={0,0,127}), Text(
              string="%second",
              index=1,
              extent={{6,3},{6,3}},
              horizontalAlignment=TextAlignment.Left));
          connect(inpSig.u, terBus.inpSig) annotation (Line(points={{-38,-40},{32,-40},
                  {32,0}}, color={0,0,127}), Text(
              string="%second",
              index=1,
              extent={{6,3},{6,3}},
              horizontalAlignment=TextAlignment.Left));
          annotation (                                         Diagram(
                coordinateSystem(preserveAspectRatio=false, extent={{-80,-60},{60,20}})));
        end DummyCentralBug;

        model DummyCentralComplex
          "Central system to which the terminal units are connected, e.g., AHU or plant"
          extends Modelica.Blocks.Icons.Block;
          parameter Integer nTer = 5
            "Number of connected components";
          Modelica.Blocks.Sources.RealExpression outSig[nTer](y={i for i in 1:nTer})
            "Output signal to terminal units"
            annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
          Modelica.Blocks.Routing.RealPassThrough inpSig[nTer]
            annotation (Placement(transformation(extent={{-40,-50},{-60,-30}})));
          BaseClasses.AhuBus ahuBus[nTer] annotation (Placement(transformation(extent={{
                    40,-20},{80,20}}), iconTransformation(extent={{-6,-12},{14,8}})));
        protected
          BaseClasses.AhuSubBusO ahuSubBusO[nTer]
            annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
          BaseClasses.AhuSubBusI ahuSubBusI[nTer]
            annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
        equation
          connect(outSig.y, ahuSubBusO.outSig) annotation (Line(points={{-39,0},{0,0}},
                color={0,0,127}), Text(
              string="%second",
              index=1,
              extent={{6,3},{6,3}},
              horizontalAlignment=TextAlignment.Left));
          connect(ahuSubBusO, ahuBus.ahuO) annotation (Line(
              points={{0,0},{30,0},{30,0.1},{60.1,0.1}},
              color={255,204,51},
              thickness=0.5), Text(
              string="%second",
              index=-1,
              extent={{-6,3},{-6,3}},
              horizontalAlignment=TextAlignment.Right));
          connect(ahuBus.ahuI, ahuSubBusI) annotation (Line(
              points={{60.1,0.1},{60.1,-40},{0,-40}},
              color={255,204,51},
              thickness=0.5), Text(
              string="%first",
              index=1,
              extent={{-3,-6},{-3,-6}},
              horizontalAlignment=TextAlignment.Right));
          connect(ahuSubBusI.inpSig, inpSig.u) annotation (Line(
              points={{0,-40},{-38,-40}},
              color={255,204,51},
              thickness=0.5), Text(
              string="%first",
              index=-1,
              extent={{6,3},{6,3}},
              horizontalAlignment=TextAlignment.Left));
          annotation (Diagram(
                coordinateSystem(preserveAspectRatio=false, extent={{-80,-60},{80,20}})));
        end DummyCentralComplex;

        model DummyCentralComplexBug
          "Central system to which the terminal units are connected, e.g., AHU or plant"
          extends Modelica.Blocks.Icons.Block;
          parameter Integer nTer = 5
            "Number of connected components";
          Modelica.Blocks.Sources.RealExpression outSig[nTer](y={i for i in 1:nTer})
            "Output signal to terminal units"
            annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
          Modelica.Blocks.Routing.RealPassThrough inpSig[nTer]
            annotation (Placement(transformation(extent={{-40,-50},{-60,-30}})));
          BaseClasses.AhuBus ahuBus[nTer] annotation (Placement(transformation(extent={{
                    40,-20},{80,20}}), iconTransformation(extent={{-6,-12},{14,8}})));
        protected
          BaseClasses.AhuSubBusO ahuSubBusO[nTer]
            annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
        equation
          connect(outSig.y, ahuSubBusO.outSig) annotation (Line(points={{-39,0},{0,0}},
                color={0,0,127}), Text(
              string="%second",
              index=1,
              extent={{6,3},{6,3}},
              horizontalAlignment=TextAlignment.Left));
          connect(ahuSubBusO, ahuBus.ahuO) annotation (Line(
              points={{0,0},{30,0},{30,0.1},{60.1,0.1}},
              color={255,204,51},
              thickness=0.5), Text(
              string="%second",
              index=-1,
              extent={{-6,3},{-6,3}},
              horizontalAlignment=TextAlignment.Right));
          connect(ahuBus.ahuI.inpSig, inpSig.u) annotation (Line(
              points={{60.1,0.1},{60.1,-40},{-38,-40}},
              color={255,204,51},
              thickness=0.5), Text(
              string="%first",
              index=-1,
              extent={{6,3},{6,3}},
              horizontalAlignment=TextAlignment.Left));
          annotation (Diagram(
                coordinateSystem(preserveAspectRatio=false, extent={{-80,-60},{80,20}})));
        end DummyCentralComplexBug;

        model DummyTerminal
          extends Modelica.Blocks.Icons.Block;
          parameter Integer indTer
            "Terminal index used for testing purposes";
          parameter Boolean tesStaAhu = false
            "Boolean flag for testing staAhu";
          Modelica.Blocks.Sources.RealExpression inpSig(y=time*indTer)
            "Input signal to AHU controller"
            annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
          Modelica.Blocks.Routing.RealPassThrough outSig
            annotation (Placement(transformation(extent={{-40,-50},{-60,-30}})));
          BaseClasses.TerminalBus terBus
            annotation (Placement(transformation(extent={{20,
                    -20},{60,20}}), iconTransformation(extent={{20,-20},{60,20}})));
          Modelica.Blocks.Routing.BooleanPassThrough staAhu if tesStaAhu
            annotation (Placement(transformation(extent={{-40,-90},{-60,-70}})));
        equation
          connect(terBus.outSig, outSig.u) annotation (Line(
              points={{40,0},{40,-40},{-38,-40}},
              color={255,204,51},
              thickness=0.5), Text(
              string="%first",
              index=-1,
              extent={{-3,6},{-3,6}},
              horizontalAlignment=TextAlignment.Right));
          connect(terBus.staAhu, staAhu.u) annotation (Line(
              points={{40.1,0.1},{40.1,-80},{-38,-80}},
              color={255,204,51},
              thickness=0.5), Text(
              string="%first",
              index=-1,
              extent={{-3,-6},{-3,-6}},
              horizontalAlignment=TextAlignment.Right));
          connect(inpSig.y, terBus.inpSig) annotation (Line(points={{-39,0},{40,0}},
                color={0,0,127}), Text(
              string="%second",
              index=1,
              extent={{6,3},{6,3}},
              horizontalAlignment=TextAlignment.Left));
          annotation (
          Diagram(
                coordinateSystem(preserveAspectRatio=false, extent={{-80,-100},{60,20}})));
        end DummyTerminal;

        model DummyTerminalComplex
          extends Modelica.Blocks.Icons.Block;
          parameter Integer indTer
            "Terminal index used for testing purposes";
          Modelica.Blocks.Sources.RealExpression inpSig(y=time*indTer)
            "Input signal to AHU controller"
            annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
          Modelica.Blocks.Routing.RealPassThrough outSig
            annotation (Placement(transformation(extent={{-40,-50},{-60,-30}})));
          BaseClasses.AhuBus ahuBus annotation (Placement(transformation(extent={{40,-20},
                    {80,20}}), iconTransformation(extent={{-4,-10},{16,10}})));
        protected
          BaseClasses.AhuSubBusI ahuSubBusI
            annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
          BaseClasses.AhuSubBusO ahuSubBusO
            annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
        equation
          connect(inpSig.y, ahuSubBusI.inpSig) annotation (Line(points={{-39,0},{0,0}},
                color={0,0,127}), Text(
              string="%second",
              index=1,
              extent={{6,3},{6,3}},
              horizontalAlignment=TextAlignment.Left));
          connect(ahuSubBusI, ahuBus.ahuI) annotation (Line(
              points={{0,0},{38,0},{38,0.1},{60.1,0.1}},
              color={255,204,51},
              thickness=0.5), Text(
              string="%second",
              index=-1,
              extent={{-6,3},{-6,3}},
              horizontalAlignment=TextAlignment.Right));
          connect(ahuBus.ahuO, ahuSubBusO) annotation (Line(
              points={{60.1,0.1},{60.1,-40},{0,-40}},
              color={255,204,51},
              thickness=0.5), Text(
              string="%first",
              index=1,
              extent={{-3,-6},{-3,-6}},
              horizontalAlignment=TextAlignment.Right));
          connect(ahuSubBusO.outSig, outSig.u) annotation (Line(
              points={{0,-40},{-38,-40}},
              color={255,204,51},
              thickness=0.5), Text(
              string="%first",
              index=-1,
              extent={{6,3},{6,3}},
              horizontalAlignment=TextAlignment.Left));
          annotation (                                          Diagram(
                coordinateSystem(preserveAspectRatio=false, extent={{-80,-60},{80,20}})));
        end DummyTerminalComplex;

        package Validation
            extends Modelica.Icons.ExamplesPackage;
          model Controller "Validation controller model"
            extends Modelica.Icons.Example;
            Buildings.Experimental.Templates_V1.Commercial.VAV.Controller.Controller
              conAHU(
              numZon=2,
              AFlo={50,50},
              have_perZonRehBox=false,
              controllerTypeMinOut=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
              controllerTypeFre=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
              controllerTypeFanSpe=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
              minZonPriFlo={(50*3/3600)*6,(50*3/3600)*6},
              VPriSysMax_flow=0.7*(50*3/3600)*6*2,
              have_occSen=true,
              controllerTypeTSup=Buildings.Controls.OBC.CDL.Types.SimpleController.PI)
              "Multiple zone AHU controller" annotation (Placement(
                  transformation(extent={{60,48},{140,152}})));

            Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetRooCooOn(
              final k=273.15 + 24)
              "Cooling on setpoint"
              annotation (Placement(transformation(extent={{-100,133},{-80,154}})));
            Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetRooHeaOn(
              final k=273.15 + 20)
              "Heating on setpoint"
              annotation (Placement(transformation(extent={{-220,149},{-200,170}})));
            Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOutCut(
              final k=297.15)
              "Outdoor temperature high limit cutoff"
              annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
            Buildings.Controls.OBC.CDL.Integers.Sources.Constant opeMod(
              final k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.occupied)
              "AHU operation mode is occupied"
              annotation (Placement(transformation(extent={{20,50},{0,70}})));
            Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TZon[2](
              each height=6,
              each offset=273.15 + 17,
              each duration=3600) "Measured zone temperature"
              annotation (Placement(transformation(extent={{-100,100},{-80,120}})));
            Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TDis[2](
              each height=4,
              each duration=3600,
              each offset=273.15 + 18) "Terminal unit discharge air temperature"
              annotation (Placement(transformation(extent={{-220,82},{-200,102}})));
            Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp numOfOcc1(
              height=2,
              duration=3600)
              "Occupant number in zone 1"
              annotation (Placement(transformation(extent={{-220,20},{-200,40}})));
            Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp numOfOcc2(
              duration=3600,
              height=3)
              "Occupant number in zone 2"
              annotation (Placement(transformation(extent={{-150,20},{-130,40}})));
            Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TSup(
              height=4,
              duration=3600,
              offset=273.15 + 14) "AHU supply air temperature"
              annotation (Placement(transformation(extent={{-220,52},{-200,72}})));
            Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp VOut_flow(
              duration=1800,
              offset=0.02,
              height=0.0168)
              "Measured outdoor airflow rate"
              annotation (Placement(transformation(extent={{-220,-14},{-200,6}})));
            Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp vavBoxFlo1(
              height=1.5,
              offset=1,
              duration=3600)
              "Ramp signal for generating VAV box flow rate"
              annotation (Placement(transformation(extent={{-220,-48},{-200,-28}})));
            Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp vavBoxFlo2(
              offset=1,
              height=0.5,
              duration=3600)
              "Ramp signal for generating VAV box flow rate"
              annotation (Placement(transformation(extent={{-220,-80},{-200,-60}})));
            Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TMixMea(
              height=4,
              duration=1,
              offset=273.15 + 2,
              startTime=0)
              "Measured mixed air temperature"
              annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
            Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TOut(
              amplitude=5,
              offset=18 + 273.15,
              freqHz=1/3600) "Outdoor air temperature"
              annotation (Placement(transformation(extent={{-220,116},{-200,136}})));
            Buildings.Controls.OBC.CDL.Continuous.Sources.Sine ducStaPre(
              offset=200,
              amplitude=150,
              freqHz=1/3600) "Duct static pressure"
              annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
            Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sine(
              offset=3,
              amplitude=2,
              freqHz=1/9600) "Duct static pressure setpoint reset requests"
              annotation (Placement(transformation(extent={{-220,-150},{-200,-130}})));
            Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sine1(
              amplitude=6,
              freqHz=1/9600)
              "Maximum supply temperature setpoint reset"
              annotation (Placement(transformation(extent={{-220,-110},{-200,-90}})));
            Buildings.Controls.OBC.CDL.Continuous.Abs abs
              "Block generates absolute value of input"
              annotation (Placement(transformation(extent={{-180,-110},{-160,-90}})));
            Buildings.Controls.OBC.CDL.Continuous.Abs abs1
              "Block generates absolute value of input"
              annotation (Placement(transformation(extent={{-180,-150},{-160,-130}})));
            Buildings.Controls.OBC.CDL.Continuous.Round round1(n=0)
              "Round real number to given digits"
              annotation (Placement(transformation(extent={{-144,-110},{-124,-90}})));
            Buildings.Controls.OBC.CDL.Continuous.Round round2(n=0)
              "Round real number to given digits"
              annotation (Placement(transformation(extent={{-144,-150},{-124,-130}})));
            Buildings.Controls.OBC.CDL.Conversions.RealToInteger ducPreResReq "Convert real to integer"
              annotation (Placement(transformation(extent={{-110,-150},{-90,-130}})));
            Buildings.Controls.OBC.CDL.Conversions.RealToInteger maxSupResReq
              "Convert real to integer"
              annotation (Placement(transformation(extent={{-110,-110},{-90,-90}})));

            Controls.OBC.CDL.Conversions.RealToInteger occConv1 "Convert real to integer"
              annotation (Placement(transformation(extent={{-190,20},{-170,40}})));
            Controls.OBC.CDL.Conversions.RealToInteger occConv2 "Convert real to integer"
              annotation (Placement(transformation(extent={{-120,20},{-100,40}})));
            BaseClasses.AhuBus ahuBus annotation (Placement(transformation(extent={{-30,152},{10,192}}), iconTransformation(
                    extent={{-254,122},{-234,142}})));
            BaseClasses.AhuSubBusI ahuSubBusI annotation (Placement(transformation(extent={{-50,162},{-30,182}}),
                  iconTransformation(extent={{-258,96},{-238,116}})));
          equation
            connect(sine.y,abs1. u)
              annotation (Line(points={{-198,-140},{-182,-140}}, color={0,0,127}));
            connect(abs1.y,round2. u)
              annotation (Line(points={{-158,-140},{-146,-140}},color={0,0,127}));
            connect(round2.y, ducPreResReq.u)
              annotation (Line(points={{-122,-140},{-112,-140}},
                                                               color={0,0,127}));
            connect(sine1.y, abs.u)
              annotation (Line(points={{-198,-100},{-182,-100}}, color={0,0,127}));
            connect(abs.y,round1. u)
              annotation (Line(points={{-158,-100},{-146,-100}},color={0,0,127}));
            connect(round1.y, maxSupResReq.u)
              annotation (Line(points={{-122,-100},{-112,-100}},
                                                               color={0,0,127}));

            connect(numOfOcc1.y, occConv1.u)
              annotation (Line(points={{-198,30},{-192,30}}, color={0,0,127}));
            connect(numOfOcc2.y, occConv2.u)
              annotation (Line(points={{-128,30},{-122,30}},
                                                           color={0,0,127}));
            connect(TSetRooHeaOn.y, ahuSubBusI.TZonHeaSet) annotation (Line(points={{-198,159.5},{-120,159.5},{-120,172},{-40,172}},
                  color={0,0,127}), Text(
                string="%second",
                index=1,
                extent={{6,3},{6,3}},
                horizontalAlignment=TextAlignment.Left));
            connect(TSetRooCooOn.y, ahuSubBusI.TZonCooSet) annotation (Line(points={{-78,143.5},{-62,143.5},{-62,172},{-40,172}},
                  color={0,0,127}), Text(
                string="%second",
                index=1,
                extent={{6,3},{6,3}},
                horizontalAlignment=TextAlignment.Left));
            connect(TDis.y, ahuSubBusI.TDis) annotation (Line(points={{-198,92},{-120,92},{-120,172},{-40,172}}, color={0,0,127}),
                Text(
                string="%second",
                index=1,
                extent={{6,3},{6,3}},
                horizontalAlignment=TextAlignment.Left));
            connect(TZon.y, ahuSubBusI.TZon) annotation (Line(points={{-78,110},{-60,110},{-60,172},{-40,172}}, color={0,0,127}),
                Text(
                string="%second",
                index=1,
                extent={{6,3},{6,3}},
                horizontalAlignment=TextAlignment.Left));
            connect(TOutCut.y, ahuSubBusI.TOutCut) annotation (Line(points={{-78,70},{-58,70},{-58,172},{-40,172}}, color={0,0,
                    127}), Text(
                string="%second",
                index=1,
                extent={{6,3},{6,3}},
                horizontalAlignment=TextAlignment.Left));
            connect(VOut_flow.y, ahuSubBusI.VOut_flow) annotation (Line(points={{-198,-4},{-118,-4},{-118,172},{-40,172}}, color=
                    {0,0,127}), Text(
                string="%second",
                index=1,
                extent={{6,3},{6,3}},
                horizontalAlignment=TextAlignment.Left));
            connect(ducStaPre.y, ahuSubBusI.ducStaPre) annotation (Line(points={{-78,-10},{-60,-10},{-60,172},{-40,172}}, color={
                    0,0,127}), Text(
                string="%second",
                index=1,
                extent={{6,3},{6,3}},
                horizontalAlignment=TextAlignment.Left));
            connect(occConv1.y, ahuSubBusI.nOcc[1]) annotation (Line(points={{-168,30},{-80,30},{-80,172},{-40,172}}, color={255,
                    127,0}), Text(
                string="%second",
                index=1,
                extent={{6,3},{6,3}},
                horizontalAlignment=TextAlignment.Left));
            connect(occConv2.y, ahuSubBusI.nOcc[2]) annotation (Line(points={{-98,30},{-46,30},{-46,172},{-40,172}}, color={255,
                    127,0}), Text(
                string="%second",
                index=1,
                extent={{6,3},{6,3}},
                horizontalAlignment=TextAlignment.Left));
            connect(vavBoxFlo1.y, ahuSubBusI.VDis_flow[1]) annotation (Line(points={{-198,-38},{-120,-38},{-120,172},{-40,172}},
                  color={0,0,127}), Text(
                string="%second",
                index=1,
                extent={{6,3},{6,3}},
                horizontalAlignment=TextAlignment.Left));
            connect(vavBoxFlo2.y, ahuSubBusI.VDis_flow[2]) annotation (Line(points={{-198,-70},{-118,-70},{-118,172},{-40,172}},
                  color={0,0,127}), Text(
                string="%second",
                index=1,
                extent={{6,3},{6,3}},
                horizontalAlignment=TextAlignment.Left));
            connect(ducPreResReq.y, ahuSubBusI.uZonPreResReq) annotation (Line(points={{-88,-140},{-40,-140},{-40,172}}, color={
                    255,127,0}), Text(
                string="%second",
                index=1,
                extent={{6,3},{6,3}},
                horizontalAlignment=TextAlignment.Left));
            connect(maxSupResReq.y, ahuSubBusI.uZonTemResReq) annotation (Line(points={{-88,-100},{-40,-100},{-40,172}}, color={
                    255,127,0}), Text(
                string="%second",
                index=1,
                extent={{6,3},{6,3}},
                horizontalAlignment=TextAlignment.Left));
            connect(opeMod.y, ahuSubBusI.uOpeMod) annotation (Line(points={{-2,60},{-30,60},{-30,172},{-40,172}}, color={255,127,
                    0}), Text(
                string="%second",
                index=1,
                extent={{-6,3},{-6,3}},
                horizontalAlignment=TextAlignment.Right));
            connect(TSup.y, ahuSubBusI.TSup) annotation (Line(points={{-198,62},{-120,62},{-120,172},{-40,172}}, color={0,0,127}),
                Text(
                string="%second",
                index=1,
                extent={{6,3},{6,3}},
                horizontalAlignment=TextAlignment.Left));
            connect(TMixMea.y, ahuSubBusI.TMix) annotation (Line(points={{-78,-50},{-58,-50},{-58,172},{-40,172}}, color={0,0,127}),
                Text(
                string="%second",
                index=1,
                extent={{6,3},{6,3}},
                horizontalAlignment=TextAlignment.Left));
            connect(TOut.y, ahuSubBusI.TOut) annotation (Line(points={{-198,126},{-120,126},{-120,172},{-40,172}}, color={0,0,127}),
                Text(
                string="%second",
                index=1,
                extent={{6,3},{6,3}},
                horizontalAlignment=TextAlignment.Left));
            connect(ahuSubBusI, ahuBus.ahuI) annotation (Line(
                points={{-40,172},{-24,172},{-24,172.1},{-9.9,172.1}},
                color={255,204,51},
                thickness=0.5), Text(
                string="%second",
                index=-1,
                extent={{-6,3},{-6,3}},
                horizontalAlignment=TextAlignment.Right));
            connect(ahuBus, conAHU.ahuBus) annotation (Line(
                points={{-10,172},{26,172},{26,100},{60,100}},
                color={255,204,51},
                thickness=0.5), Text(
                string="%first",
                index=-1,
                extent={{-6,3},{-6,3}},
                horizontalAlignment=TextAlignment.Right));
          annotation (experiment(StopTime=3600.0, Tolerance=1e-06),
            __Dymola_Commands,
              Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller</a>.
</p>
</html>",           revisions="<html>
<ul>
<li>
January 12, 2019, by Michael Wetter:<br/>
Removed wrong use of <code>each</code>.
</li>
<li>
October 30, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),Diagram(coordinateSystem(extent={{-240,-180},{240,180}})));
          end Controller;

          model ControllerConfigurationTest "Validates multizone controller model for boolean parameter values"
            extends Modelica.Icons.Example;
            Buildings.Experimental.Templates_V1.Commercial.VAV.Controller.Controller
              conAHU(
              numZon=2,
              AFlo={50,50},
              have_winSen=false,
              have_perZonRehBox=true,
              controllerTypeMinOut=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
              controllerTypeFre=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
              controllerTypeFanSpe=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
              minZonPriFlo={(50*3/3600)*6,(50*3/3600)*6},
              VPriSysMax_flow=0.7*(50*3/3600)*6*2,
              have_occSen=true,
              controllerTypeTSup=Buildings.Controls.OBC.CDL.Types.SimpleController.PI)
              "Multiple zone AHU controller" annotation (Placement(
                  transformation(extent={{-260,48},{-180,152}})));

            Buildings.Experimental.Templates_V1.Commercial.VAV.Controller.Controller
              conAHU1(
              numZon=2,
              AFlo={50,50},
              have_winSen=false,
              have_perZonRehBox=false,
              have_duaDucBox=true,
              controllerTypeMinOut=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
              controllerTypeFre=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
              controllerTypeFanSpe=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
              minZonPriFlo={(50*3/3600)*6,(50*3/3600)*6},
              VPriSysMax_flow=0.7*(50*3/3600)*6*2,
              have_occSen=true,
              controllerTypeTSup=Buildings.Controls.OBC.CDL.Types.SimpleController.PI)
              "Multiple zone AHU controller" annotation (Placement(
                  transformation(extent={{-120,48},{-40,152}})));

            Buildings.Experimental.Templates_V1.Commercial.VAV.Controller.Controller
              conAHU2(
              numZon=2,
              AFlo={50,50},
              have_winSen=true,
              have_perZonRehBox=true,
              have_duaDucBox=false,
              controllerTypeMinOut=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
              controllerTypeFre=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
              controllerTypeFanSpe=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
              minZonPriFlo={(50*3/3600)*6,(50*3/3600)*6},
              VPriSysMax_flow=0.7*(50*3/3600)*6*2,
              have_occSen=false,
              controllerTypeTSup=Buildings.Controls.OBC.CDL.Types.SimpleController.PI)
              "Multiple zone AHU controller" annotation (Placement(
                  transformation(extent={{40,48},{120,152}})));

            Buildings.Experimental.Templates_V1.Commercial.VAV.Controller.Controller
              conAHU3(
              numZon=2,
              AFlo={50,50},
              have_winSen=false,
              have_perZonRehBox=true,
              use_enthalpy=true,
              controllerTypeMinOut=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
              controllerTypeFre=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
              controllerTypeFanSpe=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
              minZonPriFlo={(50*3/3600)*6,(50*3/3600)*6},
              VPriSysMax_flow=0.7*(50*3/3600)*6*2,
              have_occSen=false,
              controllerTypeTSup=Buildings.Controls.OBC.CDL.Types.SimpleController.PI)
              "Multiple zone AHU controller" annotation (Placement(
                  transformation(extent={{222,48},{302,152}})));

            Buildings.Experimental.Templates_V1.Commercial.VAV.Controller.Controller
              conAHU4(
              numZon=2,
              AFlo={50,50},
              have_winSen=false,
              have_perZonRehBox=true,
              use_enthalpy=false,
              controllerTypeMinOut=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
              use_TMix=false,
              use_G36FrePro=true,
              controllerTypeFre=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
              controllerTypeFanSpe=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
              minZonPriFlo={(50*3/3600)*6,(50*3/3600)*6},
              VPriSysMax_flow=0.7*(50*3/3600)*6*2,
              have_occSen=false,
              controllerTypeTSup=Buildings.Controls.OBC.CDL.Types.SimpleController.PI)
              "Multiple zone AHU controller" annotation (Placement(
                  transformation(extent={{462,48},{542,152}})));

            BaseClasses.AhuSubBusI ahuSubBusI annotation (Placement(transformation(extent={{-350,322},{-330,342}}),
                  iconTransformation(extent={{-258,96},{-238,116}})));
            BaseClasses.AhuBus ahuBus annotation (Placement(transformation(extent={{-296,178},{-256,218}}), iconTransformation(
                    extent={{-656,112},{-636,132}})));
            BaseClasses.AhuBus ahuBus1
                                      annotation (Placement(transformation(extent={{-150,182},{-110,222}}), iconTransformation(
                    extent={{-656,112},{-636,132}})));
            BaseClasses.AhuBus ahuBus2
                                      annotation (Placement(transformation(extent={{8,180},{48,220}}),      iconTransformation(
                    extent={{-656,112},{-636,132}})));
            BaseClasses.AhuBus ahuBus3
                                      annotation (Placement(transformation(extent={{190,180},{230,220}}),   iconTransformation(
                    extent={{-656,112},{-636,132}})));
            BaseClasses.AhuBus ahuBus4
                                      annotation (Placement(transformation(extent={{384,180},{424,220}}),   iconTransformation(
                    extent={{-656,112},{-636,132}})));
          protected
            Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetRooCooOn(
              final k=273.15 + 24)
              "Cooling on setpoint"
              annotation (Placement(transformation(extent={{-420,280},{-400,300}})));

            Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetRooHeaOn(
              final k=273.15 + 20)
              "Heating on setpoint"
              annotation (Placement(transformation(extent={{-460,300},{-440,320}})));

            Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOutCut(
              final k=297.15) "Outdoor temperature high limit cutoff"
              annotation (Placement(transformation(extent={{-420,190},{-400,210}})));

            Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TZon[2](
              each final height=6,
              each final offset=273.15 + 17,
              each final duration=3600) "Measured zone temperature"
              annotation (Placement(transformation(extent={{-458,250},{-438,270}})));

            Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TDis[2](
              each final height=4,
              each final duration=3600,
              each final offset=273.15 + 18) "Terminal unit discharge air temperature"
              annotation (Placement(transformation(extent={{-460,160},{-440,180}})));

            Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TSup(
              final height=4,
              final duration=3600,
              final offset=273.15 + 14) "AHU supply air temperature"
              annotation (Placement(transformation(extent={{-460,210},{-440,230}})));

            Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp VOut_flow(
              final duration=1800,
              final offset=0.02,
              final height=0.0168) "Measured outdoor airflow rate"
              annotation (Placement(transformation(extent={{-460,-18},{-440,2}})));

            Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp vavBoxFlo1(
              final height=1.5,
              final offset=1,
              final duration=3600) "Ramp signal for generating VAV box flow rate"
              annotation (Placement(transformation(extent={{-460,-70},{-440,-50}})));

            Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp vavBoxFlo2(
              final offset=1,
              final height=0.5,
              final duration=3600) "Ramp signal for generating VAV box flow rate"
              annotation (Placement(transformation(extent={{-460,-102},{-440,-82}})));

            Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TMixMea(
              final height=4,
              final duration=1,
              final offset=273.15 + 2,
              final startTime=0) "Measured mixed air temperature"
              annotation (Placement(transformation(extent={{-360,-100},{-340,-80}})));

            Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TOut(
              final amplitude=5,
              final offset=18 + 273.15,
              final freqHz=1/3600) "Outdoor air temperature"
              annotation (Placement(transformation(extent={{-420,230},{-400,250}})));

            Buildings.Controls.OBC.CDL.Continuous.Sources.Sine ducStaPre(
              final offset=200,
              final amplitude=150,
              final freqHz=1/3600) "Duct static pressure"
              annotation (Placement(transformation(extent={{-380,-18},{-360,2}})));

            Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sine(
              final offset=3,
              final amplitude=2,
              final freqHz=1/9600) "Duct static pressure setpoint reset requests"
              annotation (Placement(transformation(extent={{-460,-222},{-440,-202}})));

            Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sine1(
              final amplitude=6,
              final freqHz=1/9600)
              "Maximum supply temperature setpoint reset"
              annotation (Placement(transformation(extent={{-460,-180},{-440,-160}})));

            Buildings.Controls.OBC.CDL.Continuous.Abs abs
              "Block generates absolute value of input"
              annotation (Placement(transformation(extent={{-420,-180},{-400,-160}})));

            Buildings.Controls.OBC.CDL.Continuous.Abs abs1
              "Block generates absolute value of input"
              annotation (Placement(transformation(extent={{-420,-222},{-400,-202}})));

            Buildings.Controls.OBC.CDL.Continuous.Round round1(final n=0)
              "Round real number to given digits"
              annotation (Placement(transformation(extent={{-380,-180},{-360,-160}})));

            Buildings.Controls.OBC.CDL.Continuous.Round round2(final n=0)
              "Round real number to given digits"
              annotation (Placement(transformation(extent={{-380,-222},{-360,-202}})));

            Buildings.Controls.OBC.CDL.Conversions.RealToInteger ducPreResReq
              "Convert real to integer"
              annotation (Placement(transformation(extent={{-340,-222},{-320,-202}})));

            Buildings.Controls.OBC.CDL.Conversions.RealToInteger maxSupResReq
              "Convert real to integer"
              annotation (Placement(transformation(extent={{-340,-180},{-320,-160}})));

            Buildings.Controls.OBC.CDL.Logical.Sources.Constant winSta[2](
              final k={true,false}) "Window status for each zone"
              annotation (Placement(transformation(extent={{-30,90},{-10,110}})));

            Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp numOfOcc1(
              final height=2,
              final duration=3600) "Occupant number in zone 1"
              annotation (Placement(transformation(extent={{-460,80},{-440,100}})));

            Buildings.Controls.OBC.CDL.Conversions.RealToInteger occConv1
              "Convert real to integer"
              annotation (Placement(transformation(extent={{-400,80},{-380,100}})));

            Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp numOfOcc2(
              final duration=3600,
              final height=3) "Occupant number in zone 2"
              annotation (Placement(transformation(extent={{-460,40},{-440,60}})));

            Buildings.Controls.OBC.CDL.Conversions.RealToInteger occConv2
              "Convert real to integer"
              annotation (Placement(transformation(extent={{-400,40},{-380,60}})));

            Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
              final period=10000,
              final startTime=500) "Logical pulse"
              annotation (Placement(transformation(extent={{382,0},{362,20}})));

            Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger freProSta1(
              final integerTrue=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.FreezeProtectionStages.stage2,
              final integerFalse=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.FreezeProtectionStages.stage1)
              "Freeze protection stage changes from stage 1 to stage 2"
              annotation (Placement(transformation(extent={{340,0},{320,20}})));

            Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ram(
              final duration=3600,
              final height=6) "Ramp signal for generating operation mode"
              annotation (Placement(transformation(extent={{-460,-140},{-440,-120}})));

            Buildings.Controls.OBC.CDL.Continuous.Abs abs2
              "Block generates absolute value of input"
              annotation (Placement(transformation(extent={{-420,-140},{-400,-120}})));

            Buildings.Controls.OBC.CDL.Continuous.Round round3(final n=0)
              "Round real number to given digits"
              annotation (Placement(transformation(extent={{-380,-140},{-360,-120}})));

            Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
              "Convert real to integer"
              annotation (Placement(transformation(extent={{-340,-140},{-320,-120}})));

            Buildings.Controls.OBC.CDL.Continuous.Sources.Constant hOutBelowCutoff(
              final k=45000)
              "Outdoor air enthalpy is slightly below the cutoff"
              annotation (Placement(transformation(extent={{140,140},{160,160}})));

            Buildings.Controls.OBC.CDL.Continuous.Sources.Constant hOutCut(final k=65100)
              "Outdoor air enthalpy cutoff"
              annotation (Placement(transformation(extent={{142,100},{162,120}})));

          equation
            connect(ram.y, abs2.u)
              annotation (Line(points={{-438,-130},{-422,-130}},color={0,0,127}));
            connect(abs2.y, round3.u)
              annotation (Line(points={{-398,-130},{-382,-130}},color={0,0,127}));
            connect(round3.y, reaToInt2.u)
              annotation (Line(points={{-358,-130},{-342,-130}},color={0,0,127}));
            connect(sine1.y, abs.u)
              annotation (Line(points={{-438,-170},{-422,-170}},color={0,0,127}));
            connect(abs.y, round1.u)
              annotation (Line(points={{-398,-170},{-382,-170}},color={0,0,127}));
            connect(round1.y, maxSupResReq.u)
              annotation (Line(points={{-358,-170},{-342,-170}},color={0,0,127}));
            connect(round2.y, ducPreResReq.u)
              annotation (Line(points={{-358,-212},{-354,-212},{-354,-214},{-350,-214},{-350,-212},{-342,-212}},
                                       color={0,0,127}));
            connect(abs1.y, round2.u)
              annotation (Line(points={{-398,-212},{-394,-212},{-394,-214},{-390,-214},{-390,-212},{-382,-212}},
                                       color={0,0,127}));
            connect(sine.y, abs1.u)
              annotation (Line(points={{-438,-212},{-434,-212},{-434,-214},{-430,-214},{-430,-212},{-422,-212}},
                                        color={0,0,127}));
            connect(numOfOcc2.y, occConv2.u)
              annotation (Line(points={{-438,50},{-402,50}}, color={0,0,127}));
            connect(numOfOcc1.y, occConv1.u)
              annotation (Line(points={{-438,90},{-402,90}}, color={0,0,127}));
            connect(TSetRooHeaOn.y, ahuSubBusI.TZonHeaSet) annotation (Line(points={{-438,310},{-390,310},{-390,332},{-340,332}},
                  color={0,0,127}), Text(
                string="%second",
                index=1,
                extent={{6,3},{6,3}},
                horizontalAlignment=TextAlignment.Left));
            connect(TSetRooCooOn.y, ahuSubBusI.TZonCooSet) annotation (Line(points={{-398,290},{-370,290},{-370,332},{-340,332}},
                  color={0,0,127}), Text(
                string="%second",
                index=1,
                extent={{6,3},{6,3}},
                horizontalAlignment=TextAlignment.Left));
            connect(TZon.y, ahuSubBusI.TZon) annotation (Line(points={{-436,260},{-360,260},{-360,332},{-340,332}}, color={0,0,127}),
                Text(
                string="%second",
                index=1,
                extent={{6,3},{6,3}},
                horizontalAlignment=TextAlignment.Left));
            connect(TOut.y, ahuSubBusI.TOut) annotation (Line(points={{-398,240},{-370,240},{-370,332},{-340,332}}, color={0,0,127}),
                Text(
                string="%second",
                index=1,
                extent={{6,3},{6,3}},
                horizontalAlignment=TextAlignment.Left));
            connect(TSup.y, ahuSubBusI.TSup) annotation (Line(points={{-438,220},{-388,220},{-388,332},{-340,332}}, color={0,0,127}),
                Text(
                string="%second",
                index=1,
                extent={{6,3},{6,3}},
                horizontalAlignment=TextAlignment.Left));
            connect(TOutCut.y, ahuSubBusI.TOutCut) annotation (Line(points={{-398,200},{-370,200},{-370,332},{-340,332}}, color={
                    0,0,127}), Text(
                string="%second",
                index=1,
                extent={{6,3},{6,3}},
                horizontalAlignment=TextAlignment.Left));
            connect(TDis.y, ahuSubBusI.TDis) annotation (Line(points={{-438,170},{-388,170},{-388,332},{-340,332}}, color={0,0,
                    127}), Text(
                string="%second",
                index=1,
                extent={{6,3},{6,3}},
                horizontalAlignment=TextAlignment.Left));
            connect(occConv1.y, ahuSubBusI.nOcc[1]) annotation (Line(points={{-378,90},{-358,90},{-358,332},{-340,332}}, color={
                    255,127,0}), Text(
                string="%second",
                index=1,
                extent={{6,3},{6,3}},
                horizontalAlignment=TextAlignment.Left));
            connect(occConv2.y, ahuSubBusI.nOcc[2]) annotation (Line(points={{-378,50},{-358,50},{-358,332},{-340,332}}, color={
                    255,127,0}), Text(
                string="%second",
                index=1,
                extent={{6,3},{6,3}},
                horizontalAlignment=TextAlignment.Left));
            connect(VOut_flow.y, ahuSubBusI.VOut_flow) annotation (Line(points={{-438,-8},{-388,-8},{-388,332},{-340,332}}, color=
                   {0,0,127}), Text(
                string="%second",
                index=1,
                extent={{6,3},{6,3}},
                horizontalAlignment=TextAlignment.Left));
            connect(ducStaPre.y, ahuSubBusI.ducStaPre) annotation (Line(points={{-358,-8},{-350,-8},{-350,332},{-340,332}}, color=
                   {0,0,127}), Text(
                string="%second",
                index=1,
                extent={{6,3},{6,3}},
                horizontalAlignment=TextAlignment.Left));
            connect(vavBoxFlo1.y, ahuSubBusI.VDis_flow[1]) annotation (Line(points={{-438,-60},{-388,-60},{-388,332},{-340,332}},
                  color={0,0,127}), Text(
                string="%second",
                index=1,
                extent={{6,3},{6,3}},
                horizontalAlignment=TextAlignment.Left));
            connect(vavBoxFlo2.y, ahuSubBusI.VDis_flow[2]) annotation (Line(points={{-438,-92},{-368,-92},{-368,332},{-340,332}},
                  color={0,0,127}), Text(
                string="%second",
                index=1,
                extent={{6,3},{6,3}},
                horizontalAlignment=TextAlignment.Left));
            connect(TMixMea.y, ahuSubBusI.TMix) annotation (Line(points={{-338,-90},{-338,332},{-340,332}}, color={0,0,127}),
                Text(
                string="%second",
                index=1,
                extent={{-3,6},{-3,6}},
                horizontalAlignment=TextAlignment.Right));
            connect(reaToInt2.y, ahuSubBusI.uOpeMod) annotation (Line(points={{-318,-130},{-300,-130},{-300,332},{-340,332}},
                  color={255,127,0}), Text(
                string="%second",
                index=1,
                extent={{-6,3},{-6,3}},
                horizontalAlignment=TextAlignment.Right));
            connect(maxSupResReq.y, ahuSubBusI.uZonTemResReq) annotation (Line(points={{-318,-170},{-300,-170},{-300,332},{-340,
                    332}}, color={255,127,0}), Text(
                string="%second",
                index=1,
                extent={{-6,3},{-6,3}},
                horizontalAlignment=TextAlignment.Right));
            connect(ducPreResReq.y, ahuSubBusI.uZonPreResReq) annotation (Line(points={{-318,-212},{-300,-212},{-300,332},{-340,
                    332}}, color={255,127,0}), Text(
                string="%second",
                index=1,
                extent={{-6,3},{-6,3}},
                horizontalAlignment=TextAlignment.Right));
            connect(ahuBus, conAHU.ahuBus) annotation (Line(
                points={{-276,198},{-270,198},{-270,100},{-260,100}},
                color={255,204,51},
                thickness=0.5), Text(
                string="%first",
                index=-1,
                extent={{-6,3},{-6,3}},
                horizontalAlignment=TextAlignment.Right));
            connect(winSta.y, ahuSubBusI.uWin) annotation (Line(points={{-8,100},{0,100},{0,332},{-340,332}}, color={255,0,255}),
                Text(
                string="%second",
                index=1,
                extent={{-6,3},{-6,3}},
                horizontalAlignment=TextAlignment.Right));
            connect(hOutBelowCutoff.y, ahuSubBusI.hOut) annotation (Line(points={{162,150},{180,150},{180,332},{-340,332}}, color=
                   {0,0,127}), Text(
                string="%second",
                index=1,
                extent={{-6,3},{-6,3}},
                horizontalAlignment=TextAlignment.Right));
            connect(hOutCut.y, ahuSubBusI.hOutCut) annotation (Line(points={{164,110},{180,110},{180,332},{-340,332}}, color={0,0,
                    127}), Text(
                string="%second",
                index=1,
                extent={{6,3},{6,3}},
                horizontalAlignment=TextAlignment.Left));
            connect(freProSta1.y, ahuSubBusI.uFreProSta) annotation (Line(points={{318,10},{-300,10},{-300,332},{-340,332}},
                                                                                                                           color=
                    {255,127,0}), Text(
                string="%second",
                index=1,
                extent={{-6,3},{-6,3}},
                horizontalAlignment=TextAlignment.Right));
            connect(ahuSubBusI, ahuBus.ahuI) annotation (Line(
                points={{-340,332},{-308,332},{-308,198.1},{-275.9,198.1}},
                color={255,204,51},
                thickness=0.5), Text(
                string="%second",
                index=-1,
                extent={{-6,3},{-6,3}},
                horizontalAlignment=TextAlignment.Right));
            connect(ahuSubBusI, ahuBus2.ahuI) annotation (Line(
                points={{-340,332},{-60,332},{-60,200.1},{28.1,200.1}},
                color={255,204,51},
                thickness=0.5), Text(
                string="%second",
                index=-1,
                extent={{-6,3},{-6,3}},
                horizontalAlignment=TextAlignment.Right));
            connect(ahuSubBusI, ahuBus3.ahuI) annotation (Line(
                points={{-340,332},{122,332},{122,200.1},{210.1,200.1}},
                color={255,204,51},
                thickness=0.5), Text(
                string="%second",
                index=-1,
                extent={{-6,3},{-6,3}},
                horizontalAlignment=TextAlignment.Right));
            connect(ahuSubBusI, ahuBus4.ahuI) annotation (Line(
                points={{-340,332},{380,332},{380,200.1},{404.1,200.1}},
                color={255,204,51},
                thickness=0.5), Text(
                string="%second",
                index=-1,
                extent={{-6,3},{-6,3}},
                horizontalAlignment=TextAlignment.Right));
            connect(ahuBus2, conAHU2.ahuBus) annotation (Line(
                points={{28,200},{36,200},{36,100},{40,100}},
                color={255,204,51},
                thickness=0.5), Text(
                string="%first",
                index=-1,
                extent={{-6,3},{-6,3}},
                horizontalAlignment=TextAlignment.Right));
            connect(ahuBus3, conAHU3.ahuBus) annotation (Line(
                points={{210,200},{216,200},{216,100},{222,100}},
                color={255,204,51},
                thickness=0.5), Text(
                string="%first",
                index=-1,
                extent={{-6,3},{-6,3}},
                horizontalAlignment=TextAlignment.Right));
            connect(ahuBus4, conAHU4.ahuBus) annotation (Line(
                points={{404,200},{420,200},{420,100},{462,100}},
                color={255,204,51},
                thickness=0.5), Text(
                string="%first",
                index=-1,
                extent={{-6,3},{-6,3}},
                horizontalAlignment=TextAlignment.Right));
            connect(booPul1.y, freProSta1.u) annotation (Line(points={{360,10},{342,10}}, color={255,0,255}));
            connect(ahuSubBusI, ahuBus1.ahuI) annotation (Line(
                points={{-340,332},{-160,332},{-160,202.1},{-129.9,202.1}},
                color={255,204,51},
                thickness=0.5), Text(
                string="%second",
                index=-1,
                extent={{-6,3},{-6,3}},
                horizontalAlignment=TextAlignment.Right));
            connect(ahuBus1, conAHU1.ahuBus) annotation (Line(
                points={{-130,202},{-130,99},{-120,99},{-120,100}},
                color={255,204,51},
                thickness=0.5), Text(
                string="%first",
                index=-1,
                extent={{-3,6},{-3,6}},
                horizontalAlignment=TextAlignment.Right));
          annotation (experiment(StopTime=3600.0, Tolerance=1e-06),
          Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller</a>.
It tests the controller for different configurations of the Boolean parameters, such as
for controllers with occupancy sensors, with window status sensors, with single or dual duct boxes etc.
</p>
</html>",           revisions="<html>
<ul>
<li>
July 19, 2019, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"),Diagram(coordinateSystem(extent={{-520,-240},{560,340}})));
          end ControllerConfigurationTest;

          model ControlBusArray
            "Validates that an array structure is compatible with control bus"
            extends Modelica.Icons.Example;
            parameter Integer nTer = 5
              "Number of connected components";
            DummyTerminal dummyTerminal[nTer](
              indTer={i for i in 1:nTer})
              annotation (Placement(transformation(extent={{20,-10},{40,10}})));
            DummyCentral dummyCentral(final nTer=nTer)
              annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
            BaseClasses.AhuBus ahuBus(nTer=nTer) annotation (Placement(transformation(
                    extent={{-20,-40},{20,0}}), iconTransformation(extent={{-144,-52},{
                      -124,-32}})));
          equation

            connect(dummyTerminal.terBus, ahuBus.ahuTer) annotation (Line(
                points={{34,0},{34,-19.9},{0.1,-19.9}},
                color={255,204,51},
                thickness=0.5), Text(
                string="%second",
                index=1,
                extent={{-3,-6},{-3,-6}},
                horizontalAlignment=TextAlignment.Right));
            connect(dummyCentral.ahuBus, ahuBus) annotation (Line(
                points={{-26,-0.1},{-26,-20},{0,-20}},
                color={255,204,51},
                thickness=0.5), Text(
                string="%second",
                index=1,
                extent={{-3,-6},{-3,-6}},
                horizontalAlignment=TextAlignment.Right));
          annotation (experiment(StopTime=3600.0, Tolerance=1e-06),
              Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller</a>.
It tests the controller for different configurations of the Boolean parameters, such as
for controllers with occupancy sensors, with window status sensors, with single or dual duct boxes etc.
</p>
</html>",           revisions="<html>
<ul>
<li>
July 19, 2019, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"),Diagram(coordinateSystem(extent={{-60,-40},{60,20}}), graphics={
                                                                         Text(
                    extent={{-48,60},{152,0}},
                    lineColor={28,108,200},
                    horizontalAlignment=TextAlignment.Left,
                    textString="Improvement: connectorSizing does not work for nested expandable connector. Need to specify the dimension manually in ahuBus.

BUG in OCT

In components:
    dummyCentralSystem.ahuBus.ahuTer[2]
    dummyCentralSystem.ahuBus.ahuTer[3]
    dummyCentralSystem.ahuBus.ahuTer[4]
    dummyCentralSystem.ahuBus.ahuTer[5]
  Cannot find class declaration for RealInput")}));
          end ControlBusArray;

          model ControlBusArrayBug
            "Validates that an array structure is compatible with control bus"
            extends Modelica.Icons.Example;
            parameter Integer nTer = 5
              "Number of connected components";
            DummyTerminal dummyTerminal[nTer](
              indTer={i for i in 1:nTer})
              annotation (Placement(transformation(extent={{20,-10},{40,10}})));
            DummyCentralBug
                         dummyCentralBug(
                                      final nTer=nTer)
              annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
          equation

            connect(dummyCentralBug.terBus, dummyTerminal.terBus) annotation (Line(
                points={{-26.8,0},{34,0}},
                color={255,204,51},
                thickness=0.5));
          annotation (experiment(StopTime=3600.0, Tolerance=1e-06),
              Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller</a>.
It tests the controller for different configurations of the Boolean parameters, such as
for controllers with occupancy sensors, with window status sensors, with single or dual duct boxes etc.
</p>
</html>",           revisions="<html>
<ul>
<li>
July 19, 2019, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"),Diagram(coordinateSystem(extent={{-60,-20},{60,20}}), graphics={
                                                                         Text(
                    extent={{-52,60},{148,0}},
                    lineColor={28,108,200},
                    horizontalAlignment=TextAlignment.Left,
                    textString="Bugs GUI Dymola expandable connector:

- terBus.inpSig is considered as an array if terBus[].inpSig has been connected to an array of scalar variables. 
Need to update the code manually to suppress the index and simulate.
- If the connection is made at the terminal unit first: OK.

")}));
          end ControlBusArrayBug;

          model ControlBusArrayManual
            "Validates that an array structure is compatible with control bus"
            extends Modelica.Icons.Example;
            parameter Integer nTer = 5
              "Number of connected components";
            DummyTerminal dummyTerminal[nTer](
              indTer={i for i in 1:nTer})
              annotation (Placement(transformation(extent={{20,-10},{40,10}})));
            DummyCentral dummyCentral(final nTer=nTer)
              annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
          equation

            connect(dummyTerminal.terBus, dummyCentral.ahuBus.ahuTer);

          annotation (experiment(StopTime=3600.0, Tolerance=1e-06),
          Diagram(coordinateSystem(extent={{-60,-20},{60,20}}), graphics={
                                                                         Text(
                    extent={{-42,54},{120,36}},
                    lineColor={28,108,200},
                    horizontalAlignment=TextAlignment.Left,
                    textString="Bug Dymola expandable connector:

GUI does not allow connecting directly dummyTerminal[:].ahuTer to dummyCentral.ahuBus.ahuTer[:]

I do not see what prevents that syntax in Modelica specification. 
To the contrary I read \"expandable connectors can be connected even if they do not contain the same components\".

When manually specifying the connect statement as above the model:
- fails to translate with Dymola with the message \"Connect argument was not one of the valid forms, since dummyCentral is not a connector\".
- translates and simulates with OCT.")}));
          end ControlBusArrayManual;

          model ControlBusArrayArray
            "Validates that an array structure is compatible with control bus"
            extends Modelica.Icons.Example;
            parameter Integer nTerAhu = 5
              "Number of terminal units per AHU";
            parameter Integer nAhu = 5
              "Number of AHU";
            final parameter Integer nTer = nTerAhu * nAhu
              "Number of terminal units";
            DummyTerminal dummyTerminal[nAhu,nTerAhu](indTer={{i*j for i in 1:nTerAhu} for j in 1:nAhu})
              annotation (Placement(transformation(extent={{20,-10},{40,10}})));
            DummyCentral dummyCentral[nAhu](final nTer=fill(nTerAhu, nAhu))
              annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
            BaseClasses.AhuBus ahuBus[nAhu](nTer=fill(nTerAhu, nAhu)) annotation (
                Placement(transformation(extent={{-20,-40},{20,0}}), iconTransformation(
                    extent={{-144,-52},{-124,-32}})));
          equation

            connect(ahuBus.ahuTer, dummyTerminal.terBus) annotation (Line(
                points={{0.1,-19.9},{34,-19.9},{34,0}},
                color={255,204,51},
                thickness=0.5), Text(
                string="%first",
                index=-1,
                extent={{-3,-6},{-3,-6}},
                horizontalAlignment=TextAlignment.Right));
            connect(dummyCentral.ahuBus, ahuBus) annotation (Line(
                points={{-26,-0.1},{-26,-20},{0,-20}},
                color={255,204,51},
                thickness=0.5), Text(
                string="%second",
                index=1,
                extent={{-3,-6},{-3,-6}},
                horizontalAlignment=TextAlignment.Right));
          annotation (experiment(StopTime=3600.0, Tolerance=1e-06),
              Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller</a>.
It tests the controller for different configurations of the Boolean parameters, such as
for controllers with occupancy sensors, with window status sensors, with single or dual duct boxes etc.
</p>
</html>",           revisions="<html>
<ul>
<li>
July 19, 2019, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"),Diagram(coordinateSystem(extent={{-60,-40},{60,20}}), graphics={
                                                                         Text(
                    extent={{-64,68},{136,8}},
                    lineColor={28,108,200},
                    horizontalAlignment=TextAlignment.Left,
                    textString="Bug Dymola

Unmatched dimension in connect(ahuBus.ahuTer, dummyTerminal.terBus);

The first argument, ahuBus.ahuTer, is a connector with 1 dimensions
and the second, dummyTerminal.terBus, is a connector with 2 dimensions.


Bug in OCT, similar as before:
Error at line 296, column 5, in file '/opt/oct/ThirdParty/MSL/Modelica/Blocks/Interfaces.mo':
  Cannot find class declaration for RealInput

")}));
          end ControlBusArrayArray;

          model ControlBusArrayArrayManual
            "Validates that an array structure is compatible with control bus"
            extends Modelica.Icons.Example;
            parameter Integer nTerAhu = 5
              "Number of terminal units per AHU";
            parameter Integer nAhu = 5
              "Number of AHU";
            final parameter Integer nTer = nTerAhu * nAhu
              "Number of terminal units";
            DummyTerminal dummyTerminal[nAhu,nTerAhu](indTer={{i*j for i in 1:nTerAhu} for j in 1:nAhu})
              annotation (Placement(transformation(extent={{20,-10},{40,10}})));
            DummyCentral dummyCentral[nAhu](final nTer=fill(nTerAhu, nAhu))
              annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
          equation

            connect(dummyTerminal.terBus, dummyCentral.ahuBus.ahuTer);

          annotation (experiment(StopTime=3600.0, Tolerance=1e-06),
              Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller</a>.
It tests the controller for different configurations of the Boolean parameters, such as
for controllers with occupancy sensors, with window status sensors, with single or dual duct boxes etc.
</p>
</html>",           revisions="<html>
<ul>
<li>
July 19, 2019, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"),Diagram(coordinateSystem(extent={{-80,-60},{80,60}}), graphics={
                                                                         Text(
                    extent={{-78,48},{12,36}},
                    lineColor={28,108,200},
                    horizontalAlignment=TextAlignment.Left,
                    textString="Bug in Dymola.

Simulates with OCT.")}));
          end ControlBusArrayArrayManual;

          model ControlBusArrayGateway
            "Validates that an array structure is compatible with control bus"
            extends Modelica.Icons.Example;
            parameter Integer nTer = 5
              "Number of connected components";
            DummyTerminal dummyTerminal[nTer](
              indTer={i for i in 1:nTer}, tesStaAhu=true)
              annotation (Placement(transformation(extent={{20,-10},{40,10}})));
            DummyCentral dummyCentral(final nTer=nTer, tesStaAhu=true)
              annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
            BaseClasses.AhuBusGateway ahuBusGateway(nTer=nTer)
              annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
          equation

            connect(dummyCentral.ahuBus, ahuBusGateway.ahuBus) annotation (Line(
                points={{-26,-0.1},{-26,-30.8},{0,-30.8}},
                color={255,204,51},
                thickness=0.5));
            connect(ahuBusGateway.terBus, dummyTerminal.terBus) annotation (Line(
                points={{0,-36},{34,-36},{34,0}},
                color={255,204,51},
                thickness=0.5));
          annotation (experiment(StopTime=3600.0, Tolerance=1e-06),
              Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller</a>.
It tests the controller for different configurations of the Boolean parameters, such as
for controllers with occupancy sensors, with window status sensors, with single or dual duct boxes etc.
</p>
</html>",           revisions="<html>
<ul>
<li>
July 19, 2019, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"),Diagram(coordinateSystem(extent={{-80,-60},{80,60}}), graphics={Text(
                    extent={{-78,50},{-14,24}},
                    lineColor={28,108,200},
                    textString="Bug in Dymola
The bus-input dummyTerminal[1].terBus.staAhu lacks a matching non-input in the connection sets. This means that it lacks a source writing the signal to the bus.


Simulates with OCT and correct results.",
                    horizontalAlignment=TextAlignment.Left)}));
          end ControlBusArrayGateway;

          model ControlBusArrayComplex
            "Validates that an array structure is compatible with control bus"
            extends Modelica.Icons.Example;
            parameter Integer nTer = 5
              "Number of connected components";
            DummyTerminalComplex
                          dummyTerminalComplex
                                       [nTer](
              indTer={i for i in 1:nTer})
              annotation (Placement(transformation(extent={{20,-10},{40,10}})));
            DummyCentralComplex dummyCentralComplex(final nTer=nTer)
              annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
          equation
            connect(dummyCentralComplex.ahuBus, dummyTerminalComplex.ahuBus) annotation (
                Line(
                points={{-29.6,-0.2},{0.2,-0.2},{0.2,0},{30.6,0}},
                color={255,204,51},
                thickness=0.5));
          annotation (experiment(StopTime=3600.0, Tolerance=1e-06),
              Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller</a>.
It tests the controller for different configurations of the Boolean parameters, such as
for controllers with occupancy sensors, with window status sensors, with single or dual duct boxes etc.
</p>
</html>",           revisions="<html>
<ul>
<li>
July 19, 2019, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"),Diagram(coordinateSystem(extent={{-80,-60},{80,60}})));
          end ControlBusArrayComplex;

          model ControlBusArrayComplexBug
            "Validates that an array structure is compatible with control bus"
            extends Modelica.Icons.Example;
            parameter Integer nCon = 5
              "Number of connected components";
            DummyTerminalComplex
                          dummyTerminalComplex
                                       [nCon](
              indTer={i for i in 1:nCon})
              annotation (Placement(transformation(extent={{20,-10},{40,10}})));
            DummyCentralComplexBug dummyCentralSystemComplexBug(final nCon=nCon)
              annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
          equation
            connect(dummyCentralSystemComplexBug.ahuBus, dummyTerminalComplex.ahuBus)
              annotation (Line(
                points={{-29.6,-0.2},{0.2,-0.2},{0.2,0},{30.6,0}},
                color={255,204,51},
                thickness=0.5));
          annotation (experiment(StopTime=3600.0, Tolerance=1e-06),
              Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller</a>.
It tests the controller for different configurations of the Boolean parameters, such as
for controllers with occupancy sensors, with window status sensors, with single or dual duct boxes etc.
</p>
</html>",           revisions="<html>
<ul>
<li>
July 19, 2019, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"),Diagram(coordinateSystem(extent={{-80,-60},{80,60}}), graphics={
                                                                         Text(
                    extent={{-80,50},{80,20}},
                    lineColor={28,108,200},
                    textString="Bug in Dymola: fails to expand when no sub bus is used to access a variable from a sub bus, e.g., here no ahuSubBusI in DummyCentral...

Optimica OK.")}));
          end ControlBusArrayComplexBug;

          model TestOutsideConnector
            BaseClasses.AhuBusTest bus annotation (Placement(transformation(extent={{32,-20},{72,20}}), iconTransformation(extent={{-50,-10},
                      {-30,10}})));
            Controls.OBC.CDL.Continuous.Sources.Sine yNotDeclaredPresent(
              amplitude=5,
              offset=18 + 273.15,
              freqHz=1/5) "Outdoor air temperature" annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
            BaseClasses.AhuSubBusITestDec subBus annotation (Placement(transformation(extent={{-34,-10},{-14,10}}),
                  iconTransformation(extent={{-10,-10},{10,10}})));
            Controls.OBC.CDL.Continuous.Sources.Ramp yDeclaredPresent(
              height=4,
              duration=3600,
              offset=273.15 + 14) "AHU supply air temperature" annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
          equation
            connect(yDeclaredPresent.y, subBus.yDeclaredPresent) annotation (Line(points={{-58,30},{-44,30},{-44,0.05},{-23.95,
                    0.05}},
                  color={0,0,127}), Text(
                string="%second",
                index=1,
                extent={{6,3},{6,3}},
                horizontalAlignment=TextAlignment.Left));
            connect(yNotDeclaredPresent.y, subBus.yNotDeclaredPresent) annotation (Line(points={{-58,-30},{-44,-30},{-44,0},{-24,0}},
                  color={0,0,127}), Text(
                string="%second",
                index=1,
                extent={{6,3},{6,3}},
                horizontalAlignment=TextAlignment.Left));
            connect(subBus, bus.ahuI) annotation (Line(
                points={{-24,0},{14,0},{14,0.1},{52.1,0.1}},
                color={255,204,51},
                thickness=0.5), Text(
                string="%second",
                index=-1,
                extent={{-6,3},{-6,3}},
                horizontalAlignment=TextAlignment.Right));
            connect(yDeclaredPresent.y, bus.yAct) annotation (Line(points={{-58,30},{52,30},{52,0.1},{52.1,0.1}}, color={0,0,127}),
                Text(
                string="%second",
                index=1,
                extent={{6,3},{6,3}},
                horizontalAlignment=TextAlignment.Left));
            annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-40,-40},{40,40}})),
                                                                           Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                      -60},{80,60}})));
          end TestOutsideConnector;

          model TestInsideConnector
            TestOutsideConnector test annotation (Placement(transformation(extent={{20,-6},{38,6}})));
            BaseClasses.AhuBusTest ahuBusTest annotation (Placement(transformation(extent={{-60,-20},{-20,20}}),
                  iconTransformation(extent={{-124,-8},{-104,12}})));
            BaseClasses.AhuSubBusITestDec ahuSubBusITestDec annotation (Placement(transformation(extent={{-48,-30},{-28,-10}}),
                  iconTransformation(extent={{-130,-12},{-110,8}})));
            annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-60},{80,60}})),
                                                                           Diagram(coordinateSystem(preserveAspectRatio=false, extent={
                      {-100,-60},{80,60}})));
          end TestInsideConnector;
        end Validation;
      end Controller;

      package AHUs "fixme: add brief description"
        extends Modelica.Icons.Package;

        model AHUIOConnectors "VAV air handler unit with standard I/O connectors"
          replaceable package MediumAir = Buildings.Media.Air "Medium model for air";
          replaceable package MediumWat = Buildings.Media.Water "Medium model for water";

          parameter Modelica.SIunits.MassFlowRate mAir_flow_nominal "Nominal air mass flow rate";

          parameter Modelica.SIunits.MassFlowRate mWatHeaCoi_flow_nominal
            "Nominal water mass flow rate for heating coil"
            annotation(Dialog(group="Heating coil"));

          parameter Modelica.SIunits.HeatFlowRate QHeaCoi_flow_nominal(min=0)=
            mAir_flow_nominal * (THeaCoiAirIn_nominal-THeaCoiAirOut_nominal)*1006
            "Nominal heat transfer of heating coil";
          parameter Modelica.SIunits.Temperature THeaCoiAirIn_nominal=281.65
            "Nominal air inlet temperature heating coil"
            annotation(Dialog(group="Heating coil"));
          parameter Modelica.SIunits.Temperature THeaCoiAirOut_nominal=313.65
            "Nominal air inlet temperature heating coil"
            annotation(Dialog(group="Heating coil"));
          parameter Modelica.SIunits.Temperature THeaCoiWatIn_nominal=318.15
            "Nominal water inlet temperature heating coil"
            annotation(Dialog(group="Heating coil"));
          parameter Modelica.SIunits.Temperature THeaCoiWatOut_nominal=THeaCoiWatIn_nominal-QHeaCoi_flow_nominal/mWatHeaCoi_flow_nominal/4200
            "Nominal water inlet temperature heating coil"
            annotation(Dialog(group="Heating coil"));

          parameter Modelica.SIunits.PressureDifference dpHeaCoiWat_nominal(
            min=0,
            displayUnit="Pa") = 3000
            "Water-side pressure drop of heating coil"
            annotation(Dialog(group="Heating coil"));

          parameter Modelica.SIunits.PressureDifference dpSup_nominal(
            min=0,
            displayUnit="Pa") = 500
            "Pressure difference of supply air leg (coils and filter)";

          parameter Modelica.SIunits.PressureDifference dpRet_nominal(
            min=0,
            displayUnit="Pa") = 50
            "Pressure difference of supply air leg (coils and filter)";

          parameter Modelica.SIunits.PressureDifference dpFanSup_nominal(
            min=Modelica.Constants.small,
            displayUnit="Pa")
            "Fan head at mAir_flow_nominal and full speed";

          /* Fixme: This should be constrained to all fans, not all movers */
          replaceable parameter Fluid.Movers.Data.Generic datFanSup(
            pressure(
              V_flow={0,mAir_flow_nominal/1.2*2},
              dp=2*{dpFanSup_nominal,0}))
              constrainedby Fluid.Movers.Data.Generic
            "Performance data for supply fan"
            annotation (
              choicesAllMatching=true,
              Dialog(
                group="Fan"),
            Placement(transformation(extent={{260,320},{280,340}})));

          Buildings.Controls.OBC.CDL.Interfaces.RealInput yFanSup(
             final unit="1",
             min=0,
             max=1)
             "Fan control signal" annotation (Placement(transformation(extent={
                    {-440,340},{-400,380}})));
          Buildings.Controls.OBC.CDL.Interfaces.RealInput yEcoRet(
             final unit="1",
             min=0,
             max=1)
            "Economizer return damper position (0: closed, 1: open)" annotation (Placement(
                transformation(extent={{-440,220},{-400,260}}), iconTransformation(
                  extent={{-440,220},{-400,260}})));
          Buildings.Controls.OBC.CDL.Interfaces.RealInput yEcoOut(
             final unit="1",
             min=0,
             max=1)
            "Economizer outdoor air damper signal (0: closed, 1: open)" annotation (Placement(
                transformation(extent={{-440,260},{-400,300}})));
          Buildings.Controls.OBC.CDL.Interfaces.RealInput yEcoExh(
             final unit="1",
             min=0,
             max=1)
            "Econoizer exhaust air damper signal (0: closed, 1: open)"
            annotation (Placement(transformation(extent={{-440,300},{-400,340}})));
          Buildings.Controls.OBC.CDL.Interfaces.RealOutput TAirMix(
            final unit="K",
            displayUnit="degC") "Mixed air temperture"
            annotation (Placement(transformation(extent={{400,350},{420,370}})));
          Buildings.Controls.OBC.CDL.Interfaces.RealOutput TAirSup(
            final unit="K",
            displayUnit="degC")
            "Temperature of the passing fluid"
            annotation (Placement(transformation(extent={{400,310},{420,330}})));
          Buildings.Controls.OBC.CDL.Interfaces.RealOutput TAirRet(
            final unit="K",
            displayUnit="degC") "Return air temperature"
            annotation (Placement(transformation(extent={{400,270},{420,290}})));
          Buildings.Controls.OBC.CDL.Interfaces.RealOutput VOut_flow(
            final unit="m3/s") "Outdoor air flow rate"
            annotation (Placement(transformation(extent={{400,230},{420,250}})));

          Modelica.Fluid.Interfaces.FluidPort_a port_freAir(redeclare package
              Medium =
                MediumAir) "Fresh air intake" annotation (Placement(transformation(
                  extent={{-410,30},{-390,50}})));
          Modelica.Fluid.Interfaces.FluidPort_b port_exhAir(redeclare package
              Medium =
                MediumAir) "Exhaust air" annotation (Placement(transformation(extent={{-410,
                    -50},{-390,-30}})));
          Modelica.Fluid.Interfaces.FluidPort_b port_supAir(redeclare package
              Medium =
                MediumAir) "Supply air" annotation (Placement(transformation(extent={{390,-50},
                    {410,-30}})));
          Modelica.Fluid.Interfaces.FluidPort_a port_retAir(redeclare package
              Medium =
                MediumAir) "Return air"
            annotation (Placement(transformation(extent={{392,30},{412,50}})));
          Modelica.Fluid.Interfaces.FluidPort_a port_cooCoiIn(redeclare package
              Medium =
                MediumWat) "Cooling coil inlet"
            annotation (Placement(transformation(extent={{110,-410},{130,-390}})));
          Modelica.Fluid.Interfaces.FluidPort_b port_CooCoiOut(redeclare
              package Medium =
                MediumWat) "Cooling coil outlet" annotation (Placement(transformation(
                  extent={{30,-410},{50,-390}})));
          Modelica.Fluid.Interfaces.FluidPort_a port_heaCoiIn(redeclare package
              Medium =
                MediumWat) "Heating coil inlet"
            annotation (Placement(transformation(extent={{-50,-410},{-30,-390}})));
          Modelica.Fluid.Interfaces.FluidPort_b port_heaCoiOut(redeclare
              package Medium =
                MediumWat) "Heating coil outlet"
            annotation (Placement(transformation(extent={{-130,-410},{-110,-390}})));

          Fluid.HeatExchangers.DryCoilEffectivenessNTU heaCoi(
            redeclare package Medium1 = MediumWat,
            redeclare package Medium2 = MediumAir,
            m1_flow_nominal=mWatHeaCoi_flow_nominal,
            m2_flow_nominal=mAir_flow_nominal,
            configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
            use_Q_flow_nominal=true,
            Q_flow_nominal=QHeaCoi_flow_nominal,
            dp1_nominal=dpHeaCoiWat_nominal,
            dp2_nominal=0,
            T_a1_nominal=THeaCoiWatIn_nominal,
            T_a2_nominal=THeaCoiAirIn_nominal)
            "Heating coil"
            annotation (Placement(transformation(extent={{20,-36},{0,-56}})));

          Fluid.HeatExchangers.WetCoilCounterFlow cooCoi(
            redeclare package Medium1 = MediumWat,
            redeclare package Medium2 = MediumAir,
            UA_nominal=mAir_flow_nominal*1000*15/
                Buildings.Fluid.HeatExchangers.BaseClasses.lmtd(
                T_a1=datCooCoi.TWatIn_nominal,
                T_b1=datCooCoi.TWatOut_nominal,
                T_a2=datCooCoi.TAirIn_nominal,
                T_b2=datCooCoi.TOut_nominal),
            m1_flow_nominal=datCooCoi.mWat_flow_nominal,
            m2_flow_nominal=datCooCoi.mAir_flow_nominal,
            dp1_nominal=datCooCoi.dpWat_nominal,
            dp2_nominal=datCooCoi.dpAir_nominal,
            energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
            "Cooling coil"
            annotation (Placement(transformation(extent={{82,-36},{62,-56}})));

          Fluid.FixedResistances.PressureDrop resSup(
            redeclare package Medium = MediumAir,
            m_flow_nominal=mAir_flow_nominal,
            dp_nominal=dpSup_nominal)
            "Pressure drop of heat exchangers and filter combined"
            annotation (Placement(transformation(extent={{140,-50},{160,-30}})));

          Fluid.Sensors.TemperatureTwoPort senTMix(
            redeclare package Medium = MediumAir,
            m_flow_nominal=mAir_flow_nominal) "Mixed air temperature sensor"
            annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));

          Buildings.Examples.VAVReheat.BaseClasses.MixingBox eco(
            redeclare package Medium = MediumAir,
            mOut_flow_nominal=mAir_flow_nominal,
            dpOut_nominal=10,
            mRec_flow_nominal=mAir_flow_nominal,
            dpRec_nominal=10,
            mExh_flow_nominal=mAir_flow_nominal,
            dpExh_nominal=10,
            from_dp=false) "Economizer" annotation (Placement(transformation(
                extent={{-10,-10},{10,10}},
                rotation=0,
                origin={-90,2})));

          Fluid.Sensors.TemperatureTwoPort senTSup(
            redeclare package Medium = MediumAir,
            m_flow_nominal=mAir_flow_nominal) "Supply air temperature sensor"
            annotation (Placement(transformation(extent={{310,-50},{330,-30}})));
          Fluid.Sensors.TemperatureTwoPort TRet(
            redeclare package Medium = MediumAir,
            m_flow_nominal=mAir_flow_nominal) "Return air temperature sensor"
            annotation (Placement(transformation(extent={{360,30},{340,50}})));
          Fluid.FixedResistances.PressureDrop resRet(
            redeclare package Medium = MediumAir,
            m_flow_nominal=mAir_flow_nominal,
            dp_nominal=dpRet_nominal)
                          "Pressure drop for return duct"
            annotation (Placement(transformation(extent={{160,30},{140,50}})));
          Fluid.Movers.SpeedControlled_y fanSup(
            redeclare package Medium = MediumAir,
            per=datFanSup,
            energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Supply air fan"
            annotation (Placement(transformation(extent={{220,-50},{240,-30}})));

          Fluid.Sensors.VolumeFlowRate senVOut_flow(
            redeclare package Medium = MediumAir,
            m_flow_nominal=mAir_flow_nominal)
            "Outside air volume flow rate"
            annotation (Placement(transformation(extent={{-160,30},{-140,50}})));

          parameter Data.CoolingCoil datCooCoi
            annotation (Placement(transformation(extent={{260,280},{280,300}})));
        equation
          connect(eco.port_Out, senVOut_flow.port_b) annotation (Line(points={{-100,8},{
                  -120,8},{-120,40},{-140,40}}, color={0,127,255}));
          connect(eco.port_Ret, senTMix.port_a) annotation (Line(points={{-80,-4},{-68,-4},
                  {-68,-40},{-60,-40}}, color={0,127,255}));
          connect(senTMix.port_b, heaCoi.port_a2)
            annotation (Line(points={{-40,-40},{0,-40}},   color={0,127,255}));
          connect(heaCoi.port_b2, cooCoi.port_a2)
            annotation (Line(points={{20,-40},{62,-40}},color={0,127,255}));
          connect(resSup.port_b, fanSup.port_a)
            annotation (Line(points={{160,-40},{220,-40}}, color={0,127,255}));
          connect(senVOut_flow.port_a, port_freAir) annotation (Line(points={{-160,40},{
                  -400,40}},                     color={0,127,255}));
          connect(eco.port_Exh, port_exhAir) annotation (Line(points={{-100,-4},{-120,-4},
                  {-120,-40},{-400,-40}}, color={0,127,255}));
          connect(senTSup.port_b, port_supAir)
            annotation (Line(points={{330,-40},{400,-40}}, color={0,127,255}));
          connect(TRet.port_a, port_retAir)
            annotation (Line(points={{360,40},{402,40}}, color={0,127,255}));
          connect(cooCoi.port_a1, port_cooCoiIn) annotation (Line(points={{82,-52},{120,
                  -52},{120,-400}},                 color={0,127,255}));
          connect(cooCoi.port_b1, port_CooCoiOut) annotation (Line(points={{62,-52},{50,
                  -52},{50,-300},{40,-300},{40,-400}},
                                              color={0,127,255}));
          connect(heaCoi.port_a1, port_heaCoiIn) annotation (Line(points={{20,-52},{30,-52},
                  {30,-180},{-40,-180},{-40,-400}},color={0,127,255}));
          connect(heaCoi.port_b1, port_heaCoiOut) annotation (Line(points={{0,-52},{-20,
                  -52},{-20,-160},{-120,-160},{-120,-400}}, color={0,127,255}));

          connect(TRet.port_b, resRet.port_a)
            annotation (Line(points={{340,40},{160,40}}, color={0,127,255}));
          connect(resRet.port_b, eco.port_Sup) annotation (Line(points={{140,40},{-68,40},
                  {-68,8},{-80,8}}, color={0,127,255}));
          connect(eco.yExh, yEcoExh)
            annotation (Line(points={{-83,14},{-83,320},{-420,320}}, color={0,0,127}));
          connect(eco.yOut, yEcoOut)
            annotation (Line(points={{-90,14},{-90,280},{-420,280}}, color={0,0,127}));
          connect(eco.yRet, yEcoRet) annotation (Line(points={{-96.8,14},{-98,14},{-98,222},
                  {-260,222},{-260,240},{-420,240}}, color={0,0,127}));
          connect(senTMix.T, TAirMix) annotation (Line(points={{-50,-29},{-48,-29},{-48,
                  360},{410,360}}, color={0,0,127}));
          connect(senTSup.T, TAirSup)
            annotation (Line(points={{320,-29},{320,320},{410,320}}, color={0,0,127}));
          connect(TRet.T, TAirRet)
            annotation (Line(points={{350,51},{350,280},{410,280}}, color={0,0,127}));
          connect(senVOut_flow.V_flow, VOut_flow) annotation (Line(points={{-150,51},{-150,
                  240},{410,240}}, color={0,0,127}));
          connect(yFanSup, fanSup.y) annotation (Line(points={{-420,360},{-80,360},{-80,
                  342},{230,342},{230,-28}}, color={0,0,127}));
          connect(fanSup.port_b, senTSup.port_a)
            annotation (Line(points={{240,-40},{310,-40}}, color={0,127,255}));
          connect(cooCoi.port_b2, resSup.port_a)
            annotation (Line(points={{82,-40},{140,-40}}, color={0,127,255}));
          annotation (
            defaultComponentName="ahu",
            Diagram(coordinateSystem(extent={{-400,-400},{400,400}})), Icon(
                coordinateSystem(extent={{-400,-400},{400,400}})));
        end AHUIOConnectors;

        model CoilAndValve "VAV air handler unit"
          replaceable package MediumAir = Buildings.Media.Air "Medium model for air";
          replaceable package MediumWat = Buildings.Media.Water "Medium model for water";

          parameter Modelica.SIunits.MassFlowRate mAir_flow_nominal "Nominal air mass flow rate";

          parameter Modelica.SIunits.MassFlowRate mWatHeaCoi_flow_nominal
            "Nominal water mass flow rate for heating coil"
            annotation(Dialog(group="Heating coil"));

          parameter Modelica.SIunits.HeatFlowRate QHeaCoi_flow_nominal(min=0)=
            mAir_flow_nominal * (THeaCoiAirIn_nominal-THeaCoiAirOut_nominal)*1006
            "Nominal heat transfer of heating coil";
          parameter Modelica.SIunits.Temperature THeaCoiAirIn_nominal=281.65
            "Nominal air inlet temperature heating coil"
            annotation(Dialog(group="Heating coil"));
          parameter Modelica.SIunits.Temperature THeaCoiAirOut_nominal=313.65
            "Nominal air inlet temperature heating coil"
            annotation(Dialog(group="Heating coil"));
          parameter Modelica.SIunits.Temperature THeaCoiWatIn_nominal=318.15
            "Nominal water inlet temperature heating coil"
            annotation(Dialog(group="Heating coil"));
          parameter Modelica.SIunits.Temperature THeaCoiWatOut_nominal=THeaCoiWatIn_nominal-QHeaCoi_flow_nominal/mWatHeaCoi_flow_nominal/4200
            "Nominal water inlet temperature heating coil"
            annotation(Dialog(group="Heating coil"));

          parameter Modelica.SIunits.PressureDifference dpHeaCoiWat_nominal(
            min=0,
            displayUnit="Pa") = 3000
            "Water-side pressure drop of heating coil"
            annotation(Dialog(group="Heating coil"));

          parameter Modelica.SIunits.PressureDifference dpSup_nominal(
            min=0,
            displayUnit="Pa") = 500
            "Pressure difference of supply air leg (coils and filter)";

          parameter Modelica.SIunits.PressureDifference dpRet_nominal(
            min=0,
            displayUnit="Pa") = 50
            "Pressure difference of supply air leg (coils and filter)";

          parameter Modelica.SIunits.PressureDifference dpFanSup_nominal(
            min=Modelica.Constants.small,
            displayUnit="Pa")
            "Fan head at mAir_flow_nominal and full speed";

          /* Fixme: This should be constrained to all fans, not all movers */

          Modelica.Fluid.Interfaces.FluidPort_a port_freAir(redeclare package
              Medium =
                MediumAir) "Fresh air intake" annotation (Placement(transformation(
                  extent={{-70,-70},{-50,-50}}), iconTransformation(extent={{-70,-40},{-50,-20}})));
          Modelica.Fluid.Interfaces.FluidPort_b port_supAir(redeclare package
              Medium =
                MediumAir) "Supply air" annotation (Placement(transformation(extent={{110,-70},{130,-50}}),
                                 iconTransformation(extent={{110,-80},{130,-60}})));
          Modelica.Fluid.Interfaces.FluidPort_a port_heaCoiIn(redeclare package
              Medium =
                MediumWat) "Heating coil inlet"
            annotation (Placement(transformation(extent={{30,-150},{50,-130}}),
                iconTransformation(extent={{-20,-150},{0,-130}})));
          Modelica.Fluid.Interfaces.FluidPort_b port_heaCoiOut(redeclare
              package Medium =
                MediumWat) "Heating coil outlet"
            annotation (Placement(transformation(extent={{10,-150},{30,-130}}),
                iconTransformation(extent={{-60,-150},{-40,-130}})));

          Fluid.HeatExchangers.DryCoilEffectivenessNTU heaCoi(
            redeclare package Medium1 = MediumWat,
            redeclare package Medium2 = MediumAir,
            m1_flow_nominal=mWatHeaCoi_flow_nominal,
            m2_flow_nominal=mAir_flow_nominal,
            configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
            use_Q_flow_nominal=true,
            Q_flow_nominal=QHeaCoi_flow_nominal,
            dp1_nominal=dpHeaCoiWat_nominal,
            dp2_nominal=0,
            T_a1_nominal=THeaCoiWatIn_nominal,
            T_a2_nominal=THeaCoiAirIn_nominal)
            "Heating coil"
            annotation (Placement(transformation(extent={{40,-50},{20,-70}})));

          BaseClasses.AhuSubBusO ahuSubBusO
            annotation (Placement(transformation(extent={{-26,-10},{-6,10}}),
                iconTransformation(extent={{-82,54},{-62,74}})));
          BaseClasses.AhuBus ahuBus annotation (Placement(transformation(
                extent={{-20,-20},{20,20}},
                rotation=90,
                origin={-54,8}),    iconTransformation(extent={{-106,70},{-86,90}})));
          BaseClasses.AhuSubBusI ahuSubBusI
            annotation (Placement(transformation(extent={{-26,16},{-6,36}}),
                iconTransformation(extent={{-82,80},{-62,100}})));
          Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear val annotation (Placement(transformation(
                extent={{-10,-10},{10,10}},
                rotation=90,
                origin={20,-110})));
          Fluid.Actuators.Valves.TwoWayEqualPercentage val1
            annotation (Placement(transformation(
                extent={{-10,-10},{10,10}},
                rotation=90,
                origin={20,-84})));
        equation

          connect(ahuSubBusO, ahuBus.ahuO) annotation (Line(
              points={{-16,0},{-34,0},{-34,8.1},{-54.1,8.1}},
              color={255,204,51},
              thickness=0.5));
          connect(ahuSubBusI, ahuBus.ahuI) annotation (Line(
              points={{-16,26},{-34,26},{-34,8.1},{-54.1,8.1}},
              color={255,204,51},
              thickness=0.5));
          connect(port_freAir, heaCoi.port_a2)
            annotation (Line(points={{-60,-60},{-16,-60},{-16,-54},{20,-54}}, color={0,127,255}));
          connect(val.port_1, port_heaCoiOut) annotation (Line(points={{20,-120},{20,-140}}, color={0,127,255}));
          connect(heaCoi.port_b1, val1.port_b) annotation (Line(points={{20,-66},{20,-74}}, color={0,127,255}));
          connect(port_heaCoiIn, port_heaCoiIn) annotation (Line(points={{40,-140},{40,-140}}, color={0,127,255}));
          connect(heaCoi.port_a1, port_heaCoiIn) annotation (Line(points={{40,-66},{40,-140}}, color={0,127,255}));
          connect(val.port_2, val1.port_a) annotation (Line(points={{20,-100},{20,-94}}, color={0,127,255}));
          connect(val.port_3, heaCoi.port_a1) annotation (Line(points={{30,-110},{40,-110},{40,-66}}, color={0,127,255}));
          connect(heaCoi.port_b2, port_supAir)
            annotation (Line(points={{40,-54},{90,-54},{90,-60},{120,-60}}, color={0,127,255}));
          connect(ahuSubBusO.yValHeaCoi, val1.y) annotation (Line(
              points={{-16,0},{-6,0},{-6,-84},{8,-84}},
              color={255,204,51},
              thickness=0.5), Text(
              string="%first",
              index=-1,
              extent={{-6,3},{-6,3}},
              horizontalAlignment=TextAlignment.Right));
          connect(ahuSubBusO.yValHeaCoi, val.y) annotation (Line(
              points={{-16,0},{-6,0},{-6,-110},{8,-110}},
              color={255,204,51},
              thickness=0.5), Text(
              string="%first",
              index=-1,
              extent={{-6,3},{-6,3}},
              horizontalAlignment=TextAlignment.Right));
          annotation (
            defaultComponentName="ahu",
            Diagram(coordinateSystem(extent={{-60,-140},{120,40}})),   Icon(
                coordinateSystem(extent={{-60,-140},{120,40}})));
        end CoilAndValve;

        model AHUControlBus "VAV air handler unit with expandable connector"
          replaceable package MediumAir = Buildings.Media.Air "Medium model for air";
          replaceable package MediumWat = Buildings.Media.Water "Medium model for water";

          parameter Modelica.SIunits.MassFlowRate mAir_flow_nominal "Nominal air mass flow rate";

          parameter Modelica.SIunits.MassFlowRate mWatHeaCoi_flow_nominal
            "Nominal water mass flow rate for heating coil"
            annotation(Dialog(group="Heating coil"));

          parameter Modelica.SIunits.HeatFlowRate QHeaCoi_flow_nominal(min=0)=
            mAir_flow_nominal * (THeaCoiAirIn_nominal-THeaCoiAirOut_nominal)*1006
            "Nominal heat transfer of heating coil";
          parameter Modelica.SIunits.Temperature THeaCoiAirIn_nominal=281.65
            "Nominal air inlet temperature heating coil"
            annotation(Dialog(group="Heating coil"));
          parameter Modelica.SIunits.Temperature THeaCoiAirOut_nominal=313.65
            "Nominal air inlet temperature heating coil"
            annotation(Dialog(group="Heating coil"));
          parameter Modelica.SIunits.Temperature THeaCoiWatIn_nominal=318.15
            "Nominal water inlet temperature heating coil"
            annotation(Dialog(group="Heating coil"));
          parameter Modelica.SIunits.Temperature THeaCoiWatOut_nominal=THeaCoiWatIn_nominal-QHeaCoi_flow_nominal/mWatHeaCoi_flow_nominal/4200
            "Nominal water inlet temperature heating coil"
            annotation(Dialog(group="Heating coil"));

          parameter Modelica.SIunits.PressureDifference dpHeaCoiWat_nominal(
            min=0,
            displayUnit="Pa") = 3000
            "Water-side pressure drop of heating coil"
            annotation(Dialog(group="Heating coil"));

          parameter Modelica.SIunits.PressureDifference dpSup_nominal(
            min=0,
            displayUnit="Pa") = 500
            "Pressure difference of supply air leg (coils and filter)";

          parameter Modelica.SIunits.PressureDifference dpRet_nominal(
            min=0,
            displayUnit="Pa") = 50
            "Pressure difference of supply air leg (coils and filter)";

          parameter Modelica.SIunits.PressureDifference dpFanSup_nominal(
            min=Modelica.Constants.small,
            displayUnit="Pa")
            "Fan head at mAir_flow_nominal and full speed";

          /* Fixme: This should be constrained to all fans, not all movers */
          replaceable parameter Fluid.Movers.Data.Generic datFanSup(
            pressure(
              V_flow={0,mAir_flow_nominal/1.2*2},
              dp=2*{dpFanSup_nominal,0}))
              constrainedby Fluid.Movers.Data.Generic
            "Performance data for supply fan"
            annotation (
              choicesAllMatching=true,
              Dialog(
                group="Fan"),
            Placement(transformation(extent={{318,-294},{338,-274}})));

          Modelica.Fluid.Interfaces.FluidPort_a port_freAir(redeclare package
              Medium =
                MediumAir) "Fresh air intake" annotation (Placement(transformation(
                  extent={{-410,-150},{-390,-130}}),
                                                 iconTransformation(extent={{-110,10},{
                    -90,30}})));
          Modelica.Fluid.Interfaces.FluidPort_b port_exhAir(redeclare package
              Medium =
                MediumAir) "Exhaust air" annotation (Placement(transformation(extent={{-410,-230},{-390,-210}}),
                                       iconTransformation(extent={{-110,-30},{-90,-10}})));
          Modelica.Fluid.Interfaces.FluidPort_b port_supAir(redeclare package
              Medium =
                MediumAir) "Supply air" annotation (Placement(transformation(extent={{390,-230},{410,-210}}),
                                 iconTransformation(extent={{90,-30},{110,-10}})));
          Modelica.Fluid.Interfaces.FluidPort_a port_retAir(redeclare package
              Medium =
                MediumAir) "Return air"
            annotation (Placement(transformation(extent={{392,-150},{412,-130}}),
                iconTransformation(extent={{90,10},{110,30}})));
          Modelica.Fluid.Interfaces.FluidPort_a port_cooCoiIn(redeclare package
              Medium =
                MediumWat) "Cooling coil inlet"
            annotation (Placement(transformation(extent={{110,-410},{130,-390}}),
                iconTransformation(extent={{70,-110},{90,-90}})));
          Modelica.Fluid.Interfaces.FluidPort_b port_CooCoiOut(redeclare
              package Medium =
                MediumWat) "Cooling coil outlet" annotation (Placement(transformation(
                  extent={{30,-410},{50,-390}}), iconTransformation(extent={{30,-110},{
                    50,-90}})));
          Modelica.Fluid.Interfaces.FluidPort_a port_heaCoiIn(redeclare package
              Medium =
                MediumWat) "Heating coil inlet"
            annotation (Placement(transformation(extent={{-50,-410},{-30,-390}}),
                iconTransformation(extent={{-50,-110},{-30,-90}})));
          Modelica.Fluid.Interfaces.FluidPort_b port_heaCoiOut(redeclare
              package Medium =
                MediumWat) "Heating coil outlet"
            annotation (Placement(transformation(extent={{-130,-410},{-110,-390}}),
                iconTransformation(extent={{-90,-110},{-70,-90}})));

          Fluid.HeatExchangers.DryCoilEffectivenessNTU heaCoi(
            redeclare package Medium1 = MediumWat,
            redeclare package Medium2 = MediumAir,
            m1_flow_nominal=mWatHeaCoi_flow_nominal,
            m2_flow_nominal=mAir_flow_nominal,
            configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
            use_Q_flow_nominal=true,
            Q_flow_nominal=QHeaCoi_flow_nominal,
            dp1_nominal=dpHeaCoiWat_nominal,
            dp2_nominal=0,
            T_a1_nominal=THeaCoiWatIn_nominal,
            T_a2_nominal=THeaCoiAirIn_nominal)
            "Heating coil"
            annotation (Placement(transformation(extent={{20,-216},{0,-236}})));

          Fluid.HeatExchangers.WetCoilCounterFlow cooCoi(
            redeclare package Medium1 = MediumWat,
            redeclare package Medium2 = MediumAir,
            UA_nominal=mAir_flow_nominal*1000*15/
                Buildings.Fluid.HeatExchangers.BaseClasses.lmtd(
                T_a1=datCooCoi.TWatIn_nominal,
                T_b1=datCooCoi.TWatOut_nominal,
                T_a2=datCooCoi.TAirIn_nominal,
                T_b2=datCooCoi.TOut_nominal),
            m1_flow_nominal=datCooCoi.mWat_flow_nominal,
            m2_flow_nominal=datCooCoi.mAir_flow_nominal,
            dp1_nominal=datCooCoi.dpWat_nominal,
            dp2_nominal=datCooCoi.dpAir_nominal,
            energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
            "Cooling coil"
            annotation (Placement(transformation(extent={{82,-216},{62,-236}})));

          Fluid.FixedResistances.PressureDrop resSup(
            redeclare package Medium = MediumAir,
            m_flow_nominal=mAir_flow_nominal,
            dp_nominal=dpSup_nominal)
            "Pressure drop of heat exchangers and filter combined"
            annotation (Placement(transformation(extent={{140,-230},{160,-210}})));

          Fluid.Sensors.TemperatureTwoPort senTMix(
            redeclare package Medium = MediumAir,
            m_flow_nominal=mAir_flow_nominal) "Mixed air temperature sensor"
            annotation (Placement(transformation(extent={{-60,-230},{-40,-210}})));

          Buildings.Examples.VAVReheat.BaseClasses.MixingBox eco(
            redeclare package Medium = MediumAir,
            mOut_flow_nominal=mAir_flow_nominal,
            dpOut_nominal=10,
            mRec_flow_nominal=mAir_flow_nominal,
            dpRec_nominal=10,
            mExh_flow_nominal=mAir_flow_nominal,
            dpExh_nominal=10,
            from_dp=false) "Economizer" annotation (Placement(transformation(
                extent={{-10,-10},{10,10}},
                rotation=0,
                origin={-90,-178})));

          Fluid.Sensors.TemperatureTwoPort senTSup(
            redeclare package Medium = MediumAir,
            m_flow_nominal=mAir_flow_nominal) "Supply air temperature sensor"
            annotation (Placement(transformation(extent={{310,-230},{330,-210}})));
          Fluid.Sensors.TemperatureTwoPort TRet(
            redeclare package Medium = MediumAir,
            m_flow_nominal=mAir_flow_nominal) "Return air temperature sensor"
            annotation (Placement(transformation(extent={{360,-150},{340,-130}})));
          Fluid.FixedResistances.PressureDrop resRet(
            redeclare package Medium = MediumAir,
            m_flow_nominal=mAir_flow_nominal,
            dp_nominal=dpRet_nominal)
                          "Pressure drop for return duct"
            annotation (Placement(transformation(extent={{160,-150},{140,-130}})));
          Fluid.Movers.SpeedControlled_y fanSup(
            redeclare package Medium = MediumAir,
            per=datFanSup,
            energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Supply air fan"
            annotation (Placement(transformation(extent={{220,-210},{240,-230}})));

          Fluid.Sensors.VolumeFlowRate senVOut_flow(
            redeclare package Medium = MediumAir,
            m_flow_nominal=mAir_flow_nominal)
            "Outside air volume flow rate"
            annotation (Placement(transformation(extent={{-160,-150},{-140,-130}})));

          parameter Data.CoolingCoil datCooCoi
            annotation (Placement(transformation(extent={{320,-340},{340,-320}})));

          BaseClasses.AhuBus ahuBus annotation (Placement(transformation(
                extent={{-20,-20},{20,20}},
                rotation=90,
                origin={-400,0}),   iconTransformation(extent={{-10,90},{10,110}})));

          Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller conAHU1
            annotation (Placement(transformation(extent={{-320,128},{-240,240}})));
        protected
          BaseClasses.AhuSubBusO ahuSubBusO
            annotation (Placement(transformation(extent={{-10,-10},{10,10}},
                rotation=90,
                origin={-354,20}),
                iconTransformation(extent={{-82,54},{-62,74}})));
          BaseClasses.AhuSubBusI ahuSubBusI
            annotation (Placement(transformation(extent={{-10,-10},{10,10}},
                rotation=90,
                origin={-354,-20}),
                iconTransformation(extent={{-82,80},{-62,100}})));
        equation
          connect(eco.port_Out, senVOut_flow.port_b) annotation (Line(points={{-100,-172},{-120,-172},{-120,-140},{-140,-140}},
                                                color={0,127,255}));
          connect(eco.port_Ret, senTMix.port_a) annotation (Line(points={{-80,-184},{-68,-184},{-68,-220},{-60,-220}},
                                        color={0,127,255}));
          connect(senTMix.port_b, heaCoi.port_a2)
            annotation (Line(points={{-40,-220},{0,-220}}, color={0,127,255}));
          connect(heaCoi.port_b2, cooCoi.port_a2)
            annotation (Line(points={{20,-220},{62,-220}},
                                                        color={0,127,255}));
          connect(resSup.port_b, fanSup.port_a)
            annotation (Line(points={{160,-220},{220,-220}},
                                                           color={0,127,255}));
          connect(senVOut_flow.port_a, port_freAir) annotation (Line(points={{-160,-140},{-400,-140}},
                                                 color={0,127,255}));
          connect(eco.port_Exh, port_exhAir) annotation (Line(points={{-100,-184},{-120,-184},{-120,-220},{-400,-220}},
                                          color={0,127,255}));
          connect(senTSup.port_b, port_supAir)
            annotation (Line(points={{330,-220},{400,-220}},
                                                           color={0,127,255}));
          connect(TRet.port_a, port_retAir)
            annotation (Line(points={{360,-140},{402,-140}},
                                                         color={0,127,255}));
          connect(cooCoi.port_a1, port_cooCoiIn) annotation (Line(points={{82,-232},{120,-232},{120,-400}},
                                                    color={0,127,255}));
          connect(cooCoi.port_b1, port_CooCoiOut) annotation (Line(points={{62,-232},{50,-232},{50,-400},{40,-400}},
                                              color={0,127,255}));
          connect(heaCoi.port_a1, port_heaCoiIn) annotation (Line(points={{20,-232},{30,-232},{30,-360},{-40,-360},{-40,-400}},
                                                   color={0,127,255}));
          connect(heaCoi.port_b1, port_heaCoiOut) annotation (Line(points={{0,-232},{-20,-232},{-20,-340},{-120,-340},{-120,
                  -400}},                                   color={0,127,255}));

          connect(TRet.port_b, resRet.port_a)
            annotation (Line(points={{340,-140},{160,-140}},
                                                         color={0,127,255}));
          connect(resRet.port_b, eco.port_Sup) annotation (Line(points={{140,-140},{-68,-140},{-68,-172},{-80,-172}},
                                    color={0,127,255}));
          connect(fanSup.port_b, senTSup.port_a)
            annotation (Line(points={{240,-220},{310,-220}},
                                                           color={0,127,255}));
          connect(cooCoi.port_b2, resSup.port_a)
            annotation (Line(points={{82,-220},{140,-220}},
                                                          color={0,127,255}));
          connect(ahuSubBusO.yFanSup, fanSup.y) annotation (Line(
              points={{-354,20},{230,20},{230,-232}},
              color={255,204,51},
              thickness=0.5));
          connect(senTMix.T, ahuSubBusI.TAirLvgMix) annotation (Line(points={{-50,-209},{-50,-20},{-354,-20}},
                                         color={0,0,127}));
          connect(ahuSubBusO, ahuBus.ahuO) annotation (Line(
              points={{-354,20},{-378,20},{-378,0.1},{-400.1,0.1}},
              color={255,204,51},
              thickness=0.5));
          connect(senTSup.T, ahuSubBusI.TAirSup) annotation (Line(points={{320,-209},{320,-20},{-354,-20}},
                                        color={0,0,127}));
          connect(TRet.T, ahuSubBusI.TAirRet)
            annotation (Line(points={{350,-129},{350,-20},{-354,-20}},
                                                                     color={0,0,127}));
          connect(senVOut_flow.V_flow, ahuSubBusI.VFloAirOut) annotation (Line(points={{-150,-129},{-150,-20},{-354,-20}},
                                                    color={0,0,127}));
          connect(port_supAir, port_supAir) annotation (Line(points={{400,-220},{400,-220}},
                                        color={0,127,255}));
          connect(ahuSubBusO.yEcoOut, eco.yOut) annotation (Line(
              points={{-354,20},{-90,20},{-90,-166}},
              color={255,204,51},
              thickness=0.5), Text(
              string="%first",
              index=-1,
              extent={{-6,3},{-6,3}},
              horizontalAlignment=TextAlignment.Right));
          connect(ahuSubBusO.yEcoExh, eco.yExh) annotation (Line(
              points={{-354,20},{-82,20},{-82,-166},{-83,-166}},
              color={255,204,51},
              thickness=0.5), Text(
              string="%first",
              index=-1,
              extent={{-6,3},{-6,3}},
              horizontalAlignment=TextAlignment.Right));
          connect(conAHU1.ySupFan, ahuSubBusO.ySupFan) annotation (Line(points={{-236,
                  230.667},{-180,230.667},{-180,20},{-354,20}},
                color={255,0,255}), Text(
              string="%second",
              index=1,
              extent={{-6,3},{-6,3}},
              horizontalAlignment=TextAlignment.Right));
          connect(ahuSubBusO.yEcoRet, eco.yRet) annotation (Line(
              points={{-354,20},{-96,20},{-96,-166},{-96.8,-166}},
              color={255,204,51},
              thickness=0.5), Text(
              string="%first",
              index=-1,
              extent={{-6,3},{-6,3}},
              horizontalAlignment=TextAlignment.Right));
          connect(conAHU1.ySupFanSpe, ahuSubBusO.ySupFanSpe) annotation (Line(points={{-236,
                  221.333},{-186,221.333},{-186,20},{-354,20}},
                color={0,0,127}), Text(
              string="%second",
              index=1,
              extent={{-6,3},{-6,3}},
              horizontalAlignment=TextAlignment.Right));
          connect(conAHU1.TSupSet, ahuSubBusO.tSupSet) annotation (Line(points={{-236,
                  212},{-194,212},{-194,20},{-354,20}},
                color={0,0,127}), Text(
              string="%second",
              index=1,
              extent={{-6,3},{-6,3}},
              horizontalAlignment=TextAlignment.Right));
          connect(conAHU1.yHea, ahuSubBusO.yHea) annotation (Line(points={{-236,165.333},
                  {-200,165.333},{-200,20},{-354,20}},                                                                color={0,
                  0,127}), Text(
              string="%second",
              index=1,
              extent={{-6,3},{-6,3}},
              horizontalAlignment=TextAlignment.Right));
          connect(conAHU1.yCoo, ahuSubBusO.yCoo) annotation (Line(points={{-236,156},{
                  -208,156},{-208,20},{-354,20}},                                                                     color={0,
                  0,127}), Text(
              string="%second",
              index=1,
              extent={{-6,3},{-6,3}},
              horizontalAlignment=TextAlignment.Right));
          connect(conAHU1.yRetDamPos, ahuSubBusO.yRetDamPos) annotation (Line(points={{-236,
                  146.667},{-214,146.667},{-214,20},{-354,20}},
                color={0,0,127}), Text(
              string="%second",
              index=1,
              extent={{-6,3},{-6,3}},
              horizontalAlignment=TextAlignment.Right));
          connect(ahuSubBusI, conAHU1.TZonHeaSet) annotation (Line(
              points={{-354,-20},{-340,-20},{-340,236.889},{-324,236.889}},
              color={255,204,51},
              thickness=0.5));
          connect(ahuSubBusI, conAHU1.TZonCooSet) annotation (Line(
              points={{-354,-20},{-340,-20},{-340,232.222},{-324,232.222}},
              color={255,204,51},
              thickness=0.5));
          connect(ahuSubBusI, conAHU1.TOut) annotation (Line(
              points={{-354,-20},{-340,-20},{-340,227.556},{-324,227.556}},
              color={255,204,51},
              thickness=0.5));
          connect(ahuSubBusI, conAHU1.VDis_flow[1]) annotation (Line(
              points={{-354,-20},{-340,-20},{-340,214},{-324,214}},
              color={255,204,51},
              thickness=0.5));
          connect(ahuSubBusI, conAHU1.ducStaPre) annotation (Line(
              points={{-354,-20},{-340,-20},{-340,222.889},{-324,222.889}},
              color={255,204,51},
              thickness=0.5));
          connect(ahuSubBusI.TDis, conAHU1.TDis) annotation (Line(
              points={{-354,-20},{-340,-20},{-340,194},{-324,194}},
              color={255,204,51},
              thickness=0.5));
          connect(ahuSubBusI, conAHU1.TZon[1]) annotation (Line(
              points={{-354,-20},{-340,-20},{-340,198},{-324,198}},
              color={255,204,51},
              thickness=0.5));
          connect(ahuSubBusI, conAHU1.TSup) annotation (Line(
              points={{-354,-20},{-340,-20},{-340,176.222},{-324,176.222}},
              color={255,204,51},
              thickness=0.5));
          connect(ahuSubBusI, conAHU1.TOutCut) annotation (Line(
              points={{-354,-20},{-340,-20},{-340,171.556},{-324,171.556}},
              color={255,204,51},
              thickness=0.5));
          connect(ahuSubBusI, conAHU1.VOut_flow) annotation (Line(
              points={{-354,-20},{-340,-20},{-340,157.556},{-324,157.556}},
              color={255,204,51},
              thickness=0.5));
          connect(ahuSubBusI, conAHU1.TMix) annotation (Line(
              points={{-354,-20},{-340,-20},{-340,151.333},{-324,151.333}},
              color={255,204,51},
              thickness=0.5));
          connect(ahuSubBusI, conAHU1.uOpeMod) annotation (Line(
              points={{-354,-20},{-340,-20},{-340,145.111},{-324,145.111}},
              color={255,204,51},
              thickness=0.5));
          connect(ahuSubBusI, conAHU1.uZonTemResReq) annotation (Line(
              points={{-354,-20},{-340,-20},{-340,140.444},{-324,140.444}},
              color={255,204,51},
              thickness=0.5));
          connect(ahuSubBusI, conAHU1.uZonPreResReq) annotation (Line(
              points={{-354,-20},{-340,-20},{-340,135.778},{-324,135.778}},
              color={255,204,51},
              thickness=0.5));
          connect(conAHU1.yOutDamPos, ahuSubBusO.yOutDamPos) annotation (Line(points={{-236,
                  137.333},{-220,137.333},{-220,20},{-354,20}},
                color={0,0,127}), Text(
              string="%second",
              index=1,
              extent={{-6,3},{-6,3}},
              horizontalAlignment=TextAlignment.Right));
          connect(ahuSubBusI, ahuBus.ahuI) annotation (Line(
              points={{-354,-20},{-378,-20},{-378,0.1},{-400.1,0.1}},
              color={255,204,51},
              thickness=0.5), Text(
              string="%second",
              index=-1,
              extent={{6,3},{6,3}},
              horizontalAlignment=TextAlignment.Left));
          annotation (
            defaultComponentName="ahu",
            Diagram(coordinateSystem(extent={{-400,-400},{400,340}}), graphics={
                Rectangle(
                  extent={{-400,60},{400,-60}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.Solid,
                  fillColor={245,239,184},
                  pattern=LinePattern.None),
                Text(
                  extent={{-366,-278},{-132,-300}},
                  lineColor={28,108,200},
                  textString="Equipment section"),
                Text(
                  extent={{-104,52},{130,30}},
                  lineColor={28,108,200},
                  textString="Bus section"),
                Text(
                  extent={{-118,298},{116,276}},
                  lineColor={28,108,200},
                  textString="Controls section"),
                Text(
                  extent={{-394,346},{-164,310}},
                  lineColor={0,0,0},
                  fontSize=10,
                  textString=
                      "This model is pseudo code: the bus connections are not valid as is. It only illustrates the typical model architecture.")}),
                                                                       Icon(
                coordinateSystem(extent={{-100,-100},{100,100}})));
        end AHUControlBus;

        model AHULayout "VAV air handler unit with expandable connector"
          replaceable package MediumAir = Buildings.Media.Air "Medium model for air";
          replaceable package MediumWat = Buildings.Media.Water "Medium model for water";

          parameter Modelica.SIunits.MassFlowRate mAir_flow_nominal "Nominal air mass flow rate";

          parameter Modelica.SIunits.MassFlowRate mWatHeaCoi_flow_nominal
            "Nominal water mass flow rate for heating coil"
            annotation(Dialog(group="Heating coil"));

          parameter Modelica.SIunits.HeatFlowRate QHeaCoi_flow_nominal(min=0)=
            mAir_flow_nominal * (THeaCoiAirIn_nominal-THeaCoiAirOut_nominal)*1006
            "Nominal heat transfer of heating coil";
          parameter Modelica.SIunits.Temperature THeaCoiAirIn_nominal=281.65
            "Nominal air inlet temperature heating coil"
            annotation(Dialog(group="Heating coil"));
          parameter Modelica.SIunits.Temperature THeaCoiAirOut_nominal=313.65
            "Nominal air inlet temperature heating coil"
            annotation(Dialog(group="Heating coil"));
          parameter Modelica.SIunits.Temperature THeaCoiWatIn_nominal=318.15
            "Nominal water inlet temperature heating coil"
            annotation(Dialog(group="Heating coil"));
          parameter Modelica.SIunits.Temperature THeaCoiWatOut_nominal=THeaCoiWatIn_nominal-QHeaCoi_flow_nominal/mWatHeaCoi_flow_nominal/4200
            "Nominal water inlet temperature heating coil"
            annotation(Dialog(group="Heating coil"));

          parameter Modelica.SIunits.PressureDifference dpHeaCoiWat_nominal(
            min=0,
            displayUnit="Pa") = 3000
            "Water-side pressure drop of heating coil"
            annotation(Dialog(group="Heating coil"));

          parameter Modelica.SIunits.PressureDifference dpSup_nominal(
            min=0,
            displayUnit="Pa") = 500
            "Pressure difference of supply air leg (coils and filter)";

          parameter Modelica.SIunits.PressureDifference dpRet_nominal(
            min=0,
            displayUnit="Pa") = 50
            "Pressure difference of supply air leg (coils and filter)";

          parameter Modelica.SIunits.PressureDifference dpFanSup_nominal(
            min=Modelica.Constants.small,
            displayUnit="Pa")
            "Fan head at mAir_flow_nominal and full speed";

          /* Fixme: This should be constrained to all fans, not all movers */
          replaceable parameter Fluid.Movers.Data.Generic datFanSup(
            pressure(
              V_flow={0,mAir_flow_nominal/1.2*2},
              dp=2*{dpFanSup_nominal,0}))
              constrainedby Fluid.Movers.Data.Generic "Performance data for supply fan"
            annotation (
              choicesAllMatching=true,
              Dialog(
                group="Fan"),
            Placement(transformation(extent={{318,-298},{338,-278}})));

          Modelica.Fluid.Interfaces.FluidPort_a port_airOutMin(redeclare
              package Medium =
                MediumAir) "Outdoor air port for minimum OA damper" annotation (
              Placement(transformation(extent={{-410,-190},{-390,-170}}),
                iconTransformation(extent={{-110,10},{-90,30}})),
                __Linkage(Connect(path="air_sup_min")));
          Modelica.Fluid.Interfaces.FluidPort_a port_airOut(redeclare package
              Medium =
                MediumAir) "Outdoor air port" annotation (Placement(transformation(
                  extent={{-410,-230},{-390,-210}}), iconTransformation(extent={{-110,10},{
                    -90,30}})),
                __Linkage(Connect(path="air_ret")));

          Modelica.Fluid.Interfaces.FluidPort_b port_airExh(redeclare package
              Medium =
                MediumAir) "Exhaust air port" annotation (Placement(transformation(extent={{-410,
                    -150},{-390,-130}}), iconTransformation(extent={{-110,-30},{-90,-10}})),
            __Linkage(Connect(path="air_ret")));
          Modelica.Fluid.Interfaces.FluidPort_b port_supAir(redeclare package
              Medium =
            MediumAir) "Supply air" annotation (Placement(transformation(extent={{390,-230},{410,-210}}),
            iconTransformation(extent={{90,-30},{110,-10}})),
            __Linkage(Connect(path="air_sup")));

          Modelica.Fluid.Interfaces.FluidPort_b port_coiPreHeaRet(redeclare
              package Medium =
                       MediumWat) "Preheat coil return port" annotation (Placement(
                transformation(extent={{-270,-410},{-250,-390}}), iconTransformation(
                  extent={{-90,-110},{-70,-90}})),
                __Linkage(Connect(path="chw_sup")));
          Modelica.Fluid.Interfaces.FluidPort_a port_coiPreHeaSup(redeclare
              package Medium =
                       MediumWat) "Preheat coil supply port" annotation (Placement(
                transformation(extent={{-210,-410},{-190,-390}}), iconTransformation(
                  extent={{-50,-110},{-30,-90}})),
                __Linkage(Connect(path="phw_sup")));

          Modelica.Fluid.Interfaces.FluidPort_a port_retAir(redeclare package
              Medium =
                MediumAir) "Return air"
            annotation (Placement(transformation(extent={{390,-150},{410,-130}}),
                iconTransformation(extent={{90,10},{110,30}})));
          Modelica.Fluid.Interfaces.FluidPort_a port_coiCooSup(redeclare
              package Medium =
                MediumWat) "Cooling coil supply port" annotation (Placement(
                transformation(extent={{-70,-410},{-50,-390}}), iconTransformation(
                  extent={{70,-110},{90,-90}})));
          Modelica.Fluid.Interfaces.FluidPort_b port_coiCooRet(redeclare
              package Medium =
                MediumWat) "Cooling coil return port" annotation (Placement(
                transformation(extent={{-130,-410},{-110,-390}}),
                                                              iconTransformation(extent=
                   {{30,-110},{50,-90}})));
          Modelica.Fluid.Interfaces.FluidPort_a port_coiReHeaSup(redeclare
              package Medium =
                       MediumWat) "Reheat coil supply port" annotation (Placement(
                transformation(extent={{70,-410},{90,-390}}),   iconTransformation(
                  extent={{-50,-110},{-30,-90}})));
          Modelica.Fluid.Interfaces.FluidPort_b port_coiReHeaRet(redeclare
              package Medium =
                       MediumWat) "Reheat coil return port" annotation (Placement(
                transformation(extent={{10,-410},{30,-390}}),     iconTransformation(
                  extent={{-90,-110},{-70,-90}})));

          Fluid.HeatExchangers.DryCoilEffectivenessNTU coiReHea(
            redeclare package Medium1 = MediumWat,
            redeclare package Medium2 = MediumAir,
            m1_flow_nominal=mWatHeaCoi_flow_nominal,
            m2_flow_nominal=mAir_flow_nominal,
            configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
            use_Q_flow_nominal=true,
            Q_flow_nominal=QHeaCoi_flow_nominal,
            dp1_nominal=dpHeaCoiWat_nominal,
            dp2_nominal=0,
            T_a1_nominal=THeaCoiWatIn_nominal,
            T_a2_nominal=THeaCoiAirIn_nominal) "Reheat coil"
            annotation (Placement(transformation(extent={{20,-216},{0,-236}})));

          Fluid.HeatExchangers.WetCoilCounterFlow coiCoo(
            redeclare package Medium1 = MediumWat,
            redeclare package Medium2 = MediumAir,
            UA_nominal=mAir_flow_nominal*1000*15/
                Buildings.Fluid.HeatExchangers.BaseClasses.lmtd(
                T_a1=datcoiCoo.TWatIn_nominal,
                T_b1=datcoiCoo.TWatOut_nominal,
                T_a2=datcoiCoo.TAirIn_nominal,
                T_b2=datcoiCoo.TOut_nominal),
            m1_flow_nominal=datcoiCoo.mWat_flow_nominal,
            m2_flow_nominal=datcoiCoo.mAir_flow_nominal,
            dp1_nominal=datcoiCoo.dpWat_nominal,
            dp2_nominal=datcoiCoo.dpAir_nominal,
            energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Cooling coil"
            annotation (Placement(transformation(extent={{-40,-216},{-60,-236}})));

          Fluid.FixedResistances.PressureDrop resSup(
            redeclare package Medium = MediumAir,
            m_flow_nominal=mAir_flow_nominal,
            dp_nominal=dpSup_nominal)
            "Pressure drop of heat exchangers and filter combined"
            annotation (Placement(transformation(extent={{160,-230},{180,-210}})));

          Fluid.Sensors.TemperatureTwoPort senTMix(
            redeclare package Medium = MediumAir,
            m_flow_nominal=mAir_flow_nominal) "Mixed air temperature sensor"
            annotation (Placement(transformation(extent={{-210,-230},{-190,-210}})));

          Fluid.Sensors.TemperatureTwoPort senTSup(
            redeclare package Medium = MediumAir,
            m_flow_nominal=mAir_flow_nominal) "Supply air temperature sensor"
            annotation (Placement(transformation(extent={{350,-230},{370,-210}})));
          Fluid.Sensors.TemperatureTwoPort senTRet(redeclare package Medium = MediumAir,
              m_flow_nominal=mAir_flow_nominal) "Return air temperature sensor"
            annotation (Placement(transformation(extent={{370,-150},{350,-130}})));
          Fluid.FixedResistances.PressureDrop resRet(
            redeclare package Medium = MediumAir,
            m_flow_nominal=mAir_flow_nominal,
            dp_nominal=dpRet_nominal)
                          "Pressure drop for return duct"
            annotation (Placement(transformation(extent={{180,-150},{160,-130}})));
          Fluid.Movers.SpeedControlled_y fanSup(
            redeclare package Medium = MediumAir,
            per=datFanSup,
            energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Supply fan"
            annotation (Placement(transformation(extent={{70,-210},{90,-230}})));

          Fluid.Sensors.VolumeFlowRate senVOut_flow(
            redeclare package Medium = MediumAir,
            m_flow_nominal=mAir_flow_nominal)
            "Outside air volume flow rate"
            annotation (Placement(transformation(extent={{-330,-150},{-310,-130}})));

          parameter Data.CoolingCoil datcoiCoo "Coolin coil nominal parameters"
            annotation (Placement(transformation(extent={{280,-340},{300,-320}})));

          BaseClasses.AhuBus ahuBus annotation (Placement(transformation(
                extent={{-20,-20},{20,20}},
                rotation=90,
                origin={-400,0}),   iconTransformation(extent={{-10,90},{10,110}})));

          Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller conAHU
            annotation (Placement(transformation(extent={{-320,128},{-240,240}})));
          BaseClasses.TerminalBus terBus[nTer] "Terminal unit bus" annotation (
              Placement(transformation(
                extent={{-20,-20},{20,20}},
                rotation=-90,
                origin={398,-2})));
          Fluid.HeatExchangers.DryCoilEffectivenessNTU coiPreHea(
            redeclare package Medium1 = MediumWat,
            redeclare package Medium2 = MediumAir,
            m1_flow_nominal=mWatHeaCoi_flow_nominal,
            m2_flow_nominal=mAir_flow_nominal,
            configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
            use_Q_flow_nominal=true,
            Q_flow_nominal=QHeaCoi_flow_nominal,
            dp1_nominal=dpHeaCoiWat_nominal,
            dp2_nominal=0,
            T_a1_nominal=THeaCoiWatIn_nominal,
            T_a2_nominal=THeaCoiAirIn_nominal) "Preheat coil"
            annotation (Placement(transformation(extent={{-100,-216},{-120,-236}})),
              __Linkage(Connect(path="air_sup")));

          Fluid.Sensors.TemperatureTwoPort senTOut(redeclare package Medium = MediumAir,
              m_flow_nominal=mAir_flow_nominal) "Outdoor air temperature sensor"
            annotation (Placement(transformation(extent={{-370,-230},{-350,-210}})),
            __Linkage(Connect(path="air_sup")));
          Fluid.Sensors.TemperatureTwoPort senTCoiPreHeaLvg(redeclare package
              Medium =
                MediumAir, m_flow_nominal=mAir_flow_nominal)
            "Preheat coil leaving air temperature sensor"
            annotation (Placement(transformation(extent={{-90,-230},{-70,-210}})),
            __Linkage(Connect(path="air_sup")));
          Fluid.Sensors.TemperatureTwoPort senTExh(redeclare package Medium = MediumAir,
              m_flow_nominal=mAir_flow_nominal) "Exhaust air temperature sensor"
            annotation (Placement(transformation(extent={{-370,-150},{-350,-130}}),
            __Linkage(Connect(path="air_ret"))));
          Fluid.Actuators.Dampers.MixingBox eco "Air economizer"
            annotation (Placement(transformation(extent={{-250,-170},{-230,-190}})),
            __Linkage(Connect(explicit="port_Ret: air_ret, port_Exh: air_ret, port_Out: air_sup, port_Sup: air_sup")));
          Fluid.Actuators.Dampers.MixingBoxMinimumFlow eco_cla1 "Air economizer"
            annotation (Placement(transformation(extent={{-210,-170},{-190,-190}})),
            __Linkage(Connect(explicit="port_Ret: air_ret, port_Exh: air_ret, port_Out: air_sup, port_Sup: air_sup, port_OutMin: air_sup_min")));

          Fluid.Sensors.TemperatureTwoPort senTCoiCooLvg(redeclare package
              Medium =
                MediumAir, m_flow_nominal=mAir_flow_nominal)
            "Cooling coil leaving air temperature sensor"
            annotation (Placement(transformation(extent={{-30,-230},{-10,-210}})));
          Fluid.Movers.SpeedControlled_y fanSup_pos1(
            redeclare package Medium = MediumAir,
            per=datFanSup,
            energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Supply air fan"
            annotation (Placement(transformation(extent={{-170,-210},{-150,-230}})));

          Fluid.Movers.SpeedControlled_y fanSup_cla1(
            redeclare package Medium = MediumAir,
            per=datFanSup,
            energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Supply fan"
            annotation (Placement(transformation(extent={{70,-250},{90,-270}})));
          Fluid.Sensors.TemperatureTwoPort senTCoiReHeaLvg(redeclare package
              Medium =
                MediumAir, m_flow_nominal=mAir_flow_nominal)
            "Reheat coil leaving air temperature sensor"
            annotation (Placement(transformation(extent={{30,-230},{50,-210}})),
            __Linkage(present=true));
          Fluid.Movers.SpeedControlled_y fanRet(
            redeclare package Medium = MediumAir,
            per=datFanSup,
            energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
            "Return/relief/exhaust fan"
            annotation (Placement(transformation(extent={{90,-130},{70,-150}})));
          Fluid.Movers.SpeedControlled_y fanRet_pos1(
            redeclare package Medium = MediumAir,
            per=datFanSup,
            energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
            "Return/relief/exhaust fan"
            annotation (Placement(transformation(extent={{-270,-130},{-290,-150}})));
          Fluid.HeatExchangers.DXCoils.AirCooled.VariableSpeed coiCoo_cla1(
              energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
            "Cooling coil "
            annotation (Placement(transformation(extent={{-60,-270},{-40,-250}})));
          Fluid.HeatExchangers.Heater_T coiPreHea_cla1 "Preheat coil"
            annotation (Placement(transformation(extent={{-120,-270},{-100,-250}})));
          BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(
                transformation(extent={{-20,320},{20,360}}), iconTransformation(extent=
                    {{-656,216},{-636,236}})));
          Fluid.HeatExchangers.Heater_T coiReHea_cla1 "Reheat coil"
            annotation (Placement(transformation(extent={{0,-270},{20,-250}})));
          replaceable parameter Fluid.Movers.Data.Generic datFanSup_cla1[n](pressure(
                V_flow={0,mAir_flow_nominal/1.2*2}, dp=2*{dpFanSup_nominal,0}))
            constrainedby Fluid.Movers.Data.Generic "Performance data for supply fan"
            annotation (
            choicesAllMatching=true,
            Dialog(group="Fan"),
            Placement(transformation(extent={{280,-298},{300,-278}})));
          Fluid.HeatExchangers.DryCoilEffectivenessNTU coiPreHea_pos1(
            redeclare package Medium1 = MediumWat,
            redeclare package Medium2 = MediumAir,
            m1_flow_nominal=mWatHeaCoi_flow_nominal,
            m2_flow_nominal=mAir_flow_nominal,
            configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
            use_Q_flow_nominal=true,
            Q_flow_nominal=QHeaCoi_flow_nominal,
            dp1_nominal=dpHeaCoiWat_nominal,
            dp2_nominal=0,
            T_a1_nominal=THeaCoiWatIn_nominal,
            T_a2_nominal=THeaCoiAirIn_nominal) "Preheat coil" annotation (Placement(
                transformation(extent={{-300,-216},{-320,-236}})), __Linkage(Connect(
                  path="air_sup")));

          Fluid.Sensors.TemperatureTwoPort senTCoiPreHeaLvg_pos1(redeclare
              package Medium =
                       MediumAir, m_flow_nominal=mAir_flow_nominal)
            "Preheat coil leaving air temperature sensor" annotation (Placement(
                transformation(extent={{-290,-230},{-270,-210}})), __Linkage(Connect(
                  path="air_sup")));
          Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller conAHU_cla1
            annotation (Placement(transformation(extent={{-180,130},{-100,242}})));
          Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller conAHU_cla2
            annotation (Placement(transformation(extent={{-60,130},{20,242}})));
        equation

          connect(port_supAir, port_supAir) annotation (Line(points={{400,-220},{400,-220}},
                                        color={0,127,255}));
          connect(port_airOut, senTOut.port_a)
            annotation (Line(points={{-400,-220},{-370,-220}}, color={0,127,255}));
          connect(senTOut.port_b, coiPreHea_pos1.port_a2)
            annotation (Line(points={{-350,-220},{-320,-220}}, color={0,127,255}));
          connect(port_airOutMin, eco_cla1.port_OutMin) annotation (Line(points={{-400,-180},
                  {-280,-180},{-280,-190},{-210,-190}}, color={0,127,255}));
          connect(coiPreHea_pos1.port_b2, senTCoiPreHeaLvg_pos1.port_a)
            annotation (Line(points={{-300,-220},{-290,-220}}, color={0,127,255}));
          connect(senTCoiPreHeaLvg_pos1.port_b, senTMix.port_a)
            annotation (Line(points={{-270,-220},{-210,-220}}, color={0,127,255}));
          connect(senTMix.port_b, fanSup_pos1.port_a)
            annotation (Line(points={{-190,-220},{-170,-220}}, color={0,127,255}));
          connect(fanSup_pos1.port_b, coiPreHea.port_a2)
            annotation (Line(points={{-150,-220},{-120,-220}}, color={0,127,255}));
          connect(fanRet_pos1.port_a, eco.port_Exh) annotation (Line(points={{-270,-140},
                  {-260,-140},{-260,-174},{-250,-174}}, color={0,127,255}));
          connect(eco.port_Out, senTCoiPreHeaLvg_pos1.port_b) annotation (Line(points={{
                  -250,-186},{-260,-186},{-260,-220},{-270,-220}}, color={0,127,255}));
          connect(eco.port_Ret, fanRet.port_b) annotation (Line(points={{-230,-174},{-220,
                  -174},{-220,-140},{70,-140}}, color={0,127,255}));
          connect(eco.port_Sup, senTMix.port_a) annotation (Line(points={{-230,-186},{-220,
                  -186},{-220,-220},{-210,-220}}, color={0,127,255}));
          connect(fanRet_pos1.port_b, senVOut_flow.port_b)
            annotation (Line(points={{-290,-140},{-310,-140}}, color={0,127,255}));
          connect(senVOut_flow.port_a, senTExh.port_b)
            annotation (Line(points={{-330,-140},{-350,-140}}, color={0,127,255}));
          connect(senTExh.port_a, port_airExh)
            annotation (Line(points={{-370,-140},{-400,-140}}, color={0,127,255}));
          connect(coiPreHea.port_b2, senTCoiPreHeaLvg.port_a)
            annotation (Line(points={{-100,-220},{-90,-220}}, color={0,127,255}));
          connect(senTCoiPreHeaLvg.port_b, coiCoo.port_a2) annotation (Line(points={{-70,
                  -220},{-60,-220},{-60,-220}}, color={0,127,255}));
          connect(coiCoo.port_b2, senTCoiCooLvg.port_a)
            annotation (Line(points={{-40,-220},{-30,-220}}, color={0,127,255}));
          connect(senTCoiCooLvg.port_b, coiReHea.port_a2)
            annotation (Line(points={{-10,-220},{0,-220}}, color={0,127,255}));
          connect(coiReHea.port_b2, senTCoiReHeaLvg.port_a)
            annotation (Line(points={{20,-220},{30,-220}}, color={0,127,255}));
          connect(port_coiPreHeaSup, coiPreHea.port_a1) annotation (Line(points={{-200,
                  -400},{-200,-242},{-94,-242},{-94,-232},{-100,-232}}, color={0,127,
                  255}));
          connect(coiPreHea.port_b1, port_coiPreHeaRet) annotation (Line(points={{-120,
                  -232},{-260,-232},{-260,-400}}, color={0,127,255}));
          connect(port_coiCooSup, coiCoo.port_a1) annotation (Line(points={{-60,-400},{
                  -60,-240},{-30,-240},{-30,-232},{-40,-232}}, color={0,127,255}));
          connect(coiCoo.port_b1, port_coiCooRet) annotation (Line(points={{-60,-232},{
                  -80,-232},{-80,-380},{-120,-380},{-120,-400}}, color={0,127,255}));
          connect(coiReHea.port_b1, port_coiReHeaRet) annotation (Line(points={{0,-232},
                  {-8,-232},{-8,-240},{20,-240},{20,-400}}, color={0,127,255}));
          connect(port_coiReHeaSup, coiReHea.port_a1) annotation (Line(points={{80,-400},
                  {80,-380},{40,-380},{40,-232},{20,-232}}, color={0,127,255}));
          connect(senTCoiReHeaLvg.port_b, fanSup.port_a)
            annotation (Line(points={{50,-220},{70,-220}}, color={0,127,255}));
          connect(fanSup.port_b, resSup.port_a)
            annotation (Line(points={{90,-220},{160,-220}}, color={0,127,255}));
          connect(resSup.port_b, senTSup.port_a)
            annotation (Line(points={{180,-220},{350,-220}}, color={0,127,255}));
          connect(senTSup.port_b, port_supAir)
            annotation (Line(points={{370,-220},{400,-220}}, color={0,127,255}));
          connect(port_retAir, senTRet.port_a) annotation (Line(points={{400,-140},{386,
                  -140},{386,-140},{370,-140}}, color={0,127,255}));
          connect(senTRet.port_b, resRet.port_a) annotation (Line(points={{350,-140},{
                  264,-140},{264,-140},{180,-140}}, color={0,127,255}));
          connect(resRet.port_b, fanRet.port_a)
            annotation (Line(points={{160,-140},{90,-140}}, color={0,127,255}));
          connect(fanRet_pos1.port_a, fanRet.port_b)
            annotation (Line(points={{-270,-140},{70,-140}}, color={0,127,255}));
          annotation (
            defaultComponentName="ahu",
            Diagram(coordinateSystem(extent={{-400,-400},{400,340}}), graphics={
                Rectangle(
                  extent={{-400,60},{400,-60}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.Solid,
                  fillColor={245,239,184},
                  pattern=LinePattern.None),
                Text(
                  extent={{-400,-340},{-166,-362}},
                  lineColor={0,0,0},
                  textString="Equipment section",
                  horizontalAlignment=TextAlignment.Left),
                Text(
                  extent={{-400,60},{-166,38}},
                  lineColor={0,0,0},
                  textString="Control bus section",
                  horizontalAlignment=TextAlignment.Left),
                Text(
                  extent={{-400,340},{-166,318}},
                  lineColor={0,0,0},
                  textString="Controls section",
                  horizontalAlignment=TextAlignment.Left),
                Text(
                  extent={{96,-260},{178,-270}},
                  lineColor={244,125,35},
                  horizontalAlignment=TextAlignment.Left,
                  textString="fanSup_cla1 is a wrapper for a fan array")}),
                                                                       Icon(
                coordinateSystem(extent={{-100,-100},{100,100}})));
        end AHULayout;

        package Data "Package with data records"
        extends Modelica.Icons.MaterialPropertiesPackage;
          record CoolingCoil "Data record for cooling coil"
            extends Modelica.Icons.Record;

            parameter Modelica.SIunits.Temperature TAirIn_nominal=313.15
              "Nominal air inlet temperature"
              annotation(Dialog(group="Air"));
            parameter Modelica.SIunits.Temperature TAirOut_nominal=291.15
              "Nominal air outlet temperature"
              annotation(Dialog(group="Air"));
            parameter Modelica.SIunits.MassFraction X_vIn_nominal=0.00
              "Nominal air inlet absolute humidity"
              annotation(Dialog(group="Air"));
            parameter Modelica.SIunits.MassFraction X_vOut_nominal=0.00
              "Nominal air outlet absolute humidity"
              annotation(Dialog(group="Air"));
            parameter Modelica.SIunits.MassFlowRate mAir_flow_nominal
              "Nominal air mass flow rate"
                annotation(Dialog(group="Air"));
            parameter Modelica.SIunits.PressureDifference dpAir_nominal(
              min=0,
              displayUnit="Pa") = 200
              "Air-side pressure drop"
              annotation(Dialog(group="Air"));

            parameter Modelica.SIunits.Temperature TWatIn_nominal=281.65
              "Nominal air inlet temperature cooling coil"
             annotation(Dialog(group="Hydronics"));
            parameter Modelica.SIunits.MassFlowRate mWat_flow_nominal
              "Nominal water mass flow rate"
                annotation(Dialog(group="Hydronics"));
            parameter Modelica.SIunits.PressureDifference dpWat_nominal(
              min=0,
              displayUnit="Pa") = 20000
              "Water-side pressure drop"
              annotation(Dialog(group="Hydronics"));

            final parameter Real UA_nominal(fixed=false);

            annotation (
              defaultComponentPrefixes = "parameter",
              defaultComponentName = "datCooCoi",
            Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
                  coordinateSystem(preserveAspectRatio=false)),
              Documentation(info="<html>
<p>
Data record for cooling coil.
</p>
</html>",           revisions="<html>
<ul>
<li>
March 4, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
          end CoolingCoil;
        end Data;

        package MinimumExamples "Collection of minimum examples"
          extends Modelica.Icons.ExamplesPackage;

          model LayoutTemplate "AHU layout template"

            // MEDIA
            replaceable package MediumA = Buildings.Media.Air
              "Medium model for air";
            replaceable package MediumW = Buildings.Media.Water
              "Medium model for water";

            // PARAMETERS
            //// Structural
            final parameter Boolean have_airFloMeaSta
              "Set to true if the AHU has Air Flow Measurement Station"
              annotation(Evaluate=true);

            //// System level
            parameter Modelica.SIunits.MassFlowRate mSup_flow_nominal
              "Nominal supply air mass flow rate";
            parameter Modelica.Fluid.Types.Dynamics energyDynamics=
              Modelica.Fluid.Types.Dynamics.FixedInitial
              "Type of energy balance: dynamic (3 initialization options) or steady state"
              annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
            parameter Modelica.Fluid.Types.Dynamics massDynamics=energyDynamics
              "Type of mass balance: dynamic (3 initialization options) or steady state"
              annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));

            // Economizer
            parameter Modelica.SIunits.MassFlowRate mOut_flow_nominal
              "Mass flow rate outside air damper"
              annotation (Dialog(group="Economizer"));
            parameter Modelica.SIunits.PressureDifference dpDamOut_nominal(min=0, displayUnit="Pa")
              "Pressure drop of damper in outside air leg"
               annotation (Dialog(group="Economizer"));
            parameter Modelica.SIunits.PressureDifference dpFixOut_nominal(min=0, displayUnit="Pa")=0
              "Pressure drop of duct and other resistances in outside air leg"
               annotation (Dialog(group="Economizer"));
            parameter Modelica.SIunits.MassFlowRate mRec_flow_nominal
              "Mass flow rate recirculation air damper"
              annotation (Dialog(group="Economizer"));
            parameter Modelica.SIunits.PressureDifference dpDamRec_nominal(min=0, displayUnit="Pa")
              "Pressure drop of damper in recirculation air leg"
               annotation (Dialog(group="Economizer"));
            parameter Modelica.SIunits.PressureDifference dpFixRec_nominal(min=0, displayUnit="Pa")=0
              "Pressure drop of duct and other resistances in recirculation air leg"
               annotation (Dialog(group="Economizer"));
            parameter Modelica.SIunits.MassFlowRate mExh_flow_nominal
              "Mass flow rate exhaust air damper"
              annotation (Dialog(group="Economizer"));
            parameter Modelica.SIunits.PressureDifference dpDamExh_nominal(min=0, displayUnit="Pa")
              "Pressure drop of damper in exhaust air leg"
               annotation (Dialog(group="Economizer"));
            parameter Modelica.SIunits.PressureDifference dpFixExh_nominal(min=0, displayUnit="Pa")=0
              "Pressure drop of duct and other resistances in exhaust air leg"
               annotation (Dialog(group="Economizer"));
            parameter Modelica.SIunits.MassFlowRate mOutMin_flow_nominal
              "Mass flow rate minimum outside air damper"
              annotation (Dialog(group="Economizer"));
            parameter Modelica.SIunits.PressureDifference dpDamOutMin_nominal(
              min=0, displayUnit="Pa")
              "Pressure drop of damper in minimum outside air leg"
               annotation (Dialog(group="Economizer"));
            parameter Modelica.SIunits.PressureDifference dpFixOutMin_nominal(
              min=0, displayUnit="Pa") = 0
              "Pressure drop of duct and other resistances in minimum outside air leg"
               annotation (Dialog(group="Economizer"));

            //// Cooling coil
            parameter Data.CoolingCoil datCoiCoo(
              mAir_flow_nominal=mSup_flow_nominal) "Cooling coil parameters"
              annotation (
                Dialog(group="Cooling coil"),
                Placement(transformation(extent={{-60,-308},{-40,-288}})));
            parameter Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.DXCoil
              datCoiCoo_cla1
              "DX coil performance data"
              annotation (
                Dialog(group="Cooling coil"),
                Placement(transformation(extent={{-60,-338},{-40,-318}})));

            //// Supply fan
            parameter Modelica.SIunits.PressureDifference dpFanSup_nominal(
              min=Modelica.Constants.small,
              displayUnit="Pa")
              "Fan head at nominal air flow rate and full speed"
              annotation(Dialog(group="Supply fan"));
            /* Fixme: This should be constrained to all fans, not all movers. */
            replaceable parameter Fluid.Movers.Data.Generic datFanSup(
              pressure(
                V_flow={0, mSup_flow_nominal/1.2*2},
                dp=2*{dpFanSup_nominal, 0}))
              constrainedby Fluid.Movers.Data.Generic
              "Performance data for supply fan"
              annotation (
                choicesAllMatching=true,
                Dialog(group="Supply fan"),
              Placement(transformation(extent={{70,-308},{90,-288}})));
            replaceable parameter Fluid.Movers.Data.Generic datFanSup_cla1[n](
              each pressure(
                V_flow={0, mSup_flow_nominal/1.2*2},
                dp=2*{dpFanSup_nominal, 0}))
              constrainedby Fluid.Movers.Data.Generic
              "Performance data for supply fan"
              annotation (
              choicesAllMatching=true,
              Dialog(group="Supply fan"),
              Placement(transformation(extent={{70,-336},{90,-316}})));

            // I/O VARIABLES
            Modelica.Fluid.Interfaces.FluidPort_a port_airOut(
              redeclare final package Medium = MediumA)
              "Outdoor air port"
              annotation (Placement(transformation(extent={{-410,-230},{-390,-210}}),
                iconTransformation(extent={{-110,10},{-90,30}})));
            Modelica.Fluid.Interfaces.FluidPort_b port_airExh(
              redeclare final package Medium = MediumA)
              "Exhaust air port"
              annotation (Placement(transformation(extent={{-410,-150},{-390,-130}}),
                iconTransformation(extent={{-110,-30},{-90,-10}})));
            Modelica.Fluid.Interfaces.FluidPort_a port_airOutMin(
              redeclare final package Medium = MediumA)
              "Outdoor air port for minimum OA damper"
              annotation (
                Placement(transformation(extent={{-410,-190},{-390,-170}}),
                  iconTransformation(extent={{-110,10},{-90,30}})));
            Modelica.Fluid.Interfaces.FluidPort_b port_supAir(
              redeclare final package Medium =MediumA)
              "Supply air"
              annotation (Placement(transformation(extent={{390,-230},{410,-210}}),
              iconTransformation(extent={{90,-30},{110,-10}})));
            Modelica.Fluid.Interfaces.FluidPort_a port_retAir(
              redeclare final package Medium = MediumA)
              "Return air"
              annotation (Placement(transformation(extent={{390,-150},{410,-130}}),
                iconTransformation(extent={{90,10},{110,30}})));
            Modelica.Fluid.Interfaces.FluidPort_a port_coiCooSup(
              redeclare final package Medium = MediumW)
              "Cooling coil supply port"
              annotation (
                Placement(transformation(extent={{-30,-410},{-10,-390}}),
                iconTransformation(extent={{70,-110},{90,-90}})));
            Modelica.Fluid.Interfaces.FluidPort_b port_coiCooRet(
              redeclare final package Medium = MediumW)
              "Cooling coil return port"
              annotation (Placement( transformation(extent={{-90,-410},{-70,-390}}),
                iconTransformation(extent={{30,-110},{50,-90}})));
            BoundaryConditions.WeatherData.Bus weaBus
              "Weather bus"
              annotation (Placement(transformation(extent={{-20,320},{20,360}}),
                iconTransformation(extent={{-10,-10},{10,10}},
                  rotation=90,
                  origin={-100,70})));
            BaseClasses.AhuBus ahuBus
              "AHU bus"
              annotation (Placement(transformation(
                extent={{-20,-20},{20,20}},
                rotation=90,
                origin={-400,0}), iconTransformation(extent={{-10,90},{10,110}})));
            BaseClasses.TerminalBus terBus[nTer]
              "Terminal unit bus"
              annotation (
                Placement(transformation(
                  extent={{-20,-20},{20,20}},
                  rotation=-90,
                  origin={398,-2}), iconTransformation(
                  extent={{-10,-10},{10,10}},
                  rotation=-90,
                  origin={100,70})));

            // COMPONENTS
            //// Economizer
            Fluid.Actuators.Dampers.MixingBox eco(
              redeclare final package Medium = MediumA,
              final mOut_flow_nominal=mOut_flow_nominal,
              final mRec_flow_nominal=mRec_flow_nominal,
              final mExh_flow_nominal=mExh_flow_nominal,
              final dpDamOut_flow_nominal=dpDamOut_nominal,
              final dpFixOut_nominal=dpFixOut_nominal,
              final dpDamRec_flow_nominal=dpDamRec_nominal,
              final dpFixRec_nominal=dpFixRec_nominal,
              final dpDamExh_flow_nominal=dpDamExh_nominal,
              final dpFixExh_nominal=dpExhOut_nominal)
              "Air economizer"
              annotation (Placement(transformation(extent={{-250,-170},{-230,-190}})));
            Fluid.Actuators.Dampers.MixingBoxMinimumFlow eco_cla1(
              redeclare final package Medium = MediumA,
              final mOut_flow_nominal=mOut_flow_nominal,
              final mOutMin_flow_nominal=mOutMin_flow_nominal,
              final mRec_flow_nominal=mRec_flow_nominal,
              final mExh_flow_nominal=mExh_flow_nominal,
              final dpDamOut_flow_nominal=dpDamOut_nominal,
              final dpFixOut_nominal=dpFixOut_nominal,
              final dpDamOutMin_nominal=dpDamOutMin_nominal,
              final dpFixOutMin_nominal=dpFixOutMin_nominal,
              final dpDamRec_flow_nominal=dpDamRec_nominal,
              final dpFixRec_nominal=dpFixRec_nominal,
              final dpDamExh_flow_nominal=dpDamExh_nominal,
              final dpFixExh_nominal=dpExhOut_nominal)
              "Air economizer"
              annotation (Placement(transformation(extent={{-290,-170},{-270,-190}})));
            Fluid.Sensors.TemperatureTwoPort senTMix(
              redeclare final package Medium = MediumA,
              final m_flow_nominal=mSup_flow_nominal)
              "Mixed air temperature sensor"
              annotation (Placement(transformation(extent={{-210,-230},{-190,-210}})),
                __Linkage(present="@ispresent(eco*)"));
            Fluid.Sensors.VolumeFlowRate senVFloOut(
              redeclare final package Medium = MediumA,
              final m_flow_nominal=mOut_flow_nominal)
              "OA flow rate sensor"
              annotation (Placement(transformation(extent={{-370,-230},{-350,-210}})),
                __Linkage(present="have_airFloMeaSta and @ispresent(eco)"));
            Fluid.Sensors.VolumeFlowRate senVFloOut_pos1(
              redeclare final package Medium = MediumA,
              final m_flow_nominal=mOutMin_flow_nominal)
              "OA flow rate sensor"
              annotation (Placement(transformation(extent={{-370,-190},{-350,-170}})),
                __Linkage(present="have_airFloMeaSta and @ispresent(eco_cla1)"));

            //// Cooling coil
            Fluid.HeatExchangers.WetCoilCounterFlow coiCoo(
              redeclare final package Medium1 = MediumW,
              redeclare final package Medium2 = MediumA,
              final UA_nominal=datCoiCoo.UA_nominal,
              final m1_flow_nominal=datCoiCoo.mWat_flow_nominal,
              final m2_flow_nominal=datCoiCoo.mSup_flow_nominal,
              final dp1_nominal=datCoiCoo.dpWat_nominal,
              final dp2_nominal=datCoiCoo.dpAir_nominal,
              energyDynamics=energyDynamics)
              "Cooling coil"
              annotation (Placement(transformation(extent={{-40,-216},{-60,-236}})));
            Fluid.HeatExchangers.DXCoils.AirCooled.VariableSpeed coiCoo_cla1(
              redeclare final package Medium = MediumA,
              final dp_nominal=datCoiCoo_cla1.dpAir_nominal,
              final minSpeRat=datCoiCoo_cla1.minSpeRat_coiCoo_cla1,
              energyDynamics=energyDynamics)
              "Cooling coil"
              annotation (Placement(transformation(extent={{-60,-270},{-40,-250}})));
            Fluid.Sensors.TemperatureTwoPort senTCoiCooLvg(
              redeclare final package Medium = MediumA,
              final m_flow_nominal=mSup_flow_nominal)
              "Cooling coil leaving air temperature sensor"
              annotation (Placement(transformation(extent={{-30,-230},{-10,-210}})),
                __Linkage(present="@ispresent(cooCoi*)"));

            //// Supply fan
            Fluid.Movers.SpeedControlled_y fanSup(
              redeclare final package Medium = MediumA,
              final per=datFanSup,
              energyDynamics=energyDynamics)
              "Supply fan"
              annotation (Placement(transformation(extent={{70,-210},{90,-230}})));
            Fluid.Movers.SpeedControlled_y fanSup_pos1(
              redeclare final package Medium = MediumA,
              final per=datFanSup,
              energyDynamics=energyDynamics)
              "Supply fan"
              annotation (Placement(transformation(extent={{-170,-210},{-150,-230}})));
            Fluid.Movers.SpeedControlled_y fanSup_cla1(
              redeclare final package Medium = MediumA,
              final per=datFanSup,
              energyDynamics=energyDynamics)
              "Supply fan"
              annotation (Placement(transformation(extent={{70,-250},{90,-270}})));
            Fluid.Sensors.TemperatureTwoPort senTSup(
              redeclare final package Medium = MediumA,
              final m_flow_nominal=mSup_flow_nominal)
              "Supply air temperature sensor"
              annotation(Placement(transformation(extent={{350,-230},{370,-210}})),
                __Linkage(present="@ispresent(fanSup*)"));

          initial equation
            /* Initial equations may be needed to compute some parameter values, e.g.
  coiCoo.UA_nominal (in sensible conditions).
  They should be annotated with __Linkage(present=...) */

          equation

            connect(port_supAir, port_supAir) annotation (Line(points={{400,-220},{400,-220}},
                                          color={0,127,255}));
            connect(eco.port_Sup, senTMix.port_a) annotation (Line(points={{-230,-186},{-220,
                    -186},{-220,-220},{-210,-220}}, color={0,127,255}));
            connect(senTSup.port_b, port_supAir)
              annotation (Line(points={{370,-220},{400,-220}}, color={0,127,255}));
            connect(coiCoo.port_b2, senTCoiCooLvg.port_a)
              annotation (Line(points={{-40,-220},{-30,-220}}, color={0,127,255}));
            connect(port_airExh, eco.port_Exh) annotation (Line(points={{-400,-140},{-260,
                    -140},{-260,-174},{-250,-174}}, color={0,127,255}));
            connect(senTMix.port_b, fanSup_pos1.port_a)
              annotation (Line(points={{-190,-220},{-170,-220}}, color={0,127,255}));
            connect(fanSup_pos1.port_b, coiCoo.port_a2)
              annotation (Line(points={{-150,-220},{-60,-220}}, color={0,127,255}));
            connect(senTCoiCooLvg.port_b, fanSup.port_a)
              annotation (Line(points={{-10,-220},{70,-220}}, color={0,127,255}));
            connect(fanSup.port_b, senTSup.port_a)
              annotation (Line(points={{90,-220},{350,-220}}, color={0,127,255}));
            connect(port_coiCooSup, coiCoo.port_a1) annotation (Line(points={{-20,-400},{-20,
                    -232},{-40,-232}}, color={0,127,255}));
            connect(port_coiCooRet, coiCoo.port_b1) annotation (Line(points={{-80,-400},{-80,
                    -232},{-60,-232}}, color={0,127,255}));
            connect(port_airOut, senVFloOut.port_a)
              annotation (Line(points={{-400,-220},{-370,-220}}, color={0,127,255}));
            connect(senVFloOut.port_b, eco.port_Out) annotation (Line(points={{-350,-220},
                    {-260,-220},{-260,-186},{-250,-186}}, color={0,127,255}));
            connect(senVFloOut.port_b, senTMix.port_a)
              annotation (Line(points={{-350,-220},{-210,-220}}, color={0,127,255}));
            connect(port_airOutMin, senVFloOut_pos1.port_a)
              annotation (Line(points={{-400,-180},{-370,-180}}, color={0,127,255}));
            connect(senVFloOut_pos1.port_b, eco_cla1.port_OutMin) annotation (Line(points={{-350,
                    -180},{-300,-180},{-300,-190},{-290,-190}},       color={0,127,255}));
            connect(eco.port_Ret, port_retAir) annotation (Line(points={{-230,-174},{-220,
                    -174},{-220,-140},{400,-140}}, color={0,127,255}));
            connect(port_retAir, port_airExh)
              annotation (Line(points={{400,-140},{-400,-140}}, color={0,127,255}));
            annotation (
              defaultComponentName="ahu",
              Diagram(coordinateSystem(extent={{-400,-400},{400,340}}), graphics={
                  Rectangle(
                    extent={{-400,60},{400,-60}},
                    lineColor={0,0,0},
                    fillPattern=FillPattern.Solid,
                    fillColor={245,239,184},
                    pattern=LinePattern.None),
                  Text(
                    extent={{-400,-340},{-166,-362}},
                    lineColor={0,0,0},
                    textString="Equipment section",
                    horizontalAlignment=TextAlignment.Left),
                  Text(
                    extent={{-400,60},{-166,38}},
                    lineColor={0,0,0},
                    textString="Control bus section",
                    horizontalAlignment=TextAlignment.Left),
                  Text(
                    extent={{-400,340},{-166,318}},
                    lineColor={0,0,0},
                    textString="Controls section",
                    horizontalAlignment=TextAlignment.Left)}),           Icon(
                  coordinateSystem(extent={{-100,-100},{100,100}})));
          end LayoutTemplate;

          model Component1
            replaceable package MediumA = Buildings.Media.Air "Moist air";
            replaceable package MediumW = Buildings.Media.Water "Water";
            Modelica.Fluid.Interfaces.FluidPort_a port_airEnt(
              redeclare package Medium=MediumA)
              "Fluid connector a (positive design flow direction is from port_a to port_b)"
              annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
            Modelica.Fluid.Interfaces.FluidPort_b port_airLvg(
              redeclare package Medium=MediumA)
              "Fluid connector a (positive design flow direction is from port_a to port_b)"
              annotation (Placement(transformation(extent={{90,-10},{110,10}})));
            Modelica.Fluid.Interfaces.FluidPort_a port_watEnt(
              redeclare package Medium=MediumW)
              "Fluid connector a (positive design flow direction is from port_a to port_b)"
              annotation (Placement(transformation(extent={{-50,-110},{-30,-90}})));
            Modelica.Fluid.Interfaces.FluidPort_b port_watLvg(
              redeclare package Medium=MediumW)
              "Fluid connector a (positive design flow direction is from port_a to port_b)"
              annotation (Placement(transformation(extent={{30,-110},{50,-90}})));
          equation
            connect(port_airEnt,port_airLvg)
              annotation (Line(points={{-100,0},{100,0}}, color={0,127,255}));
            connect(port_watEnt,port_watLvg)  annotation (Line(points={{-40,-100},{-40,
                    -60},{40,-60},{40,-100}}, color={0,127,255}));
          end Component1;

          model Component2
            replaceable package MediumA = Buildings.Media.Air "Moist air";
            replaceable package MediumW = Buildings.Media.Water "Water";
            Modelica.Fluid.Interfaces.FluidPort_a port_airEnt(
              redeclare package Medium=MediumA)
              "Fluid connector a (positive design flow direction is from port_a to port_b)"
              annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
            Modelica.Fluid.Interfaces.FluidPort_b port_airLvg(
              redeclare package Medium=MediumA)
              "Fluid connector a (positive design flow direction is from port_a to port_b)"
              annotation (Placement(transformation(extent={{90,-10},{110,10}})));
          equation
            connect(port_airEnt, port_airLvg)
              annotation (Line(points={{-100,0},{100,0}}, color={0,127,255}));
          end Component2;

          model ComponentWrapper
            replaceable package MediumA = Buildings.Media.Air "Moist air";
            replaceable package MediumW = Buildings.Media.Water "Water";
            Modelica.Fluid.Interfaces.FluidPort_a port_airEnt(
              redeclare package Medium=MediumA)
              "Fluid connector a (positive design flow direction is from port_a to port_b)"
              annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
            Modelica.Fluid.Interfaces.FluidPort_b port_airLvg(
              redeclare package Medium=MediumA)
              "Fluid connector a (positive design flow direction is from port_a to port_b)"
              annotation (Placement(transformation(extent={{90,-10},{110,10}})));
            Modelica.Fluid.Interfaces.FluidPort_a port_watEnt(
              redeclare package Medium=MediumW)
              "Fluid connector a (positive design flow direction is from port_a to port_b)"
              annotation (Placement(transformation(extent={{-50,-110},{-30,-90}})));
            Modelica.Fluid.Interfaces.FluidPort_b port_watLvg(
              redeclare package Medium=MediumW)
              "Fluid connector a (positive design flow direction is from port_a to port_b)"
              annotation (Placement(transformation(extent={{30,-110},{50,-90}})));

            parameter ComponentType comTyp = ComponentType.Component1;

            Component1 com1 if
                              comTyp == ComponentType.Component1
              annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

            Component2 com2 if comTyp == ComponentType.Component2
              annotation (Placement(transformation(extent={{-10,30},{10,50}})));

          equation
            connect(port_airEnt,com1.port_airEnt)
              annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
            connect(com1.port_airLvg,port_airLvg)
              annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
            connect(port_watEnt,com1.port_watEnt)  annotation (Line(points={{-40,-100},{-40,
                    -40},{-4,-40},{-4,-10}}, color={0,127,255}));
            connect(com1.port_watLvg,port_watLvg)  annotation (Line(points={{4,-10},{4,-40},
                    {40,-40},{40,-100}}, color={0,127,255}));
            connect(port_airEnt,com2.port_airEnt)  annotation (Line(points={{-100,0},{-80,
                    0},{-80,40},{-10,40}}, color={0,127,255}));
            connect(com2.port_airLvg,port_airLvg)  annotation (Line(points={{10,40},{80,40},
                    {80,0},{100,0}}, color={0,127,255}));
            annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
                  coordinateSystem(preserveAspectRatio=false)));
          end ComponentWrapper;

          model Sensor
            replaceable package Medium = Buildings.Media.Water "Water"
            annotation (choices(
                  choice(redeclare package Medium = Buildings.Media.Air "Moist air")));
            Modelica.Fluid.Interfaces.FluidPort_a port_ent(
              redeclare package Medium=Medium)
              "Fluid connector a (positive design flow direction is from port_a to port_b)"
              annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
            Modelica.Fluid.Interfaces.FluidPort_b port_lvg(
              redeclare package Medium=Medium)
              "Fluid connector a (positive design flow direction is from port_a to port_b)"
              annotation (Placement(transformation(extent={{90,-10},{110,10}})));
          equation
            connect(port_ent, port_lvg)
              annotation (Line(points={{-100,0},{100,0}}, color={0,127,255}));
          end Sensor;

          model SystemTemplate
            replaceable package MediumA = Buildings.Media.Air "Moist air";
            replaceable package MediumW = Buildings.Media.Water "Water";

            parameter ComponentType comTyp = ComponentType.Component1;

            Modelica.Fluid.Interfaces.FluidPort_a port_airEnt(
              redeclare package Medium=MediumA)
              "Fluid connector a (positive design flow direction is from port_a to port_b)"
              annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
            Modelica.Fluid.Interfaces.FluidPort_b port_airLvg(
              redeclare package Medium=MediumA)
              "Fluid connector a (positive design flow direction is from port_a to port_b)"
              annotation (Placement(transformation(extent={{90,-10},{110,10}})));
            Modelica.Fluid.Interfaces.FluidPort_a port_watEnt(
              redeclare package Medium=MediumW) if comTyp == ComponentType.Component1
              "Fluid connector a (positive design flow direction is from port_a to port_b)"
              annotation (Placement(transformation(extent={{-50,-110},{-30,-90}})));
            Modelica.Fluid.Interfaces.FluidPort_b port_watLvg(
              redeclare package Medium=MediumW) if comTyp == ComponentType.Component1
              "Fluid connector a (positive design flow direction is from port_a to port_b)"
              annotation (Placement(transformation(extent={{30,-110},{50,-90}})));
            ComponentWrapper componentWrapper(
              final comTyp=comTyp)
              annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
            Sensor sensor if comTyp == ComponentType.Component1
              annotation (Placement(transformation(
                  extent={{-10,-10},{10,10}},
                  rotation=90,
                  origin={-40,-50})));
          equation
            connect(componentWrapper.port_watLvg,port_watLvg)  annotation (Line(points={{4,
                    -10},{4,-20},{40,-20},{40,-100}}, color={0,127,255}));
            connect(port_airEnt,componentWrapper.port_airEnt)
              annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
            connect(componentWrapper.port_airLvg,port_airLvg)  annotation (Line(points={{10,
                    0},{56,0},{56,0},{100,0}}, color={0,127,255}));
            connect(port_watEnt, sensor.port_ent)
              annotation (Line(points={{-40,-100},{-40,-60}}, color={0,127,255}));
            connect(sensor.port_lvg, componentWrapper.port_watEnt) annotation (Line(
                  points={{-40,-40},{-40,-20},{-4,-20},{-4,-10}}, color={0,127,255}));
            annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
                  coordinateSystem(preserveAspectRatio=false)));
          end SystemTemplate;

          model Application
            replaceable package MediumA = Buildings.Media.Air "Moist air";
            replaceable package MediumW = Buildings.Media.Water "Water";
            SystemTemplate sys_com1
              annotation (Placement(transformation(extent={{-10,50},{10,70}})));
            Fluid.Sources.MassFlowSource_T boundary(
              redeclare package Medium=MediumA,
              nPorts=1)
              annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
            Fluid.Sources.Boundary_pT bou(
              redeclare package Medium=MediumA,
              nPorts=1)
              annotation (Placement(transformation(extent={{60,50},{40,70}})));
            Fluid.Sources.MassFlowSource_T boundary1(
              redeclare package Medium = MediumW,
              nPorts=1)
              annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
            Fluid.Sources.Boundary_pT bou1(
              redeclare package Medium = MediumW,
              nPorts=1)
              annotation (Placement(transformation(extent={{60,10},{40,30}})));
            SystemTemplate sys_com2(comTyp=ComponentType.Component2)
              annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
            Fluid.Sources.MassFlowSource_T boundary2(redeclare package Medium = MediumA,
                nPorts=1)
              annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
            Fluid.Sources.Boundary_pT bou2(redeclare package Medium = MediumA, nPorts=1)
              annotation (Placement(transformation(extent={{60,-50},{40,-30}})));
          equation
            connect(boundary.ports[1],sys_com1.port_airEnt)
              annotation (Line(points={{-40,60},{-10,60}}, color={0,127,255}));
            connect(sys_com1.port_airLvg, bou.ports[1])
              annotation (Line(points={{10,60},{40,60}}, color={0,127,255}));
            connect(boundary1.ports[1],sys_com1.port_watEnt)
              annotation (Line(points={{-40,20},{-4,20},{-4,50}}, color={0,127,255}));
            connect(sys_com1.port_watLvg, bou1.ports[1])
              annotation (Line(points={{4,50},{4,20},{40,20}}, color={0,127,255}));
            connect(boundary2.ports[1],sys_com2.port_airEnt)
              annotation (Line(points={{-40,-40},{-10,-40}}, color={0,127,255}));
            connect(sys_com2.port_airLvg, bou2.ports[1])
              annotation (Line(points={{10,-40},{40,-40}}, color={0,127,255}));
            annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
                  coordinateSystem(preserveAspectRatio=false)));
          end Application;

          type ComponentType = enumeration(
              None
                 "None",
              Component1
                       "Component1",
              Component2
                       "Component2")
          "Enumeration to define the type of component";
        end MinimumExamples;

        package Validation "Collection of validation models"
          extends Modelica.Icons.ExamplesPackage;

          model OpenLoop "Open loop test for air handler unit"
            extends Modelica.Icons.Example;
            AHUIOConnectors ahu
              annotation (Placement(transformation(extent={{-40,-40},{40,40}})));
            Fluid.Sources.Boundary_pT out(nPorts=2) "Outside conditions"
              annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
          equation
            connect(out.ports[1], ahu.port_freAir) annotation (Line(points={{-70,2},{-56,
                    2},{-56,4},{-40,4}}, color={0,127,255}));
            connect(out.ports[2], ahu.port_exhAir) annotation (Line(points={{-70,-2},{-56,
                    -2},{-56,-4},{-40,-4}}, color={0,127,255}));
          end OpenLoop;

          model OpenLoopControlBus "Open loop test for air handler unit"
            extends Modelica.Icons.Example;
            AHUControlBus ahu
              annotation (Placement(transformation(extent={{-34,-42},{46,38}})));
            Fluid.Sources.Boundary_pT out(nPorts=3) "Outside conditions"
              annotation (Placement(transformation(extent={{-90,-12},{-70,8}})));
          equation
            connect(out.ports[1], ahu.port_freAir) annotation (Line(points={{-70,0.666667},{-56,0.666667},{-56,6},{-34,6}},
                                         color={0,127,255}));
            connect(out.ports[2], ahu.port_exhAir) annotation (Line(points={{-70,-2},{-56,-2},{-56,-10},{-34,-10}},
                                            color={0,127,255}));
          end OpenLoopControlBus;

          model BusTestControllerNonExp
            Controls.OBC.CDL.Continuous.Division controller annotation (Placement(transformation(extent={{-10,44},{10,64}})));
            Modelica.Blocks.Routing.RealPassThrough realPassThrough
              annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
            BaseClasses.NonExpandableBus nonExpandableBus annotation (Placement(transformation(extent={{-8,0},{12,20}}),
                  iconTransformation(extent={{-50,20},{-30,40}})));
          equation

            connect(realPassThrough.y, controller.u1)
              annotation (Line(points={{-39,70},{-24,70},{-24,60},{-12,60}}, color={0,0,127}));

            controller.u2 = nonExpandableBus.yMea;
            nonExpandableBus.yAct = controller.y;
            realPassThrough.u = nonExpandableBus.yMea;

            annotation (Diagram(coordinateSystem(extent={{-80,-20},{40,100}})),Icon(coordinateSystem(extent={{-40,-40},{40,40}})));
          end BusTestControllerNonExp;

          model BusTestNonExp
            BusTestControllerNonExp controllerSystem annotation (Placement(transformation(extent={{-20,-10},{-40,10}})));
            BusTestControlledNonExp controlledSystem annotation (Placement(transformation(extent={{20,-10},{40,10}})));
          equation
            connect(controllerSystem.nonExpandableBus, controlledSystem.nonExpandableBus)
              annotation (Line(points={{-20,7.5},{0,7.5},{0,7.5},{20,7.5}}, color={0,0,0}));
            annotation (Diagram(coordinateSystem(extent={{-60,-20},{60,20}})), Icon(coordinateSystem(extent={{-60,-60},{60,60}})));
          end BusTestNonExp;

          model BusTestControlledNonExp
          public
            Modelica.Blocks.Sources.RealExpression sensor(y=2 + sin(time*3.14))
              annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
            Modelica.Blocks.Routing.RealPassThrough actuator annotation (Placement(transformation(extent={{60,-10},{80,10}})));
            BaseClasses.NonExpandableBus nonExpandableBus annotation (Placement(transformation(extent={{-10,-60},{10,-40}}),
                  iconTransformation(extent={{-50,20},{-30,40}})));
          equation
            nonExpandableBus.yMea = sensor.y;
            actuator.u = nonExpandableBus.yAct;
            annotation (Diagram(coordinateSystem(extent={{-100,-80},{100,40}})),  Icon(coordinateSystem(extent={{-40,-40},{40,40}})));
          end BusTestControlledNonExp;

          model BusTestExp
            extends Modelica.Icons.Example;
            BusTestControllerExp controllerSystem annotation (Placement(transformation(extent={{-20,-10},{-40,10}})));
            BusTestControlledExp controlledSystem annotation (Placement(transformation(extent={{20,-10},{40,10}})));
          equation
            connect(controllerSystem.ahuBus, controlledSystem.ahuBus)
              annotation (Line(
                points={{-20,0},{20,0}},
                color={255,204,51},
                thickness=0.5));
            annotation (Diagram(coordinateSystem(extent={{-60,-20},{60,20}})));
          end BusTestExp;

          model BusTestControllerExp
          public
            Buildings.Experimental.Templates_V1.BaseClasses.AhuBus ahuBus
              annotation (Placement(transformation(extent={{-20,-20},{20,20}}),
                  iconTransformation(extent={{-50,-10},{-30,10}})));
            Controls.OBC.CDL.Continuous.Division controller annotation (Placement(transformation(extent={{-10,44},{10,64}})));
            Modelica.Blocks.Routing.RealPassThrough realPassThrough
              annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
          equation

            connect(realPassThrough.y, controller.u1)
              annotation (Line(points={{-39,70},{-24,70},{-24,60},{-12,60}}, color={0,0,127}));

            connect(controller.y, ahuBus.yAct) annotation (Line(points={{12,54},{40,54},{40,0},{0,0}},       color={0,0,127}),
                Text(
                string="%second",
                index=1,
                extent={{6,3},{6,3}},
                horizontalAlignment=TextAlignment.Left));
            connect(ahuBus.yMea, controller.u2) annotation (Line(
                points={{0,0},{-40,0},{-40,48},{-12,48}},
                color={255,204,51},
                thickness=0.5), Text(
                string="%first",
                index=-1,
                extent={{-6,3},{-6,3}},
                horizontalAlignment=TextAlignment.Right));
            connect(ahuBus.yMea, realPassThrough.u) annotation (Line(
                points={{0,0},{-72,0},{-72,70},{-62,70}},
                color={255,204,51},
                thickness=0.5), Text(
                string="%first",
                index=-1,
                extent={{-6,3},{-6,3}},
                horizontalAlignment=TextAlignment.Right));
            annotation (Diagram(coordinateSystem(extent={{-80,-20},{60,100}})),Icon(coordinateSystem(extent={{-40,-40},{40,40}})));
          end BusTestControllerExp;

          model BusTestControlledExp
          public
            Modelica.Blocks.Sources.RealExpression sensor(y=2 + sin(time*3.14))
              annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
            Buildings.Experimental.Templates_V1.BaseClasses.AhuBus ahuBus
              annotation (Placement(transformation(extent={{-20,-20},{20,20}}),
                  iconTransformation(extent={{-50,-10},{-30,10}})));
            Modelica.Blocks.Routing.RealPassThrough actuator annotation (Placement(transformation(extent={{60,-10},{80,10}})));

          equation
            connect(ahuBus.yAct, actuator.u) annotation (Line(
                points={{0,0},{30,0},{30,0},{58,0}},
                color={255,204,51},
                thickness=0.5), Text(
                string="%first",
                index=-1,
                extent={{-6,3},{-6,3}},
                horizontalAlignment=TextAlignment.Right));
            connect(sensor.y, ahuBus.yMea) annotation (Line(points={{-59,0},{-30,0},{-30,0},{0,0}},       color={0,0,127}), Text(
                string="%second",
                index=1,
                extent={{6,3},{6,3}},
                horizontalAlignment=TextAlignment.Left));
            annotation (Diagram(coordinateSystem(extent={{-100,-20},{100,20}})),  Icon(coordinateSystem(extent={{-40,-40},{40,40}})));
          end BusTestControlledExp;

          model TestBusFluid
            package Medium = Buildings.Media.Water "Medium model for water";

            BaseClasses.AhuBusFluid ahuBusFluid annotation (Placement(transformation(extent={{-22,-20},{18,20}}),
                  iconTransformation(extent={{-178,-24},{-158,-4}})));
            Fluid.Sources.MassFlowSource_T boundary(redeclare package Medium = Medium, m_flow=1)
                                                    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
            Fluid.Sources.Boundary_pT bou(redeclare package Medium = Medium)
              annotation (Placement(transformation(extent={{70,-10},{50,10}})));
          equation
            connect(boundary.ports[1], ahuBusFluid.souPor) annotation (Line(points={{-60,0},{-2,0}}, color={0,127,255}), Text(
                string="%second",
                index=1,
                extent={{6,3},{6,3}},
                horizontalAlignment=TextAlignment.Left));
            connect(ahuBusFluid.souPor, bou.ports[1]) annotation (Line(
                points={{-2,0},{50,0}},
                color={255,204,51},
                thickness=0.5), Text(
                string="%first",
                index=-1,
                extent={{-6,3},{-6,3}},
                horizontalAlignment=TextAlignment.Right));
            annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
          end TestBusFluid;
        annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains validation models for the classes in
<a href=\"modelica://Buildings.Experimental.Templates.Commercial.VAV.AHU\">
Buildings.Experimental.Templates.Commercial.VAV.AHU</a>.
</p>
<p>
Note that most validation models contain simple input data
which may not be realistic, but for which the correct
output can be obtained through an analytic solution.
The examples plot various outputs, which have been verified against these
solutions. These model outputs are stored as reference data and
used for continuous validation whenever models in the library change.
</p>
</html>"));
        end Validation;
      annotation (preferredView="info", Documentation(info="<html>
<p>
fixme: add a package description.
</p>
</html>"));
      end AHUs;
    annotation (preferredView="info", Documentation(info="<html>
<p>
fixme: add a package description.
</p>
</html>"));
    end VAV;
  annotation (preferredView="info", Documentation(info="<html>
<p>
fixme: add a package description.
</p>
</html>"));
  end Commercial;

  package BaseClasses
    expandable connector AhuBus
      "Control bus that is adapted to the signals connected to it"
      extends Modelica.Icons.SignalBus;
      // The following declarations are optional:
      // any connect equation involving those variables will make them available in each instance of AhuBus.
    //   Real yMea;
    //   Real yAct;
      parameter Integer nTer=0
        "Number of terminal units";
        // annotation(Dialog(connectorSizing=true)) is not interpreted properly in Dymola.
      Real yTest
        "Test declared variable";
      Boolean staAhu
        "Test how a scalar variable can be passed on to an array of connected units";
      Buildings.Experimental.Templates_V1.BaseClasses.AhuSubBusO ahuO "AHU/O"
        annotation (HideResult=false);
      Buildings.Experimental.Templates_V1.BaseClasses.AhuSubBusI ahuI "AHU/I"
        annotation (HideResult=false);
      Buildings.Experimental.Templates_V1.BaseClasses.TerminalBus ahuTer[nTer] if
        nTer > 0 "Terminal unit sub-bus";
        // Binding with (each staAhu=staAhu) is invalid in Dymola and OCT.
      annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                -100},{100,100}}), graphics={Rectangle(
                      extent={{-20,2},{22,-2}},
                      lineColor={255,204,51},
                      lineThickness=0.5)}), Documentation(info="<html>
<p>
This connector defines the \"expandable connector\" ControlBus that
is used as bus in the
<a href=\"modelica://Modelica.Blocks.Examples.BusUsage\">BusUsage</a> example.
Note, this connector contains \"default\" signals that might be utilized
in a connection (the input/output causalities of the signals
are determined from the connections to this bus).
</p>
</html>"));
    end AhuBus;

    model AhuBusGateway
      "Model to connect scalar variables from main bus to an array of sub-bus"

      parameter Integer nTer=0
        "Number of terminal units";
        // annotation(Dialog(connectorSizing=true)) is not interpreted properly in Dymola.

      AhuBus ahuBus(nTer=nTer) annotation (Placement(transformation(extent={{-20,-20},{20,20}}),
            iconTransformation(extent={{-100,-88},{100,72}})));
      TerminalBus terBus[nTer]
        annotation (Placement(transformation(extent={{-20,-80},{20,-40}})));
    equation
      for i in 1:nTer loop
        connect(ahuBus.staAhu, ahuBus.ahuTer[i].staAhu);
      end for;
      connect(ahuBus.ahuTer, terBus)
        annotation (Line(
          points={{0.1,0.1},{0,0.1},{0,-60}},
          color={255,204,51},
          thickness=0.5), Text(
          string="%first",
          index=1,
          extent={{6,3},{6,3}},
          horizontalAlignment=TextAlignment.Left));
      annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                -100},{100,100}})),
        Diagram(coordinateSystem(extent={{-40,-80},{40,20}})));
    end AhuBusGateway;

    expandable connector AhuSubBusO "Icon for signal sub-bus"
      // Real yAct;
      annotation (
        Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
              Line(
                points={{-16.0,2.0},{16.0,2.0}},
                color={255,204,51},
                thickness=0.5),
              Rectangle(
                lineColor={255,204,51},
                lineThickness=0.5,
                extent={{-10.0,0.0},{8.0,8.0}}),
              Polygon(
                fillColor={255,215,136},
                fillPattern=FillPattern.Solid,
                points={{-80.0,50.0},{80.0,50.0},{100.0,30.0},{80.0,-40.0},{60.0,-50.0},{-60.0,-50.0},{-80.0,-40.0},{-100.0,30.0}},
                smooth=Smooth.Bezier),
              Ellipse(
                fillPattern=FillPattern.Solid,
                extent={{-55.0,15.0},{-45.0,25.0}}),
              Ellipse(
                fillPattern=FillPattern.Solid,
                extent={{45.0,15.0},{55.0,25.0}}),
              Ellipse(
                fillPattern=FillPattern.Solid,
                extent={{-5.0,-25.0},{5.0,-15.0}}),
              Rectangle(
                lineColor={255,215,136},
                lineThickness=0.5,
                extent={{-20.0,0.0},{20.0,4.0}})}),
        Diagram(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}}), graphics={
            Polygon(
              points={{-40,25},{40,25},{50,15},{40,-20},{30,-25},{-30,-25},{-40,-20},{-50,15}},
              lineColor={0,0,0},
              fillColor={255,204,51},
              fillPattern=FillPattern.Solid,
              smooth=Smooth.Bezier),
            Ellipse(
              extent={{-22.5,7.5},{-17.5,12.5}},
              lineColor={0,0,0},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid),
            Ellipse(
              extent={{17.5,12.5},{22.5,7.5}},
              lineColor={0,0,0},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid),
            Ellipse(
              extent={{-2.5,-7.5},{2.5,-12.5}},
              lineColor={0,0,0},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid),
            Text(
              extent={{-150,70},{150,40}},
              lineColor={0,0,0},
              textString=
                   "%name")}),
        Documentation(info="<html>
<p>
This icon is designed for a <b>sub-bus</b> in a signal connector.
</p>
</html>"));
    end AhuSubBusO;

    expandable connector AhuSubBusI "Icon for signal sub-bus"
      Real yTestI;
      annotation (
        Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
              Line(
                points={{-16.0,2.0},{16.0,2.0}},
                color={255,204,51},
                thickness=0.5),
              Rectangle(
                lineColor={255,204,51},
                lineThickness=0.5,
                extent={{-10.0,0.0},{8.0,8.0}}),
              Polygon(
                fillColor={255,215,136},
                fillPattern=FillPattern.Solid,
                points={{-80.0,50.0},{80.0,50.0},{100.0,30.0},{80.0,-40.0},{60.0,-50.0},{-60.0,-50.0},{-80.0,-40.0},{-100.0,30.0}},
                smooth=Smooth.Bezier),
              Ellipse(
                fillPattern=FillPattern.Solid,
                extent={{-55.0,15.0},{-45.0,25.0}}),
              Ellipse(
                fillPattern=FillPattern.Solid,
                extent={{45.0,15.0},{55.0,25.0}}),
              Ellipse(
                fillPattern=FillPattern.Solid,
                extent={{-5.0,-25.0},{5.0,-15.0}}),
              Rectangle(
                lineColor={255,215,136},
                lineThickness=0.5,
                extent={{-20.0,0.0},{20.0,4.0}})}),
        Diagram(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}}), graphics={
            Polygon(
              points={{-40,25},{40,25},{50,15},{40,-20},{30,-25},{-30,-25},{-40,-20},{-50,15}},
              lineColor={0,0,0},
              fillColor={255,204,51},
              fillPattern=FillPattern.Solid,
              smooth=Smooth.Bezier),
            Ellipse(
              extent={{-22.5,7.5},{-17.5,12.5}},
              lineColor={0,0,0},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid),
            Ellipse(
              extent={{17.5,12.5},{22.5,7.5}},
              lineColor={0,0,0},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid),
            Ellipse(
              extent={{-2.5,-7.5},{2.5,-12.5}},
              lineColor={0,0,0},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid),
            Text(
              extent={{-150,70},{150,40}},
              lineColor={0,0,0},
              textString=
                   "%name")}),
        Documentation(info="<html>
<p>
This icon is designed for a <b>sub-bus</b> in a signal connector.
</p>
</html>"));
    end AhuSubBusI;

    connector NonExpandableBus
      // The following declarations are required.
      Real yMea;
      Real yAct;
      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
    end NonExpandableBus;

    expandable connector AhuBusFluid "Control bus that is adapted to the signals connected to it"
      extends Modelica.Icons.SignalBus;

      annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                -100},{100,100}}), graphics={Rectangle(
                      extent={{-20,2},{22,-2}},
                      lineColor={255,204,51},
                      lineThickness=0.5)}), Documentation(info="<html>
<p>
This connector defines the \"expandable connector\" ControlBus that
is used as bus in the
<a href=\"modelica://Modelica.Blocks.Examples.BusUsage\">BusUsage</a> example.
Note, this connector contains \"default\" signals that might be utilized
in a connection (the input/output causalities of the signals
are determined from the connections to this bus).
</p>
</html>"));

    end AhuBusFluid;

    expandable connector AhuSubBusITest "Icon for signal sub-bus"
      annotation (
        Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
              Line(
                points={{-16.0,2.0},{16.0,2.0}},
                color={255,204,51},
                thickness=0.5),
              Rectangle(
                lineColor={255,204,51},
                lineThickness=0.5,
                extent={{-10.0,0.0},{8.0,8.0}}),
              Polygon(
                fillColor={255,215,136},
                fillPattern=FillPattern.Solid,
                points={{-80.0,50.0},{80.0,50.0},{100.0,30.0},{80.0,-40.0},{60.0,-50.0},{-60.0,-50.0},{-80.0,-40.0},{-100.0,30.0}},
                smooth=Smooth.Bezier),
              Ellipse(
                fillPattern=FillPattern.Solid,
                extent={{-55.0,15.0},{-45.0,25.0}}),
              Ellipse(
                fillPattern=FillPattern.Solid,
                extent={{45.0,15.0},{55.0,25.0}}),
              Ellipse(
                fillPattern=FillPattern.Solid,
                extent={{-5.0,-25.0},{5.0,-15.0}}),
              Rectangle(
                lineColor={255,215,136},
                lineThickness=0.5,
                extent={{-20.0,0.0},{20.0,4.0}})}),
        Diagram(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}}), graphics={
            Polygon(
              points={{-40,25},{40,25},{50,15},{40,-20},{30,-25},{-30,-25},{-40,-20},{-50,15}},
              lineColor={0,0,0},
              fillColor={255,204,51},
              fillPattern=FillPattern.Solid,
              smooth=Smooth.Bezier),
            Ellipse(
              extent={{-22.5,7.5},{-17.5,12.5}},
              lineColor={0,0,0},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid),
            Ellipse(
              extent={{17.5,12.5},{22.5,7.5}},
              lineColor={0,0,0},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid),
            Ellipse(
              extent={{-2.5,-7.5},{2.5,-12.5}},
              lineColor={0,0,0},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid),
            Text(
              extent={{-150,70},{150,40}},
              lineColor={0,0,0},
              textString=
                   "%name")}),
        Documentation(info="<html>
<p>
This icon is designed for a <b>sub-bus</b> in a signal connector.
</p>
</html>"));
    end AhuSubBusITest;

    expandable connector AhuBusTest "Control bus that is adapted to the signals connected to it"
      extends Modelica.Icons.SignalBus;
      // The following declarations are optional:
      // any connect equation involving those variables will make them available in each instance of AhuBus.
    //   Real yMea;
     Real yAct;

       Buildings.Experimental.Templates_V1.BaseClasses.AhuSubBusITest ahuI "AHU/I"
        annotation (HideResult=false);
      annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                -100},{100,100}}), graphics={Rectangle(
                      extent={{-20,2},{22,-2}},
                      lineColor={255,204,51},
                      lineThickness=0.5)}), Documentation(info="<html>
<p>
This connector defines the \"expandable connector\" ControlBus that
is used as bus in the
<a href=\"modelica://Modelica.Blocks.Examples.BusUsage\">BusUsage</a> example.
Note, this connector contains \"default\" signals that might be utilized
in a connection (the input/output causalities of the signals
are determined from the connections to this bus).
</p>
</html>"));

    end AhuBusTest;

    expandable connector AhuSubBusITestDec "Icon for signal sub-bus"
      Real yDeclaredPresent;
      Real yDeclaredNotPresent;
      annotation (
        Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
              Line(
                points={{-16.0,2.0},{16.0,2.0}},
                color={255,204,51},
                thickness=0.5),
              Rectangle(
                lineColor={255,204,51},
                lineThickness=0.5,
                extent={{-10.0,0.0},{8.0,8.0}}),
              Polygon(
                fillColor={255,215,136},
                fillPattern=FillPattern.Solid,
                points={{-80.0,50.0},{80.0,50.0},{100.0,30.0},{80.0,-40.0},{60.0,-50.0},{-60.0,-50.0},{-80.0,-40.0},{-100.0,30.0}},
                smooth=Smooth.Bezier),
              Ellipse(
                fillPattern=FillPattern.Solid,
                extent={{-55.0,15.0},{-45.0,25.0}}),
              Ellipse(
                fillPattern=FillPattern.Solid,
                extent={{45.0,15.0},{55.0,25.0}}),
              Ellipse(
                fillPattern=FillPattern.Solid,
                extent={{-5.0,-25.0},{5.0,-15.0}}),
              Rectangle(
                lineColor={255,215,136},
                lineThickness=0.5,
                extent={{-20.0,0.0},{20.0,4.0}})}),
        Diagram(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}}), graphics={
            Polygon(
              points={{-40,25},{40,25},{50,15},{40,-20},{30,-25},{-30,-25},{-40,-20},{-50,15}},
              lineColor={0,0,0},
              fillColor={255,204,51},
              fillPattern=FillPattern.Solid,
              smooth=Smooth.Bezier),
            Ellipse(
              extent={{-22.5,7.5},{-17.5,12.5}},
              lineColor={0,0,0},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid),
            Ellipse(
              extent={{17.5,12.5},{22.5,7.5}},
              lineColor={0,0,0},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid),
            Ellipse(
              extent={{-2.5,-7.5},{2.5,-12.5}},
              lineColor={0,0,0},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid),
            Text(
              extent={{-150,70},{150,40}},
              lineColor={0,0,0},
              textString=
                   "%name")}),
        Documentation(info="<html>
<p>
This icon is designed for a <b>sub-bus</b> in a signal connector.
</p>
</html>"));
    end AhuSubBusITestDec;

    expandable connector TerminalBus "Terminal control bus"
      extends Modelica.Icons.SignalBus;
      Boolean staAhu
        "Test how a scalar variable can be passed on to an array of connected units";
      annotation (
    Documentation(info="<html>
<p>
This connector defines the \"expandable connector\" ControlBus that
is used as bus in the
<a href=\"modelica://Modelica.Blocks.Examples.BusUsage\">BusUsage</a> example.
Note, this connector contains \"default\" signals that might be utilized
in a connection (the input/output causalities of the signals
are determined from the connections to this bus).
</p>
</html>"));

    end TerminalBus;
  end BaseClasses;
annotation (preferredView="info", Documentation(info="<html>
<p>
fixme: add a package description.
</p>
</html>"));
end Templates_V1;
