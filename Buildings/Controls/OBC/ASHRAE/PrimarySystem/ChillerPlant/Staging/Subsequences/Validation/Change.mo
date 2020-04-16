within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Validation;
model Change
  "Validates chiller stage status setpoint signal generation for plants with WSE"

  parameter Modelica.SIunits.Temperature TChiWatSupSet = 285.15
  "Chilled water supply set temperature";

  parameter Modelica.SIunits.Temperature aveTChiWatRet = 288.15
  "Average measured chilled water return temperature";

  parameter Modelica.SIunits.Time minStaRuntime = 900
    "Minimum stage runtime";

  parameter Modelica.SIunits.VolumeFlowRate aveVChiWat_flow = 0.05
    "Average measured chilled water flow rate";

  .Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Change
    cha(nSta=10)
        "Controls for stage up signal variations"
        annotation (Placement(transformation(extent={{-40,180},{-20,200}})));
  CDL.Logical.Sources.Constant                        plaSta(final k=true)
    "Plant status"
    annotation (Placement(transformation(extent={{-160,140},{-140,160}})));
  CDL.Logical.TrueDelay truDel(delayTime=10, delayOnInit=true)
    annotation (Placement(transformation(extent={{-120,140},{-100,160}})));
  CDL.Continuous.Sources.TimeTable timeTable(table=[0,0; 600,0; 600,1; 1200,1; 1200,
        0; 2500,0; 2500,1; 3700,1; 3700,0; 4300,0; 4300,1; 4500,1; 4500,0; 6000,
        0; 6000,1; 9200,1; 9200,0; 11000,0])
    annotation (Placement(transformation(extent={{-160,220},{-140,240}})));
  CDL.Continuous.GreaterThreshold greThr(threshold=0.5)
    annotation (Placement(transformation(extent={{-120,220},{-100,240}})));
  CDL.Conversions.IntegerToReal                        intToRea
    annotation (Placement(transformation(extent={{20,180},{40,200}})));
  CDL.Discrete.ZeroOrderHold                        zerOrdHol(samplePeriod=1)
    annotation (Placement(transformation(extent={{60,180},{80,200}})));
  CDL.Conversions.RealToInteger                        reaToInt
    annotation (Placement(transformation(extent={{100,180},{120,200}})));
  CDL.Integers.Add addInt(k1=+1)
    annotation (Placement(transformation(extent={{140,200},{160,220}})));
  CDL.Integers.Add addInt1(k2=-1)
    annotation (Placement(transformation(extent={{140,160},{160,180}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Change
    cha1(nSta=10)
         "Controls for stage down signal variations"
         annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  CDL.Logical.Sources.Constant                        plaSta1(final k=true)
    "Plant status"
    annotation (Placement(transformation(extent={{-160,-40},{-140,-20}})));
  CDL.Logical.TrueDelay truDel1(delayTime=10, delayOnInit=true)
    annotation (Placement(transformation(extent={{-120,-40},{-100,-20}})));
  CDL.Conversions.IntegerToReal                        intToRea1
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  CDL.Discrete.ZeroOrderHold                        zerOrdHol1(samplePeriod=1)
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  CDL.Conversions.RealToInteger                        reaToInt1
    annotation (Placement(transformation(extent={{100,0},{120,20}})));
  CDL.Integers.Add addInt2(k1=+1)
    annotation (Placement(transformation(extent={{140,20},{160,40}})));
  CDL.Integers.Add addInt3(k2=-1)
    annotation (Placement(transformation(extent={{140,-20},{160,0}})));
  CDL.Continuous.Sources.TimeTable timeTable2(table=[0,0; 800,0; 800,1; 2700,1;
        2700,0; 4500,0; 4500,1; 5200,1; 5200,0; 6000,0; 6000,1; 6900,1; 6900,0;
        7800,0; 7800,1; 8700,1; 8700,0; 11000,0])
    annotation (Placement(transformation(extent={{-160,-140},{-140,-120}})));
  CDL.Continuous.GreaterThreshold greThr2(threshold=0.5)
    annotation (Placement(transformation(extent={{-120,-140},{-100,-120}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Change
    cha2 "Controls for stage up/stage down signal interaction"
         annotation (Placement(transformation(extent={{-40,-180},{-20,-160}})));
  CDL.Logical.Sources.Constant                        plaSta2(final k=true)
    "Plant status"
    annotation (Placement(transformation(extent={{-160,-220},{-140,-200}})));
  CDL.Logical.TrueDelay truDel2(delayTime=10, delayOnInit=true)
    annotation (Placement(transformation(extent={{-120,-220},{-100,-200}})));
  CDL.Conversions.IntegerToReal                        intToRea2
    annotation (Placement(transformation(extent={{20,-180},{40,-160}})));
  CDL.Discrete.ZeroOrderHold                        zerOrdHol2(samplePeriod=1)
    annotation (Placement(transformation(extent={{60,-180},{80,-160}})));
  CDL.Conversions.RealToInteger                        reaToInt2
    annotation (Placement(transformation(extent={{100,-180},{120,-160}})));
  CDL.Integers.Add addInt4(k1=+1)
    annotation (Placement(transformation(extent={{140,-160},{160,-140}})));
  CDL.Integers.Add addInt5(k2=-1)
    annotation (Placement(transformation(extent={{140,-200},{160,-180}})));
  CDL.Continuous.GreaterThreshold greThr3(threshold=0.5)
    annotation (Placement(transformation(extent={{-120,-180},{-100,-160}})));
  CDL.Logical.Sources.Constant noStaChaSig(final k=false)
    "No stage change signal"
    annotation (Placement(transformation(extent={{-200,100},{-180,120}})));
  CDL.Continuous.Sources.TimeTable timeTable1(table=[0,0; 1600,0; 1600,1; 2400,1;
        2400,0; 3700,0; 3700,1; 5900,1; 5900,0; 6900,0; 6900,1; 7800,1; 7800,0;
        11000,0])
    annotation (Placement(transformation(extent={{-160,-180},{-140,-160}})));
  CDL.Logical.TrueFalseHold truFalHol(trueHoldDuration=10, falseHoldDuration=0)
    "Short true hold to have stage change edge signals be better visible"
    annotation (Placement(transformation(extent={{0,120},{20,140}})));
  CDL.Logical.TrueFalseHold truFalHol1(trueHoldDuration=10, falseHoldDuration=0)
    "Short true hold to have stage change edge signals be better visible"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  CDL.Logical.TrueFalseHold truFalHol2(trueHoldDuration=10, falseHoldDuration=0)
    "Short true hold to have stage change edge signals be better visible"
    annotation (Placement(transformation(extent={{0,-240},{20,-220}})));
  CDL.Integers.Max maxInt
    annotation (Placement(transformation(extent={{180,140},{200,160}})));
  CDL.Integers.Max maxInt1
    annotation (Placement(transformation(extent={{180,-40},{200,-20}})));
  CDL.Integers.Max maxInt2
    annotation (Placement(transformation(extent={{180,-220},{200,-200}})));
protected
  CDL.Integers.Sources.Constant                        u(final k=0)
    "Chiller stage"
    annotation (Placement(transformation(extent={{-120,260},{-100,280}})));
protected
  CDL.Integers.Sources.Constant step(final k=1)
    "Assuming that the next available stage is always the next stage"
    annotation (Placement(transformation(extent={{100,220},{120,240}})));
protected
  CDL.Integers.Sources.Constant                        u1(final k=7)
    "Chiller stage"
    annotation (Placement(transformation(extent={{-120,80},{-100,100}})));
protected
  CDL.Integers.Sources.Constant step1(final k=1)
    "Assuming that the next available stage is always the next stage"
    annotation (Placement(transformation(extent={{100,40},{120,60}})));
protected
  CDL.Integers.Sources.Constant                        u2(final k=1)
    "Chiller stage"
    annotation (Placement(transformation(extent={{-120,-100},{-100,-80}})));
protected
  CDL.Integers.Sources.Constant step2(final k=1)
    "Assuming that the next available stage is always the next stage"
    annotation (Placement(transformation(extent={{100,-140},{120,-120}})));
protected
  CDL.Integers.Sources.Constant                        u3(final k=0)
    "Chiller stage"
    annotation (Placement(transformation(extent={{140,120},{160,140}})));
protected
  CDL.Integers.Sources.Constant                        u4(final k=0)
    "Chiller stage"
    annotation (Placement(transformation(extent={{140,-60},{160,-40}})));
protected
  CDL.Integers.Sources.Constant                        u5(final k=0)
    "Chiller stage"
    annotation (Placement(transformation(extent={{140,-240},{160,-220}})));
equation
  connect(plaSta.y, truDel.u)
    annotation (Line(points={{-138,150},{-122,150}}, color={255,0,255}));
  connect(cha.uIni, u.y) annotation (Line(points={{-42,200},{-60,200},{-60,270},
          {-98,270}}, color={255,127,0}));
  connect(timeTable.y[1], greThr.u)
    annotation (Line(points={{-138,230},{-122,230}}, color={0,0,127}));
  connect(cha.ySta, intToRea.u) annotation (Line(points={{-18,194},{0,194},{0,
          190},{18,190}},
                     color={255,127,0}));
  connect(intToRea.y, zerOrdHol.u)
    annotation (Line(points={{42,190},{58,190}}, color={0,0,127}));
  connect(zerOrdHol.y, reaToInt.u)
    annotation (Line(points={{82,190},{98,190}}, color={0,0,127}));
  connect(reaToInt.y, addInt.u2) annotation (Line(points={{122,190},{130,190},{
          130,204},{138,204}},
                           color={255,127,0}));
  connect(reaToInt.y, addInt1.u1) annotation (Line(points={{122,190},{130,190},
          {130,176},{138,176}},color={255,127,0}));
  connect(step.y, addInt.u1) annotation (Line(points={{122,230},{130,230},{130,
          216},{138,216}},
                      color={255,127,0}));
  connect(step.y, addInt1.u2) annotation (Line(points={{122,230},{126,230},{126,
          164},{138,164}}, color={255,127,0}));
  connect(addInt.y, cha.uAvaUp) annotation (Line(points={{162,210},{170,210},{
          170,250},{-50,250},{-50,196},{-42,196}},
                                               color={255,127,0}));
  connect(truDel.y, cha.uPla) annotation (Line(points={{-98,150},{-70,150},{-70,
          180},{-42,180}}, color={255,0,255}));
  connect(plaSta1.y, truDel1.u)
    annotation (Line(points={{-138,-30},{-122,-30}}, color={255,0,255}));
  connect(cha1.uIni, u1.y) annotation (Line(points={{-42,20},{-60,20},{-60,90},
          {-98,90}},
                color={255,127,0}));
  connect(cha1.ySta, intToRea1.u) annotation (Line(points={{-18,14},{0,14},{0,
          10},{18,10}},
                     color={255,127,0}));
  connect(intToRea1.y, zerOrdHol1.u)
    annotation (Line(points={{42,10},{58,10}},   color={0,0,127}));
  connect(zerOrdHol1.y, reaToInt1.u)
    annotation (Line(points={{82,10},{98,10}},   color={0,0,127}));
  connect(reaToInt1.y, addInt2.u2) annotation (Line(points={{122,10},{130,10},{
          130,24},{138,24}},color={255,127,0}));
  connect(reaToInt1.y, addInt3.u1) annotation (Line(points={{122,10},{130,10},{
          130,-4},{138,-4}},    color={255,127,0}));
  connect(step1.y, addInt2.u1) annotation (Line(points={{122,50},{130,50},{130,
          36},{138,36}},
                     color={255,127,0}));
  connect(step1.y, addInt3.u2) annotation (Line(points={{122,50},{126,50},{126,
          -16},{138,-16}},
                      color={255,127,0}));
  connect(addInt2.y, cha1.uAvaUp) annotation (Line(points={{162,30},{170,30},{
          170,70},{-50,70},{-50,16},{-42,16}},
                                           color={255,127,0}));
  connect(truDel1.y, cha1.uPla) annotation (Line(points={{-98,-30},{-70,-30},{
          -70,0},{-42,0}}, color={255,0,255}));
  connect(timeTable2.y[1], greThr2.u)
    annotation (Line(points={{-138,-130},{-122,-130}}, color={0,0,127}));
  connect(plaSta2.y, truDel2.u)
    annotation (Line(points={{-138,-210},{-122,-210}}, color={255,0,255}));
  connect(cha2.uIni, u2.y) annotation (Line(points={{-42,-160},{-60,-160},{-60,
          -90},{-98,-90}},
                       color={255,127,0}));
  connect(cha2.ySta, intToRea2.u) annotation (Line(points={{-18,-166},{0,-166},
          {0,-170},{18,-170}},color={255,127,0}));
  connect(intToRea2.y, zerOrdHol2.u)
    annotation (Line(points={{42,-170},{58,-170}}, color={0,0,127}));
  connect(zerOrdHol2.y, reaToInt2.u)
    annotation (Line(points={{82,-170},{98,-170}}, color={0,0,127}));
  connect(reaToInt2.y, addInt4.u2) annotation (Line(points={{122,-170},{130,
          -170},{130,-156},{138,-156}},
                                  color={255,127,0}));
  connect(reaToInt2.y, addInt5.u1) annotation (Line(points={{122,-170},{130,
          -170},{130,-184},{138,-184}},
                                  color={255,127,0}));
  connect(step2.y, addInt4.u1) annotation (Line(points={{122,-130},{130,-130},{
          130,-144},{138,-144}},
                             color={255,127,0}));
  connect(step2.y, addInt5.u2) annotation (Line(points={{122,-130},{126,-130},{
          126,-196},{138,-196}},
                             color={255,127,0}));
  connect(addInt4.y, cha2.uAvaUp) annotation (Line(points={{162,-150},{170,-150},
          {170,-110},{-50,-110},{-50,-164},{-42,-164}}, color={255,127,0}));
  connect(truDel2.y, cha2.uPla) annotation (Line(points={{-98,-210},{-70,-210},
          {-70,-180},{-42,-180}},color={255,0,255}));
  connect(noStaChaSig.y, cha.uDow) annotation (Line(points={{-178,110},{-170,
          110},{-170,184},{-42,184}},
                                 color={255,0,255}));
  connect(noStaChaSig.y, cha1.uUp) annotation (Line(points={{-178,110},{-170,
          110},{-170,60},{-80,60},{-80,8},{-42,8}},color={255,0,255}));
  connect(greThr.y, cha.uUp) annotation (Line(points={{-98,230},{-70,230},{-70,
          188},{-42,188}},
                      color={255,0,255}));
  connect(greThr2.y, cha2.uUp) annotation (Line(points={{-98,-130},{-80,-130},{
          -80,-172},{-42,-172}},
                             color={255,0,255}));
  connect(greThr3.y, cha2.uDow) annotation (Line(points={{-98,-170},{-90,-170},
          {-90,-176},{-42,-176}},color={255,0,255}));
  connect(greThr.y, cha1.uDow) annotation (Line(points={{-98,230},{-64,230},{
          -64,4},{-42,4}}, color={255,0,255}));
  connect(timeTable1.y[1], greThr3.u)
    annotation (Line(points={{-138,-170},{-122,-170}}, color={0,0,127}));
  connect(cha.y, truFalHol.u) annotation (Line(points={{-18,186},{-10,186},{-10,
          130},{-2,130}}, color={255,0,255}));
  connect(cha1.y, truFalHol1.u) annotation (Line(points={{-18,6},{-10,6},{-10,
          -50},{-2,-50}}, color={255,0,255}));
  connect(cha2.y, truFalHol2.u) annotation (Line(points={{-18,-174},{-10,-174},
          {-10,-230},{-2,-230}},color={255,0,255}));
  connect(addInt1.y, maxInt.u1) annotation (Line(points={{162,170},{170,170},{
          170,156},{178,156}}, color={255,127,0}));
  connect(maxInt.u2, u3.y) annotation (Line(points={{178,144},{170,144},{170,
          130},{162,130}}, color={255,127,0}));
  connect(maxInt.y, cha.uAvaDow) annotation (Line(points={{202,150},{210,150},{
          210,110},{-50,110},{-50,192},{-42,192}}, color={255,127,0}));
  connect(addInt3.y, maxInt1.u1) annotation (Line(points={{162,-10},{170,-10},{
          170,-24},{178,-24}}, color={255,127,0}));
  connect(u4.y, maxInt1.u2) annotation (Line(points={{162,-50},{170,-50},{170,
          -36},{178,-36}}, color={255,127,0}));
  connect(maxInt1.y, cha1.uAvaDow) annotation (Line(points={{202,-30},{208,-30},
          {208,-70},{-50,-70},{-50,12},{-42,12}}, color={255,127,0}));
  connect(addInt5.y, maxInt2.u1) annotation (Line(points={{162,-190},{170,-190},
          {170,-204},{178,-204}}, color={255,127,0}));
  connect(u5.y, maxInt2.u2) annotation (Line(points={{162,-230},{170,-230},{170,
          -216},{178,-216}}, color={255,127,0}));
  connect(maxInt2.y, cha2.uAvaDow) annotation (Line(points={{202,-210},{208,
          -210},{208,-252},{-50,-252},{-50,-168},{-42,-168}}, color={255,127,0}));
annotation (
 experiment(StopTime=20000.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Subsequences/Validation/Change.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Change\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Change</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 26, 2020, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"),
Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-220,-280},{220,300}})));
end Change;