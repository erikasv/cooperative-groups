$:.unshift '.' #Necesario desde 1.9, según parece solo es necesario hacerlo una vez en la capa mas superior
require 'algoritmoGenetico'

resultados=Array.new

for i in 2..10 do
	for j in 2..20 do
		algoritmo=AlgoritmoGenetico.new 10, i, j, 10
		algoritmo.correrAlgoritmo
		
		cantCoop=algoritmo.cooperadores
		cantTrai=algoritmo.traicioneros

		puts "10:#{i}:#{j}:10 => #{cantCoop}-#{cantTrai}"
	end
end
