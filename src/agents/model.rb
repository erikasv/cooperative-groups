# Author: Erika Suárez Valencia

$:.unshift '.' #Necesario desde 1.9
require 'environment'
require '../geneticAlgorithm'
require 'dBConnection'

# ==Description
# Is the model itself
class Model
	# Receives the parameters to initialize the environment and 
	# the number of the current execution.
	# The default values are the same in the paper
	# executionTime:: number of the execution
	# width:: width of each patch (group) of plants in cells
	# gap:: gap between patches in each axis in cells
	# minPlants:: minimum number of plants in the environment
	# maxEnergyPlants:: maximum size (energy) for the plants
	# plantsRate:: logistic rate to the growth of plants
	# metabolicCost:: metabolic cost for the animals
	# amountAnimals:: number of animals on the environment
	#--
	#Parametros para el escenario: plantas:          								                 , Animales:
	def initialize executionTime, width=4, gap=10, minPlants=1000, maxEnergyPlants=10, plantsRate=0.2, metabolicCost=2, amountAnimals=80
		@mongoDB=connectDB
		@environment=Environment.new width, gap, minPlants, maxEnergyPlants, plantsRate, metabolicCost, amountAnimals
		@amountAnimals=amountAnimals
		@executionTime=executionTime
		
		#Datos par la base de datos
		writeAgents @executionTime, 0
		aboutAssortment @executionTime, 0
	end
	
	# Connect to de database
	def connectDB
		connection=DBConnection.new
		connection.connect
		#~ connection.cleanDB
		return connection
	end
	
	# Writes in the database the information about plants and animals
	# executionTime:: execution time
	# timeUnit:: time unit
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
	
	# Writes in the database the groups' composition
	# executionTime:: execution time
	# timeUnit:: time unit
	# altruists:: amount of altruists
	# selfish:: amount of selfish
	# group:: number of the group
	def writeDataGroups executionTime, timeUnit, altruists, selfish, group
		@mongoDB.writeDataGroups executionTime, timeUnit, altruists, selfish, group
	end
	
	# Run the model
	# timeUnits:: how many time units
	def run timeUnits
		for time in 1..timeUnits do
			@environment.run
			
			#Evolucionar la población
			#~ matingPool=GeneticAlgorithm.select @environment.animals, 0.6
			#~ GeneticAlgorithm.mutate matingPool, 0.01
			#~ 
			#~ toDelete=GeneticAlgorithm.replace @environment.animals, matingPool, @amountAnimals
			#~ @environment.replace toDelete, matingPool
			
			#Datos par la base de datos
			writeAgents @executionTime, time
			aboutAssortment @executionTime, time
		end
	end
	
	# Calculates the variables for after analyse the assortment
	# executionTime:: execution time
	# timeUnit:: time unit
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
			
			if (amountAltruist != 0) or (amountSelfish != 0)
				writeDataGroups executionTime, timeUnit, amountAltruist, amountSelfish, group
			end
		}
		
		altruists=nil
		selfish=nil
	end
end
