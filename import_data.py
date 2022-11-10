import pandas as pd
from vbstat_backend import TEAM_NAME, insert_team, insert_player, insert_playsposition, insert_practice, insert_hit,insert_position,insert_outcome
teams = pd.read_csv("Data/Teams.csv")
outcomes = pd.read_csv("Data/Outcomes.csv")
positions = pd.read_csv("Data/Positions.csv")
players = pd.read_csv("Data/Roster.csv")
practice_data = pd.read_csv("Data/Practice 9-27.csv")

print(teams.head(5))
print(outcomes.head(5))
print(positions.head(5))
print(players.head(5))

for index, row in teams.iterrows():
    print(row["Team Name"], row["Location"])
    insert_team(row["Team Name"], row["Location"])