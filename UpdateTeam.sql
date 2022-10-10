Use VBStatsTracker10
Go
Create Procedure UpdateTeamInfo
	@OldName varchar(50),
	@NewName varchar(50),
	@Location varchar(200),
As
Begin
	if @NewName is null Or @NewName = ''
	Begin
		PRINT 'ERROR: Team name cannot be null or empty';
		RETURN (1)
	End

	if(@OldName is null OR NOT EXISTS (SELECT * FROM [Team] WHERE Name = @OldName)
	Begin
		PRINT 'ERROR: Old Team name cannot be null or it does not exist';
		RETURN (2)
	End

	if @Location is null Or @Location = ''
	Begin
		PRINT 'ERROR: Team location cannot be null or empty';
		RETURN (3)
	End
	Update Team
	Set [Name]=@NewName, [Location]=@Location
	Where [Name]=@OldName

	Print 'Updated!'
	return 0
End