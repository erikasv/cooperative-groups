$:.unshift '.' #Necesario desde 1.9
require 'model'
require 'assortment'
require 'analysis'

#~ 10.times do |execTime|
	#~ model=Model.new execTime
	#~ model.run 10000
	#~ model=nil
#~ end

#~ 10.times do |execTime|
	#~ assortment=Assortment.new execTime, 10000
	#~ assortment.meassureAssortment
	#~ assortment=nil
#~ end

analysis=Analysis.new 10, 10000
analysis.calculateGraphicValues
graphicAssortment "graphic_assortment.svg"
