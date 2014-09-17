#!/bin/awk -f

# Nicholas LaRosa

# usage: awk -f question2.awk /afs/nd.edu/coursesp.13/cse/cse20189.01/files/hw6/sedge.csv
# By default, this script outputs to sedgeTable.tex

BEGIN{
	FS = ",";		# field separator
	ORS = "";
	previous = " ";
	start = 1;		# start of the line
	i = 0;			# counts populations
	n = 0;			# number of values in each category

	widthSum = 0;		# keep running sum to compute average
	volumeSum = 0;
	diameterSum = 0;

	headerStr1 = "Population & Shoot Widths & Shoot Volumes & Shoot Diameters \\\\ \\hline";			# header for first table
	headerStr2 = "Population & Avg. Shoot Width & Avg. Shoot Volume & Avg. Shoot Diameter \\\\ \\hline";		# header for second table

	widthStr = "";		# strings hold LATEX table data for each population
	volumeStr = "";
	diameterStr = "";

	widthAvgStr = "";	# strings hold LATEX table data averages for each population
	volumeAvgStr = "";
	diameterAvg = "";
}
{
	if( previous == $1 ){				# if the string is the same, include data

		widthStr = widthStr $2 " ";  		# concatenate strings
		volumeStr = volumeStr $3 " ";
		diameterStr = diameterStr $4 " ";
	
		widthSum = widthSum + $2;		# keep running sum
		volumeSum = volumeSum + $3;
		diameterSum = diameterSum + $4;

		n = n + 1;
	}
	else{						# we have moved onto a different population
		if( start != 1 ){			# we need to skip the first line (header)	

			if( i != 0 ){			# need to wait until at least one set of data is stored
			
				widthAvg = widthSum / n;
				volumeAvg = volumeSum / n;
				diameterAvg = diameterSum / n;

				popData[i] = previous " & " widthStr "& " volumeStr "& " diameterStr "\\\\ \\hline";
				popAvg[i] = previous " & " widthAvg " & " volumeAvg " & " diameterAvg " \\\\ \\hline";	

				widthStr = "";		# reset our strings
				volumeStr = "";
				diameterStr = "";

				widthSum = 0;		# reset our sums
				volumeSum = 0;
				diameterSum = 0;
				n = 0;
			}

			widthStr = widthStr $2 " ";  	# concatenate strings
			volumeStr = volumeStr $3 " ";
			diameterStr = diameterStr $4 " ";

			widthSum = widthSum + $2;		# keep running sum
			volumeSum = volumeSum + $3;
			diameterSum = diameterSum + $4;

			i = i + 1;
			n = n + 1;		
		}	
	}

	previous = $1;					# previous corresponds to the population on previous line
	start = 0;					# we are no longer on the first line after this
}
END{
	widthAvg = widthSum / n;
	volumeAvg = volumeSum / n;
	diameterAvg = diameterSum / n;

	popData[i] = previous " & " widthStr "& " volumeStr "& " diameterStr "\\\\ \\hline";
	popAvg[i] = previous " & " widthAvg " & " volumeAvg " & " diameterAvg " \\\\ \\hline";		# print to LATEX file

	print "\\documentclass{article}\n\n\\usepackage{fullpage}\n\n\\title{Homework 6, Question 2}\n\\author{Nick LaRosa}" > "sedgeTable.tex";
	print "\n\n\\begin{document}\n\n\\maketitle\n\n" >> "sedgeTable.tex";
	print "\\begin{table}[!htb]\n\\centering\n\\begin{tabular}{ | c | c | c | c | }\n\t\\hline\n\t" headerStr1 "\n" >> "sedgeTable.tex"; 

	for( count = 1; count <= i; count++ )
	{
		print "\t" popData[count] "\n" >> "sedgeTable.tex";
	}

	print "\\end{tabular}\n\\end{table}\n\n" >> "sedgeTable.tex";

	print "\\begin{table}[!htb]\n\\centering\n\\begin{tabular}{ | c | c | c | c | }\n\t\\hline\n\t" headerStr2 "\n" >> "sedgeTable.tex"; 

	for( count = 1; count <= i; count++ )
	{
		print "\t" popAvg[count] "\n" >> "sedgeTable.tex";
	}

	print "\\end{tabular}\n\\end{table}\n\n\\end{document}" >> "sedgeTable.tex";
}

