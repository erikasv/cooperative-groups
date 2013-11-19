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
		
		for time in 0..@timeUnits do
			documents=@mongoDB.findAll "assortment", {'timeUnit' => time}
			
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
		data=Array.new
		
		@assortment.each_index{
			|idx|
			data << OpenStruct.new({ timeUnit: idx, assortment: @assortment[idx], plusOneSD: @plusOneSD[idx], minusOneSD: @minusOneSD[idx] })
		}
		
		Graphic.makeLineChart @timeUnits, 1, yValues, data, fileName, 'Unidades de tiempo (generaciones)', 'Assortment'
	end
end
