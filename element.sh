#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ $1 ]]

then
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ELEMENT=$($PSQL "SELECT name, atomic_number, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE elements.atomic_number=$1")
  else
    ELEMENT=$($PSQL "SELECT name, atomic_number, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE name='$1' OR symbol='$1'")
  fi
  if [[ -z $ELEMENT ]]
  then
    echo "I could not find that element in the database."
  else
    ELEMENT_FORMATTED=$(echo "$ELEMENT" | sed 's/|/ /g')
    
    echo "$ELEMENT_FORMATTED" | while read NAME ATOMIC_NUMBER SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT
    do
      
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi
  
else
  echo "Please provide an element as an argument."
fi
