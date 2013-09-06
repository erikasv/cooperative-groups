class Environment
	@@grid
	@@gridSize ##Aun no estoy segura si es necesario
	
	def initialize width, gap, minPlants
		@plants=minPlants
		@gapPatch=gap
		@widthPatch=width
		
		numPatchesRow=0 #Necesario aqui?
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
	
	def createGridSpace numPatchesRow
		@@grid=Array.new
		
		#Crear el escenario de acuerdo a lineas de parches con sus respectivos espacios
		#Filas de parches:
		numPatchesRow.times do
		
			#Filas en cada parche:
			@widthPatch.times do
				row=Array.new
				
				#Columnas de parches:
				numPatchesRow.times do
				
					#Columnas en cada parche
					@widthPatch.times do
						row<< "p" #TEMPORAL!! Crear planta aqui	###[i][j]="p", j++
					end
					
					#Columnas de espacio entre parches
					@gapPatch.times do
						row<<" " #TEMPORAL?? -> Espacio vacío	###[i][j]=nil, j++
					end
				end
				@@grid<<row	###i++
			end
			
			#Filas de espacio entre parches:
			@gapPatch.times do
				@@grid<<Array.new(@@gridSize){" "} #Filas de espacios vacios ###for para columnas->[i][j]=nil, i++
			end
		end
		
	end
	
	def myPrint
		@@grid.each{
			|i|
			p i
		}
	end
	
end

prueba=Environment.new 4, 10, 1000
prueba.myPrint
