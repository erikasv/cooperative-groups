class Animal

	@@metabolicCost #Valor por defecto= al expuesto en el artículo, puesto en modelo.rb

	#Los individuos de las nuevas generaciones tienen su propia tasa de alimentación y energía 
	def initialize posX, posY, group, identifier, energy=rand(10).to_f, feedRatePercent=rand
		@posX=posX
		@posY=posY
		@energy=energy
		@feedRatePercent=feedRatePercent
		@group=group				#Para el análisis del assortment
		@identifier=identifier		#Para la base de datos
	end
	
	def eat amount
		@energy=@energy+amount
	end
	
	def move newX, newY
		#~ @energy=@energy-@@metabolicCost
		@posX=newX
		@posY=newY
	end
	
	#Aptitud, será usada por GeneticAlgorithm
	def fitness
		@energy
	end
	
	#Mutación, será usada por GeneticAlgorithm
	def mutate
		@feedRatePercent+=(rand/5)-0.1
		if @feedRatePercent <= 0.001
			@feedRatePercent=0.001
		elsif @feedRatePercent >= 1.0
			@feedRatePercent=0.99
		end
	end
	
	#Accessors para las variables de clase
	def self.metabolicCost= val
		@@metabolicCost=val
	end
	
	def self.metabolicCost
		@@metabolicCost
	end
	
	attr_reader :feedRatePercent, :energy, :posX, :posY, :identifier
	attr_accessor :group
end
