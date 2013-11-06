$:.unshift '.' #Necesario desde 1.9
require 'environment'
requier '../geneticAlgorithm'

class Model
	#Los valores por defecto son los del artículo
	#Parametros para el escenario:      		  , plantas:                          , Animales:
	def initialize width=4, gap=10, minPlants=1000, maxEnergyPlants=10, plantsRate=0.2, metabolicCost=2, amountAnimals=80
		@environment=Environment.new width, gap, minPlants, maxEnergyPlants, plantsRate, metabolicCost, amountAnimals
	end
	
	#Ejecutar el modelo
	def run timeUnits
		timeUnits.times do
			@environment.run	#Pasar una unidad de tiempo en el ambiente
			
			#Evolucionar la población
			matingPool=GeneticAlgorithm.select @environment.animals, 0.6 #Por ahora dejaré esto así, luego lo pondré variable
			GeneticAlgorithm.mutate matingPool
			toDelete=GeneticAlgorithm.replace @environment.animals, matingPool
			@environment.replace toDelete, matingPool
			
			#Medir el assortment
			measureAssortment
		end
	end
	
	def measureAssortment
		@environment.animals.each{
			|animal|
			#Verificar a que grupo pertenece el anima
			#Sumar al valor del grupo
			#Guardar el valor para poder referenciar como variable independiente
		}
		#Por cada grupo, promediar la suma
		#Construir variables independientes y dependientes
		#Calcular el assortment
	end
	
	attr_reader :environment
end

#Análisis


#~ srand(1234)

model=Model.new
model.environment.grid
model.run 1000
seeState model.environment


