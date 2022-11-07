Alter Procedure DisplayAttends
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