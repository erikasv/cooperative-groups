$:.unshift '.' #Necesario desde 1.9, según parece solo es necesario hacerlo una vez en la capa mas superior
require 'traitGroups'
require 'graphic'
require 'rubyvis'

class Analysis_details
	def initialize groups, groupSize, generations, mutationRate=0.0, killTwoSelfish=false, predationTimes=0.5
		@groups=groups
		@groupSize=groupSize
		@generations=generations
		@killTwoSelfish=killTwoSelfish
		@mutationRate=mutationRate
		@predationTimes=predationTimes
		@fileNumber="#{@groups}-#{@groupSize}_#{mutationRate}"
	end
	
	def run
		model=TraitGroups.new @groups, @groupSize, @generations, @predationTimes, @mutationRate, @killTwoSelfish
		model.run
		
		composition = model.composition
		
		graphicsData=Array.new
		composition.each_index do |i|
			graphicsData << OpenStruct.new(x: i, y: composition[i]['altruist'])
		end
		
		Graphic.makeLineChart graphicsData, "../trait-groups/detalles_#{@fileNumber}.svg", 'Generacion', 'Cantidad de cooperadores en la poblacion'
	end
end

prueba=Analysis_details.new 2, 3, 1000
prueba.run
