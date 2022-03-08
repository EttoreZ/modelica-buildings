within Buildings.Templates.Components.Dampers;
model PressureIndependent "Pressure independent damper"
  extends Buildings.Templates.Components.Dampers.Interfaces.PartialDamper(
    final typ=Buildings.Templates.Components.Types.Damper.PressureIndependent,
    final typBla=Buildings.Templates.Components.Types.DamperBlades.VAV);

  Buildings.Fluid.Actuators.Dampers.PressureIndependent dam(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final dpDamper_nominal=dp_nominal,
    final dpFixed_nominal=dat.dpFixed_nominal)
    "Pressure independent damper"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(dam.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(bus.y, dam.y) annotation (Line(
      points={{0,100},{0,56},{0,56},{0,12}},
      color={255,204,51},
      thickness=0.5));
  connect(dam.y_actual, bus.y_actual)
    annotation (Line(points={{5,7},{40,7},{40,100},{0,100}}, color={0,0,127}));
  connect(port_a, dam.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
end PressureIndependent;