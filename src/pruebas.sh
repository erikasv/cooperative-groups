ruby analysis.rb 100
mv *txt *svg ../trait-groups/100
ruby analysis.rb 1000
mv *txt *svg ../trait-groups/1000
ruby analysis.rb 10000
mv *txt *svg ../trait-groups/10000

cd ..
git add trait-groups
git commit -am "Algunas pruebas"
git push
