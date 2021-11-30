within Buildings.Templates.Components.Dampers.Interfaces;
partial model PartialDamper
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface;

  parameter Buildings.Templates.Components.Types.Damper typ
    "Equipment type"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  parameter Buildings.Templates.Components.Types.DamperBlades typBla=
    Buildings.Templates.Components.Types.DamperBlades.Parallel
    "Type of blades"
    annotation(Dialog(tab="Graphics", enable=false));

  parameter Integer text_rotation = 0
    "Text rotation angle in icon layer"
    annotation(Dialog(tab="Graphics", enable=false));
  parameter Boolean text_flip = false
    "True to flip text horizontally in icon layer"
    annotation(Dialog(tab="Graphics", enable=false));

  parameter Modelica.SIunits.PressureDifference dpDamper_nominal
    "Damper pressure drop"
    annotation (
      Dialog(group="Nominal condition"));

  outer parameter String id
    "System identifier";
  outer parameter ExternData.JSONFile dat
    "External parameter file";

  Buildings.Templates.Components.Interfaces.Bus bus
    if typ <> Buildings.Templates.Components.Types.Damper.None
     and typ <> Buildings.Templates.Components.Types.Damper.Barometric and typ
     <> Buildings.Templates.Components.Types.Damper.NoPath
    "Control bus"
    annotation (Placement(
      visible=false,
      transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={0,100}),
      iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,100})));

  annotation (
    Icon(
    graphics={
     Bitmap(
        visible=typ==Buildings.Templates.Components.Types.Damper.TwoPosition,
        extent=if text_flip then {{40,-240},{-40,-160}} else {{-40,-240},{40,-160}},
        rotation=text_rotation,
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
     Bitmap(
        visible=typ==Buildings.Templates.Components.Types.Damper.Modulated or
          typ==Buildings.Templates.Components.Types.Damper.PressureIndependent,
        extent=if text_flip then {{40,-240},{-40,-160}} else {{-40,-240},{40,-160}},
        rotation=text_rotation,
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/Modulated.svg"),
     Bitmap(
        extent={{-40,-160},{40,100}},
        visible=typ<>Buildings.Templates.Components.Types.Damper.None and
          typBla==Buildings.Templates.Components.Types.DamperBlades.Parallel,
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Dampers/BladesParallel.svg"),
     Bitmap(
        extent={{-40,-160},{40,100}},
        visible=typ<>Buildings.Templates.Components.Types.Damper.None and
          typBla==Buildings.Templates.Components.Types.DamperBlades.Opposed,
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Dampers/BladesOpposed.svg"),
     Bitmap(
        extent={{-60,-160},{60,100}},
        visible=typ<>Buildings.Templates.Components.Types.Damper.None and
          typBla==Buildings.Templates.Components.Types.DamperBlades.VAV,
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Dampers/BladesVAV.svg")},
      coordinateSystem(preserveAspectRatio=false,
      extent={{-100,-100},{100,100}})),
     Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));

end PartialDamper;
