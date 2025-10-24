echo "Generate single letter PDFs"
cd tex
for texfile in L*.tex; do
    xelatex -interaction=nonstopmode "$texfile"
    mv "${texfile%.tex}.pdf" ../html/
    rm -f "${texfile%.tex}".{aux,log,out,toc} 2>/dev/null
done
rm *.idx *.ilg *.ind
cd ..

echo "Generate collection PDFs"
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