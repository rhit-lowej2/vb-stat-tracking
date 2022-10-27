Use VBStatsTracker10
Go
Create Procedure UpdatePlaysPosition
	@PositionName varchar(30),
	@PlayerName varchar(20),
	@PlayerNumber int
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

	Declare @PlayerID int
	Select @PlayerID = PlayerID From Player As P Where (P.Name = @PlayerName And P.Number = @PlayerNumber)

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

	Update PlaysPosition
    Set PositionID = @PositionID, PlayerID = PlayerID
	Print 'Updated PlaysPosition!'
	return 0
End