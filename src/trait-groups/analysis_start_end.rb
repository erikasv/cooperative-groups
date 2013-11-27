# Author: Erika Suárez Valencia

#~ $:.unshift '.' #Necesario desde 1.9, solo es necesario hacerlo una vez en la capa mas superior
require 'traitGroups'
require '../graphic'
require 'rubyvis'

# ==Description
# Performs analysis on the number of cooperators at the beginning and
# end of each run. In addition to testing various configurations of:
# number of groups - chromosomes on each group
class Analysis_start_end
	
	# Sets the parameters to the model and how many times run the model
	# generations:: Amount of generations to run
	# executions:: How many times run the model
	# mutationRate:: Mutation rate
	# killTwoSelfish:: true if kill both selfish on the match, default=false
	# predationTimes:: How many matches occur inside a group, in terms of proportion of the group size
	def initialize generations, executions, mutationRate=0.0, killTwoSelfish=false, predationTimes=0.5
		@maxGroups=10
		@maxGroupSize=10
		@generations=generations
		@predationTimes=predationTimes
		@mutationRate=mutationRate
		@executions=executions
		@fileNumber="#{@executions}_#{mutationRate}"
		@killTwoSelfish=killTwoSelfish
	end
	
	# Run the model {executions}[rdoc-ref:Analysis_start_end::new] times
	def run
		cases=Hash.new{|hash,key| hash[key]=0}

		@executions.times do |executionNumber|
			p "executionNumber: #{executionNumber}"
			results=Array.new
			# Ejecutar el algoritmo una vez para cada configuracion grupos / tamaño de grupos
			for i in 2..@maxGroups do
				row=Array.new
				for j in 2..@maxGroupSize do
					model=TraitGroups.new i, j, @generations, @predationTimes, @mutationRate, @killTwoSelfish
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
		if not killTwoSelfish
			graphicsFile="../trait-groups/#{@generations}/casosRepeticiones_#{@fileNumber}.svg"
		else
			graphicsFile="../trait-groups_matar2/#{@generations}/casosRepeticiones_#{@fileNumber}.svg"
		end
		for i in 0..@maxGroups-2 do
			for j in 0..@maxGroupSize-2 do
				valueZ=cases["#{i+2},#{j+2}"].to_f
				data << OpenStruct.new(x: i+2, y: j+2, z: valueZ/@executions)
			end
		end

		Graphic.makeScatterplot data, graphicsFile, @maxGroups, @maxGroupSize, 'Cantidad de grupos', 'Cantidad de individuos por grupo'
	end
end
