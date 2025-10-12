#!/bin/bash

# ============================================
# Number Guessing Game - freeCodeCamp Project
# ============================================
# Database structure:
# - users: user_id (PK), username (VARCHAR 22, UNIQUE)
# - games: game_id (PK), user_id (FK), guesses, secret_number
# ============================================

# Database connection variable
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# ============================================
# USER AUTHENTICATION
# ============================================
echo "Enter your username:"
read USERNAME

# Query user from database
USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")

if [[ -z $USER_ID ]]
then
  # New user - welcome message
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  
  # Insert new user into database
  INSERT_USER=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
else
  # Returning user - fetch statistics
  GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM games WHERE user_id=$USER_ID")
  BEST_GAME=$($PSQL "SELECT MIN(guesses) FROM games WHERE user_id=$USER_ID")
  
  # Welcome back message with stats
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

# ============================================
# GAME SETUP
# ============================================
# Generate random secret number (1-1000)
SECRET_NUMBER=$(( RANDOM % 1000 + 1 ))
GUESSES=0

# Initial prompt
echo "Guess the secret number between 1 and 1000:"

# ============================================
# GAME LOOP
# ============================================
while true
do
  read GUESS
  
  # Validate input is an integer
  if [[ ! $GUESS =~ ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
    continue
  fi
  
  # Increment guess counter
  GUESSES=$(( GUESSES + 1 ))
  
  # Check if guess is correct
  if [[ $GUESS -eq $SECRET_NUMBER ]]
  then
    # Save game to database
    INSERT_GAME=$($PSQL "INSERT INTO games(user_id, guesses, secret_number) VALUES($USER_ID, $GUESSES, $SECRET_NUMBER)")
    
    # Victory message
    echo "You guessed it in $GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"
    break
  elif [[ $GUESS -lt $SECRET_NUMBER ]]
  then
    # Guess too low
    echo "It's higher than that, guess again:"
  else
    # Guess too high
    echo "It's lower than that, guess again:"
  fi
done