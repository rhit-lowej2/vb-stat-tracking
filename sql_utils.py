import pyodbc

def CallStoredProc(conn, procName, *args):
    sql = """SET NOCOUNT ON
             DECLARE @ret int
             EXEC @ret = %s %s
             SELECT @ret""" % (procName, ','.join(['?'] * len(args)))
    return int(conn.execute(sql, args).fetchone()[0])
    
def CallStoredProcDisplay(conn, procName, *args):
    sql = """SET NOCOUNT ON
             DECLARE @ret int
             EXEC @ret = %s %s
             SELECT @ret""" % (procName, ','.join(['?'] * len(args)))
    return conn.execute(sql, args).fetchall()

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