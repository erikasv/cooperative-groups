$:.unshift '.' #Necesario desde 1.9
require 'plant'

class Environment
	@@grid ##Probablemente no se necesite de clase.
	@@gridSize ##Aun no estoy segura si es necesario
	
	def initialize width, gap, minPlants, maxEnergyPlants
		@plants=minPlants
		@gapPatch=gap
		@widthPatch=width
		Plant.maxSize=maxEnergyPlants
		
		if(@plants<@widthPatch**2)
			#El espacio tiene solo un parche
			numPatchesRow=1
		else
			#Determinar el lado de la grilla
			numPatches=(@plants.to_f/@widthPatch**2).ceil
			numPatchesRow=Math.sqrt(numPatches).ceil
			
			#Se actualiza la cantidad de plantas
			@plants=numPatches*@widthPatch**2
		end
		
		@@gridSize=numPatchesRow*(@widthPatch+@gapPatch)
		createGridSpace numPatchesRow
	end
	
	#Crear el escenario de acuerdo a lineas de parches con sus respectivos espacios
	def createGridSpace numPatchesRow
		@@grid=Array.new
		i=0
		j=0
		allPlants=Array.new
		 
		numPatchesRow.times do #Filas de parches
			@widthPatch.times do #Filas de celdas en cada parche
				row=Array.new
				
				numPatchesRow.times do #Columnas de parches
					@widthPatch.times do #Columnas de celdas en cada parche
						row<< Hash.new
						newPlant=Plant.new(i, j)
						row[j]['plant']=newPlant
						allPlants<< newPlant
						j=j+1
					end
					
					row.concat(Array.new(@gapPatch){Hash.new})
					j=j+@gapPatch
				end
				@@grid<<row	###i++
				i=i+1
				j=0
			end
			
			@gapPatch.times do #Filas de espacio entre parches
				@@grid<<Array.new(@@gridSize){Hash.new} #Filas de espacios vacios
				i=i+1
			end
		end
		return allPlants
	end
	
	#attr_reader para @@grid
	def grid
		@@grid
		#~ @@grid.each{
			#~ |row|
			#~ p row
		#~ }
	end
	
end


prueba=Environment.new 2, 5, 10, 12
prueba.grid
