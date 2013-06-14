$:.unshift '.' #Necesario desde 1.9, según parece solo es necesario hacerlo una vez en la capa mas superior
require 'algoritmoGenetico'

#Ejecucución del algoritmo con diferentes parametros
grupos_maximo=10
individuos_maximo=10

datos_generaciones=File.new("generaciones.txt","w+")

resultados=Array.new
for i in 2..grupos_maximo do
	fila=Array.new
	for j in 2..individuos_maximo do
		columna=Array.new
		algoritmo=AlgoritmoGenetico.new 10, i, j, 10
		algoritmo.correrAlgoritmo
		
		cantCoop=algoritmo.cooperadores
		cantTrai=algoritmo.traicioneros

		columna << algoritmo.cooperadores << algoritmo.traicioneros
		fila << columna
		#Se escriben los datos de todas las generaciones por si las moscas
		datos_generaciones.write("10:#{i}:#{j}:10 => #{cantCoop}-#{cantTrai}\n")
	end
	resultados << fila
end
datos_generaciones.close

#
