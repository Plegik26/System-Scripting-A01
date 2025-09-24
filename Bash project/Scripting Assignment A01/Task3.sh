#!/bin/bash
# this script will check if the user has run it with rot privilages, then check if there was a filename passed as a parameter and if that file exists or is empty. once validates the script will create users and home directories for under a name for every line in the given file. if they exist, skip them. then display the home directory and passwd directory, and ask the user if he'd like to delete them.


# Reference: man read
# redirecting/nulling output https://stackoverflow.com/questions/6674327/redirect-all-output-to-file-in-bash
# accpeting uppercase and lowercase: https://www.reddit.com/r/bash/comments/gkujcc/can_someone_explain_if_answer_answeryy_then_to_me/?rdt=56242
# getting userID https://askubuntu.com/questions/468236/how-can-i-find-my-user-id-uid-from-terminal

# Function to check if the script is run with root user privialges
check_priv() {
	# if current userID is not 0 (root user) then enter if condition 
	if [ "$EUID" -ne 0 ]
	then
		echo "ERROR. This script must be run with root user privilages."
		exit
	fi
}

# Function to check if the file passed exists and is not empty
validate_passed_file() {
	#assign file passed to variable
	file=$1
	# if file does not exist
	if [ ! -f "$file" ]
	then
		#print error message
		echo "ERROR. File: $file does not exist."
		exit
	# if first condition is true (file exists) check if file is empty
	elif [ ! -s "$file" ]
	then
		#print error message
		echo "ERROR. File: $file exists, but is empty."
		exit 
	fi
}

# function to create users
create_users() {
	# Assign file with all usernames to create on a variable
	input_file=$1

	# Loop through the input file line by line and assign the name to variable username
	while IFS= read -r username
	do
		# Skip empty lines in the file
		if [ -n "$username" ]
		then
			# Check if the username already exists on system and redirects output so that it doesnt print.
		    	if id "$username" &>/dev/null
		    	then
				echo "ERROR. User: '$username' already exists on system, skipping creation..."
		    	else
				# Create the user and their home directory under the username
				useradd -m "$username"
				echo "User: $username has been successfully created."
		    	fi
		fi
	
	done < "$input_file"
}

delete_users() {
	# Ask if the user wants to delete the newly created accounts
	echo
	echo "Do you want to delete the newly created accounts? (y/n):"
	read choice

	# if user selects Yy then delete accounts, if Nn dont delete them and anything else exit script
	if [[ "$choice" == [Yy]* ]]
	then
		echo "Deleting accounts..."

		# Loop through the input file line by line
		while IFS= read -r username
		do
			# Skip empty lines in the file
		    	if [ -n "$username" ]
		    	then
				# Delete the user and their home directory
				userdel -r "$username"
			    	echo "User: '$username' has been successfully deleted with their home directory."
			fi
		done < "$input_file"

	elif [[ "$choice" == [Nn]* ]]
	then
		echo
		echo "Accounts created will NOT be deleted"
		exit
	else
		echo
		echo "ERROR. Invalid answer, exiting script."
		exit
	fi
}

# Function to display home directory and /etc/passwd
show_system_info() {
	echo
	echo "printing /etc/passwd directory:"
	cat /etc/passwd

	echo
	echo "printing /home directory:"
	ls -l /home
}

# Main script process
clear
# Ensure the script is run as root by calling check_priv function to check it
check_priv  

# Ensure the scrpt is called with the correct parameters
if [ $# -ne 1 ]
then
  	echo "ERROR. Usage: $0 <input_file>"
	exit
fi

#assign passed file to variable
input_file=$1

#validate file to enure it exists and isnt empty
validate_passed_file "$input_file"

# Create accounts from the file
create_users "$input_file"

# Show the system info after having created the users
show_system_info

# Ask the user if they want to delete the accounts
delete_users

# Show system info after deletion
show_system_info

