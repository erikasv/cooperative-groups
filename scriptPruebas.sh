#ejecutar el algoritmo
ruby analisis.rb

mv generaciones.txt generaciones2.txt
mv inicio.svg inicio2.svg
mv final.svg final2.svg
mv comparacion.svg comparacion2.svg
mv generaciones2.txt inicio2.svg final2.svg comparacion2.svg pruebas_1000_1000

#Repitis
ruby analisis.rb

mv generaciones.txt generaciones3.txt
mv inicio.svg inicio3.svg
mv final.svg final3.svg
mv comparacion.svg comparacion3.svg
mv generaciones3.txt inicio3.svg final3.svg comparacion3.svg pruebas_1000_1000

#Commit
git commit -am "Pruebas finales con 1000 generaciones y 1000 mezclas"
git push