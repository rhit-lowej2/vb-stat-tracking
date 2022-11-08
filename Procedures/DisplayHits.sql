Create Procedure DisplayHits
	@PracticeID int
As
	
	if (@PracticeID is null Or not exists(Select* From Practice as P Where P.PracticeID = @PracticeID))
	Begin
		Print 'Error: practice cannot be null or practice does not exist';
		Return (1)
	End
	Select Distinct HitID,P.Name,LeadsTo,O.Name From Hit Join Player as P on P.PlayerID = Hit.PlayerID
	Join Outcome as O on O.OutcomeID = Hit.OutcomeID
	Where Hit.PracticeID = @PracticeID

	Return