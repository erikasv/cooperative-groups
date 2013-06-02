class Cromosoma
	
	def initialize
		@genRandom=Random.new
		@val=@genRandom.rand
		@aptitud=-1
	end
	
	def mutar
		@val=@genRandom.rand #Considerara como sería agregar ruido en lugar de cambiarlo, pero creo que así está bien
	end
	
	def funcAptitud
		# < 0.5 coopera, >= 05 traiciona
		if @val < 0.5
			return 0
		else
			return 1
		end
	end
	
	attr_reader :val
	attr_accessor :aptitud
end
