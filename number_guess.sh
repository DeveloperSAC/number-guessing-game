#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# Crear tablas si no existen (silenciosamente)
$PSQL "CREATE TABLE IF NOT EXISTS users(user_id SERIAL PRIMARY KEY, username VARCHAR(22) UNIQUE NOT NULL);" > /dev/null 2>&1
$PSQL "CREATE TABLE IF NOT EXISTS games(game_id SERIAL PRIMARY KEY, user_id INT NOT NULL REFERENCES users(user_id), guesses INT NOT NULL, secret_number INT NOT NULL);" > /dev/null 2>&1

# Generar número secreto
SECRET_NUMBER=$(( RANDOM % 1000 + 1 ))

# Solicitar nombre de usuario
echo "Enter your username:"
read USERNAME

# Verificar si usuario existe
USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")

if [[ -z $USER_ID ]]
then
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  INSERT_RESULT=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME') RETURNING user_id")
  USER_ID=$INSERT_RESULT
else
  GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM games WHERE user_id=$USER_ID")
  BEST_GAME=$($PSQL "SELECT MIN(guesses) FROM games WHERE user_id=$USER_ID")
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

echo "Guess the secret number between 1 and 1000:"
GUESS_COUNT=0

# Bucle principal del juego
while IFS= read -r GUESS
do
  # Verificar si es número
  if [[ ! "$GUESS" =~ ^[0-9]+$ ]]; then
    echo "That is not an integer, guess again:"
    continue
  fi

  ((GUESS_COUNT++))
  
  if [[ $GUESS -eq $SECRET_NUMBER ]]; then
    echo "You guessed it in $GUESS_COUNT tries. The secret number was $SECRET_NUMBER. Nice job!"
    $PSQL "INSERT INTO games(user_id, guesses, secret_number) VALUES($USER_ID, $GUESS_COUNT, $SECRET_NUMBER)" > /dev/null 2>&1
    break
  elif [[ $GUESS -lt $SECRET_NUMBER ]]; then
    echo "It's higher than that, guess again:"
  else
    echo "It's lower than that, guess again:"
  fi
done