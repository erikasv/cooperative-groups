$:.unshift '.' #Necesario desde 1.9
require 'environment'

class Model
	#Los valores por defecto son los del artículo
	#Parametros para el escenario:      		  , plantas:                          , Animales:
	def initialize width=4, gap=10, minPlants=1000, maxEnergyPlants=10, plantsRate=0.2, metabolicCost=2, amountAnimals=80
		@environment=Environment.new width, gap, minPlants, maxEnergyPlants, plantsRate, metabolicCost, amountAnimals
	end
	
	#Correr el modelo
	def run generations
		@environment.run generations
	end
	
	attr_reader :environment
end

#Análisis


#~ srand(1234)

model=Model.new
model.environment.grid
model.run 1000
seeState model.environment


