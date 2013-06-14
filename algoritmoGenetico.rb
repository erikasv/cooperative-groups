#~ $:.unshift '.' #Necesario desde 1.9, según parece solo es necesario hacerlo una vez en la capa mas superior
require 'grupo'

class AlgoritmoGenetico
	
	def initialize generaciones, cantGrupos, tamGrupo, generacionesGrupo
		@generaciones=generaciones
		@cantGrupos=cantGrupos
		@tamGrupo=tamGrupo
		@generacionesGrupo=generacionesGrupo
		
		@cooperadores=Array.new
		@traicioneros=Array.new
		
		@arrGrupos=Array.new
		@cantGrupos.times do
			grupo= Grupo.new tamGrupo
			grupo.poblar
			@arrGrupos << grupo
		end
	end
	
	def correrAlgoritmo
		@generaciones.times do
			correrGrupos
		end
	end
	
	def correrGrupos
		coop=0
		trai=0
		@arrGrupos.each do |grupo|
			grupo.correr @generacionesGrupo
			coop+=grupo.cantidadCooperadores
			trai+=grupo.cantidadTraicioneros
		end
		cooperadores << coop
		traicioneros << trai
		#Promedio sobre el total de la población
		#~ @cooperadores/=(cantGrupos*tamGrupo)
		#~ @traicioneros/=(cantGrupos*tamGrupo)
			#Por ahora, mejor tengo la cantidad total
		
	end

	attr_reader :cooperadores, :traicioneros
	
end
