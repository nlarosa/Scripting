#!/bin/bash

# Nicholas LaRosa

path="./question3/"
ext=".temp"

first=129
second=74

rm $path*			# remove previously created files before beginning

for third in {0..255}
do
	for fourth in {0..255}
	do
		address="$first.$second.$third.$fourth"
	
		name=`nslookup $address | grep 'name ='`		# this is the command to find hosts that exist

		if [ -n "$name" ]
		then
			domain=`echo "$name" | awk '{print $NF}'` 			
			host=`echo "$domain" | awk -F. '{print $1}'`
			subdomain=`echo "$domain" | awk -F. '{print $2}'`
		
			if [ -a "$path$subdomain" ] 			# if a file named the subdomain already exists
			then
				echo "$host" >> "$path$subdomain"	# append to that file
			else
				echo "$host" > "$path$subdomain"	# write to a new file
			fi
		fi	
	done
done

for file in $path*							# for every file that was created
do
	sort "$file" | uniq > "$file.$ext" && mv "$file.$ext" "$file"		# replaces original file with sort and uniq output 
done

