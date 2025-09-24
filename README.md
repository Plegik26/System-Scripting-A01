# Systems Scripting – Assignment 1

This repository contains my submission for **COMPxxxx – Systems Scripting, Assignment 1**.  
The focus was on writing Bash scripts that demonstrate automation, file handling, interactive menus, and system administration tasks.  

---

## Overview
The assignment was divided into three main tasks, each implemented as a separate Bash script. All scripts include inline documentation and reference materials as per assignment requirements.

---

## Tasks Implemented

### Task 1 – File Renaming and Backup
- Script accepts a folder path as an argument.  
- Renames the first 10 `.jpg` files in the folder to the format `sun-foto-xx.jpg`.  
- Outputs details of renamed files (name, owner, size in bytes).  
- Stores renamed filenames in an array and prints them using an `until` loop.  
- Moves renamed files into a new folder, compresses them with `tar`, and backs them up to the user’s home directory.  
- Displays contents of the home directory to confirm backup.  

---

### Task 2 – Interactive Menu
Interactive Bash script with multiple menu options, each implemented as a function:
1. **Quantity Menu** (file: `grub.txt`)  
   - Counts occurrences of the word "Linux".  
   - Outputs all lines containing "Linux".  
   - Counts empty lines.  
   - Extracts lines starting with `#` into a new file and displays its contents.  

2. **Details Menu** (file: `ufw.txt`)  
   - Outputs all words starting with `l` and ending with `y`.  
   - Counts lines starting with uppercase `D`.  
   - Loads file into an array and prints lines at odd indices.  

3. **Write Menu**  
   - Prompts for a filename.  
   - Creates the file if it does not exist.  
   - Accepts user input continuously until the word `done` is entered on its own line.  
   - Allows sentences containing `done` without ending input.  

4. **Terminate Menu**  
   - Exits the script with a goodbye message.  

---

### Task 3 – User Account Automation
- Script accepts a file containing a list of usernames as an input argument.  
- Ensures the file exists and is not empty.  
- Creates user accounts and corresponding home directories if they do not already exist.  
- Displays contents of `/etc/passwd` and `/home` for verification.  
- Prompts user to delete the created accounts:  
  - If **yes** - deletes accounts and home directories, then displays verification again.  
  - If **no** - exits with a message.  
- Creation and deletion operations are implemented as functions.  
- Script enforces execution with root privileges.  
