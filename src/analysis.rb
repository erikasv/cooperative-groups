$:.unshift '.' #Necesario desde 1.9, según parece solo es necesario hacerlo una vez en la capa mas superior
require 'traitGroups'
require 'graphic'
require 'rubyvis'

#Entrada por consola: generaciones, veces de depredación (por defecto esta es 1)

maxGroups=10
maxGroupSize=10
generations=ARGV[0].to_i
predationTimes=(ARGV[1].to_i == nil)? 1 : ARGV[1].to_i

#Por el momento se harán 3 ejecuciones por cada conficuración
executions=3

executions.times do |e|
	results=Array.new
	# Ejecutar el algoritmo para cada configuracion grupos / tamaño de grupos
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
	
	data=Array.new #Array con los datos a graficar
	configurationsFile=File.new("comparation#{e}.txt","w+") #Archivo de texto con los casos satisfactorios
	graphicsFile="comparation#{e}.svg" #Nombre para el archivo del grafico
	
	successful=0
	for i in 0..maxGroups-2 do
		for j in 0..maxGroupSize-2 do
			valueZ=0
			firstGeneration=results[i][j][0]['altruist']
			lastPosition=results[i][j].size-1
			lastGeneration=results[i][j][lastPosition]['altruist']
			
			if firstGeneration > lastGeneration
				valueZ=0.1
			elsif firstGeneration < lastGeneration
				valueZ=1.0
				successful=successful+1
				configurationsFile.write("#{i+2} - #{j+2}\n")
			else
				valueZ=0
			end
			
			data << OpenStruct.new(x: i+2, y: j+2, z: valueZ)
		end
	end
	
	configurationsFile.write("#{successful} de #{(maxGroups-2)*(maxGroupSize-2)}")
	configurationsFile.close
	Graphic.makeGraphic data, graphicsFile, maxGroups, maxGroupSize, 'Cantidad de grupos', 'Cantidad de individuos por grupo'
	results=nil
end
