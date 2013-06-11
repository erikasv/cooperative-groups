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

#Datos finales:
data1=Array.new
for i in 0..resultados.size-1
	for j in 0..resultados[0].size-1
		#como siempre se tomara en cuenta los cooperadores, no es necesario
		#revisar ambos arreglos
		gen=resultados[i][j][0].size-1 #corresponde a la cantidad de coop en la ultima generación
		data1 << OpenStruct.new(x: i+2, y: j+2, 
		z:resultados[i][j][0][gen] / ((i+2.0)*(j+2.0)))
	end
end

#Los ejes
w = 400
h = w
x = pv.Scale.linear(2, 5).range(0, w)
# p x
y = pv.Scale.linear(2, 5).range(0, h)
nueva = pv.Scale.linear(0,1).range(0, w/6)#Equivalente a un cuadrito
c = pv.Scale.linear(0, 1).range( "red","blue")

# The root panel.
vis = pv.Panel.new()
	.width(w)
    .height(h)
    .bottom(20)
    .left(20)
    .right(10)
    .top(5);
    
# Y-axis and ticks. 
vis.add(pv.Rule)
	.data(y.ticks(3))
    .bottom(y)
    .strokeStyle(lambda {|d| d!=2 ? "#eee" : "#000"})
    .anchor("left").add(pv.Label)
	.visible(lambda {|d|  d > 0 and d <= 100})
	.text(y.tick_format)
#   p y.tick_format

# X-axis and ticks. 
vis.add(pv.Rule)
    .data(x.ticks(3))
    .left(x)
    .stroke_style(lambda {|d| d!=2 ? "#eee" : "#000"})
	.anchor("bottom").add(pv.Label)
	.visible(lambda {|d|  d > 0 and d <= 100})
	.text(x.tick_format)
	
vis.add(pv.Panel)
	.data(data1)
	.add(pv.Dot)
	.left(lambda {|d| x.scale(d.x)+x.scale(2.5)}) #Al revés por la pintada
	.bottom(lambda {|d| y.scale(d.y)+y.scale(2.5)}) #Al revés por la pintada
	.stroke_style(lambda {|d| c.scale(d.z)})
	.fill_style(lambda {|d| c.scale(d.z).alpha(0.2)})
	.shape_radius(lambda {|d| nueva.scale(d.z)})
	.title(lambda {|d| "(#{d.x},#{d.y}) #{d.z}"})
	
vis.render()
puts vis.to_svg
