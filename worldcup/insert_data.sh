#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")
cat games.csv | while IFS="," read YEAR ROUND NAME_W NAME_O WINNER_GOALS OPPONENT_GOALS
do
  if [[ YEAR -ne year ]]
  then
    #inserting into team first
    #get team from database
    NAME=$($PSQL "SELECT name FROM teams WHERE name='$NAME_W'")

    #if not found
    if [[ -z $NAME ]]
    then
      #insert into table 
      INSERT_NAME_RESULT=$($PSQL "INSERT INTO teams(name) VALUES ('$NAME_W')")
      if [[ $INSERT_NAME_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $NAME_W
      fi
    fi

    #get team from database
    NAME=$($PSQL "SELECT name FROM teams WHERE name='$NAME_O'")

    #if not found
    if [[ -z $NAME ]]
    then
      #insert into table 
      INSERT_NAME_RESULT=$($PSQL "INSERT INTO teams(name) VALUES ('$NAME_O')")
      if [[ $INSERT_NAME_RESULT == "INSERT 0 1" ]]
      then
        echo echo Inserted into teams, $NAME_O
      fi
    fi

    #get winner_id from db
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$NAME_W'")
    #if not found

    #get opponent_id from db
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$NAME_O'")
    #if not found

    #insert into games
    INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id,winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
    then
      GAME_ID=$($PSQL "SELECT game_id FROM games WHERE winner_id=$WINNER_ID AND opponent_id=$OPPONENT_ID")
      echo Inserted game of Game ID: $GAME_ID
    fi
  fi
done