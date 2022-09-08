within Buildings.Fluid.Storage.Plant.Validation;
model Open "Validation model of a storage plant with an open tank allowing remote charging"
  extends Modelica.Icons.Example;
  extends Buildings.Fluid.Storage.Plant.Validation.BaseClasses.PartialPlant(
    netCon(
      plaTyp=nom.plaTyp,
        perPumSup(pressure(V_flow=nom.m_flow_nominal*{0,1.6,2},
                            dp=nom.dp_nominal*{2,1.6,0})),
        perPumRet(pressure(V_flow=nom.mTan_flow_nominal*{0,1.6,2},
                            dp=nom.dp_nominal/2*{2,1.6,0}))),
      nom(
        final plaTyp=Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open,
        final dp_nominal=300000),
    tanBra(tankIsOpen=true));
  extends
    Buildings.Fluid.Storage.Plant.Validation.BaseClasses.RemoteChargingSchedule(
      conRemCha(final plaTyp=nom.plaTyp));

equation
  connect(tanBra.port_aFroNet, netCon.port_bToChi)
    annotation (Line(points={{-10,-6},{10,-6}}, color={0,127,255}));
  connect(netCon.port_aFroChi, tanBra.port_bToNet)
    annotation (Line(points={{10,6},{-10,6}}, color={0,127,255}));
  connect(set_mChi_flow.y, ideChiBra.mPumSet_flow)
    annotation (Line(points={{-79,-30},{-56,-30},{-56,-11}}, color={0,0,127}));
  connect(conRemCha.mTan_flow, tanBra.mTan_flow)
    annotation (Line(points={{9,54},{-16,54},{-16,11}}, color={0,0,127}));
  connect(conRemCha.yPumSup,netCon.yPumSup)
    annotation (Line(points={{18,39},{18,11}}, color={0,0,127}));
  connect(netCon.yValSup,conRemCha.yValSup)
    annotation (Line(points={{22,11},{22,39}}, color={0,0,127}));
  connect(conRemCha.yPumRet,netCon.yPumRet)
    annotation (Line(points={{26,39},{26,11}}, color={0,0,127}));
  connect(netCon.yValRet, conRemCha.yValRet) annotation (Line(points={{30,11},{
          30,10},{30,10},{30,39}}, color={0,0,127}));
  annotation (
  experiment(Tolerance=1e-06, StopTime=3600),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Plant/Validation/Open.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This is a validation model where the storage plant has an open tank.
This configuration automatically allows charging the tank remotely.
The operation modes are implemented in the time tables by
<a href=\"Modelica://Buildings.Fluid.Storage.Plant.Validation.BaseClasses.RemoteChargingSchedule\">
Buildings.Fluid.Storage.Plant.Validation.BaseClasses.RemoteChargingSchedule</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 11, 2022 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"));
end Open;
