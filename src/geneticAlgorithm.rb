class GeneticAlgorithm
	#The chromosome must implement:
	#fitness, mutate

	#Returns the mating pool in an array
	def self.select totalPopulation, poolSizePercent
		selected=Array.new
		populationSize=totalPopulation.size
		poolSize=(populationSize * poolSizePercent).ceil.to_i
		
		poolSize.times do
			pos1=rand(populationSize)
			pos2=rand(populationSize)
			while pos1 == pos2 do
				pos2=rand(populationSize)
			end
			chromosome1=totalPopulation[pos1]
			chromosome2=totalPopulation[pos2]
			
			if chromosome1.fitness > chromosome2.fitness
				selected << chromosome1.clone
			elsif chromosome1.fitness < chromosome2.fitness
				selected << chromosome2.clone
			else
				which=rand(2)
				selected << ((which.eql? 0)? chromosome1.clone : chromosome2.clone)
			end
		end
		
		return selected
	end
	
	#Mutate over the mating pool array
	def self.mutate population, mutationRate
		amount=(mutationRate * population.size).ceil.to_i
		amount.times do
			which=rand(population.size)
			population[which].mutate
		end
	end
	
	#Returns an array with the chromosomes to delete from the population -> Just in case
	#Also deletes them from the original population
	#The merge between the pool and the resulting population must be done by the other class
	def self.replace population, pool
		toDelete=Array.new
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
				toDelete << chromosome2
				population.delete_at pos2
			elsif chromosome1.fitness < chromosome2.fitness
				toDelete << chromosome1
				population.delete_at pos1
			else
				which=rand(2)
				if(which.eql? 0)
					population.delete_at pos1
					toDelete << chromosome1
				else
					population.delete_at pos2
					toDelete << chromosome2
				end
			end
		end
		
		return toDelete
	end
end
