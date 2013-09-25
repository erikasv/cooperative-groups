$:.unshift '.' #Necesario desde 1.9, según parece solo es necesario hacerlo una vez en la capa mas superior
require 'graphic'
require 'rubyvis'


data=data = pv.range(0, 10, 0.2).map {|x| 
  #~ OpenStruct.new({:x=> x, :y=> Math.sin(x) + rand() + 1.5})
  OpenStruct.new({:x=> x, :y=> x**2})
}

Graphic.makeLineChart data, "pruebaLineChart.svg"
