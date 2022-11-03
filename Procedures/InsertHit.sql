CREATE Procedure InsertHit
	@PlayerName varchar(20),
	@TeamName varchar(50),
	@PracticeDate date,
	@CameFrom int = null,
	@OutcomeAbb varchar(2),
	@HitType varchar(5),
	@Position varchar(5) = null,
	@SetNumber int = null,
	@Depth char(1) = null,
	@Type varchar(3) = null,
	@return int output
AS
Begin
	if @PlayerName is null Or @PlayerName=''
	Begin
		PRINT 'ERROR: PlayerName cannot be null or empty';
		RETURN 1
	End

	if @TeamName is null Or @TeamName=''
	Begin
		PRINT 'ERROR: TeamName cannot be null or empty';
		RETURN 2
	End

	DECLARE @TeamID int
	Select @TeamID = TeamID From Team Where (Team.Name = @TeamName)

	Declare @PlayerID int
	Select @PlayerID = PlayerID From Player As P Where (P.Name = @PlayerName And P.TeamID = @TeamID)
	if @PlayerID is null
		Begin
			Print 'Error: player does not exist';
			return 3
		End

	DECLARE @PracticeID int
	SELECT @PracticeID = PracticeID From Practice Where (PracticeDate = @PracticeDate and TeamID = @TeamID)
	IF @PracticeID is null
		Begin
			Print 'ERROR: Practice does not exist'
			return 4
		End

	if @OutcomeAbb is null Or @OutcomeAbb=''
	Begin
		PRINT 'ERROR: OutcomeAbbreviation cannot be null or empty';
		RETURN 5
	End

	Declare @OutcomeID int
	Select @OutcomeID = OutcomeID From Outcome Where Abbreviation = @OutcomeAbb
	if @OutcomeID is null
		Begin
			Print 'ERROR: outcome does not exist';
			return 6
		End


	Insert Into Hit(PlayerID, PracticeID, OutcomeID) values(@PlayerID, @PracticeID, @OutcomeID)
	
	SELECT @return = @@Identity
	Print(@return)
	
	IF @HitType is null Or @HitType=''
	Begin
		PRINT 'ERROR: HitType cannot be null or empty';
		RETURN 7
	End

	IF @HitType = 'Serve'
	BEGIN
		IF @Position is null Or @Position=''
		Begin
			PRINT 'ERROR: Position cannot be null or empty';
			RETURN 8
		End
		Insert Into HServe values(@return, @Position)
	END

	IF @HitType = 'SR'
	BEGIN
		IF @Depth is null Or @Depth=''
		Begin
			PRINT 'ERROR: Depth cannot be null or empty';
			RETURN 8
		End
		Insert Into HServeReceive values(@return, @Depth)
	END

	IF @HitType = 'Dig'
	BEGIN
		Insert Into HDig values(@return)
	END

	IF @HitType = 'Set'
	BEGIN
		IF @SetNumber is null OR @SetNumber NOT IN (1,2,3,4,5,6,8,9)
		Begin
			PRINT 'ERROR: SetNumber cannot be null and must be in the values (1,2,3,4,5,6,8,9)';
			RETURN 8
		End
		Insert Into HSet values(@return, @SetNumber)
	END

	IF @HitType = 'Attack'
	BEGIN
		IF @Type is null Or @Type=''
		Begin
			PRINT 'ERROR: Type cannot be null or empty';
			RETURN 8
		End
		Insert Into HAttack values(@return, @Type)
	END

	If @CameFrom is not null
		Update Hit
		SET LeadsTo = @return
		WHERE HitID = @CameFrom

	Print 'Added Hit!'
	return 0
End