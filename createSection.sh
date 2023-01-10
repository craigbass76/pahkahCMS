#!/bin/bash

echo " ";

find md/ -mindepth 1 -type d | sed 's/^[^/]*[/]//' | sort -k1 | column;

echo " "

read -ep "Directory Name: " dirName

	while true; 
	do
	
	echo '<nav id="TOC">
	<div id="contentsbox"><a href="../"><img src="../images/WHT.svg"></a></div>
	<ul>' > ./$dirName/$dirName-TOC.html;
	
	for i in $(ls ./md/$dirName/ --ignore={z*,x*} | grep .md | rev | cut -c4- | rev)
	do
	fileTitle=$(head -5 ./md/$dirName/$i.md | sed -n 's/^.*subtitle://p')
	echo "	 <li><a href=\"./$i.html\">$(echo $fileTitle)</a>" >> ./$dirName/$dirName-TOC.html;
	done
	echo "	</ul>" >> ./$dirName/$dirName-TOC.html;
    echo "</nav>" >> ./$dirName/$dirName-TOC.html;
	cat header.html > ./$dirName/index.html;
    cat ./$dirName/$dirName-TOC.html >> ./$dirName/index.html;
    cat header2.html >> ./$dirName/index.html;
	pandoc ./md/$dirName/z-sectionDesc.md -o ./$dirName/z-sectionDesc.html;
	cat ./$dirName/z-sectionDesc.html >> ./$dirName/index.html;
    cat footer.html >> ./$dirName/index.html;
    rm ./$dirName/$dirName-TOC.html;
    rm ./$dirName/z-sectionDesc.html
        
		echo " "
		echo " "
		read -p "Press [Enter] key to make another PDF, or [Ctrl + C] to kill the script"

    done
