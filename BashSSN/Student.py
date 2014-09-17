#!/usr/bin/python

# Nicholas LaRosa
# CSE 20189

import sys

class Student:
	
	runningSum = 0

	def __init__(self, name):
		self.name = name
		self.homeworks = []
		self.quizzes = []
		self.exams = []

	def getName(self):
		return self.name
	
	def addHomework(self, score):
		self.homeworks.append(score)
	
	def addQuiz(self, score):
		self.quizzes.append(score)
		
	def addExam(self, score):
		self.exams.append(score)
	
	def getSumHomeworks(self):
		Student.runningSum = 0
		for hwScore in self.homeworks:
			Student.runningSum += hwScore
		return float(Student.runningSum)

	def getSumQuizzes(self):
		Student.runningSum = 0
		for quizScore in self.quizzes:
			Student.runningSum += quizScore
		return float(Student.runningSum)
	
	def getNumExams(self):
		return float(len( self.exams ))
	
	def getExamNumber(self, number):
		return float(self.exams[ number - 1 ])

