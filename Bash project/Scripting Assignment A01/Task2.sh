#!/bin/bash

# This script will create a text based menu for the user that allows for the following:	1): will check if the file grub.txt exists, then it will count how many times the word linux appears and count how many LINES contain linux in it. it wil then count the lines tht are empty and dislpay them also	2):will check if the file ufw.txt exists, and count all the lines that have words beginning will l and ending with y,all the lines starting with D and will display the odd numbered lines 	3):will allow the user to choose a file (will create it if empty) and then type into it. once the user types the word "done" it will finish the writing.	4): will exit the script.  

# reference for grep commands: man grep
# reference for word count. https://stackoverflow.com/questions/21537854/count-number-of-words-in-file-bash-script
# reference for word slicing: https://stackoverflow.com/questions/22520324/use-grep-to-search-for-words-beginning-with-letter-s
# IFS: https://www.baeldung.com/linux/ifs-shell-variable



# Function to check if a file exists
file_exists() {
	# if file passed with function does NOT exist, print error message and return 1 (false), otherwise return 0(true)
	if [ ! -f "$1" ]
	then
		return 1
	fi
	return 0
}

# Function to count occurrences of the word "Linux" in grub.txt
# Display the lines containing linux
# Extracting lines that start with "#" to a new file and output to the terminal
grub_operation() {
	echo
	# If file_exist does returns true, then enter function
	if ! file_exists "grub.txt"
	then
		echo "grub.txt does not exist"	
		return
	fi

	echo "Counting how many times the word Linux appears in grub.txt"
	# grep all "linux" words and count them
	# -i diregards lettercase
	# -o prints result on a newline 
	count=$(grep -i -o "Linux" grub.txt | wc -l)
	# print result
	echo
	echo "Number of occurrences of 'Linux': $count"

	# Display lines containing "Linux"
	echo
	echo "Lines containing the word 'Linux':"
	grep -i "Linux" grub.txt

	# Count (-c) empty lines that start with nothing
	blank_lines=$(grep -c "^$" grub.txt)
	echo
	echo "Number of blank lines: $blank_lines"
	echo

	# Extract lines starting with "#" to a new file (overwrite if existing) then print to terminal
	grep "^#" grub.txt > comments.txt
	echo "Lines starting with '#':"
	cat comments.txt
	echo
	echo "Results have been saved to comments.txt"
}

# Function to query details from ufw.txt
ufw_operation() {
	echo
	# If file_exist does not return true, then leave function
	if ! file_exists "ufw.txt"
	then
		echo "ufw.txt does not exist"	
		return
	fi

	# Lines containing words starting with "l" and ending with "y"
	echo
	echo "Lines containing words starting with 'l' and ending with 'y':"
	grep -w l.*y ufw.txt

	# Count lines starting with D
	lines_with_d=$(grep -c "^D" ufw.txt)
	echo
	echo "Number of lines starting with 'D': $lines_with_d"

	# read file into an array
	lines=($(cat ufw.txt))

	# Output odd lines
	echo
	echo "Odd number lines:"
	count=0
	while IFS= read -r line
	do
		((count++))
		if ((count % 2 == 1))
		then
			# Print the odd line exactly as it is
			echo "$line"
		fi
	done < "ufw.txt"
}

# Function to write user input to a new file
write_to_file() {
	echo
	echo "Which file would you like to write to?:"
	read filename

	# Create the file if it does not exist
	touch "$filename.txt"

	echo
	echo "What text would you like to enter? (type 'done' to finish):"
	while true
	do
		read input
		# if final word entered is equal to done finish loop
		if [ "$input" != "done" ]
		then
			# append text to file chosen earlier.
			echo "$input" >> "$filename.txt"
		else
			break
		fi
	done
	echo "Text appended to $filename"
}

# Main menu function
main_menu() {
	while true; do
	# Display main menu options
	echo
	echo "Please choose an option:"
	echo "1. Quantity"
	echo "2. Details"
	echo "3. Write"
	echo "4. Terminate"
	read -p "Enter your choice (1-4): " choice

	if [ $choice -eq 1 ]
	then
		grub_operation
		
	elif [ $choice -eq 2 ]
	then
		ufw_operation
		
	elif [ $choice -eq 3 ]
	then
		write_to_file

	elif [ $choice -eq 4 ]
	then
		echo "Exiting application."
		break

	else
		echo "invalid choice. please enter a number between 1-4."
	fi
	done
}

# clear terminal and start the main menu
clear
main_menu
