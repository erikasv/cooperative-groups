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
	
	def calculateAssortment
		@assortmentMatrix=Array.new
		for timeUnit in 0..@timeUnits do
			cursor=@mongoDB.findAll "assortment", {'timeUnit' => timeUnit}
			cursor.sort({'executionTime'=>1})
			xVar=Array.new
			
			cursor.each{
				|doc|
				xVar << doc["assortment"].to_f
			}
			
			@assortmentMatrix << xVar 
		end
	end
	
	def graphicAssortment fileName
		assortment=Array.new
		plusOneSD=Array.new
		minusOneSD=Array.new
		
		calculateAssortment
		
		@assortmentMatrix.each do |xVar|
			
			average=Statistics.expectedValue xVar
			standarDeviation=Statistics.standarDeviation xVar
			
			assortment << average
			plusOneSD << average+standarDeviation
			minusOneSD << average-standarDeviation
			
			#~ @mongoDB.writeDataGraphics time, average, average+standarDeviation, average-standarDeviation
		end
		makeChart assortment, plusOneSD, minusOneSD, fileName
	end
	
	def makeChart assortment , plusOneSD , minusOneSD , fileName 
		yValues=['assortment', 'plusOneSD', 'minusOneSD']
		data=Array.new
		
		assortment.each_index{
			|idx|
			data << OpenStruct.new({ timeUnit: idx, assortment: assortment[idx], plusOneSD: plusOneSD[idx], minusOneSD: minusOneSD[idx] })
		}
		
		Graphic.makeLineChart @timeUnits, 1, yValues, data, fileName, 'Unidades de tiempo (generaciones)', 'Assortment'
	end
	
	def graphicAnalysis fileName
		#ra=r-rs=assortment - g-1/N-1
		
		assortment=Array.new
		plusOneSD=Array.new
		minusOneSD=Array.new
		
		calculateAssortment
		cursor = @mongoDB.findAll "animals",{'executionTime'=>0,'timeUnit'=>0}
		n = cursor.count().to_f
		
		for timeUnit in 0..@timeUnits do
			xVar = Array.new
			@executionTimes.times do |executionTime|
				cursor = @mongoDB.findAll "dataGroups",{'executionTime'=>executionTime,'timeUnit'=>timeUnit}
				g = cursor.count().to_f
				
				ra = @assortmentMatrix[timeUnit][executionTime] - (( g- 1) /(n-1))
				xVar << ra
			end
			
			average=Statistics.expectedValue xVar
			standarDeviation=Statistics.standarDeviation xVar
			
			assortment << average
			plusOneSD << average+standarDeviation
			minusOneSD << average-standarDeviation
			
		end
		makeChart assortment, plusOneSD, minusOneSD, fileName
	end
	
end
