#!/bin/bash

# Function to display the game menu and read the user's choice
function user_choice() {
    echo "Choose your weapon!"
    echo "1. Rock"
    echo "2. Paper"
    echo "3. Scissors"
    read -p "Select (1-3): " choice

    case $choice in
        1)
            echo "You chose Rock."
            user_weapon="Rock"
            ;;
        2)
            echo "You chose Paper."
            user_weapon="Paper"
            ;;
        3)
            echo "You chose Scissors."
            user_weapon="Scissors"
            ;;
        *)
            echo "Invalid choice, exiting."
            exit 1
            ;;
    esac
}

# Function to generate the computer's choice
function computer_choice() {
    comp=$(( RANDOM % 3 + 1 ))
    case $comp in
        1)
            echo "Computer chose Rock."
            comp_weapon="Rock"
            ;;
        2)
            echo "Computer chose Paper."
            comp_weapon="Paper"
            ;;
        3)
            echo "Computer chose Scissors."
            comp_weapon="Scissors"
            ;;
    esac
}

# Function to determine the winner
function determine_winner() {
    if [[ $user_weapon == $comp_weapon ]]; then
        echo "It's a tie!"
    elif [[ $user_weapon == "Rock" && $comp_weapon == "Scissors" ]] ||
         [[ $user_weapon == "Paper" && $comp_weapon == "Rock" ]] ||
         [[ $user_weapon == "Scissors" && $comp_weapon == "Paper" ]]; then
        echo "You win!"
    else
        echo "Computer wins!"
    fi
}

# Main game loop
user_choice
computer_choice
determine_winner
