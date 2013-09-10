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
	
	def fillGridSpace amountAnimals
		animals=Arary.new
		amountAnimals.times do
			animals<< Animal.new
		end
	end
	
	attr_reader :grid
	
	#~ def grid
		#~ @grid.each{
			#~ |row|
			#~ p row
		#~ }
	#~ end
	
end
