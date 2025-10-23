# Generate single letter PDFs
cd tex
for texfile in L*.tex; do
    xelatex -interaction=nonstopmode "$texfile"
    xelatex -interaction=nonstopmode "$texfile"
    mv "${texfile%.tex}.pdf" ../html/
    rm "${texfile%.tex}."*
done
rm *.idx *.ilg *.ind
cd ..

# Generate collection PDFs
cd tex

xelatex -interaction=nonstopmode tmp.tex
xelatex -interaction=nonstopmode tmp.tex
mv tmp.pdf ../html/tillich-briefe.pdf
rm tmp.*
rm *.idx
rm *.ilg
rm *.ind


xelatex -interaction=nonstopmode sk-tmp.tex
xelatex -interaction=nonstopmode sk-tmp.tex
mv sk-tmp.pdf ../html/tillich-briefe-sk.pdf
rm sk-tmp.*
rm *.idx
rm *.ilg
rm *.ind