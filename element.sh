#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -v ON_ERROR_STOP=1 -c"

if [[ -z "$1" ]]; then
  echo "Please provide an element as an argument."
  exit 0
fi

ELEMENT=$($PSQL "SELECT elements.atomic_number, name, symbol, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING (atomic_number) JOIN types USING (type_id) WHERE elements.atomic_number::text = '$1' OR symbol = '$1' OR name = '$1';")

if [[ -z "$ELEMENT" ]]; then
  echo "I could not find that element in the database."
  exit 0
fi

IFS='|' read -r ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING_POINT BOILING_POINT <<< "$ELEMENT"
echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."