Use VBStatsTracker10
Go
-- To delete a Team from the table by Name or Location
CREATE Procedure DeleteTeam
--making Name and Location optional
	@Name varchar(50) = '-1'
As
Begin
	if @Name is null Or @Name = ''
	Begin
		PRINT 'ERROR: Team name cannot be null or empty';
		RETURN (1)
	End

	Delete From Team Where ([Name]=@Name)

	Print 'Deleted!'
	return 0
End