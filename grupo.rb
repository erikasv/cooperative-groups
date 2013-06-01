#~ $:.unshift '.' #Necesario desde 1.9
require 'cromosoma'

class Grupo

	def initialize tamano#Por el momento no se si necesito algo
		@tamano = tamano
		@arrCromosomas=Array.new
		@genRandom=Random.new
		
		@matrizPago=Array[] #TERMINAR MATRIZ Y ALGORITMO DENTRO DE LOS GRUPOS
	end
	
	def agregar individuo
		@arrCromosomas << individuo
	end
	
	def poblar
		#No al crear el grupo porque solo es necesario la primera vez que el algoritmo se ejecuta
		gen=Random.new
		for i in 1..@tamano
			@arrCromosomas << Cromosoma.new
		end
	end
	
	def correr generaciones
		generaciones.times do |t|
			arrSeleccion=seleccionarCromosomas
			arrSeleccion=mutarSeleccion arrSeleccion
			reemplazarSeleccion
		end
	end
	
	def seleccionarCromosomas
		result=Array[]
		tamPool=(0.6*@tamano).to_i
		
		tamPool.times do |c|
			indv1=@genRandom.rand(@tamano)
			indv2=@genRandom.rand(@tamano)
			
		end
	end
	
	def arrCromosomas
		unless @arrCromosomas.nil?
			#~ name=Array[self.object_id]
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
