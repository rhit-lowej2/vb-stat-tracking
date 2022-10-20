Create Procedure InsertMatch
	@HomeTeamName varchar(50),
	@AwayTeamName varchar(50),
	@Result varchar(5),
	@Date date,
	@Location varchar(100)
AS
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

	if @Result is null
	Begin
		PRINT 'ERROR: Result can not be null, or result has to be Win or Loss';
		RETURN (3)
	End

	if @Date is null Or @Date = ''
	Begin
		PRINT 'ERROR: Date cannot be null or empty';
		RETURN (4)
	End

	if @Location is null Or @Location = ''
	Begin
		PRINT 'ERROR: Location cannot be null or empty';
		RETURN (5)
	End

	if(@HomeTeamName = @AwayTeamName)
	Begin
		Print 'Error: Home or Away Team Name has to be different'
		return 6
	End

	Declare @HomeTeamID int
	Declare @AwayTeamID int
	Select @HomeTeamID = TeamID From Team As T where T.Name = @HomeTeamName 
	Select @AwayTeamID = TeamID From Team As T where T.Name = @AwayTeamName 
	if(@HomeTeamID is null)
	Begin
		Print 'Error: Home Team does not exist'
		return 7
	End

	if(@AwayTeamID is null)
	Begin
		Print 'Error: Away Team does not exist'
		return 8
	End

	Insert into Match values(@HomeTeamID,@AwayTeamID,@Result,@Date,@Location)
	Print 'Added Match!'
	Return 0
End