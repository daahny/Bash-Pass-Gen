#!/bin/bash
# This is a password generator project
# It accepts a few parameters from the user and genereates a password at random



# For personal reference
<< 'FORMAT'
1. shebang
2. summary
3. default variable values
4. arguments parsing (including usage function which uses variables from 3.)
5. importing files (otherwise the file becomes too long.)
6. functions (using variables and functions from 3, 4 & 5.)
7. event functions (Ctrl+C event using a function from 5 & 6.)
8. check-command function (checking if the system has commands.)
9. read standard input
10. main body (using functions from 5 & 6.)
FORMAT



password_length=0
use_special_chars=''
password=''
RED='\033[0;31m'
GRAY='\033[0;37m'
GREEN='\033[0;32m'



# Get the desired password length
function get_length {
	printf "${GRAY}How long should the password be? (Enter for 15 chars): "
	read -r password_length
	echo ""
	if [[ "$password_length" = "" ]]; then
		password_length=15
	elif [[ "$password_length" =~ ^[0-9]+$ ]]; then
		return
	else
		printf "${RED}Error: Invalid Response. Exiting script...${GRAY}\n" && exit 1
	fi
}


# Find out if the password should contain special characters
function get_special_chars {
	printf "${GRAY}Would you like to use special characters [Y|n]: "
	read -r
	case "$REPLY" in 
		"y"|"Y"|"")	use_special_chars=0;;
		"n"|"N")	use_special_chars=1;;
		*)		printf "${RED}Error: Invalid Response. Exiting script...${GRAY}\n"
				exit 1;;
	esac
	echo ""
}


# Generate the password, then call a function to add special characters when appropriate
function generate_pass {
	export LC_ALL=C
	password=$(cat /dev/urandom | grep -ao "[A-Za-z0-9]" | head -$password_length | tr -d '\n')
	(($use_special_chars)) || add_special_chars
}


# Function that replaces random characters with special characters.
# This function generates 18 random characters that will be replaced with special characters.
# If one of the 18 random characters is found in the password string,
# it will be replaced with a special character in the spesh string that has the same index of the  
# random char in the chars string.
function add_special_chars {
	spesh='$%&*;"@#!$%&*;"@#!'
	# 10000 lines are used to increase the chances that enough randomly generated chars are unique.
	chars=$(cat /dev/urandom | grep -ao "[A-Za-z0-9]" | head -100000 | awk '!x[$0]++' | head -18 | tr -d '\n')

# 	Uncomment for debugging
#	echo "random chars: $chars"
#	echo "spesh chars:  $spesh"
#	echo "password before inserting special chars:     $password"

	# Loop through the password to see if any of the password chars match chars in the 
	# 18 random chars generated above.
	# If there is a match, replace it with the corresponding special character
	for (( i=0; i < ${#password}; i++ )); do
		current_char=${password:$i:1}
		if [[ "$chars" =~ .*$current_char.* && $current_char =~ [a-zA-Z0-9] ]]; then

			### NEEDS MORE EFFICIENT LOGIC TO FIND INDEX ###
			local spesh_index
			for ((j=0; j < ${#chars}; j++)); do
				if [[ ${chars:$j:1} =~ $current_char ]]; then
					spesh_index=$j;
					break;
				fi
			done

			local spesh_char=${spesh:$spesh_index:1}
			local new_password=${password//$current_char/$spesh_char}
			password="$new_password"
		fi
	done
}


# Main function
# First get the desired password length
# Then determine whether special characters are desired
# Finally, genereate the password and output it
function main {
	get_length
	get_special_chars
	generate_pass
	printf "${GRAY}Randomly Generated Password:${GREEN}"
	echo " $password"
}

main
printf "${GRAY}\n"
