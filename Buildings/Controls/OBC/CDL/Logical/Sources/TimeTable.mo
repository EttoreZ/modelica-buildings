within Buildings.Controls.OBC.CDL.Logical.Sources;
block TimeTable
  "Table look-up with respect to time with constant segments"

  parameter Real table[:,:]
  "Table matrix with time as a first column (in seconds, unless timeScale is not 1) and any further column as Boolean sheduled value output";
  parameter CDL.Types.Extrapolation extrapolation=CDL.Types.Extrapolation.HoldLastPoint
    "Extrapolation of data outside the definition range";
  parameter Modelica.SIunits.Time timeScale=1
    "Time scale of first table column. Set to 3600 if time in table is in hours";

  Interfaces.BooleanOutput y[nout] "Output of the table"
    annotation (Placement(transformation(extent={{120,-20},{160,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));

  Integers.Equal intEquFal[nout] "Check values equal false"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Integers.Equal intEquTru[nout] "Checks values equal true"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Integers.Sources.Constant intFal[nout](k=fill(0, nout)) "Integer false"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Integers.Sources.Constant intTru[nout](k=fill(1, nout)) "Integer true"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Or or2[nout] "Checks if the table value is either tue or false"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  MultiOr mulOr(nu=nout)
    annotation (Placement(transformation(extent={{50,60},{70,80}})));
protected
  final parameter Integer nout=size(table, 2)-1
    "Dimension of output vector";
  final parameter Integer n=size(table, 1)
    "Number of table points";
  parameter Modelica.SIunits.Time t0(fixed=false)
    "First sample time instant";

  Conversions.IntegerToReal intToRea[nout] "Type conversion"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger realToInteger[nout]
    "Converts scheduled values to integer"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  // CDL uses different enumerations for extrapolation
  // than the Modelica Standard Library. Hence, we cast the CDL
  // enumeration to the MSL enumeration.
  Modelica.Blocks.Sources.CombiTimeTable tab(
    final tableOnFile=false,
    final table=table,
    final columns=2:size(tab.table, 2),
    final smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    final extrapolation=if extrapolation == CDL.Types.Extrapolation.HoldLastPoint then
                          Modelica.Blocks.Types.Extrapolation.HoldLastPoint
                        else
                          Modelica.Blocks.Types.Extrapolation.Periodic,
    final offset=0.,
    final startTime=if (extrapolation == Types.Extrapolation.Periodic) then integer(t0/86400)*86400 else 0,
    final timeScale=timeScale) "Time table"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));

  Utilities.Assert assMes1(message="Scheduled values are not all zeroes or ones")
    "Assert all scheduled values are either zero or one values"
    annotation (Placement(transformation(extent={{80,60},{100,80}})));
initial equation
  t0=time;

equation
  assert(n > 0, "No table values defined.");
  assert(extrapolation <> CDL.Types.Extrapolation.LastTwoPoints, "Unsuitable extrapolation setting.");
  connect(realToInteger.y, y) annotation(Line(points={{-38,0},{140,0}},        color={255,127,0}));

  connect(tab.y, realToInteger.u)
    annotation (Line(points={{-79,0},{-62,0}}, color={0,0,127}));
  connect(realToInteger.y, intToRea.u) annotation (Line(points={{-38,0},{-10,0},
          {-10,30},{-2,30}}, color={255,127,0}));
  connect(realToInteger.y, intEquFal.u2) annotation (Line(points={{-38,0},{-30,0},
          {-30,30},{-50,30},{-50,72},{-42,72}}, color={255,127,0}));
  connect(realToInteger.y, intEquTru.u2) annotation (Line(points={{-38,0},{-30,0},
          {-30,30},{-50,30},{-50,42},{-42,42}}, color={255,127,0}));
  connect(intFal.y, intEquFal.u1)
    annotation (Line(points={{-58,80},{-42,80}}, color={255,127,0}));
  connect(intTru.y, intEquTru.u1)
    annotation (Line(points={{-58,50},{-42,50}}, color={255,127,0}));
  connect(intEquFal.y, or2.u1) annotation (Line(points={{-18,80},{0,80},{0,70},{
          18,70}}, color={255,0,255}));
  connect(intEquTru.y, or2.u2) annotation (Line(points={{-18,50},{0,50},{0,62},{
          18,62}}, color={255,0,255}));
  connect(or2.y, mulOr.u)
    annotation (Line(points={{42,70},{48,70}}, color={255,0,255}));
  connect(mulOr.y, assMes1.u)
    annotation (Line(points={{72,70},{78,70}}, color={255,0,255}));
  annotation (
defaultComponentName = "intTimTab",
Documentation(info="<html>
<p>
Block that outputs values of a time table with scheduled .
</p>
<p>
The block takes as a parameter a time table of the format
</p>
<pre>
table = [ 0*3600, 0;
          6*3600, 0;
          6*3600, 1;
         18*3600, 1;
         18*3600, 0;
         24*3600, 0];
</pre>
<p>
where the first column is time in seconds, and the remaining
column(s) are the table values.
Any number of columns can be specified.
The parameter <code>smoothness</code> determines how the table values
are interpolated. The following settings are allowed:
</p>

<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><th><code>smoothness</code></th><th>Description</th></tr>
<tr>
  <td><code>CDL.Types.LinearSegments</code></td>
  <td>Table points are linearly interpolated.</td>
</tr>
<tr>
  <td><code>CDL.Types.ConstantSegments</code></td>
  <td>Table points are not interpolated,
      but the previous tabulated value is returned.</td>
</tr>
</table>

<p>
The parameter <code>extrapolation</code> determines how the table
values are extrapolated. The following settings are allowed:
</p>

<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><th><code>extrapolation</code></th><th>Description</th></tr>
<tr>
  <td><code>CDL.Types.HoldLastPoint</code></td>
  <td>Hold the first or last table point outside of the table scope.</td>
</tr>
<tr>
  <td><code>CDL.Types.LastTwoPoints</code></td>
  <td>Extrapolate by using the derivative at the first or last table points
      outside of the table scope.</td>
</tr>
<tr>
  <td><code>CDL.Types.Periodic</code></td>
  <td>Repeat the table scope periodically with periodicity
      <code>(max(table[:, 1]-min(table[:, 1]))*timeScale)</code>.</td>
</tr>
</table>

<p>
If <code>extrapolation === CDL.Types.Periodic</code>, then the above example
would give a schedule with periodicity of one day. The simulation can start at any time,
whether it is a multiple of a day or not, and positive or negative.
</p>

<p>
The value of the parameter <code>offset</code> is added to the tabulated
values.
The parameters <code>timeScale</code> is used to scale the first column
of the table. For example, set <code>timeScale = 3600</code> if the first
column is in hour (because in CDL, the time unit is seconds).
</p>
<p>
If the table has only one row, no interpolation is performed and
the table values of this row are just returned.
</p>
<p>
An interval boundary is defined by two identical time values
following each other. For example
</p>
<pre>
   table = [0, 0;
            1, 0;
            1, 1;
            2, 3;
            3, 5;
            3, 2;
            4, 4;
            5, 5];
</pre>
<p>
defines three intervalls: 0..1, 1..3, 3..5. Within an interval the defined
interpolation method is applied (so the table outputs within an interval are
continuous if <code>smoothness = CDL.Types.LinearSegments</code>).
</p>
<p>
Example:
</p>
<pre>
  table = [0, 0;
           1, 0;
           1, 1;
           2, 4;
           3, 9;
           4, 16];
  smoothness = CDL.Types.LinearSegments;

If, e.g., time = 1.0, the output y =  0.0 (before event), 1.0 (after event)
    e.g., time = 1.5, the output y =  2.5,
    e.g., time = 2.0, the output y =  4.0,
    e.g., time = 5.0, the output y = 23.0 (i.e., extrapolation via last 2 points).
</pre>
<h4>Implementation</h4>
<p>
For simulation,
no time events are generated within an interval
in order that also intervals with many points do not reduce the simulation efficiency.
If the table points are largely changing, it is adviseable to force
time events by duplicating every time point (especially, if the model in which
the table is present allows the variable step integrator to make large
integrator steps). For example, if a sawtooth signal is defined with the table,
it is more reliable to define the table as:
</p>
<pre>
   table = [0, 0;
            1, 2;
            1, 2;
            2, 0;
            2, 0;
            3, 2;
            3, 2];
</pre>
<p>
instead of
</p>
<pre>
   table = [0, 0;
            1, 2;
            2, 0;
            3, 2];
</pre>
<p>
because time events are then generated at every time point.
</p>
<p>
Building automation systems typically have discrete time semantics
with fixed sampling times, and no notion of superdense time (in which
a tabulated value can change without advancing time).
Therefore, to implement a table with two equal time stamps,
a CDL translator may parameterize
a table in the building automation in such a way that the step change happens
at the time indicated in the first column, whereas previous sampling times
output the tabulated value at the last transition. For example,
</p>
<pre>
table = [0, 0;
         1, 0;
         1, 1];
smoothness = CDL.Types.ConstantSegments;
</pre>
<p>
may be converted such that a building automation system with a sampling time
of <i>0.5</i> seconds outputs
</p>
<pre>
  t = 0, 0.5, 1, ...
  y = 0, 0  , 1, ...
</pre>
</html>",
revisions="<html>
<ul>
<li>
September 14, 2020, by Milica Grahovac:<br/>
Initial CDL implementation based on continuous time table implementation in CDL.
</li>
</ul>
</html>"),
    Icon(
      graphics={                         Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={210,210,210},
          lineThickness=5,
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised,
          lineColor={0,0,0}),           Text(
        extent={{-150,150},{150,110}},
        textString="%name",
        lineColor={0,0,255}),
    Polygon(lineColor={217,67,180},
      fillColor={217,67,180},
      fillPattern=FillPattern.Solid,
      points={{-80.0,90.0},{-88.0,68.0},{-72.0,68.0},{-80.0,90.0}}),
    Line(points={{-80.0,68.0},{-80.0,-80.0}}, color={255,0,255}),
    Line(points={{-90.0,-70.0},{82.0,-70.0}},
      color={255,0,255}),
    Polygon(lineColor={255,0,255},
      fillColor={255,0,255},
      fillPattern=FillPattern.Solid,
      points={{90.0,-70.0},{68.0,-62.0},{68.0,-78.0},{90.0,-70.0}}),
    Rectangle(lineColor={255,255,255},
      fillColor={255,215,136},
      fillPattern=FillPattern.Solid,
      extent={{-48.0,-50.0},{2.0,70.0}}),
    Line(points={{-48.0,-50.0},{-48.0,70.0},{52.0,70.0},{52.0,-50.0},
        {-48.0,-50.0},{-48.0,-20.0},{52.0,-20.0},{52.0,10.0},{-48.0,10.0},
        {-48.0,40.0},{52.0,40.0},{52.0,70.0},{2.0,70.0},{2.0,-51.0}}),
        Text(
          extent={{226,60},{106,10}},
          lineColor={0,0,0},
          textString=DynamicSelect("", if (nout==1) then String(y[1], leftjustified=false, significantDigits=3) else ""))}),
    Diagram(coordinateSystem(extent={{-120,-120},{120,120}})));
end TimeTable;