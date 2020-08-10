within Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.Title24.SetPoints;
block ZonaAbsOAMin "Zone minimum outdor air setpoints"

  parameter Boolean have_winSwi "The zone has a window switch";

  parameter Boolean have_occSen  "The zone has occupancy sensor";

  parameter Boolean have_CO2Sen "The zone has CO2 sensor";

  parameter Real VAreMin_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Zone minimum outdoor airflow for building area, per California Title 24 prescribed airflow-per-area requirements"
    annotation(Dialog(enable=have_occSen));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWin if have_winSwi
    "Window status, true if open, false if closed"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-240,-120},{-200,-80}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOcc if have_occSen
    "True if the zone is populated, that is the occupancy sensor senses the presence of people"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
        iconTransformation(extent={{-240,80},{-200,120}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VOutMinZonDes_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") if not (have_winSwi or have_occSen or have_CO2Sen)
    "Outdoor air volume flow setpoint used in AHU sequeces"
    annotation (Placement(transformation(extent={{100,-70},{140,-30}}),
        iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VOutMinZonAbs_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Outdoor air volume flow setpoint used in terminal-unit sequeces"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));


equation

annotation (
  defaultComponentName = "exhDam",
  Icon(graphics={Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-96,78},{-42,40}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uOutDamPos"),
        Text(
          extent={{-94,-48},{-62,-72}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uSupFan"),
        Text(
          extent={{46,18},{96,-18}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yExhDamPos"),
        Polygon(
          points={{-46,92},{-54,70},{-38,70},{-46,92}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-46,82},{-46,-86}}, color={192,192,192}),
        Line(points={{-56,-78},{68,-78}}, color={192,192,192}),
        Polygon(
          points={{72,-78},{50,-70},{50,-86},{72,-78}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-46,-78},{14,62},{80,62}}, color={0,0,127}),
        Text(
          extent={{-100,140},{100,100}},
          lineColor={0,0,255},
          textString="%name")}),
   Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
 Documentation(info="<html>
<p>
fixme
</p>

<p align=\"center\">
<img alt=\"Image of the exhaust damper control chart for single zone AHU\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36_PR1/AHUs/SingleZone/VAV/SetPoints/ExhaustDamper.png\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
Jun 20, 2020, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end ZonaAbsOAMin;
