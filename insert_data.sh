#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
#IMPORTANT NOTE: I have used freecodecamp's Learn SQL Part 1's insert_data.sh as a template here
echo $($PSQL "TRUNCATE games, teams")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  echo 1
  if [[ $YEAR != "year" ]] && [[ $ROUND != "round" ]] && [[ $WINNER != "winner" ]] && [[ $OPPONENT != "opponent" ]] && [[ $WINNER_GOALS != "winner_goals" ]] && [[ $OPPONENT_GOALS != "opponent_goals" ]]
  then
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    if [[ -z $OPPONENT_ID ]]
    then
      OPPONENT_ID=$($PSQL "SELECT COUNT(*) FROM teams")
      echo $($PSQL "INSERT INTO teams(team_id,name) VALUES($OPPONENT_ID,'$OPPONENT')")
    fi
    if [[ -z $WINNER_ID ]]
    then
      WINNER_ID=$($PSQL "SELECT COUNT(*) FROM teams")
      echo $($PSQL "INSERT INTO teams(team_id,name) VALUES($WINNER_ID,'$WINNER')")
    fi
    echo $WINNER
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    GAME_ID=$($PSQL "SELECT COUNT(*) FROM games")
    echo $($PSQL "INSERT INTO games(game_id, year, winner_id, opponent_id, winner_goals, opponent_goals, round) VALUES($GAME_ID, $YEAR, $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS, '$ROUND')")
  fi
done
