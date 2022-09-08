within Buildings.Templates.ChilledWaterPlants;
package Types
  extends Modelica.Icons.TypesPackage;
  type Chiller = enumeration(
      AirCooled
      "Air-cooled compression chiller",
      WaterCooled
      "Water-cooled compression chiller")
      "Enumeration to specify the type of chiller";
  type Compressor = enumeration(
      ConstantSpeed "Constant speed centrifugal",
      VariableSpeed "Variable speed centrifugal",
      PositiveDisplacement "Positive displacement (screw or scroll)")
      "Enumeration to specify the type of compressor";
  type Controller = enumeration(
      Guideline36 "Guideline 36 control sequence",
      OpenLoop "Open loop")
      "Enumeration to specify the plant controller";
  type Distribution = enumeration(
      Constant1Only "Constant primary-only",
      Variable1Only "Variable primary-only",
      Constant1Variable2 "Constant primary - Variable secondary centralized",
      Variable1And2 "Variable primary - Variable secondary centralized",
      Variable1And2Distributed "Variable primary - Variable secondary distributed")
      "Enumeration to specify the type of CHW distribution system";
  type Economizer = enumeration(
      None "No waterside economizer",
      HeatExchangerWithPump "Heat exchanger with pump for CHW flow control",
      HeatExchangerWithValve "Heat exchanger with bypass valve for CHW flow control")
      "Enumeration to configure the WSE";
  type LiftControl = enumeration(
      None "No head pressure control (e.g. magnetic bearing chiller)",
      BuiltIn "Head pressure control built into chiller’s controller (AO available)",
      External "Head pressure control by BAS")
      "Enumeration to specify the type of head pressure control";
  type PumpArrangement = enumeration(
      Dedicated "Dedicated pumps",
      Headered "Headered pumps")
      "Enumeration to specify the pump arrangement";
end Types;
