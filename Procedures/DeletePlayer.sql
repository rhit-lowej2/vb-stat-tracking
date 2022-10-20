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