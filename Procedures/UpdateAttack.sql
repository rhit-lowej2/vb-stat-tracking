Create Procedure UpdateAttack
	@HitID int,
	@Type varchar(3)
AS
Begin
	if @HitID is null
	Begin
		PRINT 'ERROR: HitID cannot be null or empty';
		RETURN (1)
	End
	if not exists(Select * From Hit as H Where H.HitID = @HitID)
	Begin
		Print 'Error: Hit does not exist'
		Return 2
	End
	if @Type is null or @Type = ''
	Begin
		PRINT 'ERROR: Type cannot be null or empty';
		RETURN (3)
	End

    Update HAttack
	Set [HitID]=@HitID, [Type]=@Type
	Where [HitID]=@HitID

	Print 'Updated Attack!'
	return 0;
End