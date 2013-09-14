class Plant
	@@maxSize #Valor por defecto= al expuesto en el artículo, puesto en modelo.rb
	@@logisticRate #Valor por defecto= al expuesto en el artículo puesto en modelo.rb
	
	def initialize posX, posY
		@energy=rand(@@maxSize).to_f #Solo serán enteros, para flotantes usar un objeto de Random
		@posX=posX
		@posY=posY
	end
	
	#Función de crecimiento dado por la curva logistica del artículo.
	def grow
		if @energy<@@maxSize
			stepGrowth=@@logisticRate*@energy*( (@@maxSize-@energy)/@energy )
			if @energy+stepGrowth <= @@maxSize
				@energy=@energy+stepGrowth
			else
				@energy=@@maxSize
			end
		end
	end
	
	def beEaten amount
		@energy=@energy-amount
	end
	
	#Writers para las variables de clase
	def self.maxSize= val
		@@maxSize=val
	end
	
	def self.logisticRate= val
		@@logisticRate=val
	end
	
	attr_reader :energy, :posX, :posY
	
	#~ def to_s
		#~ "#{@energy}: #{@posX}-#{@posY}"
	#~ end
end

