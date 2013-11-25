Estructura de carpetas:
^^^^^^^^^^^^^^^^^^^^^^^
src:
  trait-groups:
    chromosome.rb
    group.rb
    traitGroups.rb
    analysis_start_end.rb
  agents:
    plant.rb
    animal.rb
    environment.rb
    model.rb
    assortment.rb
    analysis.rb
    statistics.rb
    dBConnection.rb
  geneticAlgorithm.rb
  graphic.rb

documento:
  documento.pdf

*************************************

Requerimientos del sistema:
^^^^^^^^^^^^^^^^^^^^^^^^^^^
-Ruby 1.9.2
  Gemas de ruby:
    -bson (1.9.2)
    -bson_ext (1.9.2)
    -mongo (1.9.2)
    -rubyvis (0.5.2)

-Mongodb 2.4.8

*************************************

Ejecución modelo de trait-groups:
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Se pueden ejecutar pruebas equivalentes a las realizadas en el trabajo por medio de la clase Analysis_start_end, cuyo constructor recibe 5 parametros:
  -generations=Cantidad de generaciones para cada ejecución.
  -executions=Cantidad de ejecuciones
  -mutationRate=tasa de mutación. Valor por defecto=0.0
  -killTwoSelfish=true mata los dos desertores cuando se encuentran, false mata sólo uno. Valor por defecto=false.
  -predationTimes=cantidad de encuentros que ocurren dentro de los grupos en la etapa de depredación en términos de la proporción de individuos dentro de cada grupo. Valor por defecto=0.5
Posteriormente se debe llamar al método run y éste genera la imagen resultante del análisis.
  
Por otra parte se puede ejecutar directamente el modelo por medio de la clase TraitGroups, que recibe 5 parámetros:
  -amountGroups: La cantidad de grupos.
  -groupSize: La cantidad de individuos dentro de cada grupo.
  -generations: Cantidad de generaciones.
  -predationTimes=cantidad de encuentros que ocurren dentro de los grupos en la etapa de depredación en términos de la proporción de individuos dentro de cada grupo.
  -mutationRate=tasa de mutación.
  -killTwoSelfish=true mata los dos desertores cuando se encuentran, false mata sólo uno.
Después hay que llamar al método run y se puede acceder a la composición de la población por medio de composition.

*************************************

Ejecución modelo de agentes:
  