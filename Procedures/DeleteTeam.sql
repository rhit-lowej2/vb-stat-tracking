Use VBStatsTracker10
Go
-- To delete a Team from the table by Name or Location
Create Procedure DeleteTeam
--making Name and Location optional
	@Name varchar(50) = '-1',
	@Location varchar(50) = '-1'
As
Begin
	if @Name is null Or @Name = ''
	Begin
		PRINT 'ERROR: Team name cannot be null or empty';
		RETURN (1)
	End

	if @Location is null Or @Location = ''
	Begin
		PRINT 'ERROR: Team Loaction cannot be null or empty';
		RETURN (2)
	End

	Delete From Team Where ([Name]=@Name OR [Location]=@Location)

	Print 'Updated!'
	return 0
End