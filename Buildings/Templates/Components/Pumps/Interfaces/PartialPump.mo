within Buildings.Templates.Components.Pumps.Interfaces;
partial model PartialPump "Interface class for pump"

  replaceable package Medium=Buildings.Media.Water "Medium in the component";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=sum(dat.m_flow_nominal)
    "Nominal mass flow rate" annotation (Dialog(group="Nominal condition"));

  // Structure parameters

  parameter Buildings.Templates.Components.Types.Pump typ
    "Equipment type"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  final parameter Boolean is_none = typ == Buildings.Templates.Components.Types.Pump.None
    "Set to true if pump is none"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Integer nPum(final min=0) = 1
    "Number of pumps"
    annotation(Evaluate=true,
      Dialog(group="Configuration"));

  // Record

  parameter Buildings.Templates.Components.Data.Pump dat[nPum](each final typ=
        typ) "Pump data";

  parameter Boolean allowFlowReversal = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  parameter Boolean have_singlePort_a = true
    "Set to true if single fluid connector a, = false if vectorized fluid connector a";
  parameter Boolean have_singlePort_b = true
    "Set to true if single fluid connector a, = false if vectorized fluid connector a";

  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    redeclare final package Medium = Medium,
     m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
     h_outflow(start = Medium.h_default, nominal = Medium.h_default),
     p(start=Medium.p_default)) if have_singlePort_a
    "Fluid connector a (positive design flow direction is from port(s)_a to port(s)_b)"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    redeclare final package Medium = Medium,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
     h_outflow(start = Medium.h_default, nominal = Medium.h_default),
     p(start=Medium.p_default)) if have_singlePort_b
    "Fluid connector b (positive design flow direction is from port(s)_a to port(s)_b)"
    annotation (Placement(transformation(extent={{110,-10},{90,10}})));

  Modelica.Fluid.Interfaces.FluidPorts_a ports_a[nPum](
    redeclare each final package Medium = Medium,
     each m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
     each h_outflow(start = Medium.h_default, nominal = Medium.h_default),
    each p(start=Medium.p_default)) if not have_singlePort_a
     "Vectorized fluid connector a (positive design flow direction is from port(s)_a to port(s)_b)"
     annotation (Placement(
        transformation(extent={{-108,-30},{-92,30}}), iconTransformation(extent=
           {{-108,-30},{-92,30}})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_b[nPum](
    redeclare each final package Medium = Medium,
     each m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
     each h_outflow(start = Medium.h_default, nominal = Medium.h_default),
    each p(start=Medium.p_default)) if not have_singlePort_b
     "Vectorized fluid connector b (positive design flow direction is from port(s)_a to port(s)_b)"
     annotation (Placement(
        transformation(extent={{92,-30},{108,30}}), iconTransformation(extent={{
            92,-30},{108,30}})));

  parameter Integer text_rotation = 0
    "Text rotation angle in icon layer"
    annotation(Dialog(tab="Graphics", enable=false));
  parameter Boolean text_flip = false
    "True to flip text horizontally in icon layer"
    annotation(Dialog(tab="Graphics", enable=false));

  Buildings.Templates.Components.Interfaces.Bus bus
    "Control bus"
    annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={0,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,100})));

  annotation (Icon(coordinateSystem(preserveAspectRatio=true), graphics={
    Bitmap(
      visible=(dat.typPum==Buildings.Templates.Components.Types.Pump.SingleVariable or
        dat.typPum==Buildings.Templates.Components.Types.Pump.SingleConstant),
        extent={{-100,-100},{100,100}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Pumps/Inline.svg"),
    Bitmap(
      visible=dat.typPum==Buildings.Templates.Components.Types.Pump.SingleVariable,
      extent=if text_flip then {{100,-380},{-100,-180}} else {{-100,-380},{100,-180}},
      rotation=text_rotation,
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/VFD.svg"),
    Line(
      visible=dat.typPum==Buildings.Templates.Components.Types.Pump.SingleVariable,
      points={{0,-180},{0,-100}},
      color={0,0,0},
      thickness=1)}),
   Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This partial class provides a standard interface for pump models.
</p>
</html>"));

end PartialPump;
