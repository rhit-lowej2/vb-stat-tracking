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