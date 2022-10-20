Create Procedure DeleteMatch
	@HomeTeamName varchar(50),
	@AwayTeamName varchar(50)
As
Begin
	if @HomeTeamName is null Or @HomeTeamName = ''
	Begin
		PRINT 'ERROR: HomeTeam name cannot be null or empty';
		RETURN (1)
	End

	if @AwayTeamName is null Or @AwayTeamName = ''
	Begin
		PRINT 'ERROR: AwayTeam name cannot be null or empty';
		RETURN (2)
	End

	Declare @HomeTeamID int
	Declare @AwayTeamID int
	Select @HomeTeamID = TeamID From Team As T where T.Name = @HomeTeamName 
	Select @AwayTeamID = TeamID From Team As T where T.Name = @AwayTeamName 

	if not exists(Select * From Match Where (HomeTeamID=@HomeTeamID and AwayTeamID=@AwayTeamID))
	Begin
		Print 'Error: match does not exist!'
		return 3
	End

	Delete From Match 
	Where (HomeTeamID=@HomeTeamID and AwayTeamID=@AwayTeamID)

	Print'Deleted Match'
	return 0
End