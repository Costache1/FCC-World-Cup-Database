#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then
# teams ids
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
# if not found
  if [[ -z $WINNER_ID ]]
  then
  INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $WINNER
      fi
  fi
# if not found
  if [[ -z $OPPONENT_ID ]]
  then
  INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_OPPONENT_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $OPPONENT
      fi
    fi
  fi
done

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then
  W_ID=$($PSQL "SELECT team_id FROM teams WHERE teams.name='$WINNER'")
  OP_ID=$($PSQL "SELECT team_id FROM teams WHERE teams.name='$OPPONENT'")
# insert rows

INSERT_ROWS_RESULT=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR, '$ROUND', $W_ID, $OP_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
  if [[ $INSERT_ROWS_RESULT == "INSERT 0 1" ]]
  then
    echo Inserted results $INCREMENT : $YEAR - $ROUND - $WINNER - $OPPONENT  Score: $WINNER_GOALS - $OPPONENT_GOALS
    fi
  fi
done

