Create Procedure InsertAttack
	@HitID int,
	@Type varchar(10)
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
	if @Type is null or @Type = ''
	Begin
		PRINT 'ERROR: Type cannot be null or empty';
		RETURN (3)
	End
	Insert into HAttack values(@HitID,@Type)
	Print 'Added Attack!'
	return 0;
End