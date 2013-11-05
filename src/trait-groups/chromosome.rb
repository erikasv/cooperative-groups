class Chromosome

	def initialize
		@gen=rand
		@decision=(@gen>0.5)? 0 : 1 #0 coopera, 1 Traiciona
		@fitness=nil
	end
	
	def mutate
		#Sumar o restar ruido para que el gen no sea tan diferente al anterior?
		@gen+=(rand/5)-0.1
		if @gen <= 0.0
			@gen=0.0
		elsif @gen >= 1.0
			@gen=1.0
		end
		#~ @gen=rand
		@decision=(@gen>0.5)? 0 : 1 #0 coopera, 1 Traiciona
	end
	
	attr_reader :decision
	attr_accessor :fitness
end
