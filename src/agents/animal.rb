# Author: Erika Suárez Valencia

# ==Description
# Agent that can be one of two types: altruist (eats less than 50% of the plant's energy) or selfish (eats more than 50%)
class Animal

	@@metabolicCost #Valor por defecto= al expuesto en el artículo, puesto en modelo.rb

	# Inserts a new animal. When it appears in a generation different than the 0, it has its own energy and feed rate percent
	# posX:: x position on the grid
	# posY:: y position on the grid
	# group:: number of the group which belongs to
	# identifier:: identifier on the database
	# energy:: current energy
	# feedRatePercent:: rate of energy that eats of the plant
	def initialize posX, posY, group, identifier, energy=rand(10).to_f, feedRatePercent=rand
		@posX=posX
		@posY=posY
		@energy=energy
		@feedRatePercent=feedRatePercent
		@group=group				#Para el análisis del assortment
		@identifier=identifier		#Para la base de datos
	end
	
	# To earn energy
	# amount:: quantity of energy
	def eat amount
		@energy=@energy+amount
	end
	
	# Move to a new cell in the grid
	# newX:: new x position
	# newY:: new y position
	def move newX, newY
		#~ @energy=@energy-@@metabolicCost
		@posX=newX
		@posY=newY
	end
	
	# Fitness, it will be used by GeneticAlgorithm
	def fitness
		@energy
	end
	
	# Mutation, it will be used by GeneticAlgorithm
	def mutate
		@feedRatePercent+=(rand/5)-0.1
		if @feedRatePercent <= 0.001
			@feedRatePercent=0.001
		elsif @feedRatePercent >= 1.0
			@feedRatePercent=0.99
		end
	end
	
	# Set the metabolic cost for the animals
	# val:: new metabolic cost value
	def self.metabolicCost= val
		@@metabolicCost=val
	end
	
	# Returns the value of the metabolic cost
	def self.metabolicCost
		@@metabolicCost
	end
	
	# Rate of energy that eats of the plant
	attr_reader :feedRatePercent
	# Energy of the animal
	attr_reader :energy
	# x position on the grid
	attr_reader :posX
	# y position on the grid
	attr_reader :posY
	# Identifier on the database
	attr_reader :identifier
	# Number of the group which belongs to
	attr_accessor :group
end
