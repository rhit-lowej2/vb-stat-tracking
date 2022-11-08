Create Database VolleyballTrackerTester10

IF OBJECT_ID('dbo.Plays') IS NOT NULL
DROP Table Plays
IF OBJECT_ID('dbo.PlaysIn') IS NOT NULL
DROP Table PlaysIn
IF OBJECT_ID('dbo.HServe') IS NOT NULL
DROP Table HServe
IF OBJECT_ID('dbo.HSet') IS NOT NULL
DROP Table HSet
IF OBJECT_ID('dbo.HServeReceive') IS NOT NULL
DROP Table HServeReceive
IF OBJECT_ID('dbo.HDig') IS NOT NULL
DROP Table HDig
IF OBJECT_ID('dbo.HAttack') IS NOT NULL
DROP Table HAttack
IF OBJECT_ID('dbo.Hit') IS NOT NULL
DROP Table Hit
IF OBJECT_ID('dbo.Outcome') IS NOT NULL
DROP Table Outcome
IF OBJECT_ID('dbo.Attends') IS NOT NULL
DROP Table Attends
IF OBJECT_ID('dbo.Match') IS NOT NULL
DROP Table Match
IF OBJECT_ID('dbo.PlaysPosition') IS NOT NULL
DROP Table PlaysPosition
IF OBJECT_ID('dbo.Position') IS NOT NULL
DROP Table Position
IF OBJECT_ID('dbo.Practice') IS NOT NULL
DROP Table Practice
IF OBJECT_ID('dbo.Player') IS NOT NULL
DROP Table Player
IF OBJECT_ID('dbo.Team') IS NOT NULL
DROP Table Team
GO

--Creating Tables
CREATE Table Outcome(
	OutcomeID int IDENTITY(1,1),
	Description varchar(200) NOT NULL,
	Name varchar(20) NOT NULL,
	Abbreviation varchar(2) NOT NULL,
	PRIMARY KEY (OutcomeID),
	UNIQUE(Name),
	UNIQUE(Abbreviation)
)
GO

CREATE Table Team (
	TeamID int IDENTITY(1, 1),
	Name varchar(50) NOT NULL,
	Location varchar(200) NOT NULL,
	PRIMARY KEY(TeamID),
	UNIQUE(Name)
)

CREATE Table Player (
	PlayerID int IDENTITY(1, 1),
	Name varchar(20) NOT NULL,
	Number int NOT NULL,
	isCaptain [bit] NOT NULL,
	GradYear int NOT NULL,
	HittingPercentage decimal(4, 3),
	PassingPercentage decimal(4, 3),
	TeamID int REFERENCES Team(TeamID) ON UPDATE NO ACTION ON DELETE NO ACTION,
	PRIMARY KEY (PlayerID),
	CHECK(Number > 0)
)

CREATE Table Position (
	PositionID int IDENTITY(1, 1),
	PositionName varchar(20) NOT NULL,
	PRIMARY KEY (PositionID),
	CHECK(PositionName IN ('Libero','Setter', 'Outside Hitter', 'Opposite Hitter', 'Middle Blocker', 'Defensive Specialist'))
)

CREATE Table Practice (
	PracticeID int IDENTITY(1, 1),
	TeamID int REFERENCES Team(TeamID) ON UPDATE CASCADE ON DELETE CASCADE,
	PracticeDate date NOT NULL,
	PRIMARY KEY(PracticeID)
)

Create Table Match(
    MatchID int IDENTITY(1,1),
	HomeTeamID int REFERENCES Team(TeamID) ON UPDATE CASCADE ON DELETE CASCADE,
	AwayTeamID int REFERENCES Team(TeamID) ON UPDATE NO ACTION ON DELETE NO ACTION,
    Result varchar(5) NOT NULL
        Check(Result='Win' or Result ='Loss'),
    Date date NOT NULL,
    Location varchar(100) NOT NULL,
    Primary Key(MatchID),
)

Create Table PlaysPosition (
	PositionID int,
	PlayerID int,
	Primary Key(PositionID, PlayerID),
	Foreign Key(PositionID) References Position(PositionID)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
	Foreign Key(PlayerID) References Player(PlayerID)
	ON UPDATE CASCADE
	ON DELETE CASCADE
)

