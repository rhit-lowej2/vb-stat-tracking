from getpass import getuser
from webbrowser import get
import pyodbc

TEAM_NAME = "Rose-Hulman Institute of Technology"

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
1) InsertHit
2) DeleteLastHit"""
    actionmenu = """1) InsertTeam
2) UpdateTeam
3) DeleteTeam
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
    return sproc_name

def insert_team():
    print("input team name")
    name = input()

    print("input location")
    location = input()
    output = CallStoredProc(cursor, "InsertTeam", name, location)
    print("returned " + str(output))
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

    if outcome in "kbe":
        done = True

    output = CallInsertHit(cursor, name, teamname, hitid, outcome, hittype, position, setnumber, depth, attacktype)
    errorcode = output[0]
    if errorcode != 0:
        print("errorcode " + str(errorcode))
    hitid = output[1]
    print("returned " + str(output))
    cnxn.commit()
    return hitid, done

def handleCommand(sproc_name, lasthitidIn):
    lasthitid = lasthitidIn
    if sproc_name == "01":
        insert_team()
    elif sproc_name == "1":
        done = False
        while not done:
            lasthitid, done = insert_hit(lasthitid)
        return lasthitid
    elif sproc_name == "2":
        delete_hit(lasthitid)
            


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

