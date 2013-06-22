$:.unshift '.' #Necesario desde 1.9, según parece solo es necesario hacerlo una vez en la capa mas superior
require 'algoritmoGenetico'
require 'rubyvis'

#Ejecucución del algoritmo con diferentes parametros
grupos_maximo=10
individuos_maximo=10

datos_generaciones=File.new("generaciones.txt","w+")

resultados=Array.new
for i in 2..grupos_maximo do
	fila=Array.new
	for j in 2..individuos_maximo do
		columna=Array.new
		algoritmo=AlgoritmoGenetico.new 100, i, j, 100
		algoritmo.correrAlgoritmo
		
		cantCoop=algoritmo.cooperadores
		cantTrai=algoritmo.traicioneros

		columna << algoritmo.cooperadores << algoritmo.traicioneros
		fila << columna
		#Se escriben los datos de todas las generaciones por si las moscas
		datos_generaciones.write("10:#{i}:#{j}:10 => #{cantCoop}-#{cantTrai}\n")
	end
	resultados << fila
end
datos_generaciones.close

#Elaboración de los graficos

##Los ejes
w = 600
h = w
x = pv.Scale.linear(2, grupos_maximo+1).range(0, w) #hasta grupos máximo
y = pv.Scale.linear(2, individuos_maximo+1).range(0, h) #hasta individuos máximo
nueva = pv.Scale.linear(0,1).range(0, w/20)#Equivalente a medio cuadrito
c = pv.Scale.linear(0, 1).range( "red","blue")

# Poblaciones iniciales (generación 0)
## Datos
d_iniciales=Array.new
for i in 0..grupos_maximo-2
	for j in 0..individuos_maximo-2
		#como siempre se tomara en cuenta los cooperadores, no es necesario
		#revisar ambos arreglos
		d_iniciales << OpenStruct.new(x: i+2, y: j+2, 
		z:resultados[i][j][0][0] / ((i+2.0)*(j+2.0)))
	end
end

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
	.data(y.ticks(grupos_maximo-2))
    .bottom(y)
    .strokeStyle(lambda {|d| d!=2 ? "#eee" : "#000"})
    .anchor("left").add(pv.Label)
	.visible(lambda {|d|  d > 0 and d <= 100})
	.text(y.tick_format)

### Detalles del eje X. 
panel.add(pv.Rule)
    .data(x.ticks(individuos_maximo-2))
    .left(x)
    .stroke_style(lambda {|d| d!=2 ? "#eee" : "#000"})
	.anchor("bottom").add(pv.Label)
	.visible(lambda {|d|  d > 0 and d <= 100})
	.text(x.tick_format)

### Etiquetas de los ejes
panel.add(pv.Label).left(-15).bottom(100).text('Cantidad de individuos por grupo').font("20px sans-serif").text_angle(-Math::PI / 2 ) 
panel.add(pv.Label).bottom(-35).left(200).text('Cantidad de grupos').font("20px sans-serif")

### Los datos iniciales
panel.add(pv.Panel)
	.data(d_iniciales)
	.add(pv.Dot)
	.left(lambda {|d| x.scale(d.x)+x.scale(2.5)})
	.bottom(lambda {|d| y.scale(d.y)+y.scale(2.5)})
	.stroke_style(lambda {|d| c.scale(d.z)})
	.fill_style(lambda {|d| c.scale(d.z).alpha(0.2)})
	.shape_radius(lambda {|d| nueva.scale(d.z)})
	.title(lambda {|d| "(#{d.x},#{d.y}) #{d.z}"})

svg=File.new("inicio.svg","w")
panel.render()
svg.write(panel.to_svg)
svg.close

panel=nil
svg=nil

# Poblaciones finales (ultima generación)
## Datos
d_finales=Array.new
for i in 0..grupos_maximo-2
	for j in 0..individuos_maximo-2
		#como siempre se tomara en cuenta los cooperadores, no es necesario
		#revisar ambos arreglos
		gen=resultados[i][j][0].size-1 #corresponde a la cantidad de coop en la ultima generación
		d_finales << OpenStruct.new(x: i+2, y: j+2, 
		z:resultados[i][j][0][gen] / ((i+2.0)*(j+2.0)))
	end
end

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
	.data(y.ticks(grupos_maximo-2))
    .bottom(y)
    .strokeStyle(lambda {|d| d!=2 ? "#eee" : "#000"})
    .anchor("left").add(pv.Label)
	.visible(lambda {|d|  d > 0 and d <= 100})
	.text(y.tick_format)

### Detalles del eje X. 
panel.add(pv.Rule)
    .data(x.ticks(individuos_maximo-2))
    .left(x)
    .stroke_style(lambda {|d| d!=2 ? "#eee" : "#000"})
	.anchor("bottom").add(pv.Label)
	.visible(lambda {|d|  d > 0 and d <= 100})
	.text(x.tick_format)

### Etiquetas de los ejes
panel.add(pv.Label).left(-15).bottom(100).text('Cantidad de individuos por grupo').font("20px sans-serif").text_angle(-Math::PI / 2 ) 
panel.add(pv.Label).bottom(-35).left(200).text('Cantidad de grupos').font("20px sans-serif")

### Los datos finales
panel.add(pv.Panel)
	.data(d_finales)
	.add(pv.Dot)
	.left(lambda {|d| x.scale(d.x)+x.scale(2.5)})
	.bottom(lambda {|d| y.scale(d.y)+y.scale(2.5)})
	.stroke_style(lambda {|d| c.scale(d.z)})
	.fill_style(lambda {|d| c.scale(d.z).alpha(0.2)})
	.shape_radius(lambda {|d| nueva.scale(d.z)})
	.title(lambda {|d| "(#{d.x},#{d.y}) #{d.z}"})

svg=File.new("final.svg","w")
panel.render()
svg.write(panel.to_svg)
svg.close