Create Table Attends(
    PlayerID int,
    PracticeID int,
    Date date NOT NULL,
    Primary Key(PlayerID, PracticeID),
    Foreign Key(PracticeID) References Practice(PracticeID)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
    Foreign Key(PlayerID) References Player(PlayerID)
    ON UPDATE CASCADE
    ON DELETE CASCADE
)


CREATE Table PlaysIn(
	PlayerID int REFERENCES Player(PlayerID) ON UPDATE CASCADE ON DELETE CASCADE,
	MatchID int REFERENCES Match(MatchID) ON UPDATE CASCADE ON DELETE CASCADE,
	isStarter bit NOT NULL,
	PRIMARY KEY (PlayerID, MatchID)
)
GO

CREATE Table Hit(
	HitID int IDENTITY(1,1),
	PlayerID int NOT NULL REFERENCES Player(PlayerID) ON UPDATE CASCADE ON DELETE CASCADE,
	PracticeID int NOT NULL REFERENCES Practice(PracticeID) ON UPDATE CASCADE ON DELETE CASCADE,
	LeadsTo int References Hit(HitID) ON UPDATE NO ACTION ON DELETE NO ACTION,
	OutcomeID int NOT NULL REFERENCES Outcome(OutcomeID) ON UPDATE CASCADE ON DELETE CASCADE,
	PRIMARY KEY (HitID)
)
GO

CREATE Table HServe(
	HitID int REFERENCES Hit(HitID) ON UPDATE CASCADE ON DELETE CASCADE,
	Position varchar(10) NOT NULL,
	PRIMARY KEY (HitID),
	CHECK (Position in ('left', 'right'))
)
GO

CREATE Table HServeReceive(
	HitID int REFERENCES Hit(HitID) ON UPDATE CASCADE ON DELETE CASCADE,
	Depth char(1) NOT NULL,
	PRIMARY KEY (HitID)
)
GO

CREATE Table HAttack (
	HitID int REFERENCES Hit(HitID) ON UPDATE CASCADE ON DELETE CASCADE,
	Type varchar(10) NOT NULL,
	PRIMARY KEY (HitID)
)
GO

CREATE Table HDig (
	HitID int REFERENCES Hit(HitID) ON UPDATE CASCADE ON DELETE CASCADE,
	PRIMARY KEY (HitID)
)
GO

CREATE Table HSet (
	HitID int REFERENCES Hit(HitID) ON UPDATE CASCADE ON DELETE CASCADE,
	SetNumber int NOT NULL,
	PRIMARY KEY (HitID)
)
GO

--Creating Stored Procedures
Create Procedure InsertAttends
	@PlayerName varchar(20),
	@TeamName varchar(40),
	@Date date
As
Begin

	Declare @TeamID int;
	Select @TeamID =TeamID  From Team as T Where T.Name=@TeamName
	
	if (@TeamID is not null And Not Exists (Select * From Team Where TeamID = @TeamID))
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

	Insert into Attends values(@PlayerID,@PracticeID,@Date)
	Print 'Added Attend'
	Return 0
End
Go

Create Procedure DeleteAttends
	@PlayerName varchar(20),
	@TeamName int,
	@Date date
As
Begin

	Declare @TeamID int;
	Select @TeamID =TeamID  From Team as T Where T.Name=@TeamName
	
	if (@TeamID is not null And Not Exists (Select * From Team Where TeamID = @TeamID))
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
Go

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
Go

CREATE Procedure DeleteLastHit
	@HitID int,
	@PreviousHitID int output
As
Begin

	if @HitID is null
		Begin
			PRINT 'ERROR: Hit ID cannot be null or empty';
			RETURN (1)
		End
	if not exists(Select * From Hit Where HitID = @HitID)
	Begin
		Print'Error: Hit does not exist!'
		Return (2)
	End

	Select @PreviousHitID = HitID From Hit Where LeadsTo = @HitID
	if @PreviousHitID is not null
	BEGIN
		Update Hit Set LeadsTo = null Where HitID = @PreviousHitID
	END
	Delete From Hit Where HitID = @HitID
	
	Print 'Deleted Hit'
	Return (0)
