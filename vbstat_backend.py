from getpass import getuser
from webbrowser import get
import pyodbc
from datetime import date, datetime as dt
from sql_utils import CallStoredProc, CallDeleteHit, CallInsertHit, CallStoredProcDisplay
from crud_utils import *

TEAM_NAME = "Rose-Hulman"
practice_date = date.today()

server = 'titan.csse.rose-hulman.edu'
database = 'VBTrackerTester12'
# database = 'VBStatsTracker10'
username = 'VBStatsAdmin'
password = 'help-deed-spin-road-2'

cnxn = pyodbc.connect('DRIVER={ODBC Driver 18 for SQL Server};SERVER='+server+';DATABASE='+database+';ENCRYPT=no;UID='+username+';PWD='+ password)
cursor = cnxn.cursor()

def getSproc():
    menu = """0) administrative actions
1) Display Info
2) Insert Hit
3) Undo Last Hit
4) Display Hits
"""
    actionmenu = """1) Team
2) Player
3) Practice
4) Outcome
5) Attendance
6) Back
    """
    teamMenu = """1) Insert Team
2) Update Team
3) Delete Team
4) Back
    """
    playerMenu = """1) Insert Player
2) Delete Player
3) Update Player Positions
4) Delete Player Positions
5) Back
    """
    practiceMenu = """1) Start Practice
2) Resume Practice
3) Delete Practice
4) Back
    """
    outcomeMenu = """1) Add Outcome
2) Back
    """
    attendMenu = """1) Add Attendance
2) Delete Attendance
3) Back
    """
    displaymenu = """1) Display All Team
2) Display Player
3) Display Practice
4) Display Attendance
5) Back
    """
    print("Pick an action:")
    print(menu)
    user_input = input()
    sproc_name = user_input.split(" ")[0]
    if sproc_name == "0":
        print("Pick an action:")
        print(actionmenu)
        user_input = input()
        sproc_name = sproc_name + user_input.split(" ")[0]

        if sproc_name == "01":
            print("Pick an action:")
            print(teamMenu)
            user_input = input()
            sproc_name = sproc_name + user_input.split(" ")[0]

        elif sproc_name == "02":
            print("Pick an action:")
            print(playerMenu)
            user_input = input()
            sproc_name = sproc_name + user_input.split(" ")[0]

        elif sproc_name == "03":
            print("Pick an action:")
            print(practiceMenu)
            user_input = input()
            sproc_name = sproc_name + user_input.split(" ")[0]

        elif sproc_name == "04":
            print("Pick an action:")
            print(outcomeMenu)
            user_input = input()
            sproc_name = sproc_name + user_input.split(" ")[0]
        elif sproc_name == "05":
            print("Pick an action:")
            print(attendMenu)
            user_input = input()
            sproc_name = sproc_name + user_input.split(" ")[0]
    elif sproc_name == "1":
        print("Pick an action:")
        print(displaymenu)
        user_input = input()
        sproc_name = sproc_name + user_input.split(" ")[0]
    return sproc_name

def insert_team():
    print("input team name")
    name = input()
    print("input location")
    location = input()
    insert_team_util(cnxn, cursor, name, location)

def update_team():
    print("input original team name")
    oldName = input()
    print("input new team name")
    name = input()
    print("input location")
    location = input()

    update_team_util(cnxn, cursor, oldName, name, location)

def delete_team():
    print("input team name")
    name = input()

    delete_team_util(cnxn, cursor, name)

def insert_player():
    HittingPercentage, PassingPercentage = None, None
    print("input player name")
    name = input()
    print("input player number")
    number = input()
    print("is Captain? (1/0)")
    isCap =input()
    print("GradYear")
    GradYear = input()

    insert_player_util(cnxn, cursor, name, number, isCap, GradYear, TEAM_NAME)

    insert_playsposition(name)

def delete_player():
    print("input player name")
    name = input()
    # print("input team name")
    # team_name = input()
    team_name = TEAM_NAME

    delete_player_util(cnxn, cursor, name, team_name)

def insert_attends():
    print("input player name")
    name = input()
    team_name = TEAM_NAME
    print("input pratice date")
    date = input()

    insert_attends_util(cnxn, cursor, name, team_name, date)

def delete_attends():
    print("input player name")
    name = input()
    team_name = TEAM_NAME
    print("input pratice date")
    date = input()

    delete_attends_util(cnxn, cursor, name, team_name, date)

def insert_practice():
    team_name = TEAM_NAME
    print("input practice date (mm/dd/yy)")
    inputdate = input()
    global practice_date
    if inputdate:
        practice_date = dt.strptime(inputdate, "%m/%d/%y")

    insert_practice_util(cnxn, cursor, team_name, date)

def resume_practice():
    print("input practice date (mm/dd/yy)")
    inputdate = input()
    global practice_date
    practice_date = dt.strptime(inputdate, "%m/%d/%y")

def delete_practice():
    team_name = TEAM_NAME
    print("input practice date (mm/dd/yy)")
    date = input()

    delete_practice_util(cnxn, cursor, team_name, date)

def display_team():
    for row in CallStoredProcDisplay(cursor, "DisplayTeam"):
        print(row)
    print(" ")

