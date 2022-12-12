#!/bin/bash

ls -d */ | sed 's/\/*$//g'

read -p "Directory Name: " dirName

	while true; 
	do
		pandoc -s --template="./templates/default.html" -f markdown-smart --toc --toc-depth=3 -c ./stylePDF.css ./md/TOC.md ./md/$dirName/*.md -o ./$dirName/$dirName-user-guide.html
		python3 -m weasyprint ./$dirName/$dirName-user-guide.html ./$dirName/$dirName-user-guide.pdf 
		echo " "
		echo " "
		read -p "Press [Enter] key to make another PDF, or [Ctrl + C] to kill the script"

    done
