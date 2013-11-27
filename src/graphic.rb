# Author: Erika Suárez Valencia

# ==Description
# Class to make charts
class Graphic

	# Make a scatterplot chart.
	# data:: an OpenStruct array with values for x, y and z
	# fileName:: the name for the chart file
	# limX:: maximum value on x axis
	# limY:: maximum value on y axis
	# labelX:: label to x axis
	# labelY:: label to y axis
	def self.makeScatterplot data, fileName, limX, limY, labelX, labelY
		##Los ejes
		w = 600
		h = w
		x = pv.Scale.linear(2, limX+1).range(0, w) #largo del eje x
		y = pv.Scale.linear(2, limY+1).range(0, h) #largo del eje y
		nueva = pv.Scale.linear(0,1).range(0, w/20)#Equivalente a medio cuadrito
		c = pv.Scale.linear(0, 1).range("red","blue")

		## Panel
		panel = pv.Panel.new()
			.width(w)
			.height(h)
			.bottom(50)
			.left(50)
			.right(10)
			.top(5);
			
		### Detalles del eje Y. 
		panel.add(pv.Rule)
			.data(y.ticks(limY-2))
			.bottom(y)
			.strokeStyle(lambda {|d| d!=2 ? "#eee" : "#000"})
			.anchor("left").add(pv.Label)
			.visible(lambda {|d|  d > 0 and d <= 100})
			.text(y.tick_format)

		### Detalles del eje X. 
		panel.add(pv.Rule)
			.data(x.ticks(limX-2))
			.left(x)
			.stroke_style(lambda {|d| d!=2 ? "#eee" : "#000"})
			.anchor("bottom").add(pv.Label)
			.visible(lambda {|d|  d > 0 and d <= 100})
			.text(x.tick_format)

		### Etiquetas de los ejes
		panel.add(pv.Label).left(-15).bottom(150).text(labelY).font("20px sans-serif").text_angle(-Math::PI / 2 ) 
		panel.add(pv.Label).bottom(-35).left(250).text(labelX).font("20px sans-serif")

		### Los datos
		panel.add(pv.Panel)
			.data(data)
			.add(pv.Dot)
			.left(lambda {|d| x.scale(d.x)+x.scale(2.5)})
			.bottom(lambda {|d| y.scale(d.y)+y.scale(2.5)})
			.stroke_style(lambda {|d| c.scale(d.z)})
			.fill_style(lambda {|d| c.scale(d.z).alpha(0.2)})
			.shape_radius(lambda {|d| nueva.scale(d.z)})
			.title(lambda {|d| "(#{d.x},#{d.y}) #{d.z}"})

		svg=File.new(fileName,"w")
		panel.render()
		svg.write(panel.to_svg)
		svg.close
	end
	
	# Make a multiple linechart
	# limX:: maximum value on x axis
	# limY:: maximum value on y axis
	# yPossibleValues:: possible values for y attribute
	# data:: matrix where each x value has the corresponding values for the y axis
	# fileName:: the name for the chart file
	# labelX:: label to x axis
	# labelY:: label to y axis
	def self.makeLineChart limX, limY, yPossibleValues, data, fileName, labelX, labelY
		w = 600
		h = 300
		
		x = pv.Scale.linear(0, limX).range(0, w) #largo del eje x
		y = pv.Scale.linear(limY*-1, limY).range(0, h) #largo del eje y
		fill = pv.colors("lightpink", "darkgray", "lightblue")
		#/* The lines */
		vis = pv.Panel.new()
			.width(w)
			.height(h)
			.margin(60)
			.right(40);
		vis.add(pv.Panel)
			.data(yPossibleValues)
		  .add(pv.Line)
			.data(data)
			.left(lambda {|d| x.scale(d.timeUnit)})
			.bottom(lambda {|d,t| y.scale(d.send(t))})
			.stroke_style(fill.by(pv.parent))
			.line_width(3)

		#/* X-axis ticks. */
		vis.add(pv.Label)
			.data(x.ticks())
			.left(lambda {|d| x.scale(d)})
			.bottom(0)
			.text_baseline("top")
			.text_margin(5)
			.text(x.tick_format);

		#/* Y-axis ticks. */
		vis.add(pv.Rule)
			.data(y.ticks())
			.bottom(lambda {|d| y.scale(d)})
			.stroke_style(lambda {|i|  i!=0 ? pv.color("#ccc") : pv.color("black")})
		  .anchor("left").add(pv.Label)
		  .visible(lambda { (self.index & 1)==0})
			.text_margin(6);
			
		### Etiquetas de los ejes
		vis.add(pv.Label).left(-30).bottom(100).text(labelY).font("20px sans-serif").text_angle(-Math::PI / 2 ) 
		vis.add(pv.Label).bottom(-35).left(160).text(labelX).font("20px sans-serif")

		svg=File.new(fileName,"w")
		vis.render()
		svg.write(vis.to_svg)
		svg.close
	end
end
