Create Procedure DeleteAttends
	@PlayerName varchar(20),
	@TeamName varchar(50),
	@Date date
As
Begin

	Declare @TeamID int;
	Select @TeamID =TeamID  From Team as T Where T.Name=@TeamName
	
	if @TeamName is null or @TeamID is null
	Begin
		Print 'Error: Team does not exist';
		Return (1)
	End

	if @Date is null
	Begin
		Print 'Error: Date cannot be null'
		return 2
	End

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

	Declare @PracticeID int
	Select @PracticeID = P.PracticeID From Practice as P where (P.TeamID = @TeamID And P.PracticeDate = @Date)
	if(@PracticeID is null)
		Begin
			Print 'Error: Practice does not exist' 
			return 5
		End

	Delete From Attends Where (PlayerID = @PlayerID and PracticeID = @PracticeID and Date = @Date)
	Return 0
End
GO