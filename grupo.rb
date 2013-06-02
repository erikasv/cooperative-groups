#~ $:.unshift '.' #Necesario desde 1.9
require 'cromosoma'

class Grupo

	def initialize tamano#Por el momento no se si necesito algo
		@tamano = tamano
		@arrCromosomas=Array.new
		@genRandom=Random.new
		
		@matrizPago=Array[[[3,3],[0,5]],[[5,0],[1,1]]] #Mas clara en los datos de la implementción
	end
	
	def agregar individuo
		@arrCromosomas << individuo
	end
	
	def poblar
		#Solo es necesario la primera vez que el algoritmo se ejecuta, 
		#después los grupos de destruyen y se crean nuevamente, pero los individuos no
		gen=Random.new
		for i in 1..@tamano
			@arrCromosomas << Cromosoma.new
		end
	end
	
	def correr generaciones
		generaciones.times do |t|
			arrSeleccion=seleccionarCromosomas #~ QUEDE AQUÍ
			arrSeleccion=mutarSeleccion arrSeleccion
			reemplazarSeleccion arrSeleccion
		end
	end
	
	def seleccionarCromosomas
		result=Array[]
		tamPool=(0.6*@tamano).to_i
		
		tamPool.times do |c|
			indv1=@genRandom.rand(@tamano)
			indv2=@genRandom.rand(@tamano)
			
			#Asignar a cada uno el puntaje de acuerdo a la matriz de pago
			indv1.aptitud=matrizPago[indv1.funcAptitud][indv2.funcAptitud][0]
			indv2.aptitud=matrizPago[indv1.funcAptitud][indv2.funcAptitud][1]
			
			if(indv1.aptitud>indv2.aptitud)
				result << indv1
			if(indv1.aptitud<indv2.aptitud)
				result << indv2
			else
				which=@genRandom.rand(1..2)
				result << ((which.eql? 1)? indv1: indv2)
			end
		end
		return result
	end
	
	def arrCromosomas
		unless @arrCromosomas.nil?
			name=Array[]
			@arrCromosomas.each do |crom|
				name << crom.val
			end
			return name
		else
			return "Crupo vacio"
		end
	end
	
	def eliminar
		@arrCromosomas=nil
	end
end

#~ g=Grupo.new 4
#~ g.poblar
#~ p g.arrCromosomas
#~ 
#~ prueba= Array[]
#~ prueba+=g.arrCromosomas
#~ p prueba
#~ 
#~ g.eliminar
#~ p g.arrCromosomas
#~ p prueba
