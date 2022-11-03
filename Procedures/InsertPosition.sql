Use VBStatsTracker10
Go
Create Procedure InsertPosition
	@PositionName varchar(30)
As
Begin
	-- Print 'Alert: PositionName has to be: Defensive Specialist, Middle Blocker, Opposite Hitter, Outside Hitter, Setter, or Libero';
	Print ' '
	if @PositionName is null Or @PositionName = ''
	Begin
		PRINT 'ERROR: Position name cannot be null or empty';
		RETURN (1)
	End

	If(Exists (Select * From Position Where PositionName = @PositionName))
	Begin
		Print 'Error: Position already exists'
		return 2
	End

	
	Insert Into Position Values(@PositionName)
	Print 'Added position to the table!'
	return 0

End