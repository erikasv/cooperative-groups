$:.unshift '.' #Necesario desde 1.9
require 'dBConnection'
require 'statistics'
require 'rubyvis'
require '../graphic'

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
			documents=@mongoDB.findAll "assortment", {'timeUnit' => time, 'executionTime' => @executionTimes-1}
			
			xVar=Array.new
			documents.each{
				|doc|
				xVar << doc["assortment"].to_f
			}
			
			average=Statistics.expectedValue xVar
			standarDeviation=Statistics.standarDeviation xVar
			
			@assortment << average
			@plusOneSD << average+standarDeviation
			@minusOneSD << average-standarDeviation
			
			#~ @mongoDB.writeDataGraphics time, average, average+standarDeviation, average-standarDeviation
		end
	end
	
	def graphicAssortment fileName
		yValues=['assortment', 'plusOneSD', 'minusOneSD']
		#yValues=["assortment"]
		data=Array.new
		
		@assortment.each_index{
			|idx|
			data << OpenStruct.new({ timeUnit: idx+1, assortment: @assortment[idx], plusOneSD: @plusOneSD[idx], minusOneSD: @minusOneSD[idx] })
			# data << OpenStruct.new({ timeUnit: idx+1, assortment: idx})
		}
		
		Graphic.makeLineChart @timeUnits, 0.01, yValues, data, fileName, 'Unidades de tiempo (generaciones)', 'Assortment'
	end
end
