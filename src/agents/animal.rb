class Animal
	#Morir
	#Reproducción
	@@metabolicCost #Valor por defecto= al expuesto en el artículo, puesto en modelo.rb

	def initialize posX, posY
		@posX=posX
		@posY=posY
		@energy=rand(10).to_f #Es un valor arbitrario por el momento, no se de que deba depender, debería ser mayor al costo metabolico?
		@feedRatePercent=rand
	end
	
	def eat amount
		@energy=@energy+amount
	end
	
	def move newX, newY
		@energy=@energy-@@metabolicCost
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
		if @feedRatePercent <= 0.0
			@feedRatePercent=0.0
		elsif @feedRatePercent >= 1.0
			@feedRatePercent=1.0
		end
	end
	
	#Accessors para las variables de clase
	def self.metabolicCost= val
		@@metabolicCost=val
	end
	
	def self.metabolicCost
		@@metabolicCost
	end
	
	attr_reader :feedRatePercent, :energy, :posX, :posY
end
