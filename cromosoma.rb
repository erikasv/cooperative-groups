class Cromosoma
	
	def initialize
		@genRandom=Random.new
		@val=@genRandom.rand
		@decision=((@val<0.5)?0:1) # < 0.5 coopera, >= 05 traiciona
		@aptitud=-1
	end
	
	def mutar
		@val=@genRandom.rand
		@decision=((@val<0.5)?0:1) # < 0.5 coopera, >= 05 traiciona
	end
	
	attr_accessor :aptitud
	attr_reader :decision
end
