#!/usr/bin/python

import sys
import re
import os
import math
from Student import Student

if len(sys.argv) != 2:
	raise Exception('Usage: grading.py <grades_file>\n')

location = sys.argv[1]

gradesFile = open( location, 'r' )	
outputFile = open( 'FinalGrades.tex', 'w' )

students = []				# array to hold all student objects
firstAdded = 0
numArgs = 0

numHomeworks = 0
numQuizzes = 0
numExams = 0

weightHomeworks = .50
weightQuizzes = .10
weightExams = .20

for line in gradesFile:			# for each line in the grades.csv file
	
	splits = line.split(',')

	if splits[0] == 'Name' and firstAdded == 0:	# we need to establish the point totals
		
		numArgs = len( splits )
		splits.pop( 0 )
		totals = {}				# hash to hold score totals

		for score in splits:
			
			scoreSplit = score.split( '-' )
			
			ourKey = scoreSplit[0]
			ourTotal = scoreSplit[1]
	
			ourTotal = float(ourTotal.strip())	# equivalent to perl's chomp

			if ourKey in totals:			# point total key is present
				totals[ourKey] = totals[ourKey] + ourTotal
			else:
				totals[ourKey] = ourTotal

			if re.match( "[Hh]omework", ourKey ):
				numHomeworks = numHomeworks + 1
			elif re.match( "[Qq]uiz", ourKey ):
				numQuizzes = numQuizzes + 1
			elif re.match( "[Ee]xam", ourKey ):
				numExams = numExams + 1

		firstAdded = 1
	
	elif len( splits ) == numArgs:			# gather information only if the line contains correct number of fields
	
		currentStudent = Student( splits[0] )
		splits.pop( 0 )
		fieldNumber = 1
		
		for score in splits:
			
			score = score.strip()

			if fieldNumber <= numHomeworks:
				currentStudent.addHomework( int(score) )
			elif fieldNumber <= ( numHomeworks + numQuizzes ):
				currentStudent.addQuiz( int(score) )
			elif fieldNumber <= ( numHomeworks + numQuizzes + numExams ):
				currentStudent.addExam( int(score) )

			fieldNumber = fieldNumber + 1

		students.append( currentStudent )

	else:						# incorrect number of field, skip this line
			
		print "Invalid line. Skipping...\n"

outputFile.write("\\documentclass{article}\n")
outputFile.write("\\title{Homework 12 - Final Grades (Python)}\n")
outputFile.write("\\author{Nicholas LaRosa}\n")
outputFile.write("\\begin{document}\n")
outputFile.write("\\maketitle\n")
outputFile.write("\\begin{table}[!htb]\n")
outputFile.write("\t\\centering\n")
outputFile.write("\t\\begin{tabular}{ | c | c | c | c | c | c | }\n")
outputFile.write("\t\\hline\n")
outputFile.write("\t\\textbf{Student Name} & \\textbf{Homework} & \\textbf{Quiz} & \\textbf{Exam 1} & \\textbf{Exam 2} & \\textbf{Final Grade} \\\\ \\hline\n")

for student in students:

	totalScore = float(0)

	outputFile.write("\t" + student.getName() + " & ")

	homeworkScore = float(100*(student.getSumHomeworks())/totals['Homework'])
	totalScore = float(totalScore + (weightHomeworks*homeworkScore))
	display = int(math.ceil( homeworkScore ))
	outputFile.write(str(display) + " & ")
		
	quizScore = float(100*(student.getSumQuizzes())/totals['Quiz'])
	totalScore = float(totalScore + (weightQuizzes*quizScore))
	display = int(math.ceil( quizScore ))
	outputFile.write(str(display) + " & ")

	examNumber = 1
	while examNumber <= student.getNumExams():

		examName = 'Exam ' + str( examNumber )
		examScore = float(100*(student.getExamNumber(examNumber))/totals[examName])
		totalScore = float(totalScore + (weightExams*examScore))
		display = int(math.ceil( examScore ))
		outputFile.write(str(display) + " & ")

		examNumber = examNumber + 1 

	totalScore = int( round(totalScore) )

	if totalScore <= 100 and totalScore >= 94:
		outputFile.write("A \\\\\n")	
	elif totalScore <= 93 and totalScore >= 90:
		outputFile.write("A- \\\\\n")
	elif totalScore <= 89 and totalScore >= 88:
		outputFile.write("B+ \\\\\n")
	elif totalScore <= 87 and totalScore >= 84:
		outputFile.write("B \\\\\n")
	elif totalScore <= 83 and totalScore >= 80:
		outputFile.write("B- \\\\\n")
	elif totalScore <= 79 and totalScore >= 78:
		outputFile.write("C+ \\\\\n")
	elif totalScore <= 77 and totalScore >= 74:
		outputFile.write("C \\\\\n")
	elif totalScore <= 73 and totalScore >= 70:
		outputFile.write("C- \\\\\n")
	elif totalScore <= 69 and totalScore >= 60:
		outputFile.write("D \\\\\n")
	elif totalScore <= 59 and totalScore >= 0:
		outputFile.write("F \\\\\n")

	outputFile.write("\\hline\n")

outputFile.write("\t\\end{tabular}\n")
outputFile.write("\t\\caption{This table presents final grades for the class.}\n")
outputFile.write("\\end{table}\n")
outputFile.write("\\end{document}\n")

outputFile.close()
gradesFile.close()

os.system("pdflatex FinalGrades.tex")

