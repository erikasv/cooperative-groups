# Author: Erika Suárez Valencia

# ==Description
# Agent that only grow according to the logistic function explained on the document
class Plant
	@@maxSize #Valor por defecto= al expuesto en el artículo, puesto en modelo.rb
	@@logisticRate #Valor por defecto= al expuesto en el artículo, puesto en modelo.rb
	
	# Creates a new plant
	# posX:: x position on the grid
	# posY:: y position on the grid
	# group:: number of the group which belongs to
	# identifier:: identifier on the database
	def initialize posX, posY, group, identifier
		@energy=0
		while @energy==0
			@energy=rand(@@maxSize).to_f
		end
		@posX=posX
		@posY=posY
		@group=group				#Para el análisis del assortment
		@identifier=identifier		#Para la base de datos
	end
	
	# Growth function given by the logistic curve on the paper
	def grow
		if @energy<@@maxSize
			stepGrowth=@@logisticRate*@energy*( (@@maxSize-@energy) / @@maxSize )
			if @energy+stepGrowth <= @@maxSize
				@energy=@energy+stepGrowth
			else
				@energy=@@maxSize
			end
		end
	end
	
	# When an animal eats part of the plant
	# amount:: quantity eaten
	def beEaten amount
		@energy=@energy-amount
	end
	
	# Set the maximum size of the plants
	# val:: maximum value
	def self.maxSize= val
		@@maxSize=val
	end
	
	# Set the logistic rate for the growth function
	# val:: value to the logistic rate
	def self.logisticRate= val
		@@logisticRate=val
	end
	
	# Current energy of the plant
	attr_reader :energy
	# x position on the grid
	attr_reader :posX
	# y position on the grid
	attr_reader :posY
	# Number of the group which belongs to
	attr_reader :group
	# Identifier on the database
	attr_reader :identifier
end

