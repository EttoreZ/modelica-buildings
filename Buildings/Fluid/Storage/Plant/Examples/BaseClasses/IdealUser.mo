within Buildings.Fluid.Storage.Plant.Examples.BaseClasses;
model IdealUser "Dummy user model"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface;

  parameter Modelica.Units.SI.Temperature T_a_nominal
    "Nominal temperature of CHW supply";
  parameter Modelica.Units.SI.Temperature T_b_nominal
    "Nominal temperature of CHW return";
  parameter Modelica.Units.SI.PressureDifference dp_nominal
    "Nominal pressure difference";

  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage val(
    redeclare final package Medium = Medium,
    use_inputFilter=false,
    dpValve_nominal=0.1*dp_nominal,
    m_flow_nominal=m_flow_nominal,
    y_start=0) "User control valve"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heaCon
    "Prescribed heat flow"
    annotation (Placement(transformation(extent={{22,70},{42,90}})));
  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    redeclare final package Medium = Medium,
    final prescribedHeatFlowRate=true,
    nPorts=2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=m_flow_nominal,
    allowFlowReversal=true,
    V=0.5,
    p_start=500000,
    T_start=T_b_nominal) "Volume representing the consumer"
    annotation (
      Placement(transformation(
        origin={10,-10},
        extent={{10,10},{-10,-10}},
        rotation=0)));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TUse
    "Temperature of the user"
    annotation (Placement(transformation(extent={{40,-40},{20,-20}})));
  Buildings.Fluid.FixedResistances.PressureDrop preDro(
    redeclare final package Medium = Medium,
    final allowFlowReversal=true,
    final dp_nominal=dp_nominal,
    final m_flow_nominal=m_flow_nominal) "Flow resistance of the consumer"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.Continuous.LimPID conPI(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=10,
    Ti=1000,
    reverseActing=false) "PI controller" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,50})));
  Modelica.Blocks.Interfaces.RealInput QCooLoa_flow
    "Cooling load of the consumer" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,80}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-40,110})));
  Modelica.Blocks.Interfaces.RealOutput yVal_actual
    "Consumer control valve actuator position" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,40}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={40,110})));
  Buildings.Fluid.Sensors.RelativePressure dpSen(
    redeclare final package Medium = Medium)
    "Differential pressure sensor"
    annotation (Placement(transformation(extent={{-10,-60},{10,-40}})));
  Modelica.Blocks.Interfaces.RealOutput dpUse
    "Differential pressure of the user" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,-80}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={80,110})));
  Modelica.Blocks.Sources.Constant set_TRet(final k=T_b_nominal)
    "CHW return temperature setpoint"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
equation
  connect(val.port_b, vol.ports[1])
    annotation (Line(points={{-20,0},{11,0}},color={0,127,255}));
  connect(heaCon.port, vol.heatPort)
    annotation (Line(points={{42,80},{46,80},{46,-10},{20,-10}},
                                                       color={191,0,0}));
  connect(vol.heatPort,TUse. port)
    annotation (Line(points={{20,-10},{46,-10},{46,-30},{40,-30}},
                                                       color={191,0,0}));
  connect(preDro.port_a, vol.ports[2]) annotation (Line(points={{60,0},{9,0}},
                            color={0,127,255}));
  connect(TUse.T, conPI.u_m)
    annotation (Line(points={{19,-30},{-50,-30},{-50,38}}, color={0,0,127}));
  connect(heaCon.Q_flow, QCooLoa_flow)
    annotation (Line(points={{22,80},{-110,80}}, color={0,0,127}));
  connect(dpSen.p_rel,dpUse)
    annotation (Line(points={{0,-59},{0,-80},{110,-80}}, color={0,0,127}));
  connect(val.y_actual, yVal_actual)
    annotation (Line(points={{-25,7},{-25,16},{96,16},{96,40},{110,40}},
                                                         color={0,0,127}));
  connect(val.port_a, port_a)
    annotation (Line(points={{-40,0},{-100,0}}, color={0,127,255}));
  connect(dpSen.port_a, port_a) annotation (Line(
      points={{-10,-50},{-100,-50},{-100,0}},
      color={0,127,255},
      pattern=LinePattern.Dash));
  connect(preDro.port_b, port_b)
    annotation (Line(points={{80,0},{100,0}}, color={0,127,255}));
  connect(dpSen.port_b, port_b) annotation (Line(
      points={{10,-50},{100,-50},{100,0}},
      color={0,127,255},
      pattern=LinePattern.Dash));
  connect(conPI.y, val.y)
    annotation (Line(points={{-39,50},{-30,50},{-30,12}}, color={0,0,127}));
  connect(set_TRet.y, conPI.u_s)
    annotation (Line(points={{-79,50},{-62,50}}, color={0,0,127}));
  annotation (
    defaultComponentName = "ideUse",
                                 Documentation(info="<html>
<p>
This is a simple ideal user model used by example models under
<a href=\"Modelica://Buildings.Fluid.Storage.Plant.Examples\">
Buildings.Fluid.Storage.Plant.Examples</a>.
For simplicity, instead of setting up a heat exchanger to a room model,
the consumer control valve simply tracks the return CHW temperature.
</p>
</html>", revisions="<html>
<ul>
<li>
February 18, 2022 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"),
    Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,40},{40,-40}},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-35,35},{-15,15}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-10,35},{10,15}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{15,35},{35,15}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-35,10},{-15,-10}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-10,10},{10,-10}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{15,10},{35,-10}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-35,-15},{-15,-35}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-10,-15},{10,-35}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{15,-15},{35,-35}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0})}));
end IdealUser;
