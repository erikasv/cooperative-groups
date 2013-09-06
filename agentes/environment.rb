class Environment
	@@grid
	@@gridSize ##Aun no estoy segura si es necesario
	
	def initialize width, gap, minPlants
		@plants=minPlants
		@gapPatch=gap
		@widthPatch=width
		
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
		 
		numPatchesRow.times do #Filas de parches
			@widthPatch.times do #Filas de celdas en cada parche
				row=Array.new
				
				numPatchesRow.times do #Columnas de parches
					@widthPatch.times do #Columnas de celdas en cada parche
						row<< "p" #TEMPORAL!! Crear planta aqui	###[i][j]="p", j++
					end
					
					@gapPatch.times do #Columnas de espacio entre parches
						row<<" " #TEMPORAL?? -> Espacio vacío	###[i][j]=nil, j++
					end
				end
				@@grid<<row	###i++
			end
			
			@gapPatch.times do #Filas de espacio entre parches
				@@grid<<Array.new(@@gridSize){" "} #Filas de espacios vacios ###for para columnas->[i][j]=nil, i++
			end
		end
		
	end
	
	#~ #Función de prueba
	#~ def myPrint
		#~ @@grid.each{
			#~ |i|
			#~ p i
		#~ }
	#~ end
	
end

prueba=Environment.new 2, 5, 10
#~ prueba.myPrint
