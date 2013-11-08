require 'mongo'

include Mongo

class DBConection

	def connect dbName
		mongo_client = MongoClient.new("localhost", 27017)
		@db = mongo_client.db("agentsModel")
	end
	
	def writeAnimal timeUnit animal
		db.collection("animals").insert(
			'timeUnit' => timeUnit,
			'identifier' => animal.identifier,
			'posX' => animal.posX,
			'posY' => animal.posY,
			'energy' => animal.energy,
			'feedRatePercent' => animal.feedRatePercent,
			'group' => animal.group
		)
	end
	
	def writePlant timeUnit plant
		db.collection("plants").insert(
			'timeUnit' => timeUnit,
			'identifier' => plant.identifier,
			'posX' => plant.posX,
			'posY' => plant.posY,
			'energy' => plant.energy,
			'group' => plant.group
		)
	end
	
	def writeAssortment timeUnit meassure
		db.collection("assortment").insert(
			'timeUnit' => timeUnit,
			'assortment' => meassure
		)
	end
	
	#Guardar también los componentes de cada grupo?
end
