#!/bin/bash

try_again()		# prompts the user if they would like to try again
{
	echo -n "Would you like to try again? "
	read answer

	if [[ $answer =~ [Nn]o? ]]; then
		echo ""
		exit 0						# exit program, success
	elif [[ $answer =~ [Yy](es)? ]]; then
		continue					# while loop will continue if user answers yes	
	else
		try_again					# recursively call function
	fi	
}

range=9

while true
do
	echo ""
	echo -n "Guess a number between 1 and 9: "
	read input

	ourRand=$RANDOM						# generates random number between 1 and 9

	let "ourRand %= $range"					# this generates an integer between 0 and 8
	let "ourRand = $ourRand + 1"				# increment this interval to between 1 and 9

	if [ $input -lt 1 ]; then
		echo "The range is 1-9. Please try again."
		continue
	elif [ $input -gt 9 ]; then
		echo "The range is 1-9. Please try again."
		continue
	else
		if [ $input -eq $ourRand ]; then
			echo "You guessed correctly!"		
			exit 0					# game exits once user answers correctly
		else
			echo "Sorry, the number was: $ourRand"
			echo ""
			try_again				# user is prompted to play again if they guess incorrectly
		fi
	fi
done

