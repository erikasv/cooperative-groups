ruby analisis.rb 100 100 1
ruby analisis.rb 100 100 2
ruby analisis.rb 100 100 3

mkdir ../nuevas_100_100
mv *txt *svg ../nuevas_100_100

ruby analisis.rb 100 1000 1
ruby analisis.rb 100 1000 2
ruby analisis.rb 100 1000 3

mkdir ../nuevas_100_1000
mv *txt *svg ../nuevas_100_1000

ruby analisis.rb 1000 1000 1
ruby analisis.rb 1000 1000 2
ruby analisis.rb 1000 1000 3

mkdir ../nuevas_1000_1000
mv *txt *svg ../nuevas_1000_1000

cd ../..
git add trait-groups/nuevas_100_100 trait-groups/nuevas_100_1000 trait-groups/nuevas_1000_1000
git commit -am "Nuevas pruebas"
git push