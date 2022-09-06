within Buildings.Templates.ChilledWaterPlants.Components.CoolingTowerSection.Interfaces;
record Data "Data for cooling tower section"
  extends Modelica.Icons.Record;

  // Structure parameters

  parameter
    Buildings.Templates.ChilledWaterPlants.Components.Types.CoolingTowerSection
    typ "Type of cooling tower arrangement"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Integer nCooTow
    "Number of cooling towers (count one tower for each cell)"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  // Equipment characteristics

  parameter Buildings.Templates.Components.Data.CoolingTower cooTow[nCooTow](
      each m_flow_nominal=mTow_flow_nominal) "Cooling tower data"
    annotation (Dialog(group="Cooling towers"));
  parameter Buildings.Templates.Components.Data.Valve valCooTowInlIso[nCooTow](
    each final m_flow_nominal = mTow_flow_nominal)
    "Cooling tower inlet isolation valves"
    annotation (Dialog(group="Valves"));
  parameter Buildings.Templates.Components.Data.Valve valCooTowOutIso[nCooTow](
    each final m_flow_nominal = mTow_flow_nominal)
    "Cooling tower outlet isolation valves"
    annotation (Dialog(group="Valves"));

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal
    "Cooling tower section nominal flow rate"
    annotation(Dialog(group = "Nominal condition"));
  final parameter Modelica.Units.SI.MassFlowRate mTow_flow_nominal=
    m_flow_nominal/nCooTow "Single tower nominal mass flow rate";

end Data;
