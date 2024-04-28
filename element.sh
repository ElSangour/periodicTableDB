#!/bin/bash

# Define the PSQL command for PostgreSQL connection
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

# Check if an argument is provided
if [[ $1 ]]; then
  # Check if the argument is not a number
  if [[ ! $1 =~ ^[0-9]+$ ]]; then
    # Search for the element by name using a full join
    ELEMENT=$($PSQL "SELECT atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, symbol, name, type FROM properties JOIN elements USING (atomic_number) JOIN types USING (type_id) WHERE elements.name LIKE '$1%' ORDER BY atomic_number LIMIT 1")
  else
    # Search for the element by atomic number using a full join
    ELEMENT=$($PSQL "SELECT atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, symbol, name, type FROM properties JOIN elements USING (atomic_number) JOIN types USING (type_id) WHERE elements.atomic_number = $1")
  fi

  # If no results found in the searches
  if [[ -z $ELEMENT ]]; then
    echo "I could not find that element in the database."
  else
    # Extract and print information about the element
    echo $ELEMENT | while IFS=\| read ATOMIC_NUMBER ATOMIC_MASS MPC BPC SYMBOL NAME TYPE
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MPC celsius and a boiling point of $BPC celsius."
    done
  fi
else
  # If no argument provided
  echo  "Please provide an element as an argument." 
fi
