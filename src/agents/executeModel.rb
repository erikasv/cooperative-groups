require 'model'
require 'assortment'

10.times do |execTime|
	model=Model.new execTime
	model.run 10000
end

10.times do |execTime|
	assortment=Assortment.new execTime, 10000
	assortment.meassureAssortment
end
