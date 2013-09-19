class GeneticAlgorithm
	#The chromosome must implement:
	#fitness, mutate

	def select totalPopulation, poolSizePercent #Porcentaje
		selected=Array.new
		populationSize=totalPopulation.size
		poolSize=(populationSize * poolSizePercent).ceil.to_i
		
		poolSize.times do
			pos1=rand(populationSize)
			pos2=rand(populationSize)
			while pos1 == pos2 do
				pos2=rand(populationSize)
			end
			chromosome1=totalPopulation[pos1].clone
			chromosome2=totalPopulation[pos2].clone
			
			if chromosome1.fitness > chromosome2.fitness
				selected << chromosome1
			elsif chromosome1.fitness < chromosome2.fitness
				selected << chromosome2
			else
				which=rand(2)
				selected << ((which.eql? 0)? chromosome1 : chromosome2)
			end
		end
		
		return selected
	end
	
	def mutate! population, mutationRate
		amount=(mutationRate * population.size).ceil.to_i
		amount.times do
			which=rand(population.size)
			population[which].mutate # SE DEBERÍA EXCLUIR EL CROMOSOMA QUE RECIÉN SE MUTÓ???
		end
	end
	
	def replace population, pool
		newPopulation=Array.new
		poolSize=pool.size
		populationSize=population.size
		
		poolSize.times do |i|
			pos1=rand(populationSize-i)
			pos2=rand(populationSize-i)
			while pos1 == pos2 do
				pos2=rand(populationSize-i)
			end
			chromosome1=population[pos1]
			chromosome2=population[pos2]
			
			if chromosome1.fitness > chromosome2.fitness
				population.delete_at pos2
			elsif chromosome1.fitness < chromosome2.fitness
				population.delete_at pos1
			else
				which=rand(2)
				(which.eql? 0)? (population.delete_at pos1) : (population.delete_at pos2)
			end
		end
	end
end
