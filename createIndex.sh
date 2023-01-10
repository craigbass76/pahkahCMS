#!/bin/bash
shopt -s extglob

        # Starting a table of contents 
        echo '<nav id="TOC">
	<div id="contentsbox"><a href="./"><img src="./images/WHT.svg"></a></div>
	<ul>' > ./TOC.html;
	
		# Show me all the directories that do NOT start with z-, 
		# and for each of those, we're doing a bunch of shit
		
		for i in $(ls -d ./md/!(z-*)/ | cut -c6- | rev | cut -c2- | rev)
		
        do
		# Snagging the title of the section (Point of Sale, Accounts Receivable, etc.)
		# from the z-sectionDesc.md file in each of those directories
		linkTitle=$(head -1 ./md/$i/z-sectionDesc.md | cut -c 4-)
		
		# Then writing a link line to a TOC file
		echo "	 <li><a href=\"./$i/\">$(echo $linkTitle)</a>" >> ./TOC.html;	
        
        done    
        
        # Finishing the TOC
        echo "	</ul>" >> ./TOC.html;
        echo "</nav>" >> ./TOC.html;
        
        # Writing out our index md file to a temporary html one
        pandoc ./md/index.md -o ./tmpindex.html;
        
        # Now we start reading different things into our final index.html file
        echo '
<html xmlns="http://www.w3.org/1999/xhtml" lang="" xml:lang="">
<head>
  <link rel="icon" href="../images/WHT.svg">
  <meta charset="utf-8" />
  <meta name="generator" content="pandoc" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=yes" />
  <title>Pahkah CMS</title>
  <link rel="stylesheet" href="./styleWEB.css" />
</head>
<body>' > ./index.html;
        cat TOC.html >> ./index.html;
        cat header2.html >> ./index.html;
        cat tmpindex.html >> ./index.html;
        cat footer.html >> ./index.html;
        
        # Now clean up some mess
        rm tmpindex.html
        rm TOC.html
        

