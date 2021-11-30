within Buildings.Templates.AirHandlersFans.Components.OutdoorSection;
model SingleDamper "Single common damper (modulated) with AFMS"
  extends Buildings.Templates.AirHandlersFans.Components.OutdoorSection.Interfaces.PartialOutdoorSection(
    final typ=Buildings.Templates.AirHandlersFans.Types.OutdoorSection.SingleDamper,
    final typDamOut=damOut.typ,
    final typDamOutMin=Buildings.Templates.Components.Types.Damper.None);

  Buildings.Templates.Components.Dampers.Modulated damOut(
    redeclare final package Medium = MediumAir,
    final m_flow_nominal=m_flow_nominal,
    final dpDamper_nominal=dpDamOut_nominal)
    "Outdoor air damper" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,0})));

  Buildings.Templates.Components.Sensors.VolumeFlowRate VOut_flow(
    redeclare final package Medium = MediumAir,
    final have_sen=true,
    final m_flow_nominal=m_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorVolumeFlowRate.AFMS)
    "Outdoor air volume flow rate sensor"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Buildings.Templates.Components.Sensors.Temperature TOut(
    redeclare final package Medium = MediumAir,
    final have_sen=true,
    final m_flow_nominal=m_flow_nominal)
    "Outdoor air temperature sensor"
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
  Buildings.Templates.Components.Sensors.SpecificEnthalpy hOut(
    redeclare final package Medium = MediumAir,
    final have_sen=
      typCtrEco==Buildings.Templates.AirHandlersFans.Types.ControlEconomizer.FixedEnthalpyWithFixedDryBulb or
      typCtrEco==Buildings.Templates.AirHandlersFans.Types.ControlEconomizer.DifferentialEnthalpyWithFixedDryBulb,
    final m_flow_nominal=m_flow_nominal)
    "Outdoor air enthalpy sensor"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
equation
  /* Control point connection - start */
  connect(damOut.bus, bus.damOut);
  connect(TOut.y, bus.TOut);
  connect(hOut.y, bus.hOut);
  connect(VOut_flow.y, bus.VOut_flow);
  /* Control point connection - end */
  connect(port_aIns, damOut.port_a)
    annotation (Line(points={{-40,0},{-10,0}}, color={0,127,255}));
  connect(TOut.port_b, VOut_flow.port_a)
    annotation (Line(points={{70,0},{80,0}}, color={0,127,255}));
  connect(VOut_flow.port_b, port_b)
    annotation (Line(points={{100,0},{180,0}},color={0,127,255}));
  connect(port_a, pas.port_a)
    annotation (Line(points={{-180,0},{-70,0}},  color={0,127,255}));

  connect(damOut.port_b, hOut.port_a)
    annotation (Line(points={{10,0},{20,0}}, color={0,127,255}));
  connect(hOut.port_b, TOut.port_a)
    annotation (Line(points={{40,0},{50,0}}, color={0,127,255}));
  annotation (Icon(graphics={
              Line(
          points={{0,140},{0,0}},
          color={28,108,200},
          thickness=1),
              Line(
          points={{-180,0},{180,0}},
          color={28,108,200},
          thickness=1)}));
end SingleDamper;
