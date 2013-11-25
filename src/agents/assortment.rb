$:.unshift '.' #Necesario desde 1.9
require 'dBConnection'
require 'statistics'

class Assortment

	def initialize executionTime, timeUnits
		@timeUnits=timeUnits
		@mongoDB=connectDB
		@executionTime=executionTime
	end
	
	def connectDB
		connection=DBConnection.new
		connection.connect
		#~ connection.cleanAssortment
		return connection
	end

	def meassureAssortment
		for time in 0..@timeUnits do
			assortment=oneUnitAssortment time
			#Escribir el assortment
			@mongoDB.writeAssortment @executionTime, time, assortment
		end
	end
	
	def oneUnitAssortment timeUnit
		xVar=Array.new
		yVar=Array.new
		documents=@mongoDB.findAll "dataGroups", {'executionTime' => @executionTime, 'timeUnit' => timeUnit}
		
		documents.each{					#Armar las variables independiente y dependiente
			|doc|
			altruists=doc["altruist"].to_f
			selfish=doc["selfish"].to_f
			
			totalPopGroup=altruists+selfish
			average=altruists/totalPopGroup
			
			xVar.concat(Array.new(totalPopGroup,average))
			yVar.concat(Array.new(altruists,1.0))
			yVar.concat(Array.new(selfish,0.0))
		}
		assortment=Statistics.regressionCoeficientLeastSquares xVar, yVar
		
		return assortment
	end
end
