within Buildings.Air.Systems.SingleZone.VAV.Examples.OptimalStart;
model OptimalStartGuideline36
  "Example model using optimal start with Guideline 36 controller for a single-zone system"
  extends Modelica.Icons.Example;

  Controls.SetPoints.OccupancySchedule occSch(occupancy=3600*{8,18})
    "Occupancy schedule"
    annotation (Placement(transformation(extent={{-60,-34},{-40,-14}})));
  Buildings.Controls.OBC.Utilities.OptimalStart optStaHea(computeHeating=true,
    computeCooling=false,
    thrOptOn(displayUnit="s"))
    annotation (Placement(transformation(extent={{-20,62},{0,82}})));
  Modelica.Blocks.Sources.Constant TSetHeaOn(k=20 + 273.15)
    "Zone heating setpoint during occupied period"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Modelica.Blocks.Sources.Constant TSetCooOn(k=24 + 273.15)
    "Zone cooling setpoint during occupied time"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Controls.OBC.Utilities.OptimalStart optStaCoo(
    computeHeating=false,
    computeCooling=true,
    thrOptOn(displayUnit="s"))
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Controls.OBC.CDL.Continuous.Sources.Constant con(k=0)
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  BaseClasses.ZoneWithAHUG36 zonAHUG36_1
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  BaseClasses.ZoneWithAHUG36 zonAHUG36_2
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
equation

  connect(TSetHeaOn.y, optStaHea.TSetZonHea) annotation (Line(points={{-39,80},
          {-22,80}},                      color={0,0,127}));
  connect(TSetCooOn.y, optStaCoo.TSetZonCoo) annotation (Line(points={{-39,30},
          {-30,30},{-30,33},{-22,33}},       color={0,0,127}));
  connect(occSch.tNexOcc, optStaCoo.tNexOcc) annotation (Line(points={{-39,-18},
          {-26,-18},{-26,22},{-22,22}},      color={0,0,127}));
  connect(optStaCoo.TZon, optStaHea.TZon) annotation (Line(points={{-22,27},{
          -32,27},{-32,69},{-22,69}},     color={0,0,127}));
  connect(occSch.tNexOcc, zonAHUG36_1.tNexOcc) annotation (Line(points={{-39,
          -18},{26,-18},{26,47},{38,47}}, color={0,0,127}));
  connect(occSch.occupied, zonAHUG36_1.uOcc) annotation (Line(points={{-39,-30},
          {32,-30},{32,43},{38,43}}, color={255,0,255}));
  connect(optStaHea.tOpt, zonAHUG36_1.warUpTim) annotation (Line(points={{2,76},
          {20,76},{20,56},{38,56}}, color={0,0,127}));
  connect(optStaCoo.tOpt, zonAHUG36_1.cooDowTim) annotation (Line(points={{2,34},
          {20,34},{20,51.8},{38,51.8}}, color={0,0,127}));
  connect(zonAHUG36_1.TSupCoo, optStaHea.TZon) annotation (Line(points={{62,50},
          {64,50},{64,14},{-32,14},{-32,69},{-22,69}}, color={0,0,127}));
  connect(con.y, zonAHUG36_2.warUpTim) annotation (Line(points={{2,-70},{8,-70},
          {8,-64},{38,-64}}, color={0,0,127}));
  connect(con.y, zonAHUG36_2.cooDowTim) annotation (Line(points={{2,-70},{8,-70},
          {8,-68.2},{38,-68.2}}, color={0,0,127}));
  connect(occSch.tNexOcc, zonAHUG36_2.tNexOcc) annotation (Line(points={{-39,
          -18},{26,-18},{26,-73},{38,-73}}, color={0,0,127}));
  connect(occSch.occupied, zonAHUG36_2.uOcc) annotation (Line(points={{-39,-30},
          {20,-30},{20,-77},{38,-77}}, color={255,0,255}));
  connect(occSch.tNexOcc, optStaHea.tNexOcc) annotation (Line(points={{-39,-18},
          {-26,-18},{-26,64},{-22,64}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false),
                    graphics={
        Rectangle(
          extent={{-70,-50},{74,-94}},
          fillColor={226,226,226},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Text(
          extent={{0,-76},{54,-102}},
          lineColor={238,46,47},
          fillColor={229,229,229},
          fillPattern=FillPattern.Solid,
          textString="System without optimal start"),
        Rectangle(
          extent={{-70,96},{72,8}},
          fillColor={226,226,226},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Text(
          extent={{0,104},{48,80}},
          lineColor={238,46,47},
          fillColor={229,229,229},
          fillPattern=FillPattern.Solid,
          textString="System with optimal start")}),
    experiment(
      StopTime=604800,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
      __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Air/Systems/SingleZone/VAV/Examples/Guideline36.mos"
        "Simulate and plot"),
      Documentation(info="<html>
<p>
Implementation of <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Examples.BaseClasses.PartialOpenLoop\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Examples.BaseClasses.PartialOpenLoop</a>
with ASHRAE Guideline 36 control sequence.
</p>
</html>", revisions="<html>
<ul>
<li>
July 29, 2019, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"));
end OptimalStartGuideline36;
