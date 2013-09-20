# Dentro del grupo solo ocurre depredación.

# La Depredación será:
# 1. Traiciona vs Coopera = Sobrevive el que traiciona
# 2. Traiciona vs Traiciona = Cualquiera de los dos
# 3. Coopera vs Coopera = Sobreviven los 2

class Group

	#Matriz de pago cambiada de acuerdo a la descripción de la depredación
	@@depredationMatrix=Array[ [[3,3],[0,5]] , [[5,0],[1,1]] ]

	def initialize groupSize
		@groupSize=groupSize
	end
	
	def add chromosome
		@arrayChromosomes << chromosome
	end

	def depredation matchProportion=0.5 #Cuantos encuentros realizar en proporción a la población
		howManyTimes= (@arrayChromosomes * matchProportion).ceil.to_i
		
		howManyTimes.times do
			pos1=rand(@arrayChromosomes.size)
			pos2=rand(@arrayChromosomes.size)
			while pos1 == pos2 do
				pos2=rand(@arrayChromosomes.size)
			end
			
			chromosome1=@arrayChromosomes[pos1]
			chromosome2=@arrayChromosomes[pos2]
			chromosome1.aptitud=@@depredationMatrix[chromosome1.decision][chromosome2.decision][0]
			chromosome2.aptitud=@@depredationMatrix[chromosome1.decision][chromosome2.decision][1]
			
			if chromosome1.fitness > chromosome2.fitness
				@arrayChromosomes.delete_at pos2
			elsif chromosome1.fitness < chromosome2.fitness
				@arrayChromosomes.delete_at pos1
			elsif chromosome1.fitness == @@depredationMatrix[1][1][1]
				@arrayChromosomes.delete_at (rand(2)==0)? pos1 : pos2
			end
			
		end
	end
	
	attr_reader :arrayChromosomes
end
