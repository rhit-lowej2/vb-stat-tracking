from sql_utils import CallStoredProc, CallDeleteHit, CallInsertHit, CallStoredProcDisplay

def insert_team_util(cnxn, cursor, name, location):
    output = CallStoredProc(cursor, "InsertTeam", name, location)
    cnxn.commit()
    return output

def update_team_util(cnxn, cursor, oldName, name, location):
    output = CallStoredProc(cursor, "UpdateTeamInfo", oldName, name, location)
    cnxn.commit()
    return output

def delete_team_util(cnxn, cursor, name):
    output = CallStoredProc(cursor, "DeleteTeam", name)
    cnxn.commit()
    return output

def insert_player_util(cnxn, cursor, name, number, isCap, GradYear, team_name):
    HittingPercentage, PassingPercentage = None, None
    output = CallStoredProc(cursor, "InsertPlayer", name, number, isCap, HittingPercentage, PassingPercentage, team_name, GradYear)
    cnxn.commit()
    return output

def delete_player_util(cnxn, cursor, name, team_name):
    output = CallStoredProc(cursor, "DeletePlayer", name, team_name)
    cnxn.commit()
    return output

def insert_attends_util(cnxn, cursor, name, team_name, date):
    output = CallStoredProc(cursor, "InsertAttends", name, team_name, date)
    cnxn.commit()
    return output

def delete_attends_util(cnxn, cursor, name, team_name, date):
    output = CallStoredProc(cursor, "DeleteAttends", name, team_name, date)
    cnxn.commit()
    return output

def insert_practice_util(cnxn, cursor, team_name, date):
    output = CallStoredProc(cursor, "InsertPractice", team_name, date)
    cnxn.commit()
    return output
    
def delete_practice_util(cnxn, cursor, team_name, date):
    output = CallStoredProc(cursor, "DeletePractice", team_name, date)
    cnxn.commit()
    return output

def insert_outcome_util(cnxn, cursor, name, desc, abbr):
    output = CallStoredProc(cursor, "InsertOutcome", name, desc, abbr)
    cnxn.commit()
    return output

def delete_outcome_util(cnxn, cursor, name):
    output = CallStoredProc(cursor, "DeleteOutcome", name)
    cnxn.commit()
    return output

def insert_position_util(cnxn, cursor, position):
    output = CallStoredProc(cursor, "InsertPosition", position)
    cnxn.commit()
    return output

def delete_hit_util(cnxn, cursor, hitid):
    # print("hitid = " + str(hitid))
    output = CallDeleteHit(cursor, hitid)
    # print("returned " + str(output))
    cnxn.commit()
    return output

def insert_hit_util(cnxn, cursor, name, team_name, practice_date, hitid, outcome, hittype, position, setnumber, depth, attacktype):
    output = CallInsertHit(cursor, name, team_name, practice_date, hitid, outcome, hittype, position, setnumber, depth, attacktype)
    cnxn.commit()
    return output

def insert_playsposition_util(cnxn, cursor, name, posname, team_name):
    output = CallStoredProc(cursor, "InsertPlaysPosition", posname, name, team_name)
    cnxn.commit()
    return output

def delete_playsposition_util(cnxn, cursor, name, posname, team_name):
    output = CallStoredProc(cursor, "DeletePlaysPosition", posname, name, team_name)
    cnxn.commit()
    return output