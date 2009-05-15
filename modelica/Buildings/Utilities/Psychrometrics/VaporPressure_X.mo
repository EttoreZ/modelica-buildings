within Buildings.Utilities.Psychrometrics;
block VaporPressure_X "Water vapor pressure for given humidity ratio"
  extends
    Buildings.Utilities.Psychrometrics.BaseClasses.HumidityRatioVaporPressure;
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}),
            graphics),
    Documentation(info="<html>
<p>
Block to compute the water vapor partial pressure for a given humidity ratio.
</p>
<p>If <tt>use_p_in</tt> is false (default option), the <tt>p</tt> parameter
is used as atmospheric pressure, 
and the <tt>p_in</tt> input connector is disabled; 
if <tt>use_p_in</tt> is true, then the <tt>p</tt> parameter is ignored, 
and the value provided by the input connector is used instead.
</p>
</html>", revisions="<html>
<ul>
<li>
April 14, 2009 by Michael Wetter:<br>
Converted model to block because <tt>RealInput</tt> are obsolete in Modelica 3.0.
</li>
<li>
August 7, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={Text(
          extent={{-88,26},{-60,-26}},
          lineColor={0,0,0},
          textString="X"), Text(
          extent={{46,30},{90,-32}},
          lineColor={0,0,0},
          textString="pW")}));
  Modelica.Blocks.Interfaces.RealInput XWat(min=0, max=1, nominal=0.01)
    "Species concentration at dry bulb temperature" 
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}},rotation=
           0), iconTransformation(extent={{-120,-10},{-100,10}})));
  Modelica.Blocks.Interfaces.RealOutput p_w(final quantity="Pressure",
                                           final unit="Pa",
                                           displayUnit="Pa",
                                           min = 0) "Water vapor pressure" 
    annotation (Placement(transformation(extent={{100,-10},{120,10}},
          rotation=0), iconTransformation(extent={{100,-10},{120,10}})));

equation
  X_dryAir * (1-XWat) = XWat;
 ( p_in_internal - p_w)   * X_dryAir = 0.62198 * p_w;
end VaporPressure_X;
