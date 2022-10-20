Create Procedure DeletePosition
	@PositionName varchar(30)
As
Begin
	Print 'Alert: PositionName has to be: Defensive Specialist, Middle Blocker, Opposite Hitter, Outside Hitter, Setter, or Libero';
	Print ' '
	if @PositionName is null Or @PositionName = ''
	Begin
		PRINT 'ERROR: Position name cannot be null or empty';
		RETURN (1)
	End

	if not exists(Select * From Position Where PositionName=@PositionName)
	Begin
		PRINT 'ERROR: Position does not exists';
		RETURN (2)
	End

	Delete From Position Where PositionName=@PositionName
	PRINT 'deleted position';
	RETURN (0)
End