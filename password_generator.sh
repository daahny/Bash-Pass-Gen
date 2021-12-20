#!/bin/bash

# This is a password generator project
# It accepts a few parameters from the user and genereates a password at random


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


function main {
	get_length
	get_special_chars
	generate_pass
}


function get_length {
	read -p "How long should the password be? (Enter for 15 chars): " password_length
	if [[ "$password_length" = "\n" ]]; then
		password_length=15
	elif [[ "$password_length =~ '^[0-9]+$'" ]]; then
		return
	else
		echo "Error: Invalid Response. Exiting script..." && exit 1
}

function get_special_chars {
	read -p "Would you like to use special characters [Y|n]: "
	case $REPLY; in 
		"y"|"Y"|"\n")	use_special_chars=0;;
		"n"|"N")	use_special_chars=1;;
		*)		echo "Error: Invalid Response. Exiting script..."
				exit 1;;
	esac
}

function generate_pass {
	password=$(/dev/urandom | grep -ao [A-Za-z0-9] | head -$password_length | tr -d '\n')
	$use_special_chars && add_special_chars
}

function add_special_chars {
	# generate 9 random characters that will be replaced with special characters
	# replace these characters with the special character that matches its index in the
	# mirroring array
	export LC_ALL=C
	spesh='$%&*;"@#!'
	chars=$(echo /dev/urandom | grep -ao [A-Za-z0-9] | head -9 | tr -d '\n')
	for i in $password; do
		if [[ $chars =~ .*"$i".* ]]; then
		# it's a match, replace it here	
		fi
	done
}

<< STACKOVERFLOW
RANDOM PASSWORD GENERATOR LOGIC?
chars='@#$%&_+='
{ </dev/urandom LC_ALL=C grep -ao '[A-Za-z0-9]' \
        | head -n$((RANDOM % 8 + 9))
    echo ${chars:$((RANDOM % ${#chars})):1}   # Random special char.
} \
    | shuf \
    | tr -d '\n'
STACKOVERFLOW
