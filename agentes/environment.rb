#~ $:.unshift '.' #Necesario desde 1.9
require 'animal'
require 'plant'

class Environment
	#Lista de plantas: @plants 
	#Lista de animales: @animals
	#Espacio: @grid
	
	def initialize width, gap, minPlants, maxEnergyPlants, plantsRate, metabolicCost, amountAnimals
		@amountPlants=minPlants				#Cantidad de plantas minima
		
		Plant.maxSize=maxEnergyPlants 		#Tamaño máximo de las plantas
		Plant.logisticRate=plantsRate		#Taza de crecimiento
		Animal.metabolicCost=metabolicCost	#Costo metabolico por unidad de tiempos
		
		if(@amountPlants<width**2)
			#El espacio tiene solo un parche
			numPatchesRow=1
		else
			#Determinar el lado de la grilla
			numPatches=(@amountPlants.to_f/width**2).ceil
			numPatchesRow=Math.sqrt(numPatches).ceil
			
			#Se actualiza la cantidad de plantas
			@amountPlants=numPatches*width**2
		end
		
		@gridSize=numPatchesRow*(width+gap)
		@plants=createGridSpace numPatchesRow, width, gap
		@animals=fillGridSpace amountAnimals
		@arrayCount=Array.new
		@arrayCount<< count
	end
	
	#Crear el escenario de acuerdo a lineas de parches con sus respectivos espacios
	#Retorna la lista de plantas en el ambiente
	def createGridSpace numPatchesRow, widthPatch, gapPatch
		@grid=Array.new
		i=0
		j=0
		plants=Array.new
		
		numPatchesRow.times do #Filas de parches
			widthPatch.times do #Filas de celdas en cada parche
				row=Array.new
				
				numPatchesRow.times do #Columnas de parches
					widthPatch.times do #Columnas de celdas en cada parche
						row<< Hash.new
						newPlant=Plant.new(i, j)
						row[j]['plant']=newPlant
						plants<< newPlant
						j=j+1
					end
					
					row.concat(Array.new(gapPatch){Hash.new})
					j=j+gapPatch
				end
				@grid<<row	###i++
				i=i+1
				j=0
			end
			
			gapPatch.times do #Filas de espacio entre parches
				@grid<<Array.new(@gridSize){Hash.new} #Filas de espacios vacios
				i=i+1
			end
		end
		return plants
	end
	
	#Crear y ubicar a los animales sobre plantas
	def fillGridSpace amountAnimals
		animals=Array.new
		amountAnimals.times do
			again=true
			while again do
				x=rand(@gridSize)
				y=rand(@gridSize)
				
				if(@grid[x][y]['plant']!=nil && @grid[x][y]['animal']==nil)
					newAnimal=Animal.new x, y
					animals<< newAnimal
					@grid[x][y]['animal']==newAnimal
					again=false
				end
			end
		end
		return animals
	end
	
	def run generations
		generations.times do
			growPlants #Importa el orden?, primero deberían moverse y comer los animales?
			@animals=moveAnimals
			nextGeneration
			@arrayCount<< count
		end
	end
	
	def growPlants
		@plants.each{
			|plant|
			plant.grow
		}
	end
	
	#Mover y alimentar los animales
	def moveAnimals #Primero se mueve y luego come, porque así lo explican en el artículo
		newAnimals=Array.new
		while not @animals.empty? do
			deltaX=[0,-1,-1,-1,0,1,1,1]
			deltaY=[-1,-1,0,1,1,1,0,-1]
			pos=rand(@animals.size)
			animal=@animals.delete_at(pos)
			best=nil
			#Buscar la mejor planta que satisfaga el costo metabolico
			deltaX.each_index{
				|i|
				newX=animal.posX+deltaX[i]
				newY=animal.posY+deltaY[i]
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
			
			#Moverse y comer
			if best!=nil #Si hay una planta
				@grid[animal.posX][animal.posX]['animal']=nil
				animal.move best.posX, best.posY
				amuntOfFood=animal.feedRatePercent*best.energy
				animal.eat amuntOfFood
				best.beEaten amuntOfFood
				@grid[animal.posX][animal.posX]['animal']=animal
			else #Sino, moverse a un espacio desocupado cualquiera
				newCell=nil
				while newCell==nil do
					pos=rand(deltaX.size)
					newX=animal.posX+deltaX.delete_at(pos)
					newY=animal.posY+deltaY.delete_at(pos)
					if @grid[newX][newY]['animal']==nil
						@grid[animal.posX][animal.posX]['animal']=nil
						animal.move newX, newY
						@grid[animal.posX][animal.posX]['animal']=animal
						newCell=@grid[newX][newY]
						if(newCell['plant']!=nil) #Si hay una planta en ese espacio, comer
							amuntOfFood=animal.feedRatePercent*newCell['plant'].energy
							animal.eat amuntOfFood
							newCell['plant'].beEaten amuntOfFood
						end
					end
				end
				if newCell==nil #Si no hay espacio disponible para moverse
					animal.move animal.posX, animal.posY
				end
			end
			newAnimals<< animal
		end
		return newAnimals
	end
	
	def nextGeneration
		newAnimals=selectAnimals
		newAnimals=mutateAnimals newAnimals
		replaceAnimals newAnimals
	end
	
	#Selección, por torneo y quien tenga mayor reserva de energía
	def selectAnimals
		result=Array.new
		populationSize=@animals.size
		poolSize=(0.6*populationSize).to_i
		
		poolSize.times do
			pos1=rand(populationSize)
			pos2=rand(populationSize)
			while pos1 == pos2 do
				pos2=rand(populationSize)
			end
			agent1=@animals[pos1]
			agent2=@animals[pos2]
			
			#Debería considerarse algún costo por reproducción??
			if agent1.energy>agent2.energy
				result << agent1
			elsif agent1.energy < agent2.energy
				result << agent2
			else
				which=rand(2)
				result << ((which.eql? 0)? agent1: agent2)
			end
		end
		return result
	end
	
	#Mutación
	def mutateAnimals selection
		amount=(0.1*selection.size).ceil.to_i
		amount.times do
			which=rand(selection.size)
			selection[which].mutate # SE DEBERÍA EXCLUIR EL CROMOSOMA QUE RECIÉN SE MUTÓ???
		end
		return selection
	end
	
	#Reemplazo
	def replaceAnimals selection
		selectionSize=selection.size
		populationSize=@animals.size
		selectionSize.times do |i|
			pos1=rand(populationSize-i)
			pos2=rand(populationSize-i)
			while pos1 == pos2 do
				pos2=rand(populationSize-i)
			end
			agent1=@animals[pos1]
			agent2=@animals[pos2]
			
			if agent1.energy > agent2.energy
				@animals.delete_at pos2
			elsif agent1.energy < agent2.energy
				@animals.delete_at pos1
			else
				which=rand(2)
				(which.eql? 0)? (@animals.delete_at pos1): (@animals.delete_at pos2)
			end
			
		end
		@animals.concat selection
	end
	
	def count
		amount=Hash.new(0)
		@animals.each{
			|animal|
			amount["#{animal.feedRatePercent}"]=amount["#{animal.feedRatePercent}"]+1
		}
		return amount
	end
	
	attr_reader :grid, :arrayCount
	
	#~ def grid
		#~ @grid.each{
			#~ |row|
			#~ p row
		#~ }
	#~ end
	
end
