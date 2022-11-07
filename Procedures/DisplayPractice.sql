Alter Procedure DisplayPractice
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