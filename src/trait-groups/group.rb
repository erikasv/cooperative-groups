# Dentro del grupo solo ocurre depredación.

# La Depredación será:
# 1. Traiciona vs Coopera = Sobrevive el que traiciona
# 2. Traiciona vs Traiciona = Cualquiera de los dos
# 3. Coopera vs Coopera = Sobreviven los 2

require 'chromosome'
class Group

	#Matriz de pago cambiada de acuerdo a la descripción de la depredación
	@@predationMatrix=Array[ [[3,3],[0,5]] , [[5,0],[1,1]] ]
	@@killTwoSelfish=false

	def initialize groupSize
		@groupSize=groupSize
		@arrayChromosomes=Array.new
	end
	
	def add chromosome
		@arrayChromosomes << chromosome
	end

	def predation matchTimes #Cuantos encuentros realizar
		matchTimes.times do |t| 
			if @arrayChromosomes.size < 2
				break
			end
			pos1=rand(@arrayChromosomes.size)
			pos2=rand(@arrayChromosomes.size)
			
			#~ p "t #{t} "
			#~ print "pos1 #{pos1} "
			#~ print "pos2 #{pos2} "
			
			while pos1 == pos2 do
				pos2=rand(@arrayChromosomes.size)
			end
			
			#~ print "pos1 #{pos1} "
			#~ print "pos2 #{pos2} "
			
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
	
	def self.killTwoSelfish= val
		@@killTwoSelfish=val
	end
	
	# Vaciar los grupos
	def delete
		@arrayChromosomes=nil
		#~ @arrayChromosomes=Array.new
	end
	
	#Depuración
	def count
		@arrayChromosomes.size
	end
	
	attr_reader :arrayChromosomes
end
