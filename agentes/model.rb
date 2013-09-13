$:.unshift '.' #Necesario desde 1.9
require 'environment'

class Model
	
	#Los valores por defecto son los del artículo
	#Parametros para el escenario:      		  , plantas:                          , Animales:
	def initialize width=4, gap=10, minPlants=1000, maxEnergyPlants=10, plantsRate=0.2, metabolicCost=2, amountAnimals=80
		@environment=Environment.new width, gap, minPlants, maxEnergyPlants, plantsRate, metabolicCost, amountAnimals
	end
	
	def run generations
		@environment.run generations
	end
	
	attr_reader :environment
end

model=Model.new
model.run 100

#Análisis
def countFinalState environment
	generations=environment.arrayCooperators[-1]
	generations=generations.to_a
	generations.sort!{
		|x,y|
		x[0]<=>y[0]
	}
	generations.each{
		|v|
		puts "#{v[0]} - #{v[1]}"
	}
end

countFinalState model.environment


