#!/bin/bash

find md/ -mindepth 1 -type d | sed 's/^[^/]*[/]//'

read -p "Directory Name: " dirName
echo " "
echo " "

ls -a ./md/$dirName/ | grep .md | cut -d "." -f 1
read -p "Files: " mdFileName
     
	while true; 
	do
	dirName=$dirName
     
     pandoc -s --template="./templates/default.html" -f markdown-smart --toc --toc-depth=4 -c ./stylePDF.css ./md/TOC.md ./md/$dirName/$mdFileName.md -o ./$dirName/$mdFileName.html;
     python3 -m weasyprint ./$dirName/$mdFileName.html ./$dirName/$mdFileName.pdf
	 pandoc -s --template="./templates/default-no-title.html" -f markdown-smart --toc --toc-depth=4 -c ./styleWEB.css ./md/TOC.md ./md/$dirName/$mdFileName.md -o ./$dirName/$mdFileName.html;
	 echo " "
	 echo " "
	 read -p "Press [Enter] key to make another PDF, or [Ctrl + C] to kill the script"

    done
