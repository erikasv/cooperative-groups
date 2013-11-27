# Author: Erika Suárez Valencia

# ==Description
# A chromosome has only one gen, a random number between 0 and 1, which determines if cooperate or betray
class Chromosome

	# Create a new chromosome with random value
	def initialize
		@gen=rand
		@decision=(@gen>0.5)? 0 : 1 #0 coopera, 1 Traiciona
		@fitness=nil
	end
	
	# Mutate by adding noise to the chromosome's gen
	def mutate
	# Sumar o restar ruido para que el gen no sea tan diferente al anterior
		@gen+=(rand/5)-0.1
		if @gen <= 0.0
			@gen=0.0
		elsif @gen >= 1.0
			@gen=1.0
		end
		@decision=(@gen>0.5)? 0 : 1 #0 coopera, 1 Traiciona
	end
	
	# 0 cooperate, 1 betray
	attr_reader :decision
	# Value assigned by the match with another chromosome
	attr_accessor :fitness
end
