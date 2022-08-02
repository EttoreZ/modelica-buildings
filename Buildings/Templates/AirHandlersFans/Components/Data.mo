within Buildings.Templates.AirHandlersFans.Components;
package Data "Records for design and operating parameters"
  extends Modelica.Icons.MaterialPropertiesPackage;

  record OutdoorReliefReturnSection "Record for outdoor/relief/return air section"
    extends Modelica.Icons.Record;

    parameter Buildings.Templates.AirHandlersFans.Types.ReliefReturnSection typSecRel
      "Relief/return air section type"
      annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
    parameter Buildings.Templates.Components.Types.Damper typDamOut
      "Outdoor air damper type"
      annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
    parameter Buildings.Templates.Components.Types.Damper typDamOutMin
      "Minimum outdoor air damper type"
      annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
    parameter Buildings.Templates.Components.Types.Damper typDamRel
      "Relief damper type"
      annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
    parameter Buildings.Templates.Components.Types.Damper typDamRet
      "Return damper type"
      annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
    parameter Buildings.Templates.Components.Types.Fan typFanRel
      "Type of relief fan"
      annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
    parameter Buildings.Templates.Components.Types.Fan typFanRet
      "Type of return fan"
      annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

    parameter Modelica.Units.SI.MassFlowRate mOutMin_flow_nominal(
      final min=0,
      start=0.2 * damOut.m_flow_nominal)
      "Minimum outdoor air mass flow rate at design conditions"
      annotation (Dialog(group="Dampers and economizers",
        enable=typSecRel<>Buildings.Templates.AirHandlersFans.Types.ReliefReturnSection.NoEconomizer));

    parameter Buildings.Templates.Components.Data.Damper damOut(
      final typ=typDamOut)
      "Outdoor air damper"
      annotation (Dialog(group="Dampers and economizers",
      enable=typDamOut <> Buildings.Templates.Components.Types.Damper.None));
    parameter Buildings.Templates.Components.Data.Damper damOutMin(
      final typ=typDamOutMin)
      "Minimum outdoor air damper"
      annotation (Dialog(group="Dampers and economizers",
      enable=typDamOutMin <> Buildings.Templates.Components.Types.Damper.None));
    parameter Buildings.Templates.Components.Data.Damper damRel(
     final typ=typDamRel)
     "Relief damper"
     annotation (Dialog(group="Dampers and economizers",
     enable=typDamRel <> Buildings.Templates.Components.Types.Damper.None));
    parameter Buildings.Templates.Components.Data.Damper damRet(
      final typ=typDamRet)
      "Return damper"
      annotation (Dialog(group="Dampers and economizers",
      enable=typDamRet <> Buildings.Templates.Components.Types.Damper.None));
    parameter Buildings.Templates.Components.Data.Fan fanRel(
      final typ=typFanRel)
      "Relief fan"
      annotation (Dialog(group="Fans",
      enable=typFanRel <>Buildings.Templates.Components.Types.Fan.None));
    parameter Buildings.Templates.Components.Data.Fan fanRet(
      final typ=typFanRet)
      "Return fan"
      annotation (Dialog(group="Fans",
      enable=typFanRet <>Buildings.Templates.Components.Types.Fan.None));
  end OutdoorReliefReturnSection;

  record PartialController "Record for controller interface class"
    extends Modelica.Icons.Record;

    parameter Buildings.Templates.AirHandlersFans.Types.Controller typ
      "Type of controller"
      annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
    parameter Buildings.Templates.Components.Types.Fan typFanSup
      "Type of supply fan"
      annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
    parameter Buildings.Templates.Components.Types.Fan typFanRel
      "Type of relief fan"
      annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
    parameter Buildings.Templates.Components.Types.Fan typFanRet
      "Type of return fan"
      annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  end PartialController;

  record VAVMultiZoneController "Record for multiple-zone VAV controller"
    extends Buildings.Templates.AirHandlersFans.Components.Data.PartialController;

    parameter Buildings.Templates.AirHandlersFans.Types.ReliefReturnSection typSecRel
      "Relief/return air section type"
      annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

    parameter Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorSection typSecOut
      "Type of outdoor air section"
      annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

    parameter Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes buiPreCon
      "Type of building pressure control system"
      annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

    parameter Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard stdEne
      "Energy standard, ASHRAE 90.1 or Title 24"
      annotation(Evaluate=true, Dialog(group="Configuration", enable=false));

    parameter Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard stdVen
      "Ventilation standard, ASHRAE 62.1 or Title 24"
      annotation(Evaluate=true, Dialog(group="Configuration", enable=false));

    parameter Boolean have_CO2Sen
      "Set to true if there are zones with CO2 sensor"
      annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

    parameter Modelica.Units.SI.VolumeFlowRate VOutUnc_flow_nominal(
      start=0)
      "Uncorrected design outdoor air flow rate, including diversity where applicable"
      annotation (Dialog(group="Airflow and pressure",
        enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone and
        stdVen==Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1_2016));
    parameter Modelica.Units.SI.VolumeFlowRate VOutTot_flow_nominal(
      start=0)
      "Design total outdoor air flow rate"
      annotation (Dialog(group="Airflow and pressure",
        enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone and
        stdVen==Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1_2016));
    parameter Modelica.Units.SI.VolumeFlowRate VOutAbsMin_flow_nominal(
      start=0)
      "Design outdoor air flow rate when all zones with CO2 sensors or occupancy sensors are unpopulated"
      annotation (Dialog(group="Airflow and pressure",
        enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone and
        stdVen==Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24_2016));
    parameter Modelica.Units.SI.VolumeFlowRate VOutMin_flow_nominal(
      start=0)
      "Design minimum outdoor air flow rate when all zones are occupied at their design population, including diversity"
      annotation (Dialog(group="Airflow and pressure",
        enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone and
        stdVen==Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24_2016));

    parameter Modelica.Units.SI.PressureDifference dpDamOutMinAbs(
      final min=2.4,
      displayUnit="Pa",
      start=5)
      "Differential pressure across the minimum outdoor air damper that provides the absolute minimum outdoor airflow"
      annotation (Dialog(group="Airflow and pressure",
        enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone and
          stdVen==Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24_2016
          and typSecOut == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorSection.DedicatedDampersPressure));
    parameter Modelica.Units.SI.PressureDifference dpDamOutMin_nominal(
      final min=5,
      displayUnit="Pa",
      start=15)
      "Differential pressure across the minimum outdoor air damper that provides the design minimum outdoor airflow"
      annotation (Dialog(group="Airflow and pressure",
        enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone and
          typSecOut==Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorSection.DedicatedDampersPressure));

    parameter Modelica.Units.SI.PressureDifference pAirSupSet_rel_max(
      final min=0,
      displayUnit="Pa",
      start=500)
      "Duct design maximum static pressure"
      annotation (Dialog(group="Airflow and pressure",
      enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone));

    parameter Modelica.Units.SI.PressureDifference pAirRetSet_rel_min(
      final min=2.4,
      displayUnit="Pa")=10
      "Return fan minimum discharge static pressure set point"
      annotation (Dialog(group="Airflow and pressure",
        enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone and
        buiPreCon==Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp));

    parameter Modelica.Units.SI.PressureDifference pAirRetSet_rel_max(
      final min=10,
      displayUnit="Pa")=40
      "Return fan maximum discharge static pressure set point"
      annotation (Dialog(group="Airflow and pressure",
        enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone and
        buiPreCon==Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp));

    parameter Real yFanSup_min(
      final unit="1",
      final min=0,
      final max=1)= 0.1
      "Lowest allowed fan speed if fan is on"
      annotation (Dialog(group="Airflow and pressure",
      enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone and
      typFanSup<>Buildings.Templates.Components.Types.Fan.None));

    parameter Real yFanRel_min(
      final unit="1",
      final min=0,
      final max=1)=0.1
      "Minimum relief fan speed"
      annotation (Dialog(group="Airflow and pressure",
        enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone and
        typFanRel<>Buildings.Templates.Components.Types.Fan.None));

    parameter Real yFanRet_min(
      final unit="1",
      final min=0,
      final max=1)=0.1
      "Minimum return fan speed"
      annotation (Dialog(group="Airflow and pressure",
        enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone and
        typFanRet<>Buildings.Templates.Components.Types.Fan.None));

    parameter Modelica.Units.SI.PressureDifference pBuiSet_rel(
      final min=0,
      displayUnit="Pa")=12
      "Building static pressure set point"
      annotation (Dialog(group="Airflow and pressure",
        enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone and
        (buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefDamper
         or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
         or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)));

    parameter Modelica.Units.SI.VolumeFlowRate dVFanRet_flow(
      final min=0,
      start=0.1)
      "Airflow differential between supply and return fans to maintain building pressure at set point"
      annotation (Dialog(group="Airflow and pressure",
        enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone and
        (buiPreCon==Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir or
        buiPreCon==Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanCalculatedAir)));

    parameter Real nPeaSys_nominal(
      final unit="1",
      final min=0,
      start=100)
      "Design system population (including diversity)"
      annotation (Dialog(group="Ventilation",
      enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone));

    parameter Modelica.Units.SI.Temperature TAirSupSet_min(
      final min=273.15,
      displayUnit="degC")=12+273.15
      "Lowest supply air temperature set point"
      annotation (Dialog(group="Supply air temperature",
      enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone));

    parameter Modelica.Units.SI.Temperature TAirSupSet_max(
      final min=273.15,
      displayUnit="degC")=18+273.15
      "Highest supply air temperature set point"
      annotation (Dialog(group="Supply air temperature",
      enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone));

    parameter Modelica.Units.SI.Temperature TOutRes_min(
      final min=273.15,
      displayUnit="degC")=16+273.15
      "Lowest value of the outdoor air temperature reset range"
      annotation (Dialog(group="Supply air temperature",
      enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone));

    parameter Modelica.Units.SI.Temperature TOutRes_max(
      final min=273.15,
      displayUnit="degC")=21+273.15
      "Highest value of the outdoor air temperature reset range"
      annotation (Dialog(group="Supply air temperature",
      enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone));

  end VAVMultiZoneController;
annotation (Documentation(info="<html>
<p>
This package provides records for design and operating parameters.
</p>
</html>"));
end Data;
