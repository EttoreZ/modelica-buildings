within Buildings.Templates.Components.Pumps;
model None "No pump"
  extends Buildings.Templates.Components.Pumps.Interfaces.PartialPumps(
    final nPum=0,
    final typ=Buildings.Templates.Components.Types.Pump.None);
equation
  connect(ports_a, ports_b)
    annotation (Line(points={{-100,0},{100,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={Line(
          points={{-100,0},{100,0}},
          color={28,108,200},
          thickness=1)}),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This is a direct fluid pass-through model to represent
a configuration with no pump.
</p>
</html>"));
end None;
