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
				while x==y do
					y=rand(@gridSize)
				end
				
				if(@grid[x][y]['plant']!=nil && @grid[x][y]['animal']==nil)
					newAnimal=Animal.new x, y
					animals<< newAnimal
					@grid[x][y]['animal']==newAnimal
					again=false
				end
			end
		end
	end
	
	def run generations
		generations.times do
			growPlants #Importa el orden?, primero deberían moverse y comer los animales?
			moveAnimals
			nextGeneration
		end
	end
	
	def growPlants
		@plants.each{
			|plant|
			plant.grow
		}
	end
	
	#Mover y alimentar los animales
	def moveAnimals
		deltaX=[0,-1,-1,-1,0,1,1,1]
		deltaY=[-1,-1,0,1,1,1,0,-1]
		while not @animals.empty?
			pos=rand(@animals.size)
			animal=@animals.delete_at(pos)
			best=nil
			
			#Buscar la mejor planta que satisfaga el costo metabolico
			deltaX.each_index{
				|i|
				newX=animal.posX+deltaX[i]
				newY=animal.posY+deltaY[i]
				newCell=@grid[newX][newY]
				if(newCell['plant']!=nil && newCell['animal']==nil)
					newEnergy=newCell['plant'].energy
					if(best==nil || ( newEnergy > best.energy && newEnergy > Animal.metabolicCost))
						best=@grid[newX][newY]['plant']
					end
				end
			}
			
			#Moverse y comer
			if(best!=nil) #Si hay una planta
				animal.move best.posX, best.posY
				amuntOfFood=animal.feedRatePercent*best.energy
				animal.eat amuntOfFood
				best.beEaten animal.feedRatePercent
			else #Sino, moverse a un espacio desocupado cualquiera
				#Moverse a una celda aleatoria
			end
		end
		#move
		#eat
	end
	
	def nextGeneration
		#select
		#reproduce
		#mutate
	end
	
	attr_reader :grid
	
	#~ def grid
		#~ @grid.each{
			#~ |row|
			#~ p row
		#~ }
	#~ end
	
end
