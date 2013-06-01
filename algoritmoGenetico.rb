$:.unshift '.' #Necesario desde 1.9, según parece solo es necesario hacerlo una vez en la capa mas superior
require 'grupo'

class AlgoritmoGenetico
	
	def initialize generaciones cantGrupos tamGrupo generacionesGrupo
		@generaciones=generaciones
		@cantGrupos=cantGrupos
		@tamGrupo=tamGrupo
		@generacionesGrupo=generacionesGrupo
		
		@arrGrupos=Array[cantGrupos]
		@arrGrupos.each do |grupo|
			grupo= Grupo.new tamGrupo
			grupo.poblar
		end
	end
	
	def correrAlgoritmo
		generaciones.times do |i|
			correrGrupos #Será necesario send???
		end
	end
	
	def correrGrupos
		@arrGrupos.each do |grupo|
			grupo.correr @generacionesGrupo
		end
	end
	
end

a=AlgoritmoGenetico.new
p a.crom
