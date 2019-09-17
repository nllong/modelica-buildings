within Buildings.Experimental.Templates;
package BaseClasses
  expandable connector AhuBus
    "Control bus that is adapted to the signals connected to it"
    extends Modelica.Icons.SignalBus;
    // The following declarations are optional:
    // any connect equation involving those variables will make them available in each instance of AhuBus.
  //   Real yMea;
  //   Real yAct;
     Buildings.Experimental.Templates.BaseClasses.AhuSubBusO ahuO
       "AHU/O" annotation (HideResult=false);
     Buildings.Experimental.Templates.BaseClasses.AhuSubBusI ahuI
       "AHU/I" annotation (HideResult=false);
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
    // Real yMea;
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
end BaseClasses;
