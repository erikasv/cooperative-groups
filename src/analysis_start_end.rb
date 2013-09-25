$:.unshift '.' #Necesario desde 1.9, según parece solo es necesario hacerlo una vez en la capa mas superior
require 'traitGroups'
require 'graphic'
require 'rubyvis'

#Entrada por consola: generaciones, ejecuciones, veces de depredación (por defecto esta es 50% de la población de los grupos)

maxGroups=10
maxGroupSize=10
generations=ARGV[0].to_i
predationTimes=(ARGV[2].to_i == nil)? 1 : ARGV[2].to_i

#Por el momento se harán 3 ejecuciones por cada conficuración
cases=Hash.new{|hash,key| hash[key]=0}
maxValue=0

executions=ARGV[1].to_i
executions.times do
	results=Array.new
	# Ejecutar el algoritmo una vez para cada configuracion grupos / tamaño de grupos
	for i in 2..maxGroups do
		row=Array.new
		for j in 2..maxGroupSize do
			model=TraitGroups.new i, j, generations, predationTimes
			model.run

			row << model.composition
		end
		results << row
	end
	model=nil

	for i in 0..maxGroups-2 do
		for j in 0..maxGroupSize-2 do
			firstGeneration=results[i][j][0]['altruist']
			lastPosition=results[i][j].size-1
			lastGeneration=results[i][j][lastPosition]['altruist']
			
			if firstGeneration < lastGeneration
				cases["#{i+2},#{j+2}"] = cases["#{i+2},#{j+2}"]+1
				maxValue=(maxValue < cases["#{i+2},#{j+2}"])? cases["#{i+2},#{j+2}"] : maxValue
			end
		end
	end
	results=nil
end

#Graficar los resultados
data=Array.new
graphicsFile="casosRepeticiones.svg"
for i in 0..maxGroups-2 do
	for j in 0..maxGroupSize-2 do
		valueZ=cases["#{i+2},#{j+2}"].to_f
		data << OpenStruct.new(x: i+2, y: j+2, z: valueZ/maxValue)
	end
end

Graphic.makeGraphic data, graphicsFile, maxGroups, maxGroupSize, 'Cantidad de grupos', 'Cantidad de individuos por grupo'