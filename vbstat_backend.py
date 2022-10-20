import pyodbc

def CallStoredProc(conn, procName, *args):
    sql = """SET NOCOUNT ON
             DECLARE @ret int
             EXEC @ret = %s %s
             SELECT @ret""" % (procName, ','.join(['?'] * len(args)))
    return int(conn.execute(sql, args).fetchone()[0])

server = 'titan.csse.rose-hulman.edu' 
database = 'VBStatsTracker10'
username = 'lowej2'
password = 'Algebra123'

cnxn = pyodbc.connect('DRIVER={ODBC Driver 18 for SQL Server};SERVER='+server+';DATABASE='+database+';ENCRYPT=no;UID='+username+';PWD='+ password)
cursor = cnxn.cursor()

output = CallStoredProc(cursor, 'InsertTeam', 'Rose-Hulman', 'Terre Haute, IN')
print(output)

output = CallStoredProc(cursor, 'UpdateTeamInfo', 'Rose-Hulman', 'RHIT', 'Terre Haute, IN')
print(output)

output = CallStoredProc(cursor, 'DeleteTeam', 'RHIT')
print(output)

rows = cursor.execute("SELECT * FROM Team")
row = rows.fetchone()
while row:
    print(row)
    row = rows.fetchone()

cnxn.commit()

