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
		#~ connection.cleanAssortment
		return connection
	end
	
	def calculateGraphicValues
		
	end
end
