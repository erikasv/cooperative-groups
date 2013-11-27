# Author: Erika Suárez Valencia

$:.unshift '.' #Necesario desde 1.9
require 'dBConnection'
require 'statistics'
require 'rubyvis'
require '../graphic'

# ==Description
# Used to make analysis about the assortment
class Analysis

	# Creates new object.
	# executionTime:: how many executions were made
	# timeUnits:: how many time units had each execution
	def initialize executionTimes, timeUnits
		@timeUnits=timeUnits
		@mongoDB=connectDB
		@executionTimes=executionTimes
	end
	
	# Connect to de database
	def connectDB
		connection=DBConnection.new
		connection.connect
		return connection
	end
	
	# Calculates the assortment in all time units and all executions
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
	
	# Make a chart of the assortment observed values, with average and standard deviations
	# fileName:: the name for the chart file
	def graphicAssortment fileName
		assortment=Array.new
		plusOneSD=Array.new
		minusOneSD=Array.new
		
		calculateAssortment
		
		@assortmentMatrix.each do |xVar|
			
			average=Statistics.expectedValue xVar
			standardDeviation=Statistics.standardDeviation xVar
			
			assortment << average
			plusOneSD << average+standardDeviation
			minusOneSD << average-standardDeviation
			
			#~ @mongoDB.writeDataGraphics time, average, average+standardDeviation, average-standardDeviation
		end
		makeChart assortment, plusOneSD, minusOneSD, fileName
	end
	
	# Makes the chart of the assortment and the standard deviations
	# assortment:: array with the assortment values
	# plusOneSD:: array with the values of the assortment plus one standard deviation
	# minusOneSD:: array with the values of the assortment minus one standard deviation
	# fileName:: the name for the chart file
	def makeChart assortment , plusOneSD , minusOneSD , fileName 
		yValues=['assortment', 'plusOneSD', 'minusOneSD']
		data=Array.new
		
		assortment.each_index{
			|idx|
			data << OpenStruct.new({ timeUnit: idx, assortment: assortment[idx], plusOneSD: plusOneSD[idx], minusOneSD: minusOneSD[idx] })
		}
		
		Graphic.makeLineChart @timeUnits, 1, yValues, data, fileName, 'Unidades de tiempo (generaciones)', 'Assortment'
	end
	
	# Make a chart of the assortment observed minus the expected under 
	# random distribution, with average and standard deviations
	# fileName:: the name for the chart file
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
			standardDeviation=Statistics.standardDeviation xVar
			
			assortment << average
			plusOneSD << average+standardDeviation
			minusOneSD << average-standardDeviation
			
		end
		makeChart assortment, plusOneSD, minusOneSD, fileName
	end
	
end
