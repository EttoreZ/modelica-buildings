within Buildings.Templates.ChilledWaterPlants.Validation;
model BaseWaterCooledG36
  "Base model for validating CHW plant template with water-cooled chillers"
  extends Buildings.Templates.ChilledWaterPlants.Validation.BaseWaterCooled(
    CHI(redeclare Buildings.Templates.ChilledWaterPlants.Components.Controls.G36 ctl));

end BaseWaterCooledG36;
