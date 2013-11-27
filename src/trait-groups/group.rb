# Author: Erika Suárez Valencia

require 'chromosome'
# ==Description
# Represents one group and holds {groupSize}[rdoc-ref:Group::new] chromosomes. Inside only occurs predation.
class Group

	# Matriz de pago cambiada de acuerdo a la descripción de la depredación
	@@predationMatrix=Array[ [[3,3],[0,5]] , [[5,0],[1,1]] ]
	@@killTwoSelfish=false

	# Creates a new group with size groupSize
	# grouSize:: how many chromosomes will have the group
	def initialize groupSize
		@groupSize=groupSize
		@arrayChromosomes=Array.new
	end
	
	# Adds a chromosome to the group
	# chromosome:: the chromosome to add
	def add chromosome
		@arrayChromosomes << chromosome
	end

	# Performs predation
	# matchTimes:: How many matches occur
	def predation matchTimes
		matchTimes.times do |t| 
			if @arrayChromosomes.size < 2
				break
			end
			pos1=rand(@arrayChromosomes.size)
			pos2=rand(@arrayChromosomes.size)
			
			while pos1 == pos2 do
				pos2=rand(@arrayChromosomes.size)
			end
			
			chromosome1=@arrayChromosomes[pos1]
			chromosome2=@arrayChromosomes[pos2]
			chromosome1.fitness=@@predationMatrix[chromosome1.decision][chromosome2.decision][0]
			chromosome2.fitness=@@predationMatrix[chromosome1.decision][chromosome2.decision][1]
			
			if chromosome1.fitness > chromosome2.fitness
				@arrayChromosomes.delete_at pos2
			elsif chromosome1.fitness < chromosome2.fitness
				@arrayChromosomes.delete_at pos1
			elsif chromosome1.fitness == @@predationMatrix[1][1][1]
				if not @@killTwoSelfish ###MATAR UNO ALEATORIO
					@arrayChromosomes.delete_at (rand(2)==0)? pos1 : pos2
				else ###MATAR LOS DOS
					@arrayChromosomes.delete_at pos1
					if pos1 < pos2
						pos2-=1
					end
					@arrayChromosomes.delete_at pos2
				end
			end
			
		end
	end
	
	# Set if kill both selfish
	# val:: true to kill both selfish, false to kill just one
	def self.killTwoSelfish= val
		@@killTwoSelfish=val
	end
	
	# Empty groups
	def delete
		@arrayChromosomes=nil
		#~ @arrayChromosomes=Array.new
	end
	
	#--
	#Depuración
	#~ def count
		#~ @arrayChromosomes.size
	# end
	
	# Array with the chromosomes in the group
	attr_reader :arrayChromosomes
end
