Create Procedure InsertPlaysIn
	@PlayerName varchar(20),
	@PlayerNumber int,
	@MatchID int,
	@IsStarter bit
As
Begin
	if @IsStarter is null
	Begin
		Print 'Error: IsStarter cannot be null'
		return 1
	End

	if not exists(Select * From Match as M where M.MatchID=@MatchID)
		Begin
			Print 'Error: MatchI does not exist' 
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

	Insert into PlaysIn values(@PlayerID,@MatchID,@IsStarter)
	Print 'Added PlaysIn'
	Return 0
End