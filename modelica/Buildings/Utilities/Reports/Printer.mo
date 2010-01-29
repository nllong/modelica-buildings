within Buildings.Utilities.Reports;
model Printer "Model that prints values to a file"
  extends Modelica.Blocks.Interfaces.DiscreteBlock;
  annotation (Icon(graphics={
        Text(
          extent={{-58,-46},{62,-84}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString=
               "%fileName"),
        Polygon(
          points={{-56,76},{-56,-72},{50,-72},{76,-50},{76,76},{-56,76}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,58},{-4,50}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{12,58},{48,50}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{12,26},{48,18}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,26},{-4,18}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{12,-10},{48,-18}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,-10},{-4,-18}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{12,-44},{48,-52}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,-44},{-4,-52}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}),
                            Documentation(info="<html>
<p>
This model prints to a file or the terminal at a fixed sample interval.
</p>
<p>
The parameter <tt>configuration</tt> controls the printing as follows:
<table>
<tr><td><tt>configuration</tt></td><td>configuration</td><tr>
<tr><td><tt>1</tt></td><td>print at sample times only</td><tr>
<tr><td><tt>2</tt></td><td>print at sample times and at end of simulation</td><tr>
<tr><td><tt>3</tt></td><td>print at end of simulation only</td><tr>
 
</table>
</p>
</html>", revisions="<html>
<ul>
<li>
October 1, 2008 by Michael Wetter:<br>
Revised implementation and moved to new package.
</li>
<li>
July 20, 2007 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));

  parameter String header="" "Header to be printed";
  parameter String fileName="" "File name (empty string is the terminal)";
  parameter Integer nin=1 "Number of inputs";
  parameter Integer configuration = 1
    "Index for treating final report (see documentation)";
  parameter Integer minimumWidth =  1 "Minimum width of result";
  parameter Integer precision = 16 "Number of significant digits";
  Modelica.Blocks.Interfaces.RealInput x[nin] "Value to be printed" 
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}},
          rotation=0)));

initial algorithm
  if (fileName <> "") then
    Modelica.Utilities.Files.removeFile(fileName);
  end if;
  Modelica.Utilities.Streams.print(fileName=fileName, string=header);
equation
  if configuration < 3 then
  when {sampleTrigger, initial()} then
      Buildings.Utilities.Reports.printRealArray(
                                      x=x, fileName=fileName,
                                      minimumWidth=minimumWidth,
                                      precision=precision);
  end when;
  end if;
  when terminal() then
    if configuration >= 2 then
       Buildings.Utilities.Reports.printRealArray(
                                      x=x, fileName=fileName,
                                      minimumWidth=minimumWidth,
                                      precision=precision);
   end if;
  end when;
end Printer;
