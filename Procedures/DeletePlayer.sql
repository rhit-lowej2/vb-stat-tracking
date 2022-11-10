Create Procedure DeletePlayer
	@Name varchar(20),
	@TeamName varchar(50)
As
Begin
	if @Name is null Or @Name = ''
	Begin
		PRINT 'ERROR: Player name cannot be null or empty';
		RETURN (1)
	End

	Declare @TeamID int;
	Select @TeamID =TeamID  From Team Where TeamName=@TeamName

	if @TeamName is null or @TeamID is null
	Begin
		PRINT 'ERROR: That team does not exist';
		RETURN (2)
	End

	if not exists(Select * From Player Where (Name=@Name and TeamID=@TeamID))
	Begin
		Print 'Error: Player does not exist'
		return 3
	End

	Delete From Player Where (Name=@Name and TeamID=@TeamID)
	Print 'Player deleted!'
	return 0
End