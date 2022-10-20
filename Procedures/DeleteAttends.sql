Create Procedure DeleteAttends
	@PlayerName varchar(20),
	@PlayerNumber int,
	@PracticeID int
As
Begin

	if @PracticeID is null
		Begin
			PRINT 'ERROR: Practice ID cannot be null or empty';
			RETURN (1)
		End

	Declare @PlayerID int
	Select @PlayerID = PlayerID From Player As P Where (P.Name = @PlayerName And P.Number = @PlayerNumber)

	if @PlayerName is null Or @PlayerName=''
		Begin
			PRINT 'ERROR: player cannot be null or empty';
			RETURN (2)
		End
	if @PlayerID is null
		Begin
			Print 'Error: Player does not exist' 
			return 3
		End

	Delete From Attends Where( PlayerID= @PlayerID and PracticeID = @PracticeID)
	Print 'Deleted Attend'
	Return 0
End
