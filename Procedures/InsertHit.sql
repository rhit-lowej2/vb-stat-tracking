Create Procedure InsertHit
	@PlayerName varchar(20),
	@PlayerNumber int,
	@LeadsTo int = null,
	@OutcomeAbb varchar(2)
AS
Begin
	if @PlayerName is null Or @PlayerName=''
	Begin
		PRINT 'ERROR: PlayerName cannot be null or empty';
		RETURN (1)
	End
	if @PlayerNumber is null
	Begin
		PRINT 'ERROR: PlayerNumber cannot be null';
		RETURN (2)
	End

	Declare @PlayerID int
	Select @PlayerID = PlayerID From Player As P Where (P.Name = @PlayerName And P.Number = @PlayerNumber)
	if @PlayerID is null
		Begin
			Print 'Error: player does not exist';
			return 3
		End

	if @OutcomeAbb is null Or @OutcomeAbb=''
	Begin
		PRINT 'ERROR: OutcomeAbbreviation cannot be null or empty';
		RETURN (5)
	End

	Declare @OutcomeID int
	Select @OutcomeID = OutcomeID From Outcome as O Where  o.Abbreviation= @OutcomeAbb
	if @OutcomeID is null
		Begin
			Print 'Error: outcome does not exist';
			return 6
		End

	If @LeadsTo is null

		Insert Into Hit	values(@PlayerID,null,@OutcomeID)
	Else
		Insert Into Hit	values(@PlayerID,@LeadsTo,@OutcomeID)

	Print 'Added Hit!'
	return 0
End