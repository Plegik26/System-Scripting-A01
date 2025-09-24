#!/bin/bash

# this script will validate that the user has run it with the correct parameters, and will iterate through the file it will copy the first 10 .jpg files it finds, rename them to sun-foto-XX and paste them into a backup directory created in the home directory. it will then display the new name alongside the owner and size of those files and proceed to create a tar archive of the folder in the home directory.

# reference for stat and basename found through manuaal and : https://unix.stackexchange.com/questions/16640/how-can-i-get-the-size-of-a-file-in-a-bash-script

# clear terminal
clear

backup_folder="renamed_images"
target_folder="$1"

# check if script was run with a parameter
if [ $# -ne 1 ]
	then
	echo "Invalid parameters. $0 <folder_path>"
	exit
fi

# check if given path is an existing directory
if [ ! -d "$target_folder" ]
	then
	echo "your given path is not an existing directory."
	exit 
fi

# create a backup folder if it doesnt already exist
mkdir -p "$HOME/$backup_folder"


counter=1	# Counter to rename files
renamed=();	# array to store the renamed files

echo "Files targeted for change:"
# for every file in folderpath that is a jpg
for file in "$target_folder"/*.jpg
	do
	# check if it's a file and there hasn't already been 10 of them renamed
	if [ -f "$file" ] && [ $counter -le 10 ]
		then
		echo "$file" # print for structure
		# format the new file name
		new_name="sun-foto-$counter.jpg"
		new_path="$HOME/$backup_folder/$new_name"
		
		# rename the file and copy it to the backup folder to preserve integrity of original folder
		cp "$file" "$new_path"
		
		# add the formatted file to list
		renamed+=("$new_path") 
		
		# increment counter
		((counter++))
	fi
done
echo

# Display the details of renamed files
echo "renamed files:"
# for every file in renamed array
for file in "${renamed[@]}"
	do
	# find file name (strip it's full directory), owner and size
	name=$(basename "$file")
	owner=$(stat -c "%U" "$file")
	size=$(stat -c "%s" "$file")
	
	# print with a format
	echo "File: $name, Owner: $owner, Size: $size bytes"
done
echo

# Create, compress and specify the name of archive created. Reset path to HOME and target the backup folder asthe one you'd like to clear. will overwrite if one is already existing.
tar -czf "$HOME/backedup_images.tar.gz" -C "$HOME" "$backup_folder"

# print home directory
echo "Home directory content:"
ls "$HOME"
echo