End
Go

Create Procedure InsertOutcome
	@Description varchar(200),
	@Name varchar(20),
	@Abbreviation varchar(2)
AS
Begin
	if @Description is null Or @Description = ''
	Begin
		PRINT 'ERROR: Description cannot be null or empty';
		RETURN (1)
	End

	if @Name is null Or @Name = ''
	Begin
		PRINT 'ERROR: Name cannot be null or empty';
		RETURN (2)
	End

	if @Abbreviation is null Or @Abbreviation = ''
	Begin
		PRINT 'ERROR: Abbreviation cannot be null or empty';
		RETURN (3)
	End

	Insert Into Outcome values(@Description, @Name, @Abbreviation)
	Print 'Added outcome!'
	return 0
End
Go

Create Procedure DeleteOutcome
	@Name varchar(20)
As
Begin
	if @Name is null Or @Name = ''
	Begin
		PRINT 'ERROR: Name cannot be null or empty';
		RETURN (1)
	End
	
	if not exists(Select * From Outcome Where Name=@Name)
		Begin
		PRINT 'ERROR: outcome does not exist';
		RETURN (2)
	End

	Delete From Outcome Where Name=@Name
	Print 'Deleted Outcome!'
	return 0
End
Go

Create Procedure InsertPlayer
	@Name varchar(20),
	@Number int,
	@isCaptain bit = 0,
	@HittingPercentage decimal(4,3) = null,
	@PassingPercentage decimal(4,3) = null,
	@TeamName varchar(50),
	@GradYear int
As
Begin
	if @Name is null Or @Name = ''
	Begin
		PRINT 'ERROR: Player name cannot be null or empty';
		RETURN (1)
	End

	if @Number is null
	Begin
		PRINT 'ERROR: Player number cannot be null';
		RETURN (2)
	End

	if @GradYear is null
	Begin
		PRINT 'ERROR: GradYear cannot be null';
		RETURN (3)
	End

	Declare @TeamID int;
	Select @TeamID =TeamID  From Team Where TeamName=@TeamName
	
	if (@TeamID is not null And Not Exists (Select * From Team Where TeamID = @TeamID))
	Begin
		Print 'Error: Team does not exist';
		Return (4)
	End

	Insert Into Player Values(@Name,@Number,@isCaptain,@GradYear,@HittingPercentage,@PassingPercentage,@TeamID)
	Print 'Added player to the table!'
	return 0
End
Go

Create Procedure UpdatePlayer
	@Name varchar(20),
	@Number int,
	@isCaptain bit = 0,
	@HittingPercentage decimal(4,3) = null,
	@PassingPercentage decimal(4,3) = null,
	@TeamID int = null,
	@GradYear int
As
Begin
    Declare @PlayerID int
	Select @PlayerID = PlayerID From Player As P Where (P.Name = @PlayerName And P.Number = @PlayerNumber)

	if @Name is null Or @Name = ''
	Begin
		PRINT 'ERROR: Player name cannot be null or empty';
		RETURN (1)
	End

	if @Number is null
	Begin
		PRINT 'ERROR: Player number cannot be null';
		RETURN (2)
	End

	if @GradYear is null
	Begin
		PRINT 'ERROR: GradYear cannot be null';
		RETURN (3)
	End

	if (@TeamID is not null And Not Exists (Select * From Team Where TeamID = @TeamID))
	Begin
		Print 'Error: Team does not exist';
		Return (4)
	End

	Update Player
    Set Name=@Name,Number=@Number,isCaptain=@isCaptain,GradYear=@GradYear,
    HittingPercentage=@HittingPercentage,PassingPercentage=@PassingPercentage,TeamID=@TeamID
    Where PlayerID = @PlayerID

	Print 'Updated player info!'
	return 0
End
Go

Create Procedure DeletePlayer
	@Name varchar(20),
	@Number int
