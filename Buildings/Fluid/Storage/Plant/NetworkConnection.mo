within Buildings.Fluid.Storage.Plant;
model NetworkConnection
  "Storage plant section with supply pump and valves"

  extends Buildings.Fluid.Storage.Plant.BaseClasses.PartialBranchPorts;

  parameter Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup plaTyp=
    nom.plaTyp
    "Type of plant setup";

  //Pump sizing & interlock
  parameter Buildings.Fluid.Movers.Data.Generic perPumSup
    "Performance data for the supply pump"
    annotation (Placement(transformation(extent={{-100,100},{-80,120}})),
    Dialog(group="Pump Sizing and Interlock"));
  parameter Buildings.Fluid.Movers.Data.Generic perPumRet
    "Performance data for the return pump"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})),
    Dialog(group="Pump Sizing and Interlock", enable=
    plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open));
  parameter Real tPumSupClo=0.01
    "Threshold that pumSup is considered off"
    annotation (Dialog(group="Pump Sizing and Interlock", enable=
    plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open));
  parameter Real tPumRetClo=0.01
    "Threshold that pumRet is considered off"
    annotation (Dialog(group="Pump Sizing and Interlock", enable=
    plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open));

  //Control valve sizing & interlock
  parameter Modelica.Units.SI.PressureDifference dpValToNetSup_nominal=
    0.1*nom.dp_nominal "Nominal flow rate of intValSup.valToNet"
    annotation (Dialog(group="Control Valve Sizing and Interlock", enable=
    plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
    or plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open));
  parameter Modelica.Units.SI.PressureDifference dpValFroNetSup_nominal=
    0.1*nom.dp_nominal "Nominal flow rate of intValSup.valFroNet"
    annotation (Dialog(group="Control Valve Sizing and Interlock", enable=
    plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
    or plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open));
  parameter Real tValToNetSupClo=0.01
    "Threshold that intValSup.ValToNet is considered closed"
    annotation (Dialog(group="Control Valve Sizing and Interlock", enable=
    plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
    or plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open));
  parameter Real tValFroNetSupClo=0.01
    "Threshold that intValSup.ValFroNet is considered closed"
    annotation (Dialog(group="Control Valve Sizing and Interlock", enable=
    plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
    or plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open));
  parameter Modelica.Units.SI.PressureDifference dpValToNetRet_nominal=
    0.1*nom.dp_nominal "Nominal flow rate of intValRet.valToNet"
    annotation (Dialog(group="Control Valve Sizing and Interlock", enable=
    plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open));
  parameter Modelica.Units.SI.PressureDifference dpValFroNetRet_nominal=
    0.1*nom.dp_nominal "Nominal flow rate of intValRet.valFroNet"
    annotation (Dialog(group="Control Valve Sizing and Interlock", enable=
    plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open));
  parameter Real tValToNetRetClo=0.01
    "Threshold that intValRet.ValToNet is considered closed"
    annotation (Dialog(group="Control Valve Sizing and Interlock", enable=
    plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open));
  parameter Real tValFroNetRetClo=0.01
    "Threshold that intValRet.ValFroNet is considered closed"
    annotation (Dialog(group="Control Valve Sizing and Interlock", enable=
    plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open));

  Buildings.Fluid.Movers.SpeedControlled_y pumSup(
    redeclare final package Medium = Medium,
    final per=perPumSup,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    allowFlowReversal=true,
    addPowerToMedium=false,
    y_start=0,
    T_start=nom.T_CHWR_nominal) "CHW supply pump" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,60})));
  Buildings.Fluid.Storage.Plant.BaseClasses.FluidPassThrough pasSup(
    redeclare final package Medium = Medium) if plaTyp ==
    Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedLocal
    "Replaces the valve on the supply branch when the tank is closed"
    annotation (Placement(transformation(extent={{30,90},{50,110}})));
  Modelica.Blocks.Interfaces.RealInput yValSup[2]
    if plaTyp ==
      Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
    or plaTyp ==
      Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
    "Positions of the valves on the supply line" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={10,130}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={20,110})));
  Modelica.Blocks.Interfaces.RealInput yPumSup "Speed input of the supply pump"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-10,130}),iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,110})));

  Buildings.Fluid.Movers.SpeedControlled_y pumRet(
    redeclare final package Medium = Medium,
    final per=perPumRet,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    allowFlowReversal=true,
    addPowerToMedium=false,
    y_start=0,
    T_start=nom.T_CHWR_nominal)
    if plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
    "Auxilliary CHW pump on the return line" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,-60})));
  Buildings.Fluid.Storage.Plant.BaseClasses.FluidPassThrough pasRet(
    redeclare final package Medium = Medium)
    if plaTyp ==
      Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedLocal
    or plaTyp ==
      Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
    "Replaces the pump and valves on the return branch when the tank is closed"
    annotation (Placement(transformation(extent={{40,-40},{20,-20}})));
  Modelica.Blocks.Interfaces.RealInput yValRet[2]
    if plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
    "Control signals for the valves on the return line" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={50,130}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={100,110})));
  Modelica.Blocks.Interfaces.RealInput yPumRet
    if plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
    "Speed input of the auxiliary pump on the return line" annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={30,130}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,110})));
  Buildings.Fluid.Storage.Plant.BaseClasses.InterlockedValves intValSup(
    redeclare final package Medium = Medium,
    final nom=nom,
    final dpValToNet_nominal=dpValToNetSup_nominal,
    final dpValFroNet_nominal=dpValFroNetSup_nominal,
    final tValToNetClo=tValToNetSupClo,
    final tValFroNetClo=tValFroNetSupClo)
    if plaTyp ==
    Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
     or plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
    "A pair of interlocked valves"
    annotation (Placement(transformation(extent={{20,28},{60,68}})));
  Buildings.Fluid.Storage.Plant.BaseClasses.InterlockedValves intValRet(
    redeclare final package Medium = Medium,
    final nom=nom,
    final dpValToNet_nominal=dpValToNetRet_nominal,
    final dpValFroNet_nominal=dpValFroNetRet_nominal,
    final tValToNetClo=tValToNetRetClo,
    final tValFroNetClo=tValFroNetRetClo)
    if plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
    "A pair of interlocked valves"
    annotation (Placement(transformation(extent={{20,-92},{60,-52}})));

  Buildings.Fluid.Storage.Plant.Controls.Interlock conInt(
    final t1=tPumSupClo,
    final t2=tPumRetClo)
    if plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
    "Interlock for pumps"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Modelica.Blocks.Routing.RealPassThrough pas
    if plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedLocal
    or plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
    "Block for signal routing" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-50,90})));
