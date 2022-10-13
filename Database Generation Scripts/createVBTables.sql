Use VBStatsTracker10
GO

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
	LeadsTo int References Hit(HitID) ON UPDATE NO ACTION ON DELETE NO ACTION,
	OutcomeID int REFERENCES Outcome(OutcomeID) ON UPDATE CASCADE ON DELETE CASCADE,
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
	Type varchar(3) NOT NULL,
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