within Buildings.Controls.OBC.CDL.Logical.Validation;
model ConstantDutyCycle
  "Validation model for producing the constant duty cycle"

  Buildings.Controls.OBC.CDL.Logical.ConstantDutyCycle truGo(
    final width=0.5,
    final period=4)
    "Constant duty cycle with go input being constant true"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));

  Buildings.Controls.OBC.CDL.Logical.ConstantDutyCycle falGo(
    final width=0.5,
    final period=4)
    "Constant duty cycle with go input being constant false"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));

  Buildings.Controls.OBC.CDL.Logical.ConstantDutyCycle truFalGo(
    final width=0.5,
    final period=4)
    "Constant duty cycle with go input changing from true to false"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));

  Buildings.Controls.OBC.CDL.Logical.ConstantDutyCycle falTruGo(
    final width=0.5,
    final period=4)
    "Constant duty cycle with go input changing from false to true"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul_a1(
    final width=0.8,
    final period=20)
    "Boolean pulse signal"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=true) "Constant true"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1(
    final k=false)
    "Constant false"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul_a2(
    final width=0.85,
    final period=20,
    final shift=2)
    "Boolean pulse signal"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));

equation
  connect(con.y, truGo.go)
    annotation (Line(points={{-18,70},{18,70}}, color={255,0,255}));
  connect(con1.y, falGo.go)
    annotation (Line(points={{-18,20},{18,20}}, color={255,0,255}));
  connect(booPul_a1.y, truFalGo.go)
    annotation (Line(points={{-18,-30},{18,-30}}, color={255,0,255}));
  connect(booPul_a2.y, falTruGo.go)
    annotation (Line(points={{-18,-70},{18,-70}}, color={255,0,255}));

annotation (experiment(StopTime=20,Tolerance=1e-06),
  __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Logical/Validation/ConstantDutyCycle.mos" "Simulate and plot"),
  Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Logical.ConstantDutyCycle\">
Buildings.Controls.OBC.CDL.Logical.ConstantDutyCycle</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
August 11, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(
      graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}));
end ConstantDutyCycle;
