$:.unshift '.' #Necesario desde 1.9
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
		connection.cleanAssortment
		return connection
	end

	def meassureAssortment
		for time in 1..@timeUnits do
			assortment=oneUnitAssortment time
			#Escribir el assortment
			@mongoDB.writeAssortment time, assortment
		end
	end
	
	def oneUnitAssortment timeUnit
		xVar=Array.new
		yVar=Array.new
		documents=@mongoDB.findAll "dataGroups", {'timeUnit' => timeUnit}
		
		documents.each{					#Armar las variables independiente y dependiente
			|doc|
			altruists=doc["altruist"].to_f
			selfish=doc["selfish"].to_f
			
			totalPopGroup=altruists+selfish
			average=altruists/totalPopGroup
			
			yVar.concat(Array.new(totalPopGroup,average))
			xVar.concat(Array.new(altruists,1.0))
			xVar.concat(Array.new(selfish,0.0))
		}
		assortment=Statistics.regressionCoeficient xVar, yVar
		
		return assortment
	end
	
	def graphicAssortment
	end
end

analysisTest=Analysis.new 3
analysisTest.meassureAssortment
