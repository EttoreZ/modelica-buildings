﻿within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.SetPoints;
block ChilledWaterSupply
  "Sequences to generate setpoints of chilled water supply temperaturea and the pump differential static pressure"

  parameter Modelica.SIunits.PressureDifference dpChiWatPumMin(
    final min=0,
    displayUnit="Pa") = 34473.8
    "Minimum chilled water pump differential static pressure, default 5 psi";
  parameter Modelica.SIunits.PressureDifference dpChiWatPumMax(
    final min=dpChiWatPumMin,
    displayUnit="Pa")
    "Maximum chilled water pump differential static pressure";
  parameter Modelica.SIunits.ThermodynamicTemperature TChiWatSupMin(
    displayUnit="K")
    "Minimum chilled water supply temperature";
  parameter Modelica.SIunits.ThermodynamicTemperature TChiWatSupMax(
    final min=TChiWatSupMin,
    displayUnit="K") = 288.706
    "Maximum chilled water supply temperature, default 60 degF";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uChiWatPlaRes(
    final min = 0,
    final max = 1,
    final unit = "1")
    "Chilled water plant reset"
    annotation (Placement(transformation(extent={{-120,-20},{-80,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dpChiWatPumSet(
    final unit="Pa",
    final quantity="PressureDifference")
    "Chilled water pump differential static pressure setpoint"
    annotation (Placement(transformation(extent={{80,40},{100,60}}),
      iconTransformation(extent={{100,40},{120,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TChiWatSupSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{80,-60},{100,-40}}),
      iconTransformation(extent={{100,-60},{120,-40}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Line chiWatPumPre
    "Chilled water pump differential pressure setpoint"
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerRes(
    final k=0) "Zero plant reset"
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant halRes(
    final k=0.5) "Half one plant reset"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant oneRes(
    final k=1) "One plant reset"
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minChiWatPumPre(
    final k=dpChiWatPumMin)
    "Minimum chilled water pump differential pressure setpoint"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxChiWatPumPre(
    final k=dpChiWatPumMax)
    "Maximum chilled water pump differential pressure setpoint"
    annotation (Placement(transformation(extent={{-20,18},{0,38}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxChiWatTem(
    final k=TChiWatSupMax)
    "Maximum chilled water supply temperature"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minChiWatTem(
    final k=TChiWatSupMin)
    "Minimum chilled water supply temperature"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Line chiWatTem
    "Chilled water temperature setpoint"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));

equation
  connect(zerRes.y, chiWatPumPre.x1)
    annotation (Line(points={{-39,90},{20,90},{20,58},{38,58}},
      color={0,0,127}));
  connect(minChiWatPumPre.y, chiWatPumPre.f1)
    annotation (Line(points={{1,70},{14,70},{14,54},{38,54}},
      color={0,0,127}));
  connect(halRes.y, chiWatPumPre.x2)
    annotation (Line(points={{-39,0},{20,0},{20,46},{38,46}},
      color={0,0,127}));
  connect(maxChiWatPumPre.y, chiWatPumPre.f2)
    annotation (Line(points={{1,28},{14,28},{14,42},{38,42}},
      color={0,0,127}));
  connect(halRes.y, chiWatTem.x1)
    annotation (Line(points={{-39,0},{20,0},{20,-42},{38,-42}},
      color={0,0,127}));
  connect(maxChiWatTem.y, chiWatTem.f1)
    annotation (Line(points={{1,-30},{14,-30},{14,-46},{38,-46}},
      color={0,0,127}));
  connect(oneRes.y, chiWatTem.x2)
    annotation (Line(points={{-39,-90},{14,-90},{14,-54},{38,-54}},
      color={0,0,127}));
  connect(minChiWatTem.y, chiWatTem.f2)
    annotation (Line(points={{1,-70},{20,-70},{20,-58},{38,-58}},
      color={0,0,127}));
  connect(uChiWatPlaRes, chiWatPumPre.u)
    annotation (Line(points={{-100,0},{-70,0},{-70,50},{38,50}},
      color={0,0,127}));
  connect(uChiWatPlaRes, chiWatTem.u)
    annotation (Line(points={{-100,0},{-70,0},{-70,-50},{38,-50}},
      color={0,0,127}));
  connect(chiWatPumPre.y, dpChiWatPumSet)
    annotation (Line(points={{61,50},{90,50}}, color={0,0,127}));
  connect(chiWatTem.y, TChiWatSupSet)
    annotation (Line(points={{61,-50},{90,-50}}, color={0,0,127}));

annotation (
  defaultComponentName="chiWatSupSet",
  Diagram(coordinateSystem(preserveAspectRatio=false,
  extent={{-80,-120},{80,120}}), graphics={Rectangle(
          extent={{-78,118},{78,2}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None), Rectangle(
          extent={{-78,-2},{78,-118}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{-26,118},{74,106}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,255},
          horizontalAlignment=TextAlignment.Left,
          textString="Chilled water pump differential pressure setpoint"),
          Text(
          extent={{-22,-104},{74,-116}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,255},
          horizontalAlignment=TextAlignment.Left,
          textString="Chilled water supply temperature setpoint")}),
  Icon(graphics={Text(
          extent={{-100,150},{100,110}},
          lineColor={0,0,255},
          textString="%name"),
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Line(points={{-80,72},{-80,-54},{80,-54},{80,72}}, color={95,95,95}),
        Line(
          points={{-80,64},{-2,64},{80,-54}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-80,-54},{-2,64},{80,64}},
          color={28,108,200},
          pattern=LinePattern.Dash,
          thickness=0.5),
        Line(
          points={{-2,64},{-2,-54}},
          color={215,215,215},
          pattern=LinePattern.Dash),
    Polygon(
      points={{-72,-66},{-50,-60},{-50,-72},{-72,-66}},
      lineColor={95,95,95},
      fillColor={95,95,95},
      fillPattern=FillPattern.Solid),
    Line(points={{-10,-66},{-68,-66}},color={95,95,95}),
    Line(points={{8,-66},{70,-66}},   color={95,95,95}),
    Polygon(
      points={{72,-66},{50,-60},{50,-72},{72,-66}},
      lineColor={95,95,95},
      fillColor={95,95,95},
      fillPattern=FillPattern.Solid),
    Text(
      extent={{-20,-66},{22,-82}},
      lineColor={95,95,95},
          textString="Plant reset"),
    Text(
      extent={{14,26},{68,6}},
      lineColor={95,95,95},
          horizontalAlignment=TextAlignment.Right,
          textString="Temperature
setpoint"),
    Text(
      extent={{-76,22},{-42,8}},
      lineColor={95,95,95},
          horizontalAlignment=TextAlignment.Right,
          textString="DP
setpoint"),
    Text(
      extent={{-14,-56},{12,-62}},
      lineColor={95,95,95},
          textString="0.5")}),
Documentation(info="<html>
<p>
Block that output setpoints for the chilled water supply of primary-only and 
primary-secondary systems serving differential pressure controlled pumps.
The outputs include supply temperature setpoint <code>TChiWatSupSet</code> 
and pump differential pressure setpoint <code>dpChiWatPumSet</code>, according 
to ASHRAE RP-1711 Advanced Sequences of Operation for HVAC Systems Phase II – 
Central Plants and Hydronic Systems (Draft 4 on January 7, 2019), section 5.2.5.1.
</p>
<p>
Chilled water supply temperature setpoint <code>TChiWatSupSet</code> and pump
differential pressure setpoint <code>dpChiWatPumSet</code> shall be reset based on
the current value of chilled water plant reset <code>uChiWatPlaRes</code>.
</p>
<p align=\"center\">
<img alt=\"Image of chilled water supply setpoints\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/SetPoints/ChiWatSupSet_VSChiller.png\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
April 15, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ChilledWaterSupply;
