$:.unshift '.' #Necesario desde 1.9
require 'environment'
require '../geneticAlgorithm'
require 'dBConnection'

class Model
	#Los valores por defecto son los del artículo
	#Parametros para el escenario:      		  , plantas:                          , Animales:
	def initialize width=4, gap=10, minPlants=1000, maxEnergyPlants=10, plantsRate=0.2, metabolicCost=2, amountAnimals=80
		@mongoDB=connectDB
		@environment=Environment.new width, gap, minPlants, maxEnergyPlants, plantsRate, metabolicCost, amountAnimals
		@amountAnimals=amountAnimals
		
		#Datos par la base de datos
		writeAgents 0
	end
	
	def connectDB
		connection=DBConnection.new
		connection.connect
		return connection
	end
	
	#Escribir en la base de datos la información de plantas y animales
	def writeAgents timeUnit
		@environment.plants.each{
			|plant|
			@mongoDB.writePlant timeUnit, plant
		}
		@environment.animals.each{
			|animal|
			@mongoDB.writeAnimal timeUnit, animal
		}
	end
	
	#Escribir en la base de datos la composición de los grupos
	def writeDataGroups timeUnit, altruists, selfish, group
		@mongoDB.writeDataGroups timeUnit, altruists, selfish, group
	end
	
	#Ejecutar el modelo
	def run timeUnits
		timeUnits.times do |time|
			@environment.run	#Pasar una unidad de tiempo en el ambiente si se desea escribir en la bd desde el ambiente
			
			#Evolucionar la población
			matingPool=GeneticAlgorithm.select @environment.animals, 0.5 #Por ahora dejaré esto así, luego lo pondré variable
			GeneticAlgorithm.mutate matingPool, 0.01
			
			toDelete=GeneticAlgorithm.replace @environment.animals, matingPool, @amountAnimals
			@environment.replace toDelete, matingPool
			
			#Datos par la base de datos
			writeAgents time+1
			aboutAssortment time+1
		end
	end
	
	def aboutAssortment timeUnit
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
		
		altruists.each_key{
			|group|
			writeDataGroups timeUnit, altruists[group], selfish[group], group
		}
		
		altruists=nil
		selfish=nil
	end
end

test1=Model.new 3, 2, 10, 10, 0.2, 2, 8
test1.run 3


