class Plant
	@@maxSize=10 #Valor por defecto= al expuesto en el artículo
	@@logisticRate=0.2 #Valor por defecto= al expuesto en el artículo
	#Posición
	
	def initialize posX, posY
		@energy=rand(@@maxSize) #Solo serán enteros, para flotantes usar un objeto de Random
		@posX=posX
		@posY=posY
	end
	
	#Función de crecimiento dado por una curva logistica.
	def grow
		stepGrowth=@logisticRate*@energy*( (@@maxSize-@energy)/@energy )
		@energy=@energy+stepGrowth
	end
	
	#~ def to_s
		#~ "#{@energy}: #{@posX}-#{@posY}"
	#~ end
	
	#Por la pereza de escribir los métodos para cada variable
	#~ self.class_variables.each{ |sym| class_eval("def self.#{sym.to_s.gsub('@@','')}; #{sym}; end;")}
	self.class_variables.each{ |sym| class_eval("def self.#{sym.to_s.gsub('@@','')}= val; #{sym}=val; end;")}
end

