#~ $:.unshift '.' #Necesario desde 1.9
require 'cromosoma'

class Grupo

	def initialize tamano
		@tamano = tamano
		@arrCromosomas=Array.new
		
		@cantidadCooperadores=0.0
		@cantidadTraicioneros=0.0
		
		@matrizPago=Array[ [[3,3],[0,5]] , [[5,0],[1,1]] ] #Mas clara en los datos de la implementción
	end
	
	def agregar individuo
		@arrCromosomas << individuo
	end
	
	def poblar
		#Solo es necesario la primera vez que el algoritmo se ejecuta, 
		#después los grupos de destruyen y se crean nuevamente pero los individuos no
		@tamano.times do
			@arrCromosomas << Cromosoma.new
		end
	end
	
	#Evolución durante generaciones dentro de cada grupo
	def correr generaciones
		generaciones.times do
			arrSeleccion=seleccionarCromosomas
			arrSeleccion=mutarSeleccion arrSeleccion
			reemplazarSeleccion arrSeleccion
		end
		contarcomposicion
	end
	
	#Selección
	def seleccionarCromosomas
		result=Array.new
		tamPool=(0.6*@tamano).to_i
		
		tamPool.times do
			indv1=@arrCromosomas[rand(@tamano)]
			indv2=@arrCromosomas[rand(@tamano)]
			
			#Asignar a cada uno el puntaje de acuerdo a la matriz de pago
			indv1.aptitud=@matrizPago[indv1.decision][indv2.decision][0]
			indv2.aptitud=@matrizPago[indv1.decision][indv2.decision][1]
			
			if(indv1.aptitud>indv1.aptitud)
				result << indv1
			elsif(indv1.aptitud<indv2.aptitud)
				result << indv2
			else
				cual=rand(1..2)
				result << ((cual.eql? 1)? indv1: indv2)
			end
		end
		return result
	end
	
	#Mutación
	def mutarSeleccion seleccion
		cantMutados=(0.01*seleccion.size).ceil.to_i
		cantMutados.times do
			cual=rand(seleccion.size)
			seleccion[cual].mutar # SE DEBERÍA EXCLUIR EL CROMOSOMA QUE RECIÉN SE MUTÓ???
		end
		return seleccion
	end
	
	#Reemplazo
	def reemplazarSeleccion seleccion
		cant=seleccion.size
		cant.times do |i|
			pos1=rand(@tamano-i)
			pos2=rand(@tamano-i)
			while pos1 == pos2 do
				pos2=rand(@tamano-i)
			end
			indv1=@arrCromosomas[pos1]
			indv2=@arrCromosomas[pos2]
			
			#Asignar a cada uno el puntaje de acuerdo a la matriz de pago
			indv1.aptitud=@matrizPago[indv1.decision][indv2.decision][0]
			indv2.aptitud=@matrizPago[indv1.decision][indv2.decision][1]
			
			if(indv1.aptitud>indv2.aptitud)
				@arrCromosomas.delete_at pos2
			elsif(indv1.aptitud<indv2.aptitud)
				@arrCromosomas.delete_at pos1
			else
				cual=rand(1..2)
				(cual.eql? 1)? (@arrCromosomas.delete_at pos1) : (@arrCromosomas.delete_at pos2)
			end
		end
		@arrCromosomas.concat seleccion
	end
	
	def contarcomposicion
		@cantidadCooperadores=0
		@cantidadTraicioneros=0
		@arrCromosomas.each do |crom|
			if crom.decision == 0
				@cantidadCooperadores+=1
			else
				@cantidadTraicioneros+=1
			end
		end
	end
	#~ 
	attr_reader :cantidadCooperadores, :cantidadTraicioneros, :arrCromosomas
	
	#Fue para hacer algunas pruebas
	#~ def arrCromosomas
		#~ unless @arrCromosomas.nil?
			#~ name=Array[]
			#~ @arrCromosomas.each do |crom|
				#~ name << crom.val
			#~ end
			#~ return name
		#~ else
			#~ return "Grupo vacio"
		#~ end
	#~ end
end
