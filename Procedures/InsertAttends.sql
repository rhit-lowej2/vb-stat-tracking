Create Procedure InsertAttends
	@PlayerName varchar(20),
	@PlayerNumber int,
	@PracticeID int,
	@Date date
As
Begin
	if @Date is null
	Begin
		Print 'Error: Date cannot be null'
		return 1
	End

	if not exists(Select * From Practice as P where P.PracticeID = @PracticeID)
		Begin
			Print 'Error: Practice does not exist' 
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

	Insert into Attends values(@PlayerID,@PracticeID,@Date)
	Print 'Added Attend'
	Return 0
End