require 'mongo'

include Mongo

class DBConnection

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
	
	def writeAssortment executionTime, timeUnit, meassure
		@db.collection("assortment").insert(
			'executionTime' => executionTime,
			'timeUnit' => timeUnit,
			'assortment' => meassure
		)
	end
	
	def writeDataGroups executionTime, timeUnit, altruist, selfish, group
		@db.collection("dataGroups").insert(
			'executionTime' => executionTime,
			'timeUnit' => timeUnit,
			'altruist' => altruist,
			'selfish' => selfish,
			'group' => group
		)
	end
	
###READING METHODS
	def findAll collection, query
		return @db.collection("#{collection}").find(query)
	end

end
