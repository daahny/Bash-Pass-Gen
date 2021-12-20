#!/bin/bash
# This is a password generator project
# It accepts a few parameters from the user and genereates a password at random



# For personal reference
<< FORMAT
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



# Get the desired password length
function get_length {
	read -p "How long should the password be? (Enter for 15 chars): " password_length
	if [[ "$password_length" = "\n" ]]; then
		password_length=15
	elif [[ "$password_length =~ '^[0-9]+$'" ]]; then
		return
	else
		echo "Error: Invalid Response. Exiting script..." && exit 1
	fi
}


# Find out if the password should contain special characters
function get_special_chars {
	read -p "Would you like to use special characters [Y|n]: "
	case "$REPLY"; in 
		"y"|"Y"|"\n")	use_special_chars=0;;
		"n"|"N")	use_special_chars=1;;
		*)		echo "Error: Invalid Response. Exiting script..."
				exit 1;;
	esac
}


# Generate the password, then call a function to add special characters when appropriate
function generate_pass {
	password=$(echo /dev/urandom | grep -ao [A-Za-z0-9] | head -$password_length | tr -d '\n')
	"$use_special_chars" && add_special_chars
}


# Function that replaces random characters with special characters.
# This function generates 9 random characters that will be replaced with special characters.
# If one of the 9 random characters is found in the password string,
# it will be replaced with a special character in the spesh string that has the same index of the  
# random char in the chars string.
function add_special_chars {
	export LC_ALL=C
	spesh='$%&*;"@#!'
	# 10000 lines are used to lower the likeliness of duplicate chars.
	chars=$(cat /dev/urandom | grep -ao [A-Za-z0-9] | head -100000 | awk '!x[$0]++' | head -9 | tr -d '\n')

	# Loop through the password to see if any of the password chars match chars in the 
	# 9 random chars generated above.
	# If there is a match, replace it with the corresponding special character
	for i in $password; do
		if [[ "$chars" =~ .*$i.* ]]; then
			local char_to_replace="$i"
			local spesh_index=$(expr index "$chars" "$i")
			local spesh_char=${spesh:$spesh_index:1}
			local new_password=${password//$i/$spesh_char}
			password="$new_password"
		fi
	done
}


# Main function
# First get the desired password length
# Then determinw whether special characters are desired
# Finally, genereate the password and output it
function main {
	get_length
	get_special_chars
	generate_pass
	echo "$password"
}