As
Begin
	if @Name is null Or @Name = ''
	Begin
		PRINT 'ERROR: Player name cannot be null or empty';
		RETURN (1)
	End

	if @Number is null
	Begin
		PRINT 'ERROR: Player number cannot be null';
		RETURN (2)
	End
	if not exists(Select * From Player Where (Name=@Name and Number=@Number))
	Begin
		Print 'Error: Player does not exist'
		return 3
	End

	Delete From Player Where (Name=@Name and Number=@Number)
	Print 'Player deleted!'
	return 0
End
Go

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
Go

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
Go

Create Procedure DeletePlaysPosition
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

	if @PlayerName is null Or @PlayerName=''
		Begin
			PRINT 'ERROR: player cannot be null or empty';
			RETURN (3)
		End

	DECLARE @TeamID int
	Select @TeamID = TeamID From Team Where (Team.Name = @TeamName)

	Declare @PlayerID int
	Select @PlayerID = PlayerID From Player As P Where (P.Name = @PlayerName And P.TeamID = @TeamID)

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
Go

Create Procedure InsertPosition
	@PositionName varchar(30)
As
Begin
	-- Print 'Alert: PositionName has to be: Defensive Specialist, Middle Blocker, Opposite Hitter, Outside Hitter, Setter, or Libero';
	Print ' '
	if @PositionName is null Or @PositionName = ''
	Begin
		PRINT 'ERROR: Position name cannot be null or empty';
		RETURN (1)
	End

	If(Exists (Select * From Position Where PositionName = @PositionName))
	Begin
		Print 'Error: Position already exists'
		return 2
	End

	
	Insert Into Position Values(@PositionName)
	Print 'Added position to the table!'
	return 0

End
Go

Create Procedure DeletePosition
	@PositionName varchar(30)
As
Begin
	Print 'Alert: PositionName has to be: Defensive Specialist, Middle Blocker, Opposite Hitter, Outside Hitter, Setter, or Libero';
	Print ' '
	if @PositionName is null Or @PositionName = ''
	Begin
		PRINT 'ERROR: Position name cannot be null or empty';
		RETURN (1)
	End

	if not exists(Select * From Position Where PositionName=@PositionName)
	Begin
		PRINT 'ERROR: Position does not exists';
		RETURN (2)
	End

	Delete From Position Where PositionName=@PositionName
	PRINT 'deleted position';
	RETURN (0)
End
Go

Create Procedure InsertPractice
	@TeamName varchar(50),
	@PracticeDate date
AS
Begin

	if @TeamName is null Or @TeamName = ''
		Begin
			PRINT 'ERROR:  team name cannot be null or empty';
			RETURN (1)
		End
	if @PracticeDate is null
		Set @PracticeDate = GETDATE()

	Declare @TeamID int
	Select @TeamID = TeamID From Team As T Where T.Name =@TeamName
	if @TeamID is null
		Begin
			PRINT 'ERROR:  team does not exist';
			RETURN (2)
		End

	if exists(Select * From Practice Where (PracticeDate=@PracticeDate and TeamID=@TeamID))
	Begin
		Print 'Error: practice already exists'
		return 3
	End

	Insert into Practice values(@TeamID,@PracticeDate)
	Print 'Added Practice'
	return 0
End
Go

Create Procedure DeletePractice
	@TeamName varchar(50),
	@PracticeDate date
As
Begin
	if @TeamName is null Or @TeamName = ''
		Begin
			PRINT 'ERROR:  team name cannot be null or empty';
			RETURN (1)
		End
	if @PracticeDate is null
		Begin
			PRINT 'ERROR:  date cannot be null or empty';
			RETURN (2)
		End
	Declare @TeamID int
	Select @TeamID = TeamID From Team As T Where T.Name =@TeamName
	if @TeamID is null
		Begin
			PRINT 'ERROR:  team does not exist';
			RETURN (3)
		End
	if not exists(Select * From Practice Where (PracticeDate=@PracticeDate and TeamID=@TeamID))
	Begin
		Print 'Error: practice does not exist'
		return 4
	End

	Delete From Practice
	Where (PracticeDate=@PracticeDate and TeamID=@TeamID)

	Print 'Practice Deleted!'
	return 0
End
Go

Create Procedure InsertTeam
	@Name varchar(50),
	@Location varchar(200)
