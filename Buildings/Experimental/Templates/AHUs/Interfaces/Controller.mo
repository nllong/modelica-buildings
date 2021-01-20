within Buildings.Experimental.Templates.AHUs.Interfaces;
partial model Controller
  Templates_V0.BaseClasses.AhuBus busAhu if typ<>Types.Coil.None
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-100,-200}),iconTransformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,-100})));
  Templates_V0.BaseClasses.TerminalBus busTer
    annotation (Placement(transformation(extent={{80,-220},{120,-180}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-200,-200},{220,
            200}})));
end Controller;
