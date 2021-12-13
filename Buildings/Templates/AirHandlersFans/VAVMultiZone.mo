within Buildings.Templates.AirHandlersFans;
model VAVMultiZone "Multiple-Zone VAV"
  extends Buildings.Templates.AirHandlersFans.Interfaces.AirHandler(
    nZon(min=2),
    final typ=Buildings.Templates.AirHandlersFans.Types.Configuration.SingleDuct,
    final have_porRel=secOutRel.typ <> Types.OutdoorReliefReturnSection.EconomizerNoRelief);

  inner replaceable package MediumCoo=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Cooling medium (such as CHW)"
    annotation(Dialog(enable=have_souCoiCoo));
  inner replaceable package MediumHea=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Heating medium (such as HHW)"
    annotation(Dialog(enable=have_souCoiHeaPre or have_souCoiHeaReh));

  parameter Modelica.SIunits.PressureDifference dpFanSup_nominal=
    if typFanSup<>Buildings.Templates.Components.Types.Fan.None then
      dat.getReal(varName=id + ".Mechanical.Supply fan.Total pressure rise.value")
    else 0
    "Supply fan total pressure rise"
    annotation (
      Dialog(group="Nominal condition",
        enable=typFanSup <> Buildings.Templates.Components.Types.Fan.None));
  parameter Modelica.SIunits.PressureDifference dpFanRet_nominal=
    if typFanRel <> Buildings.Templates.Components.Types.Fan.None or
      typFanRet <> Buildings.Templates.Components.Types.Fan.None then
      dat.getReal(varName=id + ".Mechanical.Relief/return fan.Total pressure rise.value")
    else 0
    "Relief/return fan total pressure rise"
    annotation (
      Dialog(group="Nominal condition",
        enable=typFanRel <> Buildings.Templates.Components.Types.Fan.None or
          typFanRet <> Buildings.Templates.Components.Types.Fan.None));

  final parameter Boolean have_souCoiCoo = coiCoo.have_sou
    "Set to true if cooling coil requires fluid ports on the source side"
    annotation (Evaluate=true, Dialog(group="Cooling coil"));
  final parameter Boolean have_souCoiHeaPre=coiHeaPre.have_sou
    "Set to true if heating coil requires fluid ports on the source side"
    annotation (Evaluate=true, Dialog(group="Heating coil"));
  final parameter Boolean have_souCoiHeaReh=coiHeaReh.have_sou
    "Set to true if reheat coil requires fluid ports on the source side"
    annotation (Evaluate=true, Dialog(group="Heating coil"));
  final parameter Boolean have_senPreBui=
    secOutRel.typSecRel==Buildings.Templates.AirHandlersFans.Types.ReliefReturnSection.ReliefDamper or
    secOutRel.typSecRel==Buildings.Templates.AirHandlersFans.Types.ReliefReturnSection.ReliefFan or
    secOutRel.typSecRel==Buildings.Templates.AirHandlersFans.Types.ReliefReturnSection.ReturnFan and
      secOutRel.typCtrFanRet==Buildings.Templates.AirHandlersFans.Types.ControlFanReturn.Pressure
    "Set to true if building static pressure sensor is used"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  final inner parameter Buildings.Templates.Components.Types.Fan typFanSup=if
      fanSupDra.typ <> Buildings.Templates.Components.Types.Fan.None then
      fanSupDra.typ elseif fanSupBlo.typ <> Buildings.Templates.Components.Types.Fan.None
      then fanSupBlo.typ else Buildings.Templates.Components.Types.Fan.None
    "Type of supply fan" annotation (Evaluate=true);
  final inner parameter Buildings.Templates.Components.Types.Fan typFanRet=
    secOutRel.typFanRet
    "Type of return fan"
    annotation (Evaluate=true);
  final inner parameter Buildings.Templates.Components.Types.Fan typFanRel=
    secOutRel.typFanRel
    "Type of relief fan"
    annotation (Evaluate=true);

  Modelica.Fluid.Interfaces.FluidPort_b port_coiCooRet(
    redeclare final package Medium = MediumCoo) if have_souCoiCoo
    "Cooling coil return port"
    annotation (Placement(
      transformation(extent={{50,-290},{70,-270}}),
      iconTransformation(extent={{-40,-210},{-20,-190}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_coiCooSup(
    redeclare final package Medium = MediumCoo) if have_souCoiCoo
    "Cooling coil supply port"
    annotation (Placement(
        transformation(extent={{90,-290},{110,-270}}),iconTransformation(
          extent={{20,-208},{40,-188}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_coiHeaPreRet(redeclare final
      package Medium = MediumHea) if have_souCoiHeaPre
    "Heating coil (preheat position) return port" annotation (Placement(
        transformation(extent={{-30,-290},{-10,-270}}), iconTransformation(
          extent={{-160,-210},{-140,-190}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_coiHeaPreSup(redeclare final
      package Medium = MediumHea) if have_souCoiHeaPre
    "Heating coil (preheat position) supply port" annotation (Placement(
        transformation(extent={{10,-290},{30,-270}}), iconTransformation(extent={{-100,
            -210},{-80,-190}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_coiHeaRehRet(redeclare final
      package Medium = MediumHea) if have_souCoiHeaReh
    "Heating coil (reheat position) return port" annotation (Placement(
        transformation(extent={{130,-290},{150,-270}}), iconTransformation(
          extent={{80,-210},{100,-190}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_coiHeaRehSup(redeclare final
      package Medium = MediumHea) if have_souCoiHeaReh
    "Heating coil (reheat position) supply port" annotation (Placement(
        transformation(extent={{170,-290},{190,-270}}), iconTransformation(
          extent={{140,-210},{160,-190}})));
  BoundaryConditions.WeatherData.Bus busWea
    "Weather bus"
    annotation (Placement(transformation(extent={{-20,260},{20,300}}),
      iconTransformation(extent={{-20,182},{20,218}})));

  /*
  Currently only the configuration with economizer is supported:
  hence, no choices annotation, but still replaceable to access parameter
  dialog box of the component.
  */
  inner replaceable Components.OutdoorReliefReturnSection.Economizer secOutRel
    constrainedby
    Components.OutdoorReliefReturnSection.Interfaces.PartialOutdoorReliefReturnSection(
      redeclare final package MediumAir = MediumAir,
      final mAirSup_flow_nominal=mAirSup_flow_nominal,
      final mAirRet_flow_nominal=mAirRet_flow_nominal,
      final dpFan_nominal=dpFanRet_nominal,
      final typCtrFanRet=ctr.typCtrFanRet,
      final typCtrEco=ctr.typCtrEco)
    "Outdoor/relief/return air section"
    annotation (
      Dialog(group="Outdoor/relief/return air section"),
      Placement(transformation(extent={{-280,-220},{-120,-60}})));

  Buildings.Templates.Components.Sensors.Temperature TAirMix(
    redeclare final package Medium = MediumAir,
    final have_sen=ctr.use_TMix,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.Averaging,
    final m_flow_nominal=mAirSup_flow_nominal) "Mixed air temperature sensor"
    annotation (Dialog(group="Supply air section", enable=false), Placement(
        transformation(extent={{-110,-210},{-90,-190}})));

  inner replaceable Buildings.Templates.Components.Fans.None fanSupBlo
    constrainedby Buildings.Templates.Components.Fans.Interfaces.PartialFan(
      redeclare final package Medium =  MediumAir,
      final m_flow_nominal=mAirSup_flow_nominal,
      final dp_nominal=dpFanSup_nominal,
      final have_senFlo=ctr.typCtrFanSup==
        Buildings.Templates.AirHandlersFans.Types.ControlFanSupply.Airflow)
    "Supply fan - Blow through"
    annotation (
      choices(
        choice(redeclare replaceable Buildings.Templates.Components.Fans.None fanSupBlo
          "No fan"),
        choice(redeclare replaceable Buildings.Templates.Components.Fans.SingleVariable fanSupBlo
          "Single fan - Variable speed"),
        choice(redeclare replaceable Buildings.Templates.Components.Fans.ArrayVariable fanSupBlo
          "Fan array - Variable speed")),
      Dialog(group="Supply air section",
        enable=fanSupDra.typ==Buildings.Templates.Components.Types.Fan.None),
      Placement(transformation(extent={{-50,-210},{-30,-190}})));

  .Buildings.Templates.Components.Sensors.Temperature TAirCoiHeaLvg(
    redeclare final package Medium = MediumAir,
    final have_sen=coiHeaPre.typ <> Buildings.Templates.Components.Types.Coil.None
         and coiCoo.typ <> Buildings.Templates.Components.Types.Coil.None,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.Averaging,
    final m_flow_nominal=mAirSup_flow_nominal)
    "Heating coil leaving air temperature sensor" annotation (Dialog(group="Supply air section",
        enable=false), Placement(transformation(extent={{40,-210},{60,-190}})));

  Buildings.Templates.Components.Sensors.Temperature TAirCoiCooLvg(
    redeclare final package Medium = MediumAir,
    final have_sen=coiCoo.typ <> Buildings.Templates.Components.Types.Coil.None
         and coiHeaReh.typ <> Buildings.Templates.Components.Types.Coil.None,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.Averaging,
    final m_flow_nominal=mAirSup_flow_nominal)
    "Cooling coil leaving air temperature sensor" annotation (Dialog(group="Supply air section",
        enable=false), Placement(transformation(extent={{100,-210},{120,-190}})));

  inner replaceable Buildings.Templates.Components.Fans.SingleVariable fanSupDra
    constrainedby Buildings.Templates.Components.Fans.Interfaces.PartialFan(
      redeclare final package Medium = MediumAir,
      final m_flow_nominal=mAirSup_flow_nominal,
      final dp_nominal=dpFanSup_nominal,
      final have_senFlo=ctr.typCtrFanSup==
        Buildings.Templates.AirHandlersFans.Types.ControlFanSupply.Airflow)
    "Supply fan - Draw through"
    annotation (
      choices(
        choice(redeclare replaceable Buildings.Templates.Components.Fans.None fanSupDra
          "No fan"),
        choice(redeclare replaceable Buildings.Templates.Components.Fans.SingleVariable fanSupDra
          "Single fan - Variable speed"),
        choice(redeclare replaceable Buildings.Templates.Components.Fans.ArrayVariable fanSupDra
          "Fan array - Variable speed")),
    Dialog(group="Supply air section",
      enable=fanSupBlo.typ==Buildings.Templates.Components.Types.Fan.None),
    Placement(transformation(extent={{172,-210},{192,-190}})));

  // FIXME: bind have_sen to control option.

  inner replaceable Components.Controls.OpenLoop ctr constrainedby
    Buildings.Templates.AirHandlersFans.Components.Controls.Interfaces.PartialSingleDuct
    "AHU controller"
    annotation (
      choices(
        choice(redeclare replaceable Buildings.Templates.AirHandlersFans.Components.Controls.Guideline36 con
          "Guideline 36 control sequence"),
        choice(redeclare replaceable Buildings.Templates.AirHandlersFans.Components.Controls.OpenLoop con
          "Open loop control")),
    Dialog(group="Controls"),
    Placement(transformation(extent={{-220,-10},{-200,10}})));

  /*
  FIXME: Dummy default values fo testing purposes only.
  Compute based on design pressure drop of each piece of equipment
  in case of a lumped pressure drop.
  */
  Fluid.FixedResistances.PressureDrop resRet(
    redeclare final package Medium = MediumAir,
    final m_flow_nominal=mAirRet_flow_nominal,
    dp_nominal=100)
    annotation (Placement(transformation(extent={{190,-90},{170,-70}})));
  Fluid.FixedResistances.PressureDrop resSup(
    redeclare final package Medium = MediumAir,
    final m_flow_nominal=mAirSup_flow_nominal,
    dp_nominal=100)
    annotation (Placement(transformation(extent={{-20,-210},{0,-190}})));

  Buildings.Templates.Components.Sensors.Temperature TAirSup(
    redeclare final package Medium = MediumAir,
    final have_sen=true,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.Standard,
    final m_flow_nominal=mAirSup_flow_nominal) "Supply air temperature sensor"
    annotation (Dialog(group="Supply air section", enable=false), Placement(
        transformation(extent={{210,-210},{230,-190}})));

  Buildings.Templates.Components.Sensors.DifferentialPressure pAirSup_rel(
      redeclare final package Medium = MediumAir, have_sen=true)
    "Duct static pressure sensor" annotation (Dialog(group="Supply air section",
        enable=false), Placement(transformation(extent={{250,-230},{270,-210}})));

  Buildings.Templates.Components.Sensors.DifferentialPressure pAirBui_rel(
    redeclare final package Medium = MediumAir,
    final have_sen=have_senPreBui,
    final text_flip=true) "Building static pressure"
    annotation (Placement(transformation(extent={{10,28},{-10,48}})));

  Buildings.Fluid.Sources.Outside out(
    redeclare final package Medium=MediumAir,
    final nPorts=2)
    "Outdoor conditions"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-40,80})));
  Buildings.Fluid.Sources.Boundary_pT bui(
    redeclare final package Medium = MediumAir,
    final use_p_in=true,
    final nPorts=2) "Building absolute pressure in representative space"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={40,82})));

  Buildings.Templates.Components.Sensors.Temperature TAirRet(
    redeclare final package Medium = MediumAir,
    final have_sen=ctr.typCtrEco == Buildings.Templates.AirHandlersFans.Types.ControlEconomizer.DifferentialDryBulb
         or ctr.typCtrEco == Buildings.Templates.AirHandlersFans.Types.ControlEconomizer.FixedDryBulbWithDifferentialDryBulb,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.Standard,
    final m_flow_nominal=mAirRet_flow_nominal) "Return air temperature sensor"
    annotation (Dialog(group="Exhaust/relief/return section", enable=false),
      Placement(transformation(extent={{220,-90},{200,-70}})));

  Buildings.Templates.Components.Sensors.SpecificEnthalpy hAirRet(
    redeclare final package Medium = MediumAir,
    final have_sen=ctr.typCtrEco == Buildings.Templates.AirHandlersFans.Types.ControlEconomizer.DifferentialEnthalpyWithFixedDryBulb,
    final m_flow_nominal=mAirRet_flow_nominal) "Return air enthalpy sensor"
    annotation (Dialog(group="Exhaust/relief/return section", enable=false),
      Placement(transformation(extent={{250,-90},{230,-70}})));

  inner replaceable Buildings.Templates.Components.Coils.None coiHeaPre(
    final mAir_flow_nominal=mAirSup_flow_nominal)
    constrainedby Buildings.Templates.Components.Coils.Interfaces.PartialCoil
    "Heating coil (preheat position)"
    annotation (
    choices(
      choice(
        redeclare replaceable Buildings.Templates.Components.Coils.None coiHeaPre(
          final mAir_flow_nominal=mAirSup_flow_nominal)
        "No coil"),
      choice(
        redeclare replaceable Buildings.Templates.Components.Coils.WaterBasedHeating coiHeaPre
        "Hot water coil"),
      choice(
        redeclare replaceable Buildings.Templates.Components.Coils.ElectricHeating coiHeaPre
        "Electric heating coil")),
    Dialog(group="Heating coil",
      enable=coiHeaReh.typ==Buildings.Templates.Components.Types.Coil.None),
    Placement(transformation(extent={{10,-210},{30,-190}})));
  inner replaceable Buildings.Templates.Components.Coils.None coiCoo(
    final mAir_flow_nominal=mAirSup_flow_nominal)
    constrainedby Buildings.Templates.Components.Coils.Interfaces.PartialCoil
    "Cooling coil"
    annotation (
    choices(
      choice(redeclare replaceable Buildings.Templates.Components.Coils.None coiCoo(
        final mAir_flow_nominal=mAirSup_flow_nominal)
        "No coil"),
      choice(redeclare replaceable Buildings.Templates.Components.Coils.WaterBasedCooling coiCoo
        "Chilled water coil")),
    Dialog(group="Cooling coil"),
    Placement(transformation(extent={{70,-210},{90,-190}})));
  inner replaceable Buildings.Templates.Components.Coils.None coiHeaReh(
    final mAir_flow_nominal=mAirSup_flow_nominal)
    constrainedby Buildings.Templates.Components.Coils.Interfaces.PartialCoil
    "Heating coil (reheat position)"
    annotation (
    choices(
      choice(redeclare replaceable Buildings.Templates.Components.Coils.None coiHeaReh(
        final mAir_flow_nominal=mAirSup_flow_nominal)
        "No coil"),
      choice(redeclare replaceable Buildings.Templates.Components.Coils.WaterBasedHeating coiHeaReh
        "Hot water coil"),
      choice(
        redeclare replaceable Buildings.Templates.Components.Coils.ElectricHeating coiHeaReh
        "Electric heating coil")),
    Dialog(group="Heating coil",
      enable=coiHeaPre.typ==Buildings.Templates.Components.Types.Coil.None),
    Placement(transformation(extent={{130,-210},{150,-190}})));
equation
  /* Control point connection - start */
  connect(TAirMix.y, bus.TAirMix);
  connect(TAirCoiHeaLvg.y, bus.TAirCoiHeaLvg);
  connect(TAirSup.y, bus.TAirSup);
  connect(pAirSup_rel.y, bus.pAirSup_rel);
  connect(hAirRet.y, bus.hAirRet);
  connect(TAirRet.y, bus.TAirRet);
  connect(fanSupDra.bus, bus.fanSup);
  connect(fanSupBlo.bus, bus.fanSup);
  connect(coiHeaPre.bus, bus.coiHea);
  connect(coiCoo.bus, bus.coiCoo);
  connect(coiHeaReh.bus, bus.coiHea);
  connect(secOutRel.bus, bus);
  connect(bui.p_in, bus.pAirBui);
  connect(pAirBui_rel.y, bus.pAirBui_rel);
  /* Control point connection - stop */

  connect(coiHeaPre.port_bSou, port_coiHeaPreRet) annotation (Line(points={{15,
          -210},{15,-260},{-20,-260},{-20,-280}}, color={0,127,255}));
  connect(port_coiHeaPreSup, coiHeaPre.port_aSou) annotation (Line(points={{20,
          -280},{20,-260},{25,-260},{25,-210}}, color={0,127,255}));
  connect(port_coiCooSup, coiCoo.port_aSou) annotation (Line(points={{100,-280},
          {100,-260},{85,-260},{85,-210}}, color={0,127,255}));
  connect(coiCoo.port_bSou, port_coiCooRet) annotation (Line(points={{75,-210},{
          75,-260},{60,-260},{60,-280}}, color={0,127,255}));
  connect(busWea,coiCoo.busWea)  annotation (Line(
      points={{0,280},{0,100},{74,100},{74,-190}},
      color={255,204,51},
      thickness=0.5));
  connect(TAirMix.port_b, fanSupBlo.port_a)
    annotation (Line(points={{-90,-200},{-50,-200}}, color={0,127,255}));
  connect(port_coiHeaRehSup, coiHeaReh.port_aSou) annotation (Line(points={{180,-280},
          {180,-260},{145,-260},{145,-210}}, color={0,127,255}));
  connect(coiHeaReh.port_bSou, port_coiHeaRehRet) annotation (Line(points={{135,-210},
          {135,-260},{140,-260},{140,-280}}, color={0,127,255}));
  connect(coiHeaReh.port_b, fanSupDra.port_a)
    annotation (Line(points={{150,-200},{172,-200}}, color={0,127,255}));
  connect(busWea, out.weaBus) annotation (Line(
      points={{0,280},{0,100},{-40,100},{-40,90},{-39.8,90}},
      color={255,204,51},
      thickness=0.5));
  connect(pAirBui_rel.port_b, out.ports[1]) annotation (Line(points={{-10,38},{-10,
          60},{-41,60},{-41,70}}, color={0,127,255}));
  connect(bui.ports[1], pAirBui_rel.port_a) annotation (Line(points={{39,72},{39,
          60},{10,60},{10,38}}, color={0,127,255}));

  connect(ctr.busTer, busTer) annotation (Line(
      points={{-200,0},{300,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(ctr.bus, bus) annotation (Line(
      points={{-220,0},{-300,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(resRet.port_a, TAirRet.port_b)
    annotation (Line(points={{190,-80},{200,-80}}, color={0,127,255}));
  connect(port_Ret, hAirRet.port_a)
    annotation (Line(points={{300,-80},{250,-80}}, color={0,127,255}));
  connect(hAirRet.port_b, TAirRet.port_a)
    annotation (Line(points={{230,-80},{220,-80}}, color={0,127,255}));
  connect(coiHeaPre.port_b, TAirCoiHeaLvg.port_a)
    annotation (Line(points={{30,-200},{40,-200}}, color={0,127,255}));
  connect(TAirCoiHeaLvg.port_b, coiCoo.port_a)
    annotation (Line(points={{60,-200},{70,-200}}, color={0,127,255}));
  connect(coiCoo.port_b, TAirCoiCooLvg.port_a)
    annotation (Line(points={{90,-200},{100,-200}}, color={0,127,255}));
  connect(TAirCoiCooLvg.port_b, coiHeaReh.port_a)
    annotation (Line(points={{120,-200},{130,-200}}, color={0,127,255}));
  connect(secOutRel.port_Sup, TAirMix.port_a)
    annotation (Line(points={{-120,-200},{-110,-200}}, color={0,127,255}));
  connect(secOutRel.port_Ret, resRet.port_b)
    annotation (Line(points={{-120,-80.2},{10,-80.2},{10,-80},{170,-80}},
                                                    color={0,127,255}));
  connect(secOutRel.port_bPre, out.ports[2]) annotation (Line(points={{-162,-60},
          {-162,60},{-39,60},{-39,70}},              color={0,127,255}));
  connect(port_Rel, secOutRel.port_Rel)
    annotation (Line(points={{-300,-80},{-280,-80}}, color={0,127,255}));
  connect(port_Out, secOutRel.port_Out)
    annotation (Line(points={{-300,-200},{-280,-200}}, color={0,127,255}));
  connect(bui.ports[2], pAirSup_rel.port_b) annotation (Line(points={{41,72},{41,
          60},{280,60},{280,-220},{270,-220}}, color={0,127,255}));
  connect(TAirSup.port_b, port_Sup)
    annotation (Line(points={{230,-200},{300,-200}}, color={0,127,255}));
  connect(TAirSup.port_b, pAirSup_rel.port_a) annotation (Line(points={{230,-200},
          {240,-200},{240,-220},{250,-220}}, color={0,127,255}));
  connect(fanSupBlo.port_b, resSup.port_a)
    annotation (Line(points={{-30,-200},{-20,-200}}, color={0,127,255}));
  connect(resSup.port_b, coiHeaPre.port_a)
    annotation (Line(points={{0,-200},{10,-200}}, color={0,127,255}));
  connect(fanSupDra.port_b, TAirSup.port_a)
    annotation (Line(points={{192,-200},{210,-200}}, color={0,127,255}));
  annotation (
    defaultComponentName="ahu",
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
    coordinateSystem(preserveAspectRatio=false, extent={{-300,-280},{300,280}}),
      graphics={
        Line(
          points={{250,-206},{250,-220},{256,-220}},
          color={0,0,0},
          thickness=1),
        Line(
          points={{264,-220},{270,-220}},
          color={0,0,0},
          thickness=1),
        Bitmap(extent={{-84,-210},{-76,-190}}, fileName="modelica://Buildings/Resources/Images/Templates/Components/Filters/Filter.svg"),
        Bitmap(extent={{-84,-224},{-76,-216}}, fileName="modelica://Buildings/Resources/Images/Templates/Components/Sensors/DifferentialPressure.svg"),
        Line(
          points={{-90,-206},{-90,-220},{-84,-220}},
          color={0,0,0},
          thickness=1),
        Line(
          points={{-70,-206},{-70,-220},{-76,-220}},
          color={0,0,0},
          thickness=1),
        Line(points={{300,-70},{-120,-70}}, color={0,0,0}),
        Line(points={{300,-90},{-120,-90}}, color={0,0,0}),
        Line(points={{300,-210},{-120,-210}}, color={0,0,0}),
        Line(points={{300,-190},{-120,-190}}, color={0,0,0}),
        Line(
          visible=have_senPreBui,
          points={{-16,40},{-10,40}},
          color={0,0,0},
          thickness=1),
        Line(
          visible=have_senPreBui,
          points={{16,40},{10,40}},
          color={0,0,0},
          thickness=1),
        Text(
          visible=have_senPreBui,
          extent={{18,46},{60,34}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          fontName="sans-serif",
          textString="REPRESENTATIVE SPACE
INSIDE BUILDING",
          fontSize=4),
        Text(
          visible=have_senPreBui,
          extent={{-60,46},{-18,34}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Right,
          fontName="sans-serif",
          textString="REFERENCE OUTSIDE
BUILDING",fontSize=4)}),
    Documentation(info="<html>
Requires building indoor _absolute_ pressure as input

Economizer and fan options options

Common economizer/minimum OA damper

- AFMS required

Dedicated OA damper

- AFMS => modulating OAMin damper
- dp sensor => two-position OAMin damper


Relief fan => Two position relief damper

Return fan

- Modulating relief (exhaust) damper
- For AHUs with return fans, the outdoor air damper remains
fully open whenever the AHU is on. But AO point specified nevertheless.
- Control either return fan discharge pressure (fan) and building pressure (damper),
or airflow (fan) and exhaust damper modulating in tandem with return damper

Modulating relief damper

- No relief fan
- Control building static pressure



</html>"));
end VAVMultiZone;