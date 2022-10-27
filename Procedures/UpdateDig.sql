Create Procedure UpdateDig
	@HitID int
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
	
	Insert into HDig values(@HitID)
	Print 'Added Dig!'
	return 0;
End