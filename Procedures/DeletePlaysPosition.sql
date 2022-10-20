Create Procedure DeletePlaysPosition
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

	if not exists(Select * From PlaysPosition Where(PlayerID=@PlayerID and PositionID=@PositionID))
	Begin
		Print 'Error: info does not exist on the table'
		return 5
	End

	Delete From PlaysPosition Where(PlayerID=@PlayerID and PositionID=@PositionID)
	Print 'Delete PlaysPosition!'
	return 0
End