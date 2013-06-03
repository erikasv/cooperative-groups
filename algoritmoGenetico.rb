$:.unshift '.' #Necesario desde 1.9, según parece solo es necesario hacerlo una vez en la capa mas superior
require 'grupo'

class AlgoritmoGenetico
	
	def initialize generaciones cantGrupos tamGrupo generacionesGrupo
		@generaciones=generaciones
		@cantGrupos=cantGrupos
		@tamGrupo=tamGrupo
		@generacionesGrupo=generacionesGrupo
		
		@promCooperadores=0
		@promTraicioneros=0
		
		@arrGrupos=Array[cantGrupos]
		@arrGrupos.each do |grupo|
			grupo= Grupo.new tamGrupo
			grupo.poblar
		end
	end
	
	def correrAlgoritmo
		generaciones.times
			correrGrupos
		end
	end
	
	def correrGrupos
		@arrGrupos.each do |grupo|
			grupo.correr @generacionesGrupo
			@promCooperadores+=grupo.cantidadCooperadores
			@promTraicioneros+=grupo.cantidadTraicioneros
		end
		#Promedio sobre el total de la población
		@promCooperadores/=(cantGrupos*tamGrupo)
		@promTraicioneros/=(cantGrupos*tamGrupo)
	end
	
end

a=AlgoritmoGenetico.new
p a.crom
