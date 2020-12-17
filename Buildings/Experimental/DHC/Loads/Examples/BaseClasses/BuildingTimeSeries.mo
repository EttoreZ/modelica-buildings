within Buildings.Experimental.DHC.Loads.Examples.BaseClasses;
model BuildingTimeSeries
  "Building model with heating and cooling loads provided as time series"
  extends Buildings.Experimental.DHC.Loads.BaseClasses.PartialBuilding(
    redeclare package Medium=Buildings.Media.Water,
    have_heaWat=true,
    have_chiWat=true,
    final have_fan=false,
    final have_pum=true,
    final have_eleHea=false,
    final have_eleCoo=false,
    final have_weaBus=false);
  parameter Boolean have_hotWat = false
    "Set to true if SHW load is included in the time series"
    annotation (Evaluate=true);
  replaceable package Medium2=Buildings.Media.Air
    "Load side medium";
  parameter String filNam
    "File name with thermal loads as time series";
  // TODO: compute facSca* based on peak loads.
  parameter Real facScaHea=1
    "Heating terminal unit scaling factor"
    annotation(Dialog(enable=have_heaWat));
  parameter Real facScaCoo=1
    "Cooling terminal unit scaling factor"
    annotation(Dialog(enable=have_chiWat));
  parameter Modelica.SIunits.Temperature T_aHeaWat_nominal=40+273.15
    "Heating water inlet temperature at nominal conditions"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_bHeaWat_nominal(
    min=273.15,
    displayUnit="degC")=T_aHeaWat_nominal-5
    "Heating water outlet temperature at nominal conditions"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_aChiWat_nominal=18+273.15
    "Chilled water inlet temperature at nominal conditions "
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_bChiWat_nominal(
    min=273.15,
    displayUnit="degC")=T_aChiWat_nominal+5
    "Chilled water outlet temperature at nominal conditions"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_aLoaHea_nominal=273.15 + 20
    "Load side inlet temperature at nominal conditions in heating mode"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_aLoaCoo_nominal=273.15 + 24
    "Load side inlet temperature at nominal conditions in cooling mode"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate mLoaHea_flow_nominal=1
    "Load side mass flow rate at nominal conditions in heating mode (single unit)"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate mLoaCoo_flow_nominal=mLoaHea_flow_nominal
    "Load side mass flow rate at nominal conditions in cooling mode (single unit)"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.HeatFlowRate QCoo_flow_nominal(
    max=-Modelica.Constants.eps)=Buildings.Experimental.DHC.Loads.BaseClasses.getPeakLoad(
    string="#Peak space cooling load",
    filNam=Modelica.Utilities.Files.loadResource(filNam))
    "Design cooling heat flow rate (<=0)"
    annotation (Dialog(group="Design parameter"));
  parameter Modelica.SIunits.HeatFlowRate QHea_flow_nominal(
    min=Modelica.Constants.eps)=Buildings.Experimental.DHC.Loads.BaseClasses.getPeakLoad(
    string="#Peak space heating load",
    filNam=Modelica.Utilities.Files.loadResource(filNam))
    "Design heating heat flow rate (>=0)"
    annotation (Dialog(group="Design parameter"));
  parameter Real k(
    min=0)=1
    "Gain of controller";
  parameter Modelica.SIunits.Time Ti(
    min=Modelica.Constants.small)=10
    "Time constant of integrator block";
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance for fan air volume"
    annotation (Evaluate=true,Dialog(tab="Dynamics",group="Equations"));
  parameter Modelica.SIunits.Time tau=1
    "Time constant of fan air volume, used if energy or mass balance is dynamic"
    annotation (Dialog(tab="Dynamics",group="Nominal condition",
      enable=energyDynamics <> Modelica.Fluid.Types.Dynamics.SteadyState));
  parameter Boolean use_inputFilter=true
    "= true, if fan speed is filtered with a 2nd order CriticalDamping filter"
    annotation (Dialog(tab="Dynamics",group="Filtered speed"));
  parameter Modelica.SIunits.Time riseTime=30
    "Rise time of the filter (time to reach 99.6 % of the speed)"
    annotation (Dialog(tab="Dynamics",group="Filtered speed",enable=use_inputFilter));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput QReqHotWat_flow(
    final unit="W") if have_hotWat
    "SHW load" annotation (Placement(
      transformation(extent={{300,-140},{340,-100}}), iconTransformation(
      extent={{-20,-20},{20,20}},
      rotation=-90,
      origin={260,-320})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput QReqHea_flow(
    final quantity="HeatFlowRate",
    final unit="W") if have_heaLoa
    "Heating load"
    annotation (Placement(transformation(extent={{300,20},{340,60}}),
      iconTransformation(extent={{-40,-40},{40,40}},rotation=-90,origin={200,-340})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput QReqCoo_flow(
    final quantity="HeatFlowRate",
    final unit="W") if have_cooLoa
    "Cooling load"
    annotation (Placement(transformation(extent={{300,-20},{340,20}}),
      iconTransformation(extent={{-40,-40},{40,40}},rotation=-90,origin={240,-340})));
  Modelica.Blocks.Sources.CombiTimeTable loa(
    tableOnFile=true,
    tableName="tab1",
    fileName=Modelica.Utilities.Files.loadResource(
      filNam),
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    y(each unit="W"),
    offset={0,0,0},
    columns=if have_hotWat then {2,3,4} else {2,3},
    smoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative1)
    "Reader for thermal loads (y[1] is cooling load, y[2] is heating load)"
    annotation (Placement(transformation(extent={{-280,-10},{-260,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minTSet(
    k=293.15,
    y(final unit="K",
      displayUnit="degC"))
    "Minimum temperature set point"
    annotation (Placement(transformation(extent={{-280,170},{-260,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxTSet(
    k=297.15,
    y(final unit="K",
      displayUnit="degC"))
    "Maximum temperature set point"
    annotation (Placement(transformation(extent={{-280,210},{-260,230}})));
  DHC.Loads.Validation.BaseClasses.FanCoil2PipeHeating terUniHea(
    redeclare final package Medium1=Medium,
    redeclare final package Medium2=Medium2,
    final facSca=facScaHea,
    final facMul=1,
    final QHea_flow_nominal=QHea_flow_nominal/facScaHea,
    final mHeaWat_flow_nominal=mHeaWat_flow_nominal/facScaHea,
    final mLoaHea_flow_nominal=mLoaHea_flow_nominal,
    final energyDynamics=energyDynamics,
    final T_aHeaWat_nominal=T_aHeaWat_nominal,
    final T_bHeaWat_nominal=T_bHeaWat_nominal,
    final T_aLoaHea_nominal=T_aLoaHea_nominal,
    final k=k,
    final Ti=Ti,
    final tau=tau,
    final use_inputFilter=use_inputFilter,
    final riseTime=riseTime) if have_heaWat
    "Heating terminal unit"
    annotation (Placement(transformation(extent={{70,-22},{90,-2}})));
  Buildings.Experimental.DHC.Loads.FlowDistribution disFloHea(
    redeclare package Medium=Medium,
    m_flow_nominal=mHeaWat_flow_nominal*facScaHea,
    have_pum=true,
    dp_nominal=100000,
    nPorts_a1=1,
    nPorts_b1=1) if have_heaWat
    "Heating water distribution system"
    annotation (Placement(transformation(extent={{120,-70},{140,-50}})));
  Buildings.Experimental.DHC.Loads.FlowDistribution disFloCoo(
    redeclare package Medium=Medium,
    final m_flow_nominal=mChiWat_flow_nominal*facScaCoo,
    typDis=Buildings.Experimental.DHC.Loads.Types.DistributionType.ChilledWater,
    have_pum=true,
    dp_nominal=100000,
    nPorts_b1=1,
    nPorts_a1=1) if have_chiWat
    "Chilled water distribution system"
    annotation (Placement(transformation(extent={{120,-270},{140,-250}})));
  DHC.Loads.Validation.BaseClasses.FanCoil2PipeCooling terUniCoo(
    redeclare final package Medium1=Medium,
    redeclare final package Medium2=Medium2,
    final facSca=facScaCoo,
    final facMul=1,
    final QCoo_flow_nominal=QCoo_flow_nominal/facScaCoo,
    final mChiWat_flow_nominal=mHeaWat_flow_nominal/facScaCoo,
    final mLoaCoo_flow_nominal=mLoaCoo_flow_nominal,
    final energyDynamics=energyDynamics,
    final QHea_flow_nominal=QHea_flow_nominal/facScaHea,
    final T_aHeaWat_nominal=T_aHeaWat_nominal,
    final T_aChiWat_nominal=T_aChiWat_nominal,
    final T_bHeaWat_nominal=T_bHeaWat_nominal,
    final T_bChiWat_nominal=T_bChiWat_nominal,
    final T_aLoaHea_nominal=T_aLoaHea_nominal,
    final T_aLoaCoo_nominal=T_aLoaCoo_nominal,
    final k=k,
    final Ti=Ti,
    final tau=tau,
    final use_inputFilter=use_inputFilter,
    final riseTime=riseTime) if have_chiWat
    "Cooling terminal unit"
    annotation (Placement(transformation(extent={{70,36},{90,56}})));
  Buildings.Controls.OBC.CDL.Continuous.Add addPPum
    "Sum pump power"
    annotation (Placement(transformation(extent={{240,70},{260,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant noCoo(
    k=0) if not have_chiWat
    "No cooling system"
    annotation (Placement(transformation(extent={{130,70},{150,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant noHea(
    k=0) if not have_heaWat
    "No heating system"
    annotation (Placement(transformation(extent={{130,110},{150,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Add addPFan
    "Sum fan power"
    annotation (Placement(transformation(extent={{240,110},{260,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain mulQReqHea_flow(
    final k=facMul) if have_heaLoa "Scaling"
    annotation (Placement(transformation(extent={{272,30},{292,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain mulQReqCoo_flow(
    final k=facMul) if have_cooLoa "Scaling"
    annotation (Placement(transformation(extent={{272,-10},{292,10}})));
protected
  parameter Modelica.SIunits.SpecificHeatCapacity cpHeaWat_nominal=
    Medium.specificHeatCapacityCp(
      Medium.setState_pTX(
        Medium.p_default,
        T_aHeaWat_nominal))
    "Heating water specific heat capacity at nominal conditions";
  parameter Modelica.SIunits.SpecificHeatCapacity cpChiWat_nominal=
    Medium.specificHeatCapacityCp(
      Medium.setState_pTX(
        Medium.p_default,
        T_aChiWat_nominal))
    "Chilled water specific heat capacity at nominal conditions";
  parameter Modelica.SIunits.MassFlowRate mChiWat_flow_nominal=abs(
    QCoo_flow_nominal/cpChiWat_nominal/(T_aChiWat_nominal-T_bChiWat_nominal))
    "Chilled water mass flow rate at nominal conditions (all units)";
  parameter Modelica.SIunits.MassFlowRate mHeaWat_flow_nominal=abs(
    QHea_flow_nominal/cpHeaWat_nominal/(T_aHeaWat_nominal-T_bHeaWat_nominal))
    "Heating water mass flow rate at nominal conditions (all units)";
equation
  connect(terUniHea.port_bHeaWat,disFloHea.ports_a1[1])
    annotation (Line(points={{90,-20.3333},{90,-20},{146,-20},{146,-54},{140,
          -54}},                                                                   color={0,127,255}));
  connect(disFloHea.ports_b1[1],terUniHea.port_aHeaWat)
    annotation (Line(points={{120,-54},{64,-54},{64,-20.3333},{70,-20.3333}},color={0,127,255}));
  connect(terUniHea.mReqHeaWat_flow,disFloHea.mReq_flow[1])
    annotation (Line(points={{90.8333,-15.3333},{100,-15.3333},{100,-64},{119,
          -64}},                                                                     color={0,0,127}));
  connect(loa.y[1],terUniCoo.QReqCoo_flow)
    annotation (Line(points={{-259,0},{40,0},{40,42.5},{69.1667,42.5}}, color={0,0,127}));
  connect(loa.y[2],terUniHea.QReqHea_flow)
    annotation (Line(points={{-259,0},{40,0},{40,-13.6667},{69.1667,-13.6667}}, color={0,0,127}));
  connect(disFloCoo.ports_b1[1],terUniCoo.port_aChiWat)
    annotation (Line(points={{120,-254},{60,-254},{60,39.3333},{70,39.3333}},color={0,127,255}));
  connect(terUniCoo.port_bChiWat,disFloCoo.ports_a1[1])
    annotation (Line(points={{90,39.3333},{160,39.3333},{160,-254},{140,-254}}, color={0,127,255}));
  connect(terUniCoo.mReqChiWat_flow,disFloCoo.mReq_flow[1])
    annotation (Line(points={{90.8333,41},{108,41},{108,-264},{119,-264}},color={0,0,127}));
  connect(minTSet.y,terUniHea.TSetHea)
    annotation (Line(points={{-258,180},{-20,180},{-20,-7},{69.1667,-7}}, color={0,0,127}));
  connect(maxTSet.y,terUniCoo.TSetCoo)
    annotation (Line(points={{-258,220},{0,220},{0,49.3333},{69.1667,49.3333}},color={0,0,127}));
  connect(disFloHea.PPum,addPPum.u1)
    annotation (Line(points={{141,-68},{170,-68},{170,86},{238,86}},color={0,0,127}));
  connect(disFloCoo.PPum,addPPum.u2)
    annotation (Line(points={{141,-268},{200,-268},{200,74},{238,74}},color={0,0,127}));
  connect(noHea.y,addPPum.u1)
    annotation (Line(points={{152,120},{170,120},{170,86},{238,86}}, color={0,0,127}));
  connect(noCoo.y,addPPum.u2)
    annotation (Line(points={{152,80},{200,80},{200,74},{238,74}}, color={0,0,127}));
  connect(noHea.y,addPFan.u1)
    annotation (Line(points={{152,120},{180,120},{180,126},{238,126}},
                                                                     color={0,0,127}));
  connect(noCoo.y,addPFan.u2)
    annotation (Line(points={{152,80},{200,80},{200,114},{238,114}},
                                                                   color={0,0,127}));
  connect(terUniCoo.PFan,addPFan.u2)
    annotation (Line(points={{90.8333,46},{160,46},{160,114},{238,114}},color={0,0,127}));
  connect(terUniHea.PFan,addPFan.u1)
    annotation (Line(points={{90.8333,-24},{180,-24},{180,126},{218,126}},color={0,0,127}));
  connect(loa.y[3], QReqHotWat_flow) annotation (Line(points={{21,0},{46,0},{46,
          -120},{320,-120}}, color={0,0,127}));
    annotation (Line(points={{90.8333,-12},{180,-12},{180,126},{238,126}},color={0,0,127}));
  connect(disFloCoo.port_b, scaChiWatOut[1].port_a)
    annotation (Line(points={{140,-260},{260,-260}}, color={0,127,255}));
  connect(disFloHea.port_b, scaHeaWatOut[1].port_a)
    annotation (Line(points={{140,-60},{260,-60}}, color={0,127,255}));
  connect(scaHeaWatInl[1].port_b, disFloHea.port_a)
    annotation (Line(points={{-260,-60},{120,-60}}, color={0,127,255}));
  connect(scaChiWatInl[1].port_b, disFloCoo.port_a)
    annotation (Line(points={{-260,-260},{120,-260}}, color={0,127,255}));
  connect(addPFan.y, mulPFan.u)
    annotation (Line(points={{262,120},{268,120}}, color={0,0,127}));
  connect(addPPum.y, mulPPum.u)
    annotation (Line(points={{262,80},{268,80}}, color={0,0,127}));
  connect(mulQReqCoo_flow.y, QReqCoo_flow)
    annotation (Line(points={{294,0},{320,0}}, color={0,0,127}));
  connect(mulQReqHea_flow.y, QReqHea_flow)
    annotation (Line(points={{294,40},{320,40}}, color={0,0,127}));
  connect(loa.y[1], mulQReqCoo_flow.u)
    annotation (Line(points={{-259,0},{270,0}}, color={0,0,127}));
  connect(loa.y[2], mulQReqHea_flow.u) annotation (Line(points={{-259,0},{260,0},
          {260,40},{270,40}}, color={0,0,127}));
  connect(disFloHea.QActTot_flow, mulQHea_flow.u) annotation (Line(points={{141,
          -66},{220,-66},{220,280},{268,280}}, color={0,0,127}));
  connect(disFloCoo.QActTot_flow, mulQCoo_flow.u) annotation (Line(points={{141,
          -266},{224,-266},{224,240},{268,240}}, color={0,0,127}));
  annotation (
    Documentation(
      info="
<html>
<p>
This is a simplified building model where the space heating and cooling loads
are provided as time series.
</p>
</html>",
      revisions="<html>
<ul>
<li>
September 18, 2020, by Jianjun Hu:<br/>
Changed flow distribution components and the terminal units to be conditional depending
on if there is water-based heating, or cooling system.
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2147\">issue 2147</a>.
</li>
<li>
February 21, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-300,-300},{300,300}})));
end BuildingTimeSeries;