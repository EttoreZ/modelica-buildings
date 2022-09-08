within Buildings.Fluid.Storage.Plant.Validation;
model ClosedLocal
  "Validation model of a storage plant with an open tank"
  extends Modelica.Icons.Example;
  extends
    Buildings.Fluid.Storage.Plant.Validation.BaseClasses.PartialPlant(
    netCon(plaTyp=nom.plaTyp),
      nom(final plaTyp=
        Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedLocal),
    tanBra(tankIsOpen=false));

  Modelica.Blocks.Sources.TimeTable set_mPumSec_flow(table=[0,1; 900,1; 900,-1;
        1800,-1; 1800,0; 2700,0; 2700,1; 3600,1])
    "Secondary mass flow rate setpoint"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Buildings.Controls.Continuous.LimPID conPID_PumSec(
    k=1,
    Ti=15) "PI controller" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-10,70})));
  Modelica.Blocks.Math.Gain gai(k=1/nom.mTan_flow_nominal)    "Gain"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-10,30})));

  Modelica.Blocks.Sources.Constant mSet_flow(k=nom.mChi_flow_nominal)
    "Chiller branch flow rate setpoint"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Buildings.Fluid.Sources.Boundary_pT sou_p(
    redeclare final package Medium = Medium,
    final p=300000,
    final T=nom.T_CHWR_nominal,
    nPorts=1) "Pressurisation point" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,-50})));
equation
  connect(gai.y, conPID_PumSec.u_m)
    annotation (Line(points={{-10,41},{-10,58}},  color={0,0,127}));
  connect(set_mPumSec_flow.y, conPID_PumSec.u_s)
    annotation (Line(points={{-39,70},{-22,70}}, color={0,0,127}));
  connect(netCon.yPumSup, conPID_PumSec.y)
    annotation (Line(points={{18,11},{18,70},{1,70}}, color={0,0,127}));
  connect(mSet_flow.y, ideChiBra.mPumSet_flow)
    annotation (Line(points={{-79,-30},{-56,-30},{-56,-11}}, color={0,0,127}));
  connect(tanBra.mTan_flow, gai.u)
    annotation (Line(points={{-16,11},{-10,11},{-10,18}}, color={0,0,127}));
  connect(sou_p.ports[1], tanBra.port_aFroNet) annotation (Line(points={{-20,
          -50},{0,-50},{0,-6},{-10,-6}}, color={0,127,255}));
  annotation (__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Plant/Validation/ClosedLocal.mos"
        "Simulate and plot"),
  experiment(Tolerance=1e-06, StopTime=3600),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>
This is a validation model where the storage plant with a closed tank is configured
NOT to allow remotely charging the tank.
</p>
</html>", revisions="<html>
<ul>
<li>
February 18, 2022 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"));
end ClosedLocal;
