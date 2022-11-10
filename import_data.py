import pandas as pd
import pyodbc
from crud_utils import *

abbr_map = {"s": "Sophia Harrison",
                "liz": "Elizabeth Canon",
                "leah": "Aaliyah Jones",
                "kate": "Kate Wood",
                "allie": "Allie Fults",
                "ky": "Kylie Rathbun",
                "koop": "Sophia Koop",
                "j": "Jillian Gregg",
                "ang": "Angela Potts",
                "eb": "Emily Buchta",
                "syd": "Sydney Naibauer",
                "mw": "Megan Weber",
                "ja": "Jayden O'Dell",
                "cl": "Claudia Rowan",
                "lily": "Lily Ebright",
                "mk": "Megan Korte",
                "mo": "Marina Cadilli",
                "ellie": "Ellie Harshany",
                "m": "McKenzie Gross"
                }

teams = pd.read_csv("Data/Teams.csv")
outcomes = pd.read_csv("Data/Outcomes.csv")
positions = pd.read_csv("Data/Positions.csv")
players = pd.read_csv("Data/Roster.csv")
practice_data = pd.read_csv("Data/Practice 9-27.csv")

server = 'titan.csse.rose-hulman.edu'
database = 'VBTrackerTester12'
# database = 'VBStatsTracker10'
username = 'VBStatsAdmin'
password = 'help-deed-spin-road-2'

cnxn = pyodbc.connect('DRIVER={ODBC Driver 18 for SQL Server};SERVER='+server+';DATABASE='+database+';ENCRYPT=no;UID='+username+';PWD='+ password)
cursor = cnxn.cursor()

# print(teams.head(5))
# print(outcomes.head(5))
# print(positions.head(5))
# print(players.head(5))

for index, row in teams.iterrows():
    # print(row["Team Name"], row["Location"])
    insert_team_util(cnxn, cursor, row["Team Name"], row["Location"])

for index, row in outcomes.iterrows():
    insert_outcome_util(cnxn, cursor, row["Name"], row["Description"], row["Abbreviation"])

for index, row in positions.iterrows():
    insert_position_util(cnxn, cursor, row["Position Name"])

for index, row in players.iterrows():
    name = " ".join(row["Player Name"].split(", ")[::-1])
    isCap = (name == "Sophia Harrison" or name == "Jillian Gregg")
    insert_player_util(cnxn, cursor, name, row["Player Number"], isCap, row["GradYear"], row["Team"])
    position = row["Player Position"].split("/")
    for pos in position:
        insert_playsposition_util(cnxn, cursor, name, pos, row["Team"])

insert_practice_util(cnxn, cursor, "Rose-Hulman", "09/27/22")

for index, row in practice_data.iterrows():
    team_name = "Rose-Hulman"
    setter = row["Setter"]
    
    if setter in abbr_map:
        setter = abbr_map[setter]

    hitter = row["Player"]
    
    if hitter in abbr_map:
        hitter = abbr_map[hitter]

    number = row["Attack"]

    if number == "br":
        number = 11

    result = row["Result"]

    if setter == hitter:
        insert_hit_util(cnxn, cursor, setter, team_name, "09/27/22", None, result, "Attack", None, None, None, "d")
    else:
#       insert_hit_util         (cnxn, cursor, name, team_name, practice_date, hitid, outcome, hittype, position, setnumber, depth, attacktype)
        output = insert_hit_util(cnxn, cursor, setter, team_name, "09/27/22", None, "ip", "Set", None, number, None, None)
        if result in ['ip', 'k', 'e', 'b']:
            insert_hit_util(cnxn, cursor, hitter, team_name, "09/27/22", output[1], result, "Attack", None, None, None, "hit")
        else:
            insert_hit_util(cnxn, cursor, hitter, team_name, "09/27/22", output[1], result, "Attack", None, None, None, "tip")
        print(output)