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

# Limpiar el input del usuario (eliminar espacios y caracteres especiales)
USERNAME=$(echo "$USERNAME" | xargs)

# Verificar si usuario existe
USER_RESULT=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")

if [[ -z $USER_RESULT ]]
then
  # Usuario nuevo
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  # Insertar usuario y obtener ID - extraer solo el número
  INSERT_OUTPUT=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME') RETURNING user_id")
  USER_ID=$(echo "$INSERT_OUTPUT" | grep -o '[0-9]\+' | head -1)
else
  # Usuario existente
  USER_ID=$USER_RESULT
  # Obtener estadísticas
  GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM games WHERE user_id=$USER_ID")
  BEST_GAME=$($PSQL "SELECT MIN(guesses) FROM games WHERE user_id=$USER_ID")
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

echo "Guess the secret number between 1 and 1000:"
GUESS_COUNT=0

while true
do
  read GUESS
  
  # Ignorar entradas vacías
  if [[ -z "$GUESS" ]]; then
    continue
  fi
  
  # Validar que sea un número entero
  if [[ ! "$GUESS" =~ ^[0-9]+$ ]]; then
    echo "That is not an integer, guess again:"
    continue
  fi

  ((GUESS_COUNT++))
  
  if [[ $GUESS -eq $SECRET_NUMBER ]]; then
    echo "You guessed it in $GUESS_COUNT tries. The secret number was $SECRET_NUMBER. Nice job!"
    # Guardar el juego en la base de datos
    $PSQL "INSERT INTO games(user_id, guesses, secret_number) VALUES($USER_ID, $GUESS_COUNT, $SECRET_NUMBER)" > /dev/null
    break
  elif [[ $GUESS -lt $SECRET_NUMBER ]]; then
    echo "It's higher than that, guess again:"
  else
    echo "It's lower than that, guess again:"
  fi
done