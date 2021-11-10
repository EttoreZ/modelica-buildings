within Buildings.Examples.VAVReheat.Validation.BaseClasses;
model Floor
  "Extends Buildings.Examples.VAVReheat.BaseClasses.Floor with CO2 generation from people and CO2 from outside air."
  extends Buildings.Examples.VAVReheat.BaseClasses.Floor(
    nor(use_C_flow=true,
        C_start=fill(400e-6*Modelica.Media.IdealGases.Common.SingleGasesData.CO2.MM
                      /Modelica.Media.IdealGases.Common.SingleGasesData.Air.MM, Medium.nC)),
    eas(use_C_flow=true,
        C_start=fill(400e-6*Modelica.Media.IdealGases.Common.SingleGasesData.CO2.MM
                      /Modelica.Media.IdealGases.Common.SingleGasesData.Air.MM, Medium.nC)),
    cor(use_C_flow=true,
        C_start=fill(400e-6*Modelica.Media.IdealGases.Common.SingleGasesData.CO2.MM
                      /Modelica.Media.IdealGases.Common.SingleGasesData.Air.MM, Medium.nC)),
    wes(use_C_flow=true,
        C_start=fill(400e-6*Modelica.Media.IdealGases.Common.SingleGasesData.CO2.MM
                      /Modelica.Media.IdealGases.Common.SingleGasesData.Air.MM, Medium.nC)),
    sou(use_C_flow=true,
        C_start=fill(400e-6*Modelica.Media.IdealGases.Common.SingleGasesData.CO2.MM
                      /Modelica.Media.IdealGases.Common.SingleGasesData.Air.MM, Medium.nC)),
    leaSou(amb(C=fill(400e-6*Modelica.Media.IdealGases.Common.SingleGasesData.CO2.MM
                      /Modelica.Media.IdealGases.Common.SingleGasesData.Air.MM, Medium.nC))),
    leaEas(amb(C=fill(400e-6*Modelica.Media.IdealGases.Common.SingleGasesData.CO2.MM
                      /Modelica.Media.IdealGases.Common.SingleGasesData.Air.MM, Medium.nC))),
    leaNor(amb(C=fill(400e-6*Modelica.Media.IdealGases.Common.SingleGasesData.CO2.MM
                      /Modelica.Media.IdealGases.Common.SingleGasesData.Air.MM, Medium.nC))),
    leaWes(amb(C=fill(400e-6*Modelica.Media.IdealGases.Common.SingleGasesData.CO2.MM
                      /Modelica.Media.IdealGases.Common.SingleGasesData.Air.MM, Medium.nC))));

  Modelica.Blocks.Sources.RealExpression CO2GenWes(y=gai.y[3]*AFloWes/80*
      8.64e-6) "CO2 generated by people in the west zone"
  annotation (Placement(transformation(extent={{-110,50},{-90,70}})));
  Modelica.Blocks.Sources.RealExpression CO2GenCor(y=gai.y[3]*AFloCor/80*
      8.64e-6) "CO2 generated by people in the core zone"
  annotation (Placement(transformation(extent={{82,56},{102,76}})));
  Modelica.Blocks.Sources.RealExpression CO2GenEas(y=gai.y[3]*AFloEas/80*
      8.64e-6) "CO2 generated by people in the east zone"
  annotation (Placement(transformation(extent={{254,64},{274,84}})));
  Modelica.Blocks.Sources.RealExpression CO2GenNor(y=gaiIntNor[3].y*AFloNor/80*
      8.64e-6) "CO2 generated by people in the north zone"
  annotation (Placement(transformation(extent={{80,142},{100,162}})));
  Modelica.Blocks.Sources.RealExpression CO2GenSou(y=gaiIntSou[3].y*AFloSou/80*
      8.64e-6) "CO2 generated by people in the south zone"
  annotation (Placement(transformation(extent={{84,-20},{104,0}})));

equation
  connect(CO2GenNor.y, nor.C_flow[1]) annotation (Line(points={{101,152},{122,152},
          {122,138.8},{142.4,138.8}}, color={0,0,127}));
  connect(CO2GenWes.y, wes.C_flow[1]) annotation (Line(points={{-89,60},{-40,60},
          {-40,58.8},{10.4,58.8}}, color={0,0,127}));
  connect(CO2GenCor.y, cor.C_flow[1]) annotation (Line(points={{103,66},{124,66},
          {124,58.8},{142.4,58.8}}, color={0,0,127}));
  connect(CO2GenSou.y, sou.C_flow[1]) annotation (Line(points={{105,-10},{124,-10},
          {124,-21.2},{142.4,-21.2}}, color={0,0,127}));
  connect(CO2GenEas.y, eas.C_flow[1]) annotation (Line(points={{275,74},{288,74},
          {288,78.8},{302.4,78.8}}, color={0,0,127}));
annotation(Documentation(info="<html>
<p>
This model is used in the model
<a href=\"modelica://Buildings.Examples.VAVReheat.Validation.TraceSubstance\">
Buildings.Examples.VAVReheat.Validation.TraceSubstance</a>.  It extends
<a href=\"modelica://Buildings.Examples.VAVReheat.BaseClasses.Floor\">
Buildings.Examples.VAVReheat.BaseClasses.Floor</a> with CO<sub>2</sub> generation
from people and CO<sub>2</sub> from outside air infiltration.  Calculation of the
generation from people uses the gain schedule for latent load and assumes
80 W per person latent load to calculate the number of people.  Then, it assumes
CO<sub>2</sub> generation is 0.0048 l/s per person (Table 5, Persily and De Jonge 2017)
and density of CO<sub>2</sub> to be 1.8 kg/m<sup>3</sup>, making CO<sub>2</sub> generation equal to
8.64e-6 kg/s per person. Outside air CO<sub>2</sub> concentration is assumed 400 ppm.
</p>
<h4>References</h4>
<p>
Persily, A. and De Jonge, L. (2017). Carbon dioxide generation rates for
building occupants. <i>Indoor Air</i>, 27, 868–879.
https://doi.org/10.1111/ina.12383.
</p>
</html>",revisions="<html>
<ul>
<li>
May 9, 2021, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"), Icon(graphics={Text(
          extent={{258,-18},{324,-62}},
          lineColor={0,0,0},
          textString="CO2")}));
end Floor;
