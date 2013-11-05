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
		
		
		#Determinar el lado de la grilla en parches
		numPatches=(@amountPlants.to_f/width**2).ceil
		numPatchesRow=Math.sqrt(numPatches).ceil
		numPatches=numPatchesRow**2
		
		#Se actualiza la cantidad de plantas
		@amountPlants=numPatches*width**2
		
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
						#Escribirla también en la base de datos
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
					#Agregar el animal también a la base de datos
					#Esto requiere tener un identificador para el animal, tanto en la clase como en el registro de la bd
					@grid[x][y]['animal']=newAnimal
					again=false
				end
			end
		end
		return animals
	end
	
	def run generations
		#Creo que debería manejar la parte de evolución desde el modelo mismo. 
		#Y acá solo ejecutar una unidad de tiempo, ya que 1 unidad de tiempo = 1 generación
		generations.times do
			growPlants
			@animals=moveAnimals
			#Calcular siguiente generación
		end
	end
	
	def growPlants
		@plants.each{
			|plant|
			plant.grow
			#Cambiar la planta en la base de datos
		}
	end
	
	#Mover y alimentar los animales
	def moveAnimals #Primero se mueve y luego come, porque así lo explican en el artículo
		newAnimals=Array.new
		while not @animals.empty? do
			pos=rand(@animals.size)
			animal=@animals.delete_at(pos)
			
			if animal.energy >= Animal.metabolicCost	#Si tiene energía para vivir
				newPlant= findNewCell animal 			#Encontrar la mejor planta y moverse a ella
				if newPlant								#Si se movió
					eatPlant animal						#Comerse la planta
				else 									#Sino, moverse a cualquier lado
					moveAnyPlace animal
					if @grid[animal.posX][animal.posY]['plant']!=nil #Si cayó en planta comerla
						eatPlant animal
					end
				end
				#Cambiar el animal en la base de datos
			else #Sino muere
				@grid[animal.posX][animal.posY]['animal']=nil
				#Eliminar el animal en la base de datos
			end
		end
	end
	
	#Buscar la mejor planta que satisfaga el costo metabolico y moverse a ella
	#Retorna si encontró la mejor planta
	def findNewPlant animal
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
	
	#Mover el animal a una posición vecina sin otro animal de forma aleatoria
	def moveAnyPlace animal
		deltaX=[0,-1,-1,-1,0,1,1,1]
		deltaY=[-1,-1,0,1,1,1,0,-1]
		newCell=false
		while not newCell && not deltaX.empty? do
			pos=rand(deltaX.size)
			newX=validate animal.posX+deltaX.delete_at(pos)
			newY=validate animal.posY+deltaY.delete_at(pos)
			if @grid[newX][newY]['animal']==nil
				moveAnimal animal, newX, newY
				newCell=true
			end
		end
		
		if not newCell #Si no hay espacio para moverse, solo se pierde el costo metabolico
			animal.move animal.posX animal.posY
		end
	end
	
	#Mover el animal a una nueva posición dada
	def moveAnimal animal, newX, newX
		@grid[animal.posX][animal.posX]['animal']=nil
		@grid[newX][newY]['animal']=animal
		animal.move newX, newY
	end
	
	def eatPlant animal
		plant= @grid[animal.posX][animal.posY]['plant']
		amuntOfFood=animal.feedRatePercent*plant.energy
		animal.eat amuntOfFood
		plant.beEaten amuntOfFood
		#Cambiar la planta en base de datos
	end
	
	#Validar la posición para que el mundo sea ciclico
	def validate pos
		return pos % @gridSize
	end
	
end
