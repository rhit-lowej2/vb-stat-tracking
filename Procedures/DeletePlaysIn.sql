Create Procedure DeletePlaysIn
	@PlayerName varchar(20),
	@PlayerNumber int,
	@MatchID int
As
Begin
	Declare @PlayerID int
	Select @PlayerID = PlayerID From Player As P Where (P.Name = @PlayerName And P.Number = @PlayerNumber)

	if @PlayerName is null Or @PlayerName=''
		Begin
			PRINT 'ERROR: player cannot be null or empty';
			RETURN (1)
		End
	if @PlayerNumber is null
		Begin
			PRINT 'ERROR: player number cannot be null or empty';
			RETURN (2)
		End
	if @PlayerID is null
		Begin
			Print 'Error: Player does not exist' 
			return 3
		End
	
	if not exists(Select * From PlaysIn Where (MatchID=@MatchID and PlayerID=@PlayerID))
		Begin
		PRINT 'ERROR: Plays in does not exist';
		RETURN (4)
	End

	Delete From PlaysIn Where PlayerID=@PlayerID
	Print 'Deleted PlaysIn!'
	return 0
End