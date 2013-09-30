#~ $:.unshift '.' #Necesario desde 1.9, según parece solo es necesario hacerlo una vez en la capa mas superior
require 'traitGroups'
require 'graphic'
require 'rubyvis'

class Analysis_start_end
	
	def initialize generations, executions, mutationRate=0.0, predationTimes=0.5
		@maxGroups=10
		@maxGroupSize=10
		@generations=generations
		@predationTimes=predationTimes
		@mutationRate=mutationRate
		@executions=executions
		@fileNumber="#{@executions}_#{mutationRate}"
	end
	
	def run
		cases=Hash.new{|hash,key| hash[key]=0}

		@executions.times do |executionNumber|
			p "executionNumber: #{executionNumber}"
			results=Array.new
			# Ejecutar el algoritmo una vez para cada configuracion grupos / tamaño de grupos
			for i in 2..@maxGroups do
				row=Array.new
				for j in 2..@maxGroupSize do
					model=TraitGroups.new i, j, @generations, @predationTimes, @mutationRate
					model.run

					row << model.composition
				end
				results << row
			end
			model=nil

			for i in 0..@maxGroups-2 do
				for j in 0..@maxGroupSize-2 do
					firstGeneration=results[i][j][0]['altruist']
					lastPosition=results[i][j].size-1
					lastGeneration=results[i][j][lastPosition]['altruist']
					
					if firstGeneration < lastGeneration
						cases["#{i+2},#{j+2}"] = cases["#{i+2},#{j+2}"]+1
					end
				end
			end
			results=nil
		end
		
		#Graficar los resultados
		data=Array.new
		graphicsFile="../trait-groups/#{@generations}/casosRepeticiones_#{@fileNumber}.svg"
		for i in 0..@maxGroups-2 do
			for j in 0..@maxGroupSize-2 do
				valueZ=cases["#{i+2},#{j+2}"].to_f
				data << OpenStruct.new(x: i+2, y: j+2, z: valueZ/@executions)
			end
		end

		Graphic.makeScatterplot data, graphicsFile, @maxGroups, @maxGroupSize, 'Cantidad de grupos', 'Cantidad de individuos por grupo'
	end
end
