Use VBStatsTracker10
Go
Create Procedure InsertPlaysPosition
	@PositionName varchar(30),
	@PlayerName varchar(20),
	@TeamName varchar(50)
As
Begin
	Print 'Hint: PositionName has to be: Defensive Specialist, Middle Blocker, Opposite Hitter, Outside Hitter, Setter, or Libero';
	Print ' '
	Declare @PositionID int
	Select @PositionID = PositionID From Position Where PositionName = @PositionName

	if @PositionName is null Or @PositionName=''
		Begin
			PRINT 'ERROR: Position cannot be null or empty';
			RETURN (1)
		End
	if @PositionID is null
		Begin
			Print 'Error: Position does not exist' 
			return 2
		End

	DECLARE @TeamID int
	Select @TeamID = TeamID From Team Where (Team.Name = @TeamName)

	Declare @PlayerID int
	Select @PlayerID = PlayerID From Player As P Where (P.Name = @PlayerName And P.TeamID = @TeamID)

	if @PlayerName is null Or @PlayerName=''
		Begin
			PRINT 'ERROR: player cannot be null or empty';
			RETURN (3)
		End
	if @PlayerID is null
		Begin
			Print 'Error: Player does not exist' 
			return 4
		End

	Insert into PlaysPosition values(@PositionID,@PlayerID)
	Print 'Added!'
	return 0
End