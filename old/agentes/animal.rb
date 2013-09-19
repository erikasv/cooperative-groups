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
	
	def mutate
		@feedRatePercent=rand
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
