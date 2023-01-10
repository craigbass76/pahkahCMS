#!/bin/bash

while true; do

echo " ";

find md/ -mindepth 1 -type d | sed 's/^[^/]*[/]//' | sort -k1 | column;

echo " "

read -p "Directory Name: " dirName

ls -a ./md/$dirName/ | grep .md | rev | cut -c4- | rev | sort -k1 | column;

echo " "

read -ep "Old Files: " curFileName
read -ep "New File: " newFileName

	
# Get the file renamed, then update the html so that it's got
# a link to the PDF's new filename
	
	mv ./md/$dirName/$curFileName.md ./md/$dirName/$newFileName.md
	mv ./$dirName/$curFileName.html ./$dirName/$newFileName.html
	mv ./$dirName/$curFileName.pdf ./$dirName/$newFileName.pdf
	sed -i "s/$curFileName.pdf/$newFileName.pdf/" ./$dirName/$newFileName.html

# Run the building routine for all of the html in this directory

	echo '<nav id="TOC">
	<div id="contentsbox"><a href="../"><img src="../images/liftoffLogo.svg"></a></div>
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

done
