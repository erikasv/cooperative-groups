ruby analysis.rb 100 10
mv casosRepeticiones.svg ../trait-groups/100_10
ruby analysis.rb 100 100
mv casosRepeticiones.svg ../trait-groups/100_100
ruby analysis.rb 1000 10
mv casosRepeticiones.svg ../trait-groups/1000_10
ruby analysis.rb 1000 100
mv casosRepeticiones.svg ../trait-groups/1000_100
ruby analysis.rb 10000_10
mv casosRepeticiones.svg ../trait-groups/10000_10
ruby analysis.rb 10000_100
mv casosRepeticiones.svg ../trait-groups/10000_100

cd ..
git add trait-groups
git commit -am "Añadidos los gráficos de cuantas veces se repite cada caso. Seleccionar 1 o 2 para pruebas más detalladas"
git push
