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