def display_player():
    print("Team: "+ TEAM_NAME)
    for row in CallStoredProcDisplay(cursor, "DisplayPlayer", TEAM_NAME):
        print(row)
    print(" ")

def display_practice():
    print("Team: "+TEAM_NAME)
    for row in CallStoredProcDisplay(cursor, "DisplayPractice", TEAM_NAME):
        print(row)
    print(" ")

def display_attendance():
    print("Team: "+TEAM_NAME)
    for row in CallStoredProcDisplay(cursor, "DisplayAttends", TEAM_NAME):
        print(row)
    print(" ")

def display_hits():
    print("input practice date")
    inputdate = input()
    if inputdate:
        inputdate = dt.strptime(inputdate, "%m/%d/%y")
    for row in CallStoredProcDisplay(cursor, "DisplayHits", inputdate):
        print(row)
    print(" ")

def insert_outcome():
    print("input outcome name")
    name = input()
    print("input description")
    desc = input()
    print("input abbreviation")
    abbr = input()

    insert_outcome_util(cnxn, cursor, name, desc, abbr)

def delete_outcome():
    print("input outcome name")
    name = input()

    delete_outcome_util(cnxn, cursor, name)

def insert_position():
    print("input position name")
    position = input()

    insert_position_util(cnxn, cursor, position)

def delete_hit(hitid):

    delete_hit_util(cnxn, cursor, hitid)

def insert_hit(hitid):
    done = False
    position, setnumber, depth, attacktype = None, None, None, None
    print("input hit type")
    hittype = input()

    print("input player name")
    name = input()
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
    if name in abbr_map:
        name = abbr_map[name]

    team_name = TEAM_NAME

    if hittype == "Serve":
        print("input position")
        position = input()
        hitid = None

    if hittype == "SR":
        print("input depth")
        depth = input()

    if hittype == "Dig":
        pass

    if hittype == "Set":
        print("input set number")
        setnumber = input()

    if hittype == "Attack":
        print("input attack type")
        attacktype = input()

    print("input outcome abbreviation")
    outcome= input()

    if outcome in ['k', 'tk', 'b', 'e']:
        done = True

    # print(practice_date)
    # print(practice_date.strftime("%m/%d/%y"))
    output = insert_hit_util(cnxn, cursor, name, team_name, practice_date, hitid, outcome, hittype, position, setnumber, depth, attacktype)
    errorcode = output[0]
    if errorcode != 0:
        print("errorcode " + str(errorcode))
    hitid = output[1]
    # print("returned " + str(output))
    return hitid, done

def insert_playsposition(name=None):
    team_name = TEAM_NAME
    if not name:
        print("input player name")
        name = input()
    print("input position name, or hit enter to end")
    posname = input()
    while posname:
        insert_playsposition_util(cnxn, cursor, name, posname, team_name)
        print("input position name, or hit enter to end")
        posname = input()

def delete_playsposition():
    team_name = TEAM_NAME
    print("input player name")
    name = input()
    print("input position name")
    posname = input()
    delete_playsposition_util(cnxn, cursor, name, posname, team_name)


def handleCommand(sproc_name, lasthitidIn):
    lasthitid = lasthitidIn
    if sproc_name == "011":
        insert_team()
    elif sproc_name == "11":
        display_team()
    elif sproc_name == "12":
        display_player()
    elif sproc_name == "13":
        display_practice()
    elif sproc_name == "14":
        display_attendance()
    elif sproc_name == "2":
        done = False
        while not done:
            lasthitid, done = insert_hit(lasthitid)
        return lasthitid
    elif sproc_name == "3":
        lasthitid = delete_hit(lasthitid)
        return lasthitid
    elif sproc_name == "012":
        update_team()
    elif sproc_name == "013":
        delete_team()
    elif sproc_name == "021":
        insert_player()
    elif sproc_name == "022":
        delete_player()
    elif sproc_name == "023":
        insert_playsposition()
    elif sproc_name == "024":
        delete_playsposition()
    elif sproc_name == "031":
        insert_practice()
    elif sproc_name == "032":
        resume_practice()
    elif sproc_name == "033":
        delete_practice()
    elif sproc_name == "041":
        insert_outcome()
    # elif sproc_name == "042":
    #     delete_outcome()
    elif sproc_name == "051":
        insert_attends()
    elif sproc_name == "052":
        delete_attends()
    elif sproc_name == "4":
        display_hits()


# output = CallStoredProc(cursor, 'InsertTeam', 'Rose-Hulman', 'Terre Haute, IN')
# print(output)

# output = CallStoredProc(cursor, 'UpdateTeamInfo', 'Rose-Hulman', 'RHIT', 'Terre Haute, IN')
# print(output)

# output = CallStoredProc(cursor, 'DeleteTeam', 'RHIT')
# print(output)

# rows = cursor.execute("SELECT * FROM Team")
# row = rows.fetchone()
# while row:
#     print(row)
#     row = rows.fetchone()
def main():
    sproc = getSproc()
    lasthitid = None
    while(sproc):
        lasthitid = handleCommand(sproc, lasthitid)
        sproc = getSproc()

main()
