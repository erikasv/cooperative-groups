require 'rubyvis'

resultados=Array[
	[[[4, 2, 0, 0, 2, 2, 2, 4, 4, 2], [0, 2, 4, 4, 2, 2, 2, 0, 0, 2]],
	 [[3, 3, 0, 3, 0, 3, 3, 6, 3, 3], [3, 3, 6, 3, 6, 3, 3, 0, 3, 3]],
	 [[0, 4, 4, 4, 0, 4, 4, 8, 8, 8], [8, 4, 4, 4, 8, 4, 4, 0, 0, 0]]
	],
	[[[4, 4, 4, 4, 4, 2, 4, 4, 2, 2], [2, 2, 2, 2, 2, 4, 2, 2, 4, 4]],
	 [[3, 3, 9, 6, 3, 6, 6, 6, 3, 0], [6, 6, 0, 3, 6, 3, 3, 3, 6, 9]],
	 [[8, 8, 4, 4, 12, 0, 8, 8, 0, 12], [4, 4, 8, 8, 0, 12, 4, 4, 12, 0]]
	],
	[[[4, 0, 4, 2, 2, 4, 4, 2, 2, 6], [4, 8, 4, 6, 6, 4, 4, 6, 6, 2]],
	 [[7, 3, 9, 3, 6, 0, 9, 3, 6, 9], [5, 9, 3, 9, 6, 12, 3, 9, 6, 3]],
	 [[8, 8, 8, 4, 4, 16, 8, 16, 4, 8], [8, 8, 8, 12, 12, 0, 8, 0, 12, 8]]
	]]

#Datos iniciales:
data1=Array.new
for i in 0..resultados.size-1
	for j in 0..resultados[0].size-1
		#como siempre se tomara en cuenta los cooperadores, no es necesario
		#revisar ambos arreglos
		data1 << OpenStruct.new(x: i+2, y: j+2, 
		z:resultados[i][j][0][0] / ((i+2.0)*(j+2.0)))
	end
end

#Datos finales:
data2=Array.new
for i in 0..resultados.size-1
	for j in 0..resultados[0].size-1
		#como siempre se tomara en cuenta los cooperadores, no es necesario
		#revisar ambos arreglos
		gen=resultados[i][j][0].size-1 #corresponde a la cantidad de coop en la ultima generación
		data2 << OpenStruct.new(x: i+2, y: j+2, 
		z:resultados[i][j][0][gen] / ((i+2.0)*(j+2.0)))
	end
end

#Los ejes
w = 400
h = w
x = pv.Scale.linear(2, 5).range(0, w) #hasta grupos máximo
# p x
y = pv.Scale.linear(2, 5).range(0, h) #hasta individuos máximo
nueva = pv.Scale.linear(0,1).range(0, w/6)#Equivalente a un cuadrito (el denominador cambia)
c = pv.Scale.linear(0, 1).range( "red","blue")


#Panel inicial
vis1 = pv.Panel.new()
	.width(w)
    .height(h)
    .bottom(40)
    .left(40)
    .right(10)
    .top(5);
    
# Agregar detalles del eje Y. 
vis1.add(pv.Rule)
	.data(y.ticks(3))
    .bottom(y)
    .strokeStyle(lambda {|d| d!=2 ? "#eee" : "#000"})
    .anchor("left").add(pv.Label)
	.visible(lambda {|d|  d > 0 and d <= 100})
	.text(y.tick_format)



# Agregar detalles del eje X. 
vis1.add(pv.Rule)
    .data(x.ticks(3))
    .left(x)
    .stroke_style(lambda {|d| d!=2 ? "#eee" : "#000"})
	.anchor("bottom").add(pv.Label)
	.visible(lambda {|d|  d > 0 and d <= 100})
	.text(x.tick_format)

vis1.add(pv.Label).left(-10).bottom(30).text('Cantidad de individuos por grupo').font("20px sans-serif").text_angle(-Math::PI / 2 ) 
vis1.add(pv.Label).bottom(-30).left(70).text('Cantidad de grupos').font("20px sans-serif")

#Los datos iniciales
vis1.add(pv.Panel)
	.data(data1)
	.add(pv.Dot)
	.left(lambda {|d| x.scale(d.x)+x.scale(2.5)}) #Al revés por la pintada
	.bottom(lambda {|d| y.scale(d.y)+y.scale(2.5)}) #Al revés por la pintada
	.stroke_style(lambda {|d| c.scale(d.z)})
	.fill_style(lambda {|d| c.scale(d.z).alpha(0.2)})
	.shape_radius(lambda {|d| nueva.scale(d.z)})
	.title(lambda {|d| "(#{d.x},#{d.y}) #{d.z}"})

svg1=File.new("inicio.svg","w")
vis1.render()
svg1.write(vis1.to_svg)
svg1.close
#puts vis1.to_svg

#Panel final
vis2 = pv.Panel.new()
	.width(w)
    .height(h)
    .bottom(40)
    .left(40)
    .right(10)
    .top(5);
    
# Agregar detalles del eje Y. 
vis2.add(pv.Rule)
	.data(y.ticks(3))
    .bottom(y)
    .strokeStyle(lambda {|d| d!=2 ? "#eee" : "#000"})
    .anchor("left").add(pv.Label)
	.visible(lambda {|d|  d > 0 and d <= 100})
	.text(y.tick_format)

# Agregar detalles del eje X. 
vis2.add(pv.Rule)
    .data(x.ticks(3))
    .left(x)
    .stroke_style(lambda {|d| d!=2 ? "#eee" : "#000"})
	.anchor("bottom").add(pv.Label)
	.visible(lambda {|d|  d > 0 and d <= 100})
	.text(x.tick_format)

vis2.add(pv.Label).left(-10).bottom(30).text('Cantidad de individuos por grupo').font("20px sans-serif").text_angle(-Math::PI / 2 ) 
vis2.add(pv.Label).bottom(-30).left(70).text('Cantidad de grupos').font("20px sans-serif")

#Los datos finales
vis2.add(pv.Panel)
	.data(data2)
	.add(pv.Dot)
	.left(lambda {|d| x.scale(d.x)+x.scale(2.5)}) #Al revés por la pintada
	.bottom(lambda {|d| y.scale(d.y)+y.scale(2.5)}) #Al revés por la pintada
	.stroke_style(lambda {|d| c.scale(d.z)})
	.fill_style(lambda {|d| c.scale(d.z).alpha(0.2)})
	.shape_radius(lambda {|d| nueva.scale(d.z)})
	.title(lambda {|d| "(#{d.x},#{d.y}) #{d.z}"})

svg2=File.new("final.svg","w")
vis2.render()
svg2.write(vis2.to_svg)
svg2.close
#puts vis1.to_svg
