from getpass import getuser
from webbrowser import get
import pyodbc
from datetime import date, datetime as dt

TEAM_NAME = "Rose-Hulman Institute of Technology"
practice_date = date.today()

def CallStoredProc(conn, procName, *args):
    sql = """SET NOCOUNT ON
             DECLARE @ret int
             EXEC @ret = %s %s
             SELECT @ret""" % (procName, ','.join(['?'] * len(args)))
    return int(conn.execute(sql, args).fetchone()[0])

def CallDeleteHit(conn, *args):
    sql = """SET NOCOUNT ON
             DECLARE @ret int
             DECLARE @output int
             EXEC @ret = DeleteLastHit
                @HitID = ?,
                @PreviousHitID = @output OUTPUT
             SELECT @ret, @output"""
    output = conn.execute(sql, args).fetchone()
    return (int(output[0]), output[1])

def CallInsertHit(conn, *args):
    sql = """SET NOCOUNT ON
             DECLARE @ret int
             DECLARE @output int
             EXEC @ret = InsertHit @PlayerName = ?,
                @TeamName = ?,
                @PracticeDate = ?,
                @CameFrom = ?,
                @OutcomeAbb = ?,
                @HitType = ?,
	            @Position = ?,
                @SetNumber = ?,
                @Depth = ?,
                @Type = ?,
                @return = @output OUTPUT
             SELECT @ret, @output"""
    output = conn.execute(sql, args).fetchone()
    return (int(output[0]), output[1])

def getSproc():
    menu = """0) administrative actions
1) Insert Hit
2) Undo Last Hit"""
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
4) Back
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
    return sproc_name

def insert_team():
    print("input team name")
    name = input()

    print("input location")
    location = input()
    output = CallStoredProc(cursor, "InsertTeam", name, location)
    print("returned " + str(output))
    cnxn.commit()

def update_team():
    print("input original team name")
    oldName = input()
    print("input new team name")
    name = input()
    print("input location")
    location = input()

    output = CallStoredProc(cursor, "UpdateTeamInfo", oldName, name, location)
    print("returned " + str(output))
    cnxn.commit()

def delete_team():
    print("input team name")
    name = input()
    output = CallStoredProc(cursor, "DeleteTeam", name)
    print("returned " + str(output))
    cnxn.commit()

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
    output = CallStoredProc(cursor, "InsertPlayer", name, number, isCap, HittingPercentage, PassingPercentage, TEAM_NAME, GradYear)
    print("returned "+ str(output))
    insert_playsposition(name)
    cnxn.commit()

def delete_player():
    print("input player name")
    name = input()
    print("input player number")
    number = input()
    output = CallStoredProc(cursor, "DeletePlayer", name, number)
    print("returned "+ str(output))
    cnxn.commit()

def insert_attends():
    print("input player name")
    pname = input()
    tname = TEAM_NAME
    print("input pratice date")
    date = input()
    output = CallStoredProc(cursor, "InsertAttends", pname, tname, date)
    print("returned "+ str(output))
    cnxn.commit()

def delete_attends():
    print("input player name")
    pname = input()
    tname = TEAM_NAME
    print("input pratice date")
    date = input()
    output = CallStoredProc(cursor, "DeleteAttends", pname, tname, date)
    print("returned "+ str(output))
    cnxn.commit()

def insert_practice():
    name = TEAM_NAME
    print("input practice date (mm/dd/yy)")
    inputdate = input()
    global practice_date
    practice_date = dt.strptime(inputdate, "%m/%d/%y")
    output = CallStoredProc(cursor, "InsertPractice", name, inputdate)
    print("returned "+ str(output))
    cnxn.commit()

def resume_practice():
    print("input practice date (mm/dd/yy)")
    inputdate = input()
    global practice_date
    practice_date = dt.strptime(inputdate, "%m/%d/%y")
    
def delete_practice():
    name = TEAM_NAME
    print("input practice date (mm/dd/yy)")
    inputdate = input()
    output = CallStoredProc(cursor, "DeletePractice", name, inputdate)
    print("returned "+ str(output))
    cnxn.commit()

def insert_outcome():
    print("input outcome name")
    name = input()
    print("input abbreviation")
    abbr = input()
    print("input description")
    desc = input()
    output = CallStoredProc(cursor, "InsertOutcome", desc, name, abbr)
    print("returned "+ str(output))
    cnxn.commit()

def delete_outcome():
    print("input outcome name")
    name = input()
    output = CallStoredProc(cursor, "DeleteOutcome", name)
    print("returned "+ str(output))
    cnxn.commit()

def delete_hit(hitid):
    print("hitid = " + str(hitid))
    output = CallDeleteHit(cursor, hitid)
    print("returned " + str(output))
    cnxn.commit()

def insert_hit(hitid):
    done = False
    position, setnumber, depth, attacktype = None, None, None, None
    print("input hit type")
    hittype = input()

    print("input player name")
    name = input()
    abbr_map = {"s": "Sophia Harrison",
                "j": "Jillian Gregg",
                "liz": "Elizabeth Canon"}
    name = abbr_map[name]

    teamname = TEAM_NAME

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

    print(practice_date)
    print(practice_date.strftime("%m/%d/%y"))
    output = CallInsertHit(cursor, name, teamname, practice_date, hitid, outcome, hittype, position, setnumber, depth, attacktype)
    errorcode = output[0]
    if errorcode != 0:
        print("errorcode " + str(errorcode))
    hitid = output[1]
    print("returned " + str(output))
    cnxn.commit()
    return hitid, done

def insert_playsposition(name=None):
    if not name:
        print("input player name")
        name = input()
    print("input position name, or hit enter to end")
    posname = input()
    while posname:
        output = CallStoredProc(cursor, "InsertPlaysPosition", posname, name, TEAM_NAME)
        print("returned " + str(output))
        cnxn.commit()
        print("input position name, or hit enter to end")
        posname = input()


def handleCommand(sproc_name, lasthitidIn):
    lasthitid = lasthitidIn
    if sproc_name == "011":
        insert_team()
    elif sproc_name == "1":
        done = False
        while not done:
            lasthitid, done = insert_hit(lasthitid)
        return lasthitid
    elif sproc_name == "2":
        delete_hit(lasthitid)
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
        
    

            


server = 'titan.csse.rose-hulman.edu' 
database = 'VBStatsTracker10'
username = 'VBStatsAdmin'
password = 'help-deed-spin-road-2'

cnxn = pyodbc.connect('DRIVER={ODBC Driver 18 for SQL Server};SERVER='+server+';DATABASE='+database+';ENCRYPT=no;UID='+username+';PWD='+ password)
cursor = cnxn.cursor()

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

sproc = getSproc()
lasthitid = None
while(sproc):
    lasthitid = handleCommand(sproc, lasthitid)
    sproc = getSproc()

