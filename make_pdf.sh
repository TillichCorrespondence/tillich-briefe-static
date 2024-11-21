cd tex 
xelatex -interaction=nonstopmode tmp.tex
xelatex -interaction=nonstopmode tmp.tex
mv tmp.pdf ../html/tillich-briefe.pdf
rm tmp.*
rm *.idx
rm *.ilg
rm *.ind