As
Begin
	if @Name is null Or @Name = ''
	Begin
		PRINT 'ERROR: Team name cannot be null or empty';
		RETURN (1)
	End

	if Exists(Select Name from Team Where Name = @Name)
	Begin
		PRINT 'ERROR: Team already exists with that name';
		RETURN (2)
	End

	if @Location is null Or @Location = ''
	Begin
		PRINT 'ERROR: Team location cannot be null or empty';
		RETURN (3)
	End
	INSERT INTO Team
	Values(@Name, @Location)
	Print 'Added to table!'
	return 0
End
Go

Create Procedure UpdateTeamInfo
	@OldName varchar(50),
	@NewName varchar(50),
	@Location varchar(200)
As
Begin
	if @NewName is null Or @NewName = ''
	Begin
		PRINT 'ERROR: Team name cannot be null or empty';
		RETURN (1)
	End

	if((@OldName is null) OR (NOT EXISTS (SELECT Name FROM Team WHERE [Name] = @OldName)))
	Begin
		PRINT 'ERROR: Old Team name cannot be null or it does not exist';
		RETURN (2)
	End

	if(EXISTS (SELECT Name FROM Team WHERE [Name] = @NewName))
	Begin
		PRINT 'ERROR: The new team name already exists';
		RETURN (3)
	End

	if @Location is null Or @Location = ''
	Begin
		PRINT 'ERROR: Team location cannot be null or empty';
		RETURN (4)
	End

	Update Team
	Set [Name]=@NewName, [Location]=@Location
	Where [Name]=@OldName

	Print 'Updated!'
	return 0
End
Go

CREATE Procedure DeleteTeam
--making Name and Location optional
	@Name varchar(50) = '-1'
As
Begin
	if @Name is null Or @Name = ''
	Begin
		PRINT 'ERROR: Team name cannot be null or empty';
		RETURN (1)
	End

	Delete From Team Where ([Name]=@Name)

	Print 'Deleted!'
	return 0
End
Go

Create Procedure DisplayAttends
	@TeamName varchar(40)
As
	Declare @TeamID int;
	Select @TeamID =TeamID  From Team as T Where T.Name=@TeamName
	
	if (@TeamID is not null And Not Exists (Select * From Team Where TeamID = @TeamID))
	Begin
		Print 'Error: Team does not exist';
		Return (1)
	End

	Select Name,Date From Attends Join Player on Attends.PlayerID=Player.PlayerID 
	Join Practice on Practice.PracticeID=Attends.PracticeID
	Where Practice.TeamID=@TeamID
	Order By Date
	Return
Go

Create Procedure DisplayPlayer
	@TeamName varchar(40)
As
	Declare @TeamID int;
	Select @TeamID =TeamID  From Team as T Where T.Name=@TeamName
	
	if (@TeamID is not null And Not Exists (Select * From Team Where TeamID = @TeamID))
	Begin
		Print 'Error: Team does not exist';
		Return (1)
	End

	Select Name, Number, GradYear From Player Where TeamID = @TeamID
	Return
Go

Create Procedure DisplayTeam
As
	Select Name From Team
	Return
Go

Create Procedure DisplayPractice
	@TeamName varchar(40)
As
	Declare @TeamID int;
	Select @TeamID =TeamID  From Team as T Where T.Name=@TeamName
	
	if (@TeamID is not null And Not Exists (Select * From Team Where TeamID = @TeamID))
	Begin
		Print 'Error: Team does not exist';
		Return (1)
	End
	Select PracticeDate From Practice Where TeamID=@TeamID Order By PracticeDate
	Return
Go

Create Procedure DisplayHits
	@PracticeID int
As
	
	if (@PracticeID is null Or not exists(Select* From Practice as P Where P.PracticeID = @PracticeID))
	Begin
		Print 'Error: practice cannot be null or practice does not exist';
		Return (1)
	End
	Select Distinct HitID,P.Name,LeadsTo,O.Name From Hit Join Player as P on P.PlayerID = Hit.PlayerID
	Join Outcome as O on O.OutcomeID = Hit.OutcomeID
	Where Hit.PracticeID = @PracticeID

	Return
Go