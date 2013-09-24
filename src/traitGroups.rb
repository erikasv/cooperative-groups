require 'group'
class TraitGroups
	
	def initialize amountGroups, groupSize, generations, predationTimes=0.5
		@amountGroups=amountGroups
		@groupSize=groupSize
		@generations=generations
		@predationTimes=(predationTimes * @groupSize).ceil.to_i
		@composition=Array.new
		
		@arrayGroups=Array.new
		@amountGroups.times do
			newGroup=Group.new groupSize
			@arrayGroups << newGroup
		end
		
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
		@generations.times do
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
			
			# 3. Reproducirlos: 1 solo hijo por cada uno, sin cruce ni mutación
			newPopulation=Array.new
			totalPopulation.each do |chromosome|
				newPopulation << chromosome
				newPopulation << chromosome.clone
			end
			totalPopulation=nil
			
			# 3.5 Contar la cantidad de altruistas y de egoistas
			count newPopulation
			
			# 4. Volver a repartirlos en los grupos
			distribute newPopulation
			
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
		@arrayGroups.each do |group|
			@groupSize.times do
				pos=rand(population.size)
				group.add population[pos]
				population.delete_at pos
			end
		end
	end
	
	attr_reader :composition
end
