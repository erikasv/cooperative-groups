
EMERGENCIA EVOLUTIVA DE GRUPOS COOPERATIVOS GUIADOS POR EL ENTORNO
Erika Suárez Valencia

-----------------------------------------------------------------------------------------------

Estructura de carpetas:
^^^^^^^^^^^^^^^^^^^^^^^
src:
  trait-groups: (Modelo de trait-groups)
    chromosome.rb
    group.rb
    traitGroups.rb
    analysis_start_end.rb
    doc:	(Documentación del modelo de trait-groups)
      index.html
  agents:	(Modelo de agentes)
    plant.rb
    animal.rb
    environment.rb
    model.rb
    assortment.rb
    analysis.rb
    statistics.rb
    dBConnection.rb
    doc:	(Documentación del modelo de agentes)
      index.html
  geneticAlgorithm.rb
  graphic.rb

documento:	(El mismo documento impreso)
  documento.pdf
 
README.txt	(Este archivo)

-----------------------------------------------------------------------------------------------

Requerimientos del sistema:
^^^^^^^^^^^^^^^^^^^^^^^^^^^
-Ruby 1.9.2
  Gemas de ruby:
    -bson (1.9.2)
    -bson_ext (1.9.2)
    -mongo (1.9.2)
    -rubyvis (0.5.2)

-Mongodb 2.4.8

-----------------------------------------------------------------------------------------------

Ejecución modelo de trait-groups:
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Se pueden ejecutar pruebas equivalentes a las realizadas en el trabajo por medio de la clase "Analysis_start_end", cuyo constructor recibe 5 parametros:
  -generations: Cantidad de generaciones para cada ejecución.
  -executions: Cantidad de ejecuciones
  -mutationRate: tasa de mutación. Valor por defecto=0.0
  -killTwoSelfish: true mata los dos desertores cuando se encuentran, false mata sólo uno. Valor por defecto=false.
  -predationTimes: cantidad de encuentros que ocurren dentro de los grupos en la etapa de depredación en términos de la proporción de individuos dentro de cada grupo. Valor por defecto=0.5
Posteriormente se debe llamar al método run y éste genera la imagen resultante del análisis.
  
Por otra parte se puede ejecutar directamente el modelo por medio de la clase "TraitGroups", que recibe 5 parámetros:
  -amountGroups: La cantidad de grupos.
  -groupSize: La cantidad de individuos dentro de cada grupo.
  -generations: Cantidad de generaciones.
  -predationTimes=cantidad de encuentros que ocurren dentro de los grupos en la etapa de depredación en términos de la proporción de individuos dentro de cada grupo.
  -mutationRate=tasa de mutación.
  -killTwoSelfish=true mata los dos desertores cuando se encuentran, false mata sólo uno.
Después hay que llamar al método run y se puede acceder a la composición de la población por medio de composition.

-----------------------------------------------------------------------------------------------

Ejecución modelo de agentes:
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

El modelo escribe datos en la base de datos "agentsModel", con colecciones para guardar los animales, las plantas, la composición de cada grupo en cada unidad de tiempo y el assortment.

La clase Model realiza la ejecución del modelo con los parámetros que recibe el constructor:
  -executionTime: Número para la ejecución que se está realizando.
  -width: Ancho del parche de plantas en celdas. Valor por defecto=4
  -gap: Espacio en celdas que hay entre los parches en cada eje. Valor por defecto=10
  -minPlants: Mínima cantidad de plantas en el ambiente. Valor por defecto=1000
  -maxEnergyPlants: Máxima energía que puede tener una planta. Valor por defecto=10
  -plantsRate: Tasa logística para la función de crecimiento de las plantas. Valor por defecto=0.2
  -metabolicCost: Costo metabólico por unidad de tiempo para los animales. Valor por defecto=2
  -amountAnimals: Cantidad de animales en el ambiente. Valor por defecto=80
Después debe llamarse al método "run" con la cantidad de unidades de tiempo a ejecutar.

Al terminar la ejecución, hay dos pasos para hacer el análisis:
  1. Instanciar la clase "Assortment" con la cantidad de ejecuciones que se realizaron y las unidades de tiempo en cada ejecución. Y llamar al método "meassureAssortment".
  2. Instanciar la clase "Analysis" con la cantidad de ejecuciones que se realizaron y las unidades de tiempo en cada ejecución. Después se puede llamar a alguno de estos métodos:
    -graphicAssortment: Genera la gráfica del cálculo del coeficiente de regresión entre G_W y G_A
    -graphicAnalysis: Genera la gráfica del cálculo del assortment: r_a = r - r_s
  