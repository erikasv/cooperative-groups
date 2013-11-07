$:.unshift '.' #Necesario desde 1.9
require 'environment'
require '../geneticAlgorithm'

class Model
	#Los valores por defecto son los del artículo
	#Parametros para el escenario:      		  , plantas:                          , Animales:
	def initialize width=4, gap=10, minPlants=1000, maxEnergyPlants=10, plantsRate=0.2, metabolicCost=2, amountAnimals=80
		@environment=Environment.new width, gap, minPlants, maxEnergyPlants, plantsRate, metabolicCost, amountAnimals
	end
	
	###Hay que hacer una funcion para la conexión a la base de datos y organizar eso
	
	#Ejecutar el modelo
	def run timeUnits
		timeUnits.times do
			@environment.run	#Pasar una unidad de tiempo en el ambiente
			
			#Evolucionar la población
			matingPool=GeneticAlgorithm.select @environment.animals, 0.6 #Por ahora dejaré esto así, luego lo pondré variable
			GeneticAlgorithm.mutate matingPool
			toDelete=GeneticAlgorithm.replace @environment.animals, matingPool
			@environment.replace toDelete, matingPool
			
			#Datos para medir el assortment
			aboutAssortment
		end
	end
	
	def aboutAssortment
		altruists=Hash.new{|hash,key| hash[key]=0}
		selfish=Hash.new{|hash,key| hash[key]=0}
		@environment.animals.each{
			|animal|
			if(animal.feedRatePercent > 0.5)
				selfish[animal.group]+=1
			else
				altruists[animal.group]+=1
			end
		}
		
		#Construcción de las variables independientes y dependientes
		#x=genotipo del actor
		#y=promedio del genotipo del grupo
		altruists.each_key{
			|key|
			totalPopGroup=altruist[key]+selfish[key]
			average=altruist[key]/totalPopGroup
			#Escribir tantos pares de variables x, y como sea necesario en la base de datos
				#-x es 1 o 0 para egoísta y altruista respectivamente
				#-y es el promedio que se acabó de calcular
				#-Buscar hacer esto con una función que inserte vários registros iguales
		}
		
		altruists=nil
		selfish=nil
	end
end


