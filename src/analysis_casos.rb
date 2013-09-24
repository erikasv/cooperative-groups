$:.unshift '.' #Necesario desde 1.9, según parece solo es necesario hacerlo una vez en la capa mas superior
require 'traitGroups'

#Entrada por consola: generaciones, veces de depredación (por defecto esta es 1)

maxGroups=10
maxGroupSize=10
generations=ARGV[0].to_i
predationTimes=(ARGV[1].to_i == nil)? 1 : ARGV[1].to_i

#Por el momento se harán 3 ejecuciones por cada conficuración
cases=Array.new
generationsContent=Array.new

results=Array.new
# Ejecutar el algoritmo una vez para cada configuracion grupos / tamaño de grupos
for i in 2..maxGroups do
	row=Array.new
	for j in 2..maxGroupSize do
		model=TraitGroups.new i, j, generations, predationTimes
		model.run

		row << model.composition
	end
	results << row
end
model=nil

for i in 0..maxGroups-2 do
	for j in 0..maxGroupSize-2 do
		firstGeneration=results[i][j][0]['altruist']
		lastPosition=results[i][j].size-1
		lastGeneration=results[i][j][lastPosition]['altruist']
		
		if firstGeneration < lastGeneration
			cases << [(i+2),(j+2)]
			generationsContent << results[i][j]
		end
	end
end
results=nil
	
executions=20	
while (not cases.empty?) && (executions > 0)
	thisCase=Array.new
	results=Array.new
	# Ejecutar el algoritmo para cada configuracion grupos / tamaño de grupos
	for i in 2..maxGroups do
		row=Array.new
		for j in 2..maxGroupSize do
			model=TraitGroups.new i, j, generations, predationTimes
			model.run

			row << model.composition
		end
		results << row
	end
	model=nil
	
	for i in 0..maxGroups-2 do
		for j in 0..maxGroupSize-2 do
			firstGeneration=results[i][j][0]['altruist']
			lastPosition=results[i][j].size-1
			lastGeneration=results[i][j][lastPosition]['altruist']

			if firstGeneration < lastGeneration
				thisCase << [(i+2),(j+2)]
			end
		end
	end	
	results=nil
	
	cases.each_index{
		|i|
		if ( thisCase.index(cases[i]) ) == nil
			cases.delete_at(i)
			generationsContent.delete_at(i)
		end
	}
	
	executions-=1
end

if not cases.empty?
	fileCase=File.new("successfulCase.txt","w+")
	cases.each_index {
		|i|
		fileCase.write("#{cases[i]} \n")
		fileCase.write("#{generationsContent[i]}\n")
	}
	fileCase.close
end
