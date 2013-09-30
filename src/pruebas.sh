mkdir -p ../trait-groups/100_10
mkdir -p ../trait-groups/100_100
mkdir -p ../trait-groups/1000_100
mkdir -p ../trait-groups/1000_1000
mkdir -p ../trait-groups/10000_1000
mkdir -p ../trait-groups/10000_10000

#Mutación del 0%, 10% y 1%, 100 generaciones 10 ejecuciones
ruby analysis_start_end.rb 100 10
mv casosRepeticiones_10_0.0.svg ../trait-groups/100_10
ruby analysis_start_end.rb 100 10 0.1
mv casosRepeticiones_10_0.1.svg ../trait-groups/100_10
ruby analysis_start_end.rb 100 10 0.01
mv casosRepeticiones_10_0.01.svg ../trait-groups/100_10
mv log.log ../trait-groups/100_10

#Mutación del 0%, 10% y 1%, 100 generaciones 100 ejecuciones
ruby analysis_start_end.rb 100 100
mv casosRepeticiones_100_0.0.svg ../trait-groups/100_100
ruby analysis_start_end.rb 100 100 0.1
mv casosRepeticiones_100_0.1.svg ../trait-groups/100_100
ruby analysis_start_end.rb 100 100 0.01
mv casosRepeticiones_100_0.01.svg ../trait-groups/100_100
mv log.log ../trait-groups/100_100

#Mutación del 0%
ruby analysis_start_end.rb 1000 100
mv casosRepeticiones_100_0.0.svg ../trait-groups/1000_100
ruby analysis_start_end.rb 1000 1000
mv casosRepeticiones_1000_0.0.svg ../trait-groups/1000_1000
#Mutación del 10%
ruby analysis_start_end.rb 1000 100 0.1
mv casosRepeticiones_100_0.1.svg ../trait-groups/1000_100
ruby analysis_start_end.rb 1000 1000 0.1
mv casosRepeticiones_1000_0.1.svg ../trait-groups/1000_1000
#Mutación del 1%
ruby analysis_start_end.rb 1000 100 0.01
mv casosRepeticiones_100_0.01.svg ../trait-groups/1000_100
ruby analysis_start_end.rb 1000 1000 0.01
mv casosRepeticiones_1000_0.01.svg ../trait-groups/1000_1000

#Mutación del 0%
ruby analysis_start_end.rb 10000 100
mv casosRepeticiones_1000_0.0.svg ../trait-groups/10000_1000
ruby analysis_start_end.rb 10000 1000
mv casosRepeticiones_10000_0.0.svg ../trait-groups/10000_10000
#Mutación del 10%
ruby analysis_start_end.rb 10000 100 0.1
mv casosRepeticiones_1000_0.1.svg ../trait-groups/10000_1000
ruby analysis_start_end.rb 10000 1000 0.1
mv casosRepeticiones_10000_0.1.svg ../trait-groups/10000_10000
#Mutación del 1%
ruby analysis_start_end.rb 10000 100 0.01
mv casosRepeticiones_1000_0.01.svg ../trait-groups/10000_1000
ruby analysis_start_end.rb 10000 1000 0.01
mv casosRepeticiones_10000_0.01.svg ../trait-groups/10000_10000

cd ..
git add trait-groups
git commit -am "Pruebas sin mutación, con el 1% y con el 10%"
git push
