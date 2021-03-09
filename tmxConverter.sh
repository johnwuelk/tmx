#!/bin/bash
# this script converts a tab delimited text file into a tmx file.
#
inputTxtFile=$1; #argument: tab-delimited text file
outputTmxFile="${1//'.txt'/''}.tmx"

if [[ $# -eq 1 ]]; then
    read -n 2 -p $'Enter source language (2 characters): ' sourceLang
    read -n 2 -p $'\nEnter target language (2 characters): ' targetLang
    echo $'\n\nsource: '$sourceLang''
    echo $'target: '$targetLang''
    echo $'A rerun would overwrite the existing file'
    echo '<tmx version="1">
  <header
    creationtool="TMX_Linux_Bash" creationtoolversion="1"
    datatype="PlainText" segtype="sentence"
    adminlang="de" srclang="'$sourceLang'"/>
  <body>' > $outputTmxFile
    
    while IFS= read -r line; do
        echo '    <tu>
      <tuv xml:lang="'$sourceLang'">        ' >> $outputTmxFile
	line=${line//'<'/'&lt;'}
	line=${line//'>'/'&gt;'}
        source=$(echo "$line" | cut -d $'\t' -f 1)
        target=$(echo "$line" | cut -d $'\t' -f 2)
        echo "        <seg>$source</seg>" >> $outputTmxFile
        echo '      </tuv>' >> $outputTmxFile
        echo '      <tuv xml:lang="'$targetLang'">' >> $outputTmxFile
        echo "        <seg>$target</seg>" >> $outputTmxFile
        echo '      </tuv>' >> $outputTmxFile
        echo '    </tu>' >> $outputTmxFile
    done < $1
    echo '  </body>' >> $outputTmxFile
    echo '</tmx>' >> $outputTmxFile
else
    echo "Correct Usage: 'tmx tab-delimited-text.txt'"
fi
