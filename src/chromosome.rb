class Chromosome

	def initialize
		@gen=rand
		@decision=(@gen>0.5)? 0 : 1
		@fitness=nil
	end
	
	attr_reader :fitness, :decision
end
