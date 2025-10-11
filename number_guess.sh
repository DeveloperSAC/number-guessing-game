#!/bin/bash

# Variable PSQL para consultas
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# Generar número secreto aleatorio entre 1 y 1000
SECRET_NUMBER=$((RANDOM % 1000 + 1))

# Solicitar nombre de usuario
echo "Enter your username:"
read USERNAME

# Verificar si el usuario existe
USER_INFO=$($PSQL "SELECT user_id, username FROM users WHERE username='$USERNAME'")

if [[ -z $USER_INFO ]]
then
  # Usuario nuevo
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  
  # Insertar nuevo usuario
  INSERT_USER=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
else
  # Usuario existente
  IFS="|" read USER_ID USERNAME <<< "$USER_INFO"
  
  # Obtener estadísticas
  GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM games WHERE user_id=$USER_ID")
  BEST_GAME=$($PSQL "SELECT MIN(guesses) FROM games WHERE user_id=$USER_ID")
  
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

# Iniciar juego
echo "Guess the secret number between 1 and 1000:"
NUMBER_OF_GUESSES=0

while true
do
  read GUESS
  NUMBER_OF_GUESSES=$((NUMBER_OF_GUESSES + 1))
  
  # Verificar que sea un entero
  if [[ ! $GUESS =~ ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
    continue
  fi
  
  # Comparar con el número secreto
  if [[ $GUESS -eq $SECRET_NUMBER ]]
  then
    # Victoria
    echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"
    
    # Guardar juego en la base de datos
    INSERT_GAME=$($PSQL "INSERT INTO games(user_id, guesses) VALUES($USER_ID, $NUMBER_OF_GUESSES)")
    break
  elif [[ $GUESS -lt $SECRET_NUMBER ]]
  then
    echo "It's higher than that, guess again:"
  else
    echo "It's lower than that, guess again:"
  fi
done