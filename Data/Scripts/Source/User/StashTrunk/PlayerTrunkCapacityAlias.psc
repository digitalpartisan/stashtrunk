Scriptname StashTrunk:PlayerTrunkCapacityAlias extends ReferenceAlias

Function attemptUpdate()
	StashTrunk:ContainerHandler myQuest = GetOwningQuest() as StashTrunk:ContainerHandler
	if (myQuest)
		myQuest.updateCarryWeight()
	endif
EndFunction

Event OnPlayerLoadGame()
	attemptUpdate()
EndEvent

Event OnLocationChange(Location akOldLoc, Location akNewLoc)
	attemptUpdate()
EndEvent

