$:.unshift '.' #Necesario desde 1.9
require 'dBConnection'
require 'statistics'

class Analysis
	def initialize executionTimes, timeUnits
		@timeUnits=timeUnits
		@mongoDB=connectDB
		@executionTimes=executionTimes
	end
	
	def connectDB
		connection=DBConnection.new
		connection.connect
		return connection
	end
	
	def calculateGraphicValues
		@assortment=Array.new
		@plusOneSD=Array.new
		@minusOneSD=Array.new
		
		for time in 1..@timeUnits do
			|time|
			documents=@mongoDB.findAll "assortment", {'timeUnit' => time}
			
			xVar=Array.new
			documents.each{
				|doc|
				xVar << doc["assortment"]
			}
			
			average=Statistics.expectedValue xVar
			standarDeviation=Statistics.standarDeviation xVar
			
			@assortment << average
			@plusOneSD << average+standarDeviation
			@minusOneSD << average-standarDeviation
			
			#~ @mongoDB.writeDataGraphics time, average, average+standarDeviation, average-standarDeviation
		end
	end
	
	def 
	end
end
