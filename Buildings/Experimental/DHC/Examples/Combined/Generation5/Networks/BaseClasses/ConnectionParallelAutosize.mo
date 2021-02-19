within Buildings.Experimental.DHC.Examples.Combined.Generation5.Networks.BaseClasses;
model ConnectionParallelAutosize
  "Model for connecting an agent to the DHC system"
  extends ConnectionParallelStandard(
    tau=5*60,
    redeclare replaceable model Model_pipDis = PipeAutosize (
      roughness=7e-6,
      fac=1.5,
      dh=dhDis,
      final length=lDis,
      final dp_length_nominal=dp_length_nominal),
    pipDisRet(dh=dhDisRet),
    redeclare replaceable model Model_pipCon = PipeAutosize (
      roughness=2.5e-5,
      fac=2,
      final length=2*lCon,
      final dh=dhCon,
      final dp_length_nominal=dp_length_nominal));
  parameter Real dp_length_nominal(final unit="Pa/m") = 250
    "Pressure drop per pipe length at nominal flow rate";
  parameter Modelica.SIunits.Length dhDisRet
    "Hydraulic diameter of the return distribution pipe";
end ConnectionParallelAutosize;
