require '../geneticAlgorithm'
require 'group'
class TraitGroups
	
	def initialize amountGroups, groupSize, generations, predationTimes, mutationRate, killTwoSelfish=false
		@amountGroups=amountGroups
		@groupSize=groupSize
		@generations=generations
		@predationTimes=(predationTimes * @groupSize).ceil.to_i
		@mutationRate=mutationRate
		@composition=Array.new
		Group.killTwoSelfish=killTwoSelfish
		
		chromosomes=Array.new
		(@amountGroups * @groupSize).times do
			chromosomes << Chromosome.new
		end
		
		#Contar la cantidad de altruistas y egoistas inicial
		count chromosomes
		
		#Repartirlos en grupos
		distribute chromosomes
		
		chromosomes=nil
	end
	
	def run
		@generations.times do |g|
		
			# 1. Depredación por @predationTimes generaciones
			@arrayGroups.each do |group|
				group.predation @predationTimes
			end
			
			# 2. Mezcla = Sacar todos los cromosomas de los grupos
			totalPopulation=Array.new
			@arrayGroups.each do |group|
				totalPopulation.concat group.arrayChromosomes
				group.delete
			end
			@arrayGroups=nil
			
			# 3. Reproducirlos: 1 solo hijo por cada uno, sin cruce ni mutación
			newPopulation=Array.new
			totalPopulation.each do |chromosome|
				newPopulation << chromosome
				newPopulation << chromosome.clone
			end
			totalPopulation=nil
			
			# 4. Mutarlos
			GeneticAlgorithm.mutate newPopulation, @mutationRate
			
			# 4.5 Contar la cantidad de altruistas y de egoistas
			count newPopulation
			
			# 5. Volver a repartirlos en los grupos
			distribute newPopulation
			if newPopulation.size > 0
			end
			newPopulation=nil
		end
	end
	
	def count population
		altruist=0
		selfish=0
		population.each do |chromosome|
			if chromosome.decision == 0
				altruist=altruist+1
			else
				selfish=selfish+1
			end
		end
		values=Hash.new
		values['altruist']=altruist
		values['selfish']=selfish
		@composition << values
	end
	
	def distribute population
		howManyGroups=population.size / @groupSize
		if howManyGroups > @amountGroups
			howManyGroups=@amountGroups
		end
		 
		@arrayGroups=Array.new
		howManyGroups.times do
			group=Group.new @groupSize
			@groupSize.times do
				pos=rand(population.size)
				group.add population[pos]
				population.delete_at pos
			end
			@arrayGroups << group
		end
	end
	
	def countGroups
		total=0
		@arrayGroups.each do |group|
			total+=group.count
		end
		total
	end
	
	attr_reader :composition
end
