#!/bin/awk -f

# Nicholas LaRosa
# CSE 20189

# usage: awk -f switches.awk <switches_file>

BEGIN{
	FS = ",";

	numPorts = 0;
	switchNum = 1;
	currMin = 10000;			# current switch port minimum will be reset every iteration
	currIndex1 = "";			# current index to the string containing the current minimum switch port
	currIndex2 = "";			

	file = "switches.tex";

	print "\\documentclass{article}" > file;
	print "\\title{Homework 12 - Switches}" >> file;
	print "\\author{Nicholas LaRosa}" >> file;
	print "\\begin{document}" >> file;
	print "\\maketitle" >> file; 
}
{
	if( $1 != "\"Switch\"" )
	{
		if( $1 != "" ){			# corresponds to a new switch
			
			for( i = 1; i <= NF; i++ )	# get rid of quotes and spaces
			{
				sub(/^\"/, "", $i);
				sub(/\"$/, "", $i);
				sub(/ /, "", $i);			
			}

			if( switchNum > 1 ){		# we have an array stored, print table
				
				print "\\begin{table}[!htb]" >> file;
				print "\t\\centering" >> file;
				print "\t\\begin{tabular}{ | c | c | c | c | c | }" >> file;
				print "\t\\hline" >> file;
				print "\t\\textbf{Jack} & \\textbf{Room} & \\textbf{Host} & \\textbf{MAC} & \\textbf{Switch Port} \\\\ \\hline" >> file;
				for( i = 0; i < numPorts; i++ )
				{
					currMin = 10000;

					for( combined in switches )
					{
						split( combined, line, SUBSEP )
						{
							if( line[2] < currMin )
							{	
								currMin = line[2];
								currIndex1 = line[1];
								currIndex2 = line[2];
							}
						}
					}
					
					print switches[ currIndex1, currIndex2 ] >> file;
					delete switches[ currIndex1, currIndex2 ];				
				}

				numPorts = 0;
				delete switches;	
		
				print "\t\\end{tabular}" >> file;
				print "\t\\caption{Switch: " currSwitch "}" >> file;
				print "\\end{table}" >> file;
			}	

			currSwitch = $1;	
			switches[currSwitch, $6] = "\t" $2 " & " $3 " & " $4 " & " $5 " & " $6 " \\\\ \\hline";
			switchNum = switchNum + 1;
		}
		else{	
			for( i = 2; i <= NF; i++ )	# get rid of quotes and spaces
			{
				sub(/^\"/, "", $i);
				sub(/\"$/, "", $i);
				sub(/ /, "", $i);			
			}

			switches[$currSwitch, $6] = "\t" $2 " & " $3 " & " $4 " & " $5 " & " $6 " \\\\ \\hline";
			numPorts = numPorts + 1;
		}
	}
}
END{
	print "\\begin{table}[!htb]" >> file;
	print "\t\\centering" >> file;
	print "\t\\begin{tabular}{ | c | c | c | c | c | }" >> file;
	print "\t\\hline" >> file;
	print "\t\\textbf{Jack} & \\textbf{Room} & \\textbf{Host} & \\textbf{MAC} & \\textbf{Switch Port} \\\\ \\hline" >> file;			

	for( i = 0; i < numPorts; i++ )
	{
		currMin = 10000;

		for( combined in switches )
		{
			split( combined, line, SUBSEP )
			{
				if( line[2] < currMin )
				{	
					currMin = line[2];
					currIndex1 = line[1];
					currIndex2 = line[2];
				}
			}
		}

		print switches[ currIndex1, currIndex2 ] >> file;
		delete switches[ currIndex1, currIndex2 ];				
	}

	print "\t\\end{tabular}" >> file;
	print "\t\\caption{Switch: " currSwitch "}" >> file;
	print "\\end{table}" >> file;
	
	print "\\end{document}" >> file; 

	system("pdflatex switches.tex");
}
