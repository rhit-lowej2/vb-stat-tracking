Create Procedure InsertServeReceive
	@HitID int,
	@Depth char(1) 
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
	if @Depth is null
	Begin
		PRINT 'ERROR: Depth cannot be null or empty';
		RETURN (3)
	End
	Insert into HServeReceive values(@HitID,@Depth)
	Print 'Added ServeReceive!'
	return 0;
End