# Author: Erika Suárez Valencia

require 'mongo'
include Mongo

# ==Description
# Class to connect and make operatoions with the database
class DBConnection

	# Connect to the database
	def connect
		mongo_client = MongoClient.new("localhost", 27017)
		@db = mongo_client.db("agentsModel")
	end
	
	#~ def cleanDB
		#~ @db.command({ dropDatabase: 1 })
	#~ end
	
	#~ def cleanAssortment
		#~ @db.collection("assortment").drop
	#~ end
	
###WRITING METHODS

	# Write an animal
	# executionTime:: execution time
	# timeUnit:: time unit
	# animal:: animal to write
	def writeAnimal executionTime, timeUnit, animal
		@db.collection("animals").insert(
			'executionTime' => executionTime,
			'timeUnit' => timeUnit,
			'identifier' => animal.identifier,
			'posX' => animal.posX,
			'posY' => animal.posY,
			'energy' => animal.energy,
			'feedRatePercent' => animal.feedRatePercent,
			'group' => animal.group
		)
	end
	
	# Write a plant
	# executionTime:: execution time
	# timeUnit:: time unit
	# plant:: plant to write
	def writePlant executionTime, timeUnit, plant
		@db.collection("plants").insert({
			'executionTime' => executionTime,
			'timeUnit' => timeUnit,
			'identifier' => plant.identifier,
			'posX' => plant.posX,
			'posY' => plant.posY,
			'energy' => plant.energy,
			'group' => plant.group
		})
	end
	
	# Write the assortment
	# executionTime:: execution time
	# timeUnit:: time unit
	# meassure:: assortment value for that time unit and execution time
	def writeAssortment executionTime, timeUnit, meassure
		@db.collection("assortment").insert(
			'executionTime' => executionTime,
			'timeUnit' => timeUnit,
			'assortment' => meassure
		)
	end
	
	# Write information about the groups
	# executionTime:: execution time
	# timeUnit:: time unit
	# altruist:: amount of altruists
	# selfish:: amount of selfish
	# group:: number of the group
	def writeDataGroups executionTime, timeUnit, altruist, selfish, group
		@db.collection("dataGroups").insert(
			'executionTime' => executionTime,
			'timeUnit' => timeUnit,
			'altruist' => altruist,
			'selfish' => selfish,
			'group' => group
		)
	end
	
	#~ def writeDataGraphics timeUnit, assortment, plusOneSD, minusOneSD
		#~ @db.collection("dataGraphics").insert(
			#~ 'timeUnit' => timeUnit,
			#~ 'assortment' => assortment,
			#~ 'plusOneSD' => plusOneSD,
			#~ 'minusOneSD' => minusOneSD
		#~ )
	#~ end
	
###READING METHODS

	# Find all the documents in the collection that satisfy the query
	# collection:: collection name
	# query:: query
	# options:: options
	def findAll collection, query, options={}
		return @db.collection("#{collection}").find(query)
	end

end
