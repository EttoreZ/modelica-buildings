within Buildings.Experimental.Templates.Commercial.VAV.Controller;
model DummyCentralSystem
  "Central system to which the terminal units are connected, e.g., AHU or plant"
  extends Modelica.Blocks.Icons.Block;
  parameter Integer nCon = 5
    "Number of connected components";
  Modelica.Blocks.Sources.RealExpression outSig[nCon](y={i for i in 1:nCon})
    "Output signal to terminal units"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Blocks.Routing.RealPassThrough inpSig[nCon]
    annotation (Placement(transformation(extent={{-40,-50},{-60,-30}})));
  BaseClasses.TerminalBus busTer[nCon] annotation (Placement(transformation(
          extent={{20,-20},{60,20}}), iconTransformation(extent={{20,-20},{60,
            20}})));
equation
  connect(outSig.y, busTer.outSig) annotation (Line(points={{-39,0},{40,0}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(busTer.inpSig, inpSig.u) annotation (Line(
      points={{40,0},{40,-40},{-38,-40}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end DummyCentralSystem;
