require 'dBConnection'
require 'statistics'

class Analysis

	def initialize timeUnits
		@timeUnits=timeUnits
		@mongoDB=connectDB
	end
	
	def connectDB
		connection=DBConnection.new
		connection.connect
		return connection
	end

	def meassureAssortment
		@timeUnits.each{
			|time|
			assortment=oneUnitAssortment time
			
			#Escribir el assortment
			@mongoDB.writeAssortment timeUnit, assortment
		}
	end
	
	def oneUnitAssortment timeUnit
		xVar=Array.new
		yVar=Array.new
		documents=@mongoDB.findAll "dataGroups", {'timeUnit' => timeUnit}
		
		documents.each{					#Armar las variables independiente y dependiente
			|doc|
			altruists=doc.altruist
			selfish=doc.selfish
			
			totalPopGroup=altruists+selfish
			average=altruists/totalPopGroup
			
			yVar.concat(Array.new(totalPopGroup,average))
			xVar.concat(Array.new(altruists,1))
			xVar.concat(Array.new(selfish,0))
		}
		
		assortment=Statistics.regressionCoeficient xVar, yVar
		
		return assortment
	end
	
	def graphicAssortment
	end
end
