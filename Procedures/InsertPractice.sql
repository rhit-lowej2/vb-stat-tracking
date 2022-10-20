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

	Insert into Practice values(@TeamID,@PracticeDate)
	Print 'Added Practice'
	return 0
End