equation
  connect(port_aFroChi, pumSup.port_a)
    annotation (Line(points={{-100,60},{-60,60}}, color={0,127,255}));
  connect(pasSup.port_b, port_bToNet) annotation (Line(points={{50,100},{68,100},
          {68,60},{100,60}}, color={0,127,255}));
  connect(port_bToChi, pumRet.port_a)
    annotation (Line(points={{-100,-60},{-60,-60}}, color={0,127,255}));
  connect(port_aFroNet, pasRet.port_a) annotation (Line(points={{100,-60},{90,-60},
          {90,-30},{40,-30}}, color={0,127,255}));
  connect(pasRet.port_b, port_bToChi) annotation (Line(points={{20,-30},{-80,-30},
          {-80,-60},{-100,-60}}, color={0,127,255}));
  connect(intValSup.port_bToNet, port_bToNet)
    annotation (Line(points={{60,60},{100,60}}, color={0,127,255}));
  connect(intValSup.port_bToChi, port_aFroChi) annotation (Line(points={{20,36},
          {-80,36},{-80,60},{-100,60}}, color={0,127,255}));
  connect(intValSup.port_aFroNet, port_bToNet) annotation (Line(points={{60,36},
          {68,36},{68,60},{100,60}}, color={0,127,255}));
  connect(intValSup.yVal, yValSup) annotation (Line(points={{40,70},{20,70},{20,
          110},{10,110},{10,130}}, color={0,0,127}));
  connect(intValRet.port_bToNet, port_aFroNet)
    annotation (Line(points={{60,-60},{100,-60}}, color={0,127,255}));
  connect(intValRet.port_aFroNet, port_aFroNet) annotation (Line(points={{60,-84},
          {70,-84},{70,-60},{100,-60}}, color={0,127,255}));
  connect(intValRet.port_bToChi, port_bToChi) annotation (Line(points={{20,-84},
          {-70,-84},{-70,-60},{-100,-60}}, color={0,127,255}));
  connect(intValRet.yVal, yValRet) annotation (Line(points={{40,-50},{76,-50},{
          76,114},{50,114},{50,130}}, color={0,0,127}));
  connect(pumSup.port_b, intValSup.port_aFroChi)
    annotation (Line(points={{-40,60},{20,60}}, color={0,127,255}));
  connect(pumSup.port_b, pasSup.port_a) annotation (Line(points={{-40,60},{10,60},
          {10,100},{30,100}}, color={0,127,255}));
  connect(pumRet.port_b, intValRet.port_aFroChi)
    annotation (Line(points={{-40,-60},{20,-60}}, color={0,127,255}));
  connect(pumSup.y, pas.y)
    annotation (Line(points={{-50,72},{-50,79}}, color={0,0,127}));
  connect(pas.u, yPumSup) annotation (Line(points={{-50,102},{-50,110},{-10,110},
          {-10,130}}, color={0,0,127}));
  connect(yPumSup, conInt.u1_in) annotation (Line(points={{-10,130},{-10,110},{-66,
          110},{-66,18},{-62,18}}, color={0,0,127}));
  connect(pumSup.y_actual, conInt.u1_actual) annotation (Line(points={{-39,67},{
          -34,67},{-34,28},{-70,28},{-70,14},{-62,14}}, color={0,0,127}));
  connect(conInt.y1, pumSup.y) annotation (Line(points={{-39,14},{-30,14},{-30,76},
          {-50,76},{-50,72}}, color={0,0,127}));
  connect(conInt.u2_in, yPumRet) annotation (Line(points={{-62,6},{-74,6},{-74,116},
          {30,116},{30,130}}, color={0,0,127}));
  connect(conInt.y2, pumRet.y) annotation (Line(points={{-39,6},{-30,6},{-30,-40},
          {-50,-40},{-50,-48}}, color={0,0,127}));
  connect(pumRet.y_actual, conInt.u2_actual) annotation (Line(points={{-39,-53},
          {-34,-53},{-34,-8},{-66,-8},{-66,2},{-62,2}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Line(points={{-100,60},{100,60}}, color={28,108,200}),
        Line(points={{-100,-60},{100,-60}}, color={28,108,200}),
        Ellipse(
          extent={{-60,80},{-20,40}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{40,60},{24,70},{24,50},{40,60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
               or plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open),
        Polygon(
          points={{40,60},{56,70},{56,50},{40,60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
               or plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open),
        Line(
          points={{80,60},{80,32},{-80,32},{-80,60}},
          color={28,108,200},
          visible=plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
               or plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open),
        Polygon(
          points={{40,32},{24,42},{24,22},{40,32}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
               or plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open),
        Polygon(
          points={{40,32},{56,42},{56,22},{40,32}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
               or plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open),
        Polygon(
          points={{-20,60},{-50,76},{-50,44},{-20,60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.None),
        Ellipse(
          extent={{-60,-40},{-20,-80}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          startAngle=0,
          endAngle=360,
          visible=plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open),
        Polygon(
          points={{40,-60},{24,-50},{24,-70},{40,-60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open),
        Polygon(
          points={{40,-60},{56,-50},{56,-70},{40,-60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open),
        Line(
          points={{80,-60},{80,-88},{-80,-88},{-80,-60}},
          color={28,108,200},
          visible=plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open),
        Polygon(
          points={{40,-88},{24,-78},{24,-98},{40,-88}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open),
        Polygon(
          points={{40,-88},{56,-78},{56,-98},{40,-88}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open),
        Polygon(
          points={{-20,-60},{-50,-44},{-50,-76},{-20,-60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.None,
          visible=plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open)}),
                                                                 Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            120}})),
    defaultComponentName = "netCon",
    Documentation(info="<html>
<p>
This model is part of a storage plant model.
It has the following components:
</p>
<table summary= \"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<thead>
  <tr>
    <th>Component</th>
    <th>Enabled</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td>Supply pump<br/>
        <code>pumSup</code></td>
    <td>Always</td>
  </tr>
  <tr>
    <td>Supply output valve<br/>
        <code>intValSup.valToNet</code></td>
    <td rowspan=\"2\"><code>plaTyp == .ClosedRemote</code>
        or <code>.Open</code></td>
  </tr>
  <tr>
    <td>Supply charging valve<br/>
        <code>intValSup.valFroNet</code></td>
  </tr>
  <tr>
    <td>Auxiliary pump<br/>
        <code>pumRet</code></td>
    <td rowspan=\"3\"><code>plaTyp == .Open</code></td>
  </tr>
  <tr>
    <td>Return charging valve<br/>
        <code>intValRet.valToNet</code></td>
  </tr>
  <tr>
    <td>Return output valve<br/>
        <code>intValRet.valFroNet</code></td>
  </tr>
</tbody>
</table>
<p>
Under configurations where remote charging is allowed
(<code>plaTyp == .ClosedRemote</code> or <code>.Open</code>),
these components are controlled by
<a href=\"Modelica://Buildings.Fluid.Storage.Plant.BaseClasses.PumpValveControl\">
Buildings.Fluid.Storage.Plant.BaseClasses.PumpValveControl</a>.
See its documentation for the control objectives.
</p>
</html>", revisions="<html>
<ul>
<li>
February 18, 2022 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"));
end NetworkConnection;
