#!/bin/bash

initialPath="/tmp/usr/"

#results=$( egrep -r '[0-9]{3}-[0-9]{2}-[0-9]{3}' $path );

#echo $results;

sumFiles=0

function findFiles
{
	local path=$1

	for var in `ls $path`;		# for every file or directory in the tmp/usr directory
	do	
		echo "$path$var"

		if [ -f "$path$var" ] && [ -r "$path$var" ];	# this is a readable file
		then 
			ext=$( echo $path$var | awk -F . '{print $NF}' )
			if [ "$ext" = "gz" ]; then
				gzip -dc $path$var > /tmp/nlarosa
				egrep '\s[0-9]{3}-[0-9]{2}-[0-9]{3}\s' /tmp/nlarosa
				if [ $? -eq 0 ]; then
					echo "\\item \\begin{verbatim}Found SSN in $var at path: $path$var\\end{verbatim}" >> ssnReport.tex
					let sumFiles=sumFiles+1
				fi
				rm /tmp/nlarosa
			elif [ "$ext" = "bz" ]; then
				bzcat $path$var > /tmp/nlarosa
				egrep '\s[0-9]{3}-[0-9]{2}-[0-9]{3}\s' /tmp/nlarosa
				if [ $? -eq 0 ]; then
					echo "\\item \\begin{verbatim}Found SSN in $var at path: $path$var\\end{verbatim}" >> ssnReport.tex
					let sumFiles=sumFiles+1
				fi
				rm /tmp/nlarosa
			elif [ "$ext" = "bz2" ]; then
				bzcat $path$var > /tmp/nlarosa
				egrep '\s[0-9]{3}-[0-9]{2}-[0-9]{3}\s' /tmp/nlarosa
				if [ $? -eq 0 ]; then
					echo "\\item \\begin{verbatim}Found SSN in $var at path: $path$var\\end{verbatim}" >> ssnReport.tex
					let sumFiles=sumFiles+1
				fi
				rm /tmp/nlarosa
			else
				egrep '\s[0-9]{3}-[0-9]{2}-[0-9]{3}\s' $path$var
				if [ $? -eq 0 ]; then
					echo "\\item \\begin{verbatim}Found SSN in $var at path: $path$var\\end{verbatim}" >> ssnReport.tex
					let sumFiles=sumFiles+1
				fi
			fi
		elif [ -d "$path$var" ] && [ -r "$path$var" ];
		then
			findFiles "$path$var/"
		fi
	done
}

echo "\\documentclass{article}" > ssnReport.tex
echo "\\usepackage{verbatim}" >> ssnReport.tex
echo "\\usepackage{enumitem}" >> ssnReport.tex
echo "\\begin{document}" >> ssnReport.tex
echo "\\title{Homework 12 - SSN Report}" >> ssnReport.tex
echo "\\author{Nicholas LaRosa}" >> ssnReport.tex
echo "\\maketitle" >> ssnReport.tex
echo "Machine name: student00.cse.nd.edu" >> ssnReport.tex
echo "\\begin{itemize}[leftmargin=0cm]" >> ssnReport.tex

findFiles "$initialPath"

echo "\\end{itemize}" >> ssnReport.tex
echo "There were $sumFiles SSNs found in the $initialPath directory." >> ssnReport.tex
echo "\\end{document}" >> ssnReport.tex

pdflatex ssnReport.tex

