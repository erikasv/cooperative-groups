require 'mongo'

include Mongo

class DBConnection

	def connect
		mongo_client = MongoClient.new("localhost", 27017)
		@db = mongo_client.db("agentsModel")
		
		#Limpiar la base de datos
		@db.command({ dropDatabase: 1 })
	end
	
###WRITING METHODS
	def writeAnimal timeUnit, animal
		@db.collection("animals").insert(
			'timeUnit' => timeUnit,
			'identifier' => animal.identifier,
			'posX' => animal.posX,
			'posY' => animal.posY,
			'energy' => animal.energy,
			'feedRatePercent' => animal.feedRatePercent,
			'group' => animal.group
		)
	end
	
	def writePlant timeUnit, plant
		@db.collection("plants").insert({
			'timeUnit' => timeUnit,
			'identifier' => plant.identifier,
			'posX' => plant.posX,
			'posY' => plant.posY,
			'energy' => plant.energy,
			'group' => plant.group
		})
	end
	
	def writeAssortment timeUnit, meassure
		@db.collection("assortment").insert(
			'timeUnit' => timeUnit,
			'assortment' => meassure
		)
	end
	
	def writeDataGroups timeUnit, altruist, selfish, group
		@db.collection("dataGroups").insert(
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
