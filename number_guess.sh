#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# Crear tablas si no existen
$PSQL "CREATE TABLE IF NOT EXISTS users(user_id SERIAL PRIMARY KEY, username VARCHAR(22) UNIQUE NOT NULL);" > /dev/null
$PSQL "CREATE TABLE IF NOT EXISTS games(game_id SERIAL PRIMARY KEY, user_id INT NOT NULL REFERENCES users(user_id), guesses INT NOT NULL, secret_number INT NOT NULL);" > /dev/null

# Generar número secreto
SECRET_NUMBER=$(( RANDOM % 1000 + 1 ))

# Solicitar nombre de usuario
echo "Enter your username:"
read USERNAME

# Limitar el nombre de usuario a 22 caracteres si es más largo
if [[ ${#USERNAME} -gt 22 ]]; then
  USERNAME="${USERNAME:0:22}"
fi

# Verificar si usuario existe
USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")

if [[ -z $USER_ID ]]
then
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  # Insertar usuario y obtener ID - FORMA MÁS ROBUSTA
  INSERT_RESULT=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME') RETURNING user_id")
  # Extraer el user_id de forma más confiable
  USER_ID=$(echo "$INSERT_RESULT" | grep -oE '^[0-9]+')
  
  # Verificar que USER_ID no esté vacío
  if [[ -z $USER_ID ]]; then
    # Si falla, obtener el user_id recién insertado
    USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
  fi
else
  # Obtener estadísticas para usuario existente
  GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM games WHERE user_id=$USER_ID")
  BEST_GAME=$($PSQL "SELECT COALESCE(MIN(guesses), 0) FROM games WHERE user_id=$USER_ID")
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

echo "Guess the secret number between 1 and 1000:"
GUESS_COUNT=0

while true
do
  read GUESS
  
  # Validar que no esté vacío
  if [[ -z "$GUESS" ]]; then
    echo "Please enter a number, guess again:"
    continue
  fi
  
  # Validar que sea un número
  if [[ ! "$GUESS" =~ ^[0-9]+$ ]]; then
    echo "That is not an integer, guess again:"
    continue
  fi

  ((GUESS_COUNT++))
  
  if [[ $GUESS -eq $SECRET_NUMBER ]]; then
    echo "You guessed it in $GUESS_COUNT tries. The secret number was $SECRET_NUMBER. Nice job!"
    # Verificar que USER_ID tenga un valor antes de insertar
    if [[ -n $USER_ID && $USER_ID =~ ^[0-9]+$ ]]; then
      $PSQL "INSERT INTO games(user_id, guesses, secret_number) VALUES($USER_ID, $GUESS_COUNT, $SECRET_NUMBER)" > /dev/null
    else
      echo "Error: Could not save game to database." >&2
    fi
    break
  elif [[ $GUESS -lt $SECRET_NUMBER ]]; then
    echo "It's higher than that, guess again:"
  else
    echo "It's lower than that, guess again:"
  fi
done