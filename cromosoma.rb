class Cromosoma
	
	def initialize
		@genRandom=Random.new
		@val=@genRandom.rand
	end
	
	def mutar
		@val=@genRandom.rand #Considerara como sería agregar ruido en lugar de cambiarlo, pero creo que así está bien
	end
	
	def aptitud
		#true si coopera, false si traiciona
		if @val > 0.5
			return 1
		else
			return 0
		end
	end
	
	attr_reader :val
end
