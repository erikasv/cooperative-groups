# Author: Erika Suárez Valencia

#~ $:.unshift '.' #Necesario desde 1.9
require 'animal'
require 'plant'

# ==Description
# Is the squared environment of the model
class Environment
	#Lista de plantas: @plants 
	#Lista de animales: @animals
	#Espacio: @grid
	
	# Creates a new environment
	# width:: width of each patch (group) of plants in cells
	# gap:: gap between patches in each axis in cells
	# minPlants:: minimum number of plants in the environment
	# maxEnergyPlants:: maximum size (energy) for the plants
	# plantsRate:: logistic rate to the growth of plants
	# metabolicCost:: metabolic cost for the animals
	# amountAnimals:: number of animals on the environment
	def initialize width, gap, minPlants, maxEnergyPlants, plantsRate, metabolicCost, amountAnimals
		@amountPlants=minPlants				#Cantidad de plantas minima
		@amountAnimals=amountAnimals		#cantidad de animales
		
		Plant.maxSize=maxEnergyPlants 		#Tamaño máximo de las plantas
		Plant.logisticRate=plantsRate		#Taza de crecimiento
		Animal.metabolicCost=metabolicCost	#Costo metabolico por unidad de tiempos
		
		
		#Determinar el lado de la grilla en parches
		numPatches=(@amountPlants.to_f/width**2).ceil
		numPatchesRow=Math.sqrt(numPatches).ceil
		numPatches=numPatchesRow**2
		
		#Se actualiza la cantidad de plantas
		@amountPlants=numPatches*width**2
		
		@idAnimals=0					#El id para diferenciarlos en la base de datos
		@gridSize=numPatchesRow*(width+gap)
		@plants=createGridSpace numPatchesRow, width, gap
		@animals=fillGridSpace amountAnimals
	end
	
	# Creates the grid according to the rows of patches.
	# numPatchesRow:: number of rows in terms of patches
	# widthPatch:: width of each patch
	# gapPatch:: gap between patches
	#
	# Returns an array with the plants on the environment.
	def createGridSpace numPatchesRow, widthPatch, gapPatch
		@grid=Array.new
		i=0
		j=0
		plants=Array.new
		
		a=0		#Para enumerar los grupos de plantas
		b=0		#Para enumerar los grupos de plantas
		id=0	#Para diferenciar las plantas en la base de datos
		numPatchesRow.times do #Filas de parches
			widthPatch.times do #Filas de celdas en cada parche
				row=Array.new
				
				numPatchesRow.times do #Columnas de parches
					widthPatch.times do #Columnas de celdas en cada parche
						row<< Hash.new
						newPlant=Plant.new i, j, a+b, id
						row[j]['plant']=newPlant
						plants<< newPlant
						j=j+1
						id+=1
					end
					
					row.concat(Array.new(gapPatch){Hash.new})
					j=j+gapPatch
					
					a+=1
					if a%numPatchesRow==0
						a=0
					end
				end
				@grid<<row
				i=i+1
				j=0
			end
			
			b=b+numPatchesRow
			
			gapPatch.times do #Filas de espacio entre parches
				@grid<<Array.new(@gridSize){Hash.new} #Filas de espacios vacios
				i=i+1
			end
		end
		@amountGroups=b
		return plants
	end
	
	# Creates and places the animals in the grid
	# amountAnimals:: Number of animals to create
	def fillGridSpace amountAnimals
		animals=Array.new
		amountAnimals.times do
			again=true
			while again do
				x=rand(@gridSize)
				y=rand(@gridSize)
				
				if(@grid[x][y]['plant']!=nil && @grid[x][y]['animal']==nil)
					newAnimal=Animal.new x, y, @grid[x][y]['plant'].group, @idAnimals
					animals<< newAnimal
					@grid[x][y]['animal']=newAnimal
					again=false
					@idAnimals +=1
				end
			end
		end
		return animals
	end
	
	# Run one time unit
	def run
		growPlants
		@animals=moveAnimals
	end
	
	# Grow each plant
	def growPlants
		@plants.each{
			|plant|
			plant.grow
		}
	end
	
	# Move and feed each animal
	def moveAnimals #Primero se mueve y luego come, porque así lo explican en el artículo
		newAnimals=Array.new
		while not @animals.empty? do
			pos=rand(@animals.size)
			animal=@animals.delete_at(pos)
			
			if animal.energy >= Animal.metabolicCost	#Si tiene energía para vivir
				newPlant= moveNewPlant animal 			#Encontrar la mejor planta y moverse a ella
				if newPlant								#Si se movió a una planta
					eatPlant animal						#Comerse la planta
				else 									#Sino, moverse a cualquier lado
					moveAnyPlace animal
					if @grid[animal.posX][animal.posY]['plant']!=nil #Si cayó en una planta comerla
						eatPlant animal
					end
				end
				newAnimals << animal
			else #Sino muere
				@grid[animal.posX][animal.posY]['animal']=nil
			end
		end
		return newAnimals
	end
	
	# Find the best plant that has at least the metabolic cost
	# and moves the animal to it.
	# animal:: the animal to move
	#
	# Returns if found the best plant.
	def moveNewPlant animal
		deltaX=[0,-1,-1,-1,0,1,1,1]
		deltaY=[-1,-1,0,1,1,1,0,-1]
		
		best=nil
		deltaX.each_index{
			|i|
			newX=validate animal.posX+deltaX[i]
			newY=validate animal.posY+deltaY[i]
			newCell=@grid[newX][newY]
			if newCell['plant']!=nil && newCell['animal']==nil
				newEnergy=newCell['plant'].energy
				if best==nil && ( newEnergy > Animal.metabolicCost )
					best=newCell['plant']
				elsif best!=nil && (newEnergy > best.energy)
					best=newCell['plant']
				end
			end
		}
		if best != nil
			moveAnimal animal, best.posX, best.posY
			return true
		else
			return false
		end
	end
	
	# Moves the animal to a neighbor position without another animal
	# animal:: the animal to move
	def moveAnyPlace animal
		deltaX=[0,-1,-1,-1,0,1,1,1]
		deltaY=[-1,-1,0,1,1,1,0,-1]
		newCell=false
		while (not newCell) && (not deltaX.empty?) do
			pos=rand(deltaX.size)
			newX=validate animal.posX+deltaX.delete_at(pos)
			newY=validate animal.posY+deltaY.delete_at(pos)
			if @grid[newX][newY]['animal']==nil
				moveAnimal animal, newX, newY
				newCell=true
			end
		end
		
		if not newCell #Si no hay espacio para moverse, solo se pierde el costo metabolico
			animal.move animal.posX, animal.posY
		end
	end
	
	# Moves the animal to a new position
	# animal:: the animal to move
	# newX:: new x position
	# newY:: new y position
	def moveAnimal animal, newX, newY
		@grid[animal.posX][animal.posY]['animal']=nil
		@grid[newX][newY]['animal']=animal
		animal.move newX, newY
	end
	
	# Eat a plant
	# animal:: the animal that is going to eat
	def eatPlant animal
		plant= @grid[animal.posX][animal.posY]['plant']
		amountOfFood=animal.feedRatePercent*plant.energy
		
		animal.eat amountOfFood
		animal.group=plant.group
		plant.beEaten amountOfFood
	end
	
	# Validates a position. The environment is cyclic
	def validate pos
		return pos % @gridSize
	end
	
	# Evolutive section:
	#
	# Deletes from the grid the animals in the toDelete array
	# 
	# Places in the grid the animals in the toAdd array
	def replace toDelete, toAdd
		toDelete.each{
			|animal|
			@grid[animal.posX][animal.posY]['animal']=nil
		}
		toAdd.each{
			|animal|
			again=true
			while again do
				x=rand(@gridSize)
				y=rand(@gridSize)
				
				if(@grid[x][y]['plant']!=nil && @grid[x][y]['animal']==nil)
					newAnimal=Animal.new x, y, @grid[x][y]['plant'].group, @idAnimals, animal.energy, animal.feedRatePercent
					@grid[x][y]['animal']=newAnimal
					again=false
					@idAnimals+=1
					@animals << newAnimal
				end
			end
		}
	end
	
	#--
	#~ def imprimir
		#~ plants=0
		#~ animals=0
		#~ @grid.each{
			#~ |row|
			#~ row.each{
				#~ |cell|
				#~ if cell['plant']!=nil
					#~ plants+=1
				#~ end
				#~ if cell['animal']!=nil
					#~ animals+=1
				#~ end
			#~ }
		#~ }
		#~ p "plants: #{plants} - animals: #{animals}"
	#~ end
	
	# Array with the animals on the environment
	attr_reader :animals
	# Array with the plants on the environment
	attr_reader :plants
	# Quantity of groups (patches with animals) in the environment
	attr_reader :amountGroups
end
