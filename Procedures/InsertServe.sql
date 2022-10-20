Create Procedure InsertServe
	@HitID int,
	@Position varchar(10)
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
	if @Position is null or @Position = ''
	Begin
		PRINT 'ERROR: Depth cannot be null or empty';
		RETURN (3)
	End
	Insert into HServe values(@HitID,@Position)
	Print 'Added Serve!'
	return 0;
End