$:.unshift '.' #Necesario desde 1.9
require 'environment'

class Model
	
	#Los valores por defecto son los del artículo
	#Parametros para el escenario:      		  , plantas:                          , Animales:
	def initialize width=4, gap=10, minPlants=1000, maxEnergyPlants=10, plantsRate=0.2, metabolicCost=2, amountAnimals=80
		@environment=Environment.new width, gap, minPlants, maxEnergyPlants, plantsRate, metabolicCost, amountAnimals
	end
	
	def run generations #Si son generaciones? -> no podŕia ser que una generación sea un conjunto de pasos, es decir cada tantos movimientos (unidades de tiempo)
		@environment.run generations
	end
end

model=Model.new 3, 2, 10, amountAnimals=10


