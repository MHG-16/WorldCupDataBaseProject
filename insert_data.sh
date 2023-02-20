#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "truncate teams, games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != winner ]]
  then
    # get winner id if exists or null
    WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")";
    #if not exist
    if [[ -z $WINNER_ID ]]
    then
      #INSERT new team
      INSERTED_NEW_TEAM="$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")"
      if [[ $INSERTED_NEW_TEAM == 'INSERT 0 1' ]]
      then
        echo "Inserted $WINNER into teams"
      fi
    fi
    OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")";
    if [[ -z $OPPONENT_ID ]]
    then
      #INSERT new team
      INSERTED_NEW_TEAM="$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")"
      if [[ $INSERTED_NEW_TEAM == 'INSERT 0 1' ]]
      then
        echo "Inserted $OPPONENT into teams"
      fi
    fi

    #get winner_id & opponent_id
    WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")";
    OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")";
    #INSERT new game
    INSERTED_NEW_GAME="$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")";
    if [[ $INSERTED_NEW_TEAM == 'INSERT 0 1' ]]
      then
        echo "Inserted new games into games"
      fi
  fi
done