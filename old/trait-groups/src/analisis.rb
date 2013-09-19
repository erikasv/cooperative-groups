$:.unshift '.' #Necesario desde 1.9, según parece solo es necesario hacerlo una vez en la capa mas superior
require 'algoritmoGenetico'
require 'rubyvis'

#Ejecucución del algoritmo con diferentes parametros
#Por consola entran generaciones, generacionesGrupo y numero del archivo. En ese orden.
grupos_maximo=10
individuos_maximo=10
#~ generaciones=100
#~ generacionesGrupo=100
generaciones=ARGV[0].to_i
generacionesGrupo=ARGV[1].to_i

resultados=Array.new
for i in 2..grupos_maximo do
	fila=Array.new
	for j in 2..individuos_maximo do
		columna=Array.new
		algoritmo=AlgoritmoGenetico.new generaciones, i, j, generacionesGrupo
		algoritmo.correrAlgoritmo
		
		coop=algoritmo.cooperadores
		trai=algoritmo.traicioneros

		columna << coop << trai
		fila << columna
	end
	resultados << fila
end


def hacerGrafico datos, nombreArchivo, limEjex, limEjey
	##Los ejes
	w = 600
	h = w
	x = pv.Scale.linear(2, limEjex+1).range(0, w) #hasta grupos máximo
	y = pv.Scale.linear(2, limEjey+1).range(0, h) #hasta individuos máximo
	nueva = pv.Scale.linear(0,1).range(0, w/20)#Equivalente a medio cuadrito
	c = pv.Scale.linear(0, 1).range( "red","blue")

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
		.data(y.ticks(limEjex-2))
		.bottom(y)
		.strokeStyle(lambda {|d| d!=2 ? "#eee" : "#000"})
		.anchor("left").add(pv.Label)
		.visible(lambda {|d|  d > 0 and d <= 100})
		.text(y.tick_format)

	### Detalles del eje X. 
	panel.add(pv.Rule)
		.data(x.ticks(limEjey-2))
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
		.data(datos)
		.add(pv.Dot)
		.left(lambda {|d| x.scale(d.x)+x.scale(2.5)})
		.bottom(lambda {|d| y.scale(d.y)+y.scale(2.5)})
		.stroke_style(lambda {|d| c.scale(d.z)})
		.fill_style(lambda {|d| c.scale(d.z).alpha(0.2)})
		.shape_radius(lambda {|d| nueva.scale(d.z)})
		.title(lambda {|d| "(#{d.x},#{d.y}) #{d.z}"})

	svg=File.new(nombreArchivo,"w")
	panel.render()
	svg.write(panel.to_svg)
	svg.close
end

#Elaboración de los graficos

# Poblaciones iniciales (generación 0)
archivo="inicio#{ARGV[2]}.svg"
## Datos
d_iniciales=Array.new #Array con los valores de cada celda que se va a graficar
for i in 0..grupos_maximo-2
	for j in 0..individuos_maximo-2
		#como siempre se tomara en cuenta los cooperadores, no es necesario
		#revisar ambos arreglos
		d_iniciales << OpenStruct.new(x: i+2, y: j+2, # x=valor para grupos, y=valor para individuos
		z:resultados[i][j][0][0] / ((i+2.0)*(j+2.0)) ) #z: Porcentaje de cooperadores en cada celda
	end
end

hacerGrafico d_iniciales, archivo, grupos_maximo, individuos_maximo

# Poblaciones finales (ultima generación)
archivo="final#{ARGV[2]}.svg"
## Datos
d_finales=Array.new #Array con los valores de cada celda que se va a graficar
for i in 0..grupos_maximo-2
	for j in 0..individuos_maximo-2
		#como siempre se tomara en cuenta los cooperadores, no es necesario
		#revisar ambos arreglos
		gen=resultados[i][j][0].size-1 #corresponde a la cantidad de cooperadores en la ultima generación
		d_finales << OpenStruct.new(x: i+2, y: j+2, 
		z:resultados[i][j][0][gen] / ((i+2.0)*(j+2.0)))
	end
end

hacerGrafico d_finales, archivo, grupos_maximo, individuos_maximo

#Comparación entre los datos iniciales y finales
archivo="comparacion#{ARGV[2]}.svg"

#Archivo de texto para comparar después entre ejecuciones
datos_generaciones=File.new("generaciones#{ARGV[2]}.txt","w+")

## Datos
d_comparativos=Array.new
for i in 0..grupos_maximo-2
	for j in 0..individuos_maximo-2
		valorZ=0
		generacion0=resultados[i][j][0][0]
		gen=resultados[i][j][0].size-1
		generacionFinal=resultados[i][j][0][gen]
		
		if(generacion0>generacionFinal)
			valorZ=0.1
			datos_generaciones.write("#{i+2} - #{j+2}\n")
		elsif (generacion0< generacionFinal)
			valorZ=1.0
		else
			valorZ=0
		end
		
		d_comparativos << OpenStruct.new(x: i+2, y: j+2, z:valorZ)
	end
end
datos_generaciones.close

hacerGrafico d_comparativos, archivo, grupos_maximo, individuos_maximo
