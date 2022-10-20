Create Procedure InsertSet
	@HitID int,
	@SetNumber int
AS
Begin
	if @HitID is null
	Begin
		PRINT 'ERROR: HitID cannot be null or empty';
		RETURN (1)
	End
	if not exists(Select * From Hit as H Where H.HitID = @HitID)
	Begin
		Print 'Error: Hit does not exsit'
		Return 2
	End
	if @SetNumber is null
	Begin
		PRINT 'ERROR: SetNumber cannot be null or empty';
		RETURN (3)
	End
	Insert into HSet values(@HitID,@SetNumber)
	Print 'Added set!'
	return 0;
End