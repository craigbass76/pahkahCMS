#!/bin/bash

echo " "

find md/ -mindepth 1 -type d | sed 's/^[^/]*[/]//' | sort -k1 | column;

echo " "

read -ep "Directory Name: " dirName
echo " "
echo " "

ls -a ./md/$dirName/ | grep .md | rev | cut -c4- | rev
read -p "Files: " mdFileName
     
	while true; 
	do
	# dirName=$dirName
     sed -i "3s/.*/date: $(date +"%b %d, %Y")/" ./md/$dirName/$mdFileName.md
     pandoc -s --template="./templates/default.html" -f markdown-smart --toc --toc-depth=4 -c ./stylePDF.css ./md/TOC.md ./md/$dirName/$mdFileName.md -o ./$dirName/$mdFileName.html;
     python3 -m weasyprint -p ./$dirName/$mdFileName.html ./$dirName/$mdFileName.pdf
	 pandoc -s --template="./templates/default-no-title.html" -f markdown-smart --toc --toc-depth=4 -c ./styleWEB.css ./md/TOC.md ./md/$dirName/$mdFileName.md -o ./$dirName/$mdFileName.html;
     sed -i "/<\/nav/i <ul><li><a href=\"$mdFileName.pdf\" class=\"navLinkPDF\">Download a PDF</a></li></ul>" ./$dirName/$mdFileName.html

	 echo " "
	 echo " "
	 read -p "Press [Enter] key to make another PDF, or [Ctrl + C] to kill the script"

    done

#pandoc -s --template="templates/default.html" -f markdown-smart --toc --toc-depth=4 -c ./stylePDF.css ./md/TOC.md ./md/pos/*.md ./md/pos/subtitle.md -o ./Complete-LBM-LiftOff-user-guide.html
