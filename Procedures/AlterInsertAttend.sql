USE [VBStatsTracker10]
GO

/****** Object:  StoredProcedure [dbo].[InsertAttends]    Script Date: 11/3/2022 3:42:26 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

Alter Procedure InsertAttends
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
GO

