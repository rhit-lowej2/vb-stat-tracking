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