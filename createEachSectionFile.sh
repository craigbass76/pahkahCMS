#!/bin/bash

find md/ -mindepth 1 -type d | sed 's/^[^/]*[/]//'

read -p "Directory Name: " dirName

	while true; 
	do
		dirName=$dirName

        echo '<nav id="TOC">
	<div id="contentsbox"><a href="../"><img src="../images/liftoffLogo.svg"></a></div>
	<ul>' > ./$dirName/$dirName-TOC.html;
	
	    #rm ./html/$dirName/z*;
		for i in $(ls ./md/$dirName/ --ignore="z-subtitle.md" | grep .md | cut -d "." -f 1)
        do
		pandoc -s --template="./templates/default.html" -f markdown-smart --toc --toc-depth=4 -c ./stylePDF.css ./md/TOC.md ./md/$dirName/$i.md -o ./$dirName/$i.html;
		fileTitle=$(head -5 ./md/$dirName/$i.md | sed -n 's/^.*subtitle://p')
		
		echo "	 <li><a href=\"./$i.html\">$(echo $fileTitle)</a>" >> ./$dirName/$dirName-TOC.html;
		python3 -m weasyprint ./$dirName/$i.html ./$dirName/$i.pdf
		pandoc -s --template="./templates/TOC-ONLY.html" -f markdown-smart -c ./styleWEB.css ./md/TOC.md ./md/$dirName/$i.md -o ./$dirName/$i-TOC.html;
        pandoc -s --template="./templates/default-no-title.html" -f markdown-smart --toc --toc-depth=4 -c ./styleWEB.css ./md/TOC.md ./md/$dirName/$i.md -o ./$dirName/$i.html;
		sed -i "/<\/nav/i <a href=\"$i.pdf\" class=\"navLinkPDF\">Download a PDF</a>" ./$dirName/$i.html
		rm ./$dirName/$i-TOC.html;
		
        done    
        echo "	</ul>" >> ./$dirName/$dirName-TOC.html;
        echo "</nav>" >> ./$dirName/$dirName-TOC.html;
        cat header.html > ./$dirName/index.html;
        cat ./$dirName/$dirName-TOC.html >> ./$dirName/index.html;
        cat footer.html >> ./$dirName/index.html;
        rm ./$dirName/$dirName-TOC.html;
#        rsync -avz $dirName /home/craig/craigEC2/documentation/
#        rsync -avz images/ /home/craig/craigEC2/documentation/images/
        echo " "
		echo " "
		read -p "Press [Enter] key to make another PDF, or [Ctrl + C] to kill the script"		
    done
