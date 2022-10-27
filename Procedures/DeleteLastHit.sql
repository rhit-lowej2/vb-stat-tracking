CREATE Procedure DeleteLastHit
	@HitID int,
	@PreviousHitID int output
As
Begin

	if @HitID is null
		Begin
			PRINT 'ERROR: Hit ID cannot be null or empty';
			RETURN (1)
		End
	if not exists(Select * From Hit Where HitID = @HitID)
	Begin
		Print'Error: Hit does not exist!'
		Return (2)
	End

	Select @PreviousHitID = HitID From Hit Where LeadsTo = @HitID
	if @PreviousHitID is not null
	BEGIN
		Update Hit Set LeadsTo = null Where HitID = @PreviousHitID
	END
	Delete From Hit Where HitID = @HitID
	
	Print 'Deleted Hit'
	Return (0)
End