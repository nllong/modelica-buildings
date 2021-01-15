within Buildings.Experimental.Templates_V0.BaseClasses;
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
