Use VBStatsTracker10
Go
Create Procedure InsertPlayer
	@Name varchar(20),
	@Number int,
	@isCaptain bit = 0,
	@HittingPercentage decimal(4,3) = null,
	@PassingPercentage decimal(4,3) = null,
	@TeamID int = null,
	@GradYear int
As
Begin
	if @Name is null Or @Name = ''
	Begin
		PRINT 'ERROR: Player name cannot be null or empty';
		RETURN (1)
	End

	if @Number is null
	Begin
		PRINT 'ERROR: Player number cannot be null';
		RETURN (2)
	End

	if @GradYear is null
	Begin
		PRINT 'ERROR: GradYear cannot be null';
		RETURN (3)
	End

	if (@TeamID is not null And Not Exists (Select * From Team Where TeamID = @TeamID))
	Begin
		Print 'Error: Team does not exist';
		Return (4)
	End

	Insert Into Player Values(@Name,@Number,@isCaptain,@GradYear,@HittingPercentage,@PassingPercentage,@TeamID)
	Print 'Added player to the table!'
	return 0
End