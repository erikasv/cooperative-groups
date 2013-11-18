$:.unshift '.' #Necesario desde 1.9
require 'environment'
require '../geneticAlgorithm'
require 'dBConnection'

class Model
	#Los valores por defecto son los del artículo
	#Parametros para el escenario: plantas:          								                  , Animales:
	def initialize executionTime,  width=4, gap=10, minPlants=1000, maxEnergyPlants=10, plantsRate=0.2, metabolicCost=2, amountAnimals=80
		@mongoDB=connectDB
		@environment=Environment.new width, gap, minPlants, maxEnergyPlants, plantsRate, metabolicCost, amountAnimals
		@amountAnimals=amountAnimals
		@executionTime=executionTime
		
		#Datos par la base de datos
		writeAgents @executionTime, 0
		aboutAssortment @executionTime, 0
	end
	
	def connectDB
		connection=DBConnection.new
		connection.connect
		#~ connection.cleanDB
		return connection
	end
	
	#Escribir en la base de datos la información de plantas y animales
	def writeAgents executionTime, timeUnit
		@environment.plants.each{
			|plant|
			@mongoDB.writePlant executionTime, timeUnit, plant
		}
		@environment.animals.each{
			|animal|
			@mongoDB.writeAnimal executionTime, timeUnit, animal
		}
	end
	
	#Escribir en la base de datos la composición de los grupos
	def writeDataGroups executionTime, timeUnit, altruists, selfish, group
		@mongoDB.writeDataGroups executionTime, timeUnit, altruists, selfish, group
	end
	
	#Ejecutar el modelo
	def run timeUnits
		for time in 1..timeUnits do
			@environment.run	#Pasar una unidad de tiempo en el ambiente si se desea escribir en la bd desde el ambiente
			
			#Evolucionar la población
			matingPool=GeneticAlgorithm.select @environment.animals, 0.6 #Por ahora dejaré esto así, luego lo pondré variable
			GeneticAlgorithm.mutate matingPool, 0.01
			
			toDelete=GeneticAlgorithm.replace @environment.animals, matingPool, @amountAnimals
			@environment.replace toDelete, matingPool
			
			#Datos par la base de datos
			writeAgents @executionTime, time
			aboutAssortment @executionTime, time
		end
	end
	
	def aboutAssortment executionTime, timeUnit
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
		
		@environment.amountGroups.times{
			|group|
			amountAltruist=altruists[group]
			amountSelfish=selfish[group]
			
			if (amountAltruist != 0) || (amountSelfish != 0)
				writeDataGroups executionTime, timeUnit, amountAltruist, amountSelfish, group
			end
		}
		
		altruists=nil
		selfish=nil
	end
end
