within Buildings.Templates.ZoneEquipment.Data;
record VAVBox
  extends Buildings.Templates.ZoneEquipment.Data.PartialAirTerminal(
    redeclare Buildings.Templates.ZoneEquipment.Components.Data.VAVBoxController
      ctl(final have_CO2Sen=have_CO2Sen),
    final mAir_flow_nominal=ctl.VAir_flow_nominal * 1.2);

  parameter Buildings.Templates.Components.Types.Damper typDamVAV
    "Type of VAV damper"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.Components.Types.Coil typCoiHea
    "Type of heating coil"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.Components.Types.Valve typValCoiHea
    "Type of valve for heating coil"
    annotation (Dialog(group="Configuration", enable=false));
  parameter Boolean have_CO2Sen
    "Set to true if the zone has CO2 sensor"
    annotation (Dialog(group="Configuration", enable=false));

  parameter Buildings.Templates.Components.Data.Damper damVAV(
    final typ=typDamVAV,
    m_flow_nominal=mAir_flow_nominal)
    "VAV damper"
    annotation (Dialog(group="Equipment"));

  parameter Buildings.Templates.Components.Data.Coil coiHea(
    final typ=typCoiHea,
    final typVal=typValCoiHea,
    final have_sou=have_souCoiHea,
    mAir_flow_nominal=ctl.VAirHeaSet_flow_max*1.2)
    "Reheat coil"
    annotation (Dialog(group="Equipment"));

end VAVBox;