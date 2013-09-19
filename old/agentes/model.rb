$:.unshift '.' #Necesario desde 1.9
require 'environment'

class Model
	#Los valores por defecto son los del artículo
	#Parametros para el escenario:      		  , plantas:                          , Animales:
	def initialize width=4, gap=10, minPlants=1000, maxEnergyPlants=10, plantsRate=0.2, metabolicCost=2, amountAnimals=80
		@environment=Environment.new width, gap, minPlants, maxEnergyPlants, plantsRate, metabolicCost, amountAnimals
	end
	
	def run generations
		@environment.run generations
	end
	
	attr_reader :environment
end

#Análisis
def seeState environment
	index=0
	environment.arrayCount.each{
		|gen|
		gen=gen.to_a
		gen.sort!{|x,y| x[0]<=>y[0]}
		
		puts "Generation: #{index}"
		gen.size.times do |i|
			puts "#{gen[i][0].to_f} - #{gen[i][1]}"
		end
		index=index+1
	}
end

#~ srand(1234)

model=Model.new
model.environment.grid
model.run 1000
seeState model.environment


