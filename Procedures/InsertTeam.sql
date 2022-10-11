Use VBStatsTracker10
Go
Create Procedure InsertTeam
	@Name varchar(50),
	@Location varchar(200)
As
Begin
	if @Name is null Or @Name = ''
	Begin
		PRINT 'ERROR: Team name cannot be null or empty';
		RETURN (1)
	End

	if Exists(Select Name from Team Where Name = @Name)
	Begin
		PRINT 'ERROR: Team already exists with that name';
		RETURN (2)
	End

	if @Location is null Or @Location = ''
	Begin
		PRINT 'ERROR: Team location cannot be null or empty';
		RETURN (3)
	End
	INSERT INTO Team
	Values(@Name, @Location)
	Print 'Added to table!'
	return 0
End