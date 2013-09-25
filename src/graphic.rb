#Require 'rubyvis', no se coloca acá porque los datos son un arreglo de OpenStruct, con etiquetas x, y, z
class Graphic

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
	
	def self.makeLineChart data, fileName #  Probando, aún no está listo, falta modificar entradas y eso :P
		w = 400
		h = 200
		x = pv.Scale.linear(data, lambda {|d| d.x}).range(0, w)
		y = pv.Scale.linear(data, lambda {|d| d.y}).range(0, h);

		#/* The root panel. */
		vis = pv.Panel.new()
			.width(w)
			.height(h)
			.bottom(20)
			.left(20)
			.right(10)
			.top(5);

		#/* X-axis ticks. */
		vis.add(pv.Rule)
			.data(x.ticks())
			.visible(lambda {|d|  d > 0})
			.left(x)
			.strokeStyle("#eee")
		  .add(pv.Rule)
			.bottom(-5)
			.height(5)
			.strokeStyle("#000")
		  .anchor("bottom").add(pv.Label)
		  .text(x.tick_format)

		#/* Y-axis ticks. */
		vis.add(pv.Rule)
			.data(y.ticks(5))
			.bottom(y)
			.strokeStyle(lambda {|d| d!=0 ? "#eee" : "#000"})
		  .anchor("left").add(pv.Label)
		  .text(y.tick_format);

		#/* The line. */
		vis.add(pv.Line)
			.data(data)
			.left(lambda {|d| x.scale(d.x)})
			.bottom(lambda {|d| y.scale(d.y)})
			.lineWidth(3);

		svg=File.new(fileName,"w")
		vis.render()
		svg.write(vis.to_svg)
		svg.close
	end
end
