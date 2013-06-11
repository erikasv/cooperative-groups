$:.unshift '.' #Necesario desde 1.9, según parece solo es necesario hacerlo una vez en la capa mas superior
require 'algoritmoGenetico'

#Ejecucución del algoritmo con diferentes parametros
resultados=Array.new
for i in 2..4 do
	fila=Array.new
	for j in 2..4 do
		columna=Array.new
		algoritmo=AlgoritmoGenetico.new 10, i, j, 10
		algoritmo.correrAlgoritmo
		
		cantCoop=algoritmo.cooperadores
		cantTrai=algoritmo.traicioneros

		columna << algoritmo.cooperadores << algoritmo.traicioneros
		fila << columna
		#~ puts "10:#{i}:#{j}:10 => #{cantCoop}-#{cantTrai}"
	end
	resultados << fila
end

for i in 2..4 do
	for j in 2..4 do
	print "10:#{i}:#{j}:10 => #{resultados[i-2][j-2]}"
	end
	puts
end
