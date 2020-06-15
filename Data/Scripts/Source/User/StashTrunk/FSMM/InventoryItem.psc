Scriptname StashTrunk:FSMM:InventoryItem extends ObjectReference

Form Property PlaceMe Auto Const Mandatory

Event OnContainerChanged(ObjectReference akNewContainer, ObjectReference akOldContainer)
	if (akNewContainer)
		return
	endif

	Game.GetPlayer().PlaceAtMe(PlaceMe, 1, true, false, false)
	Delete()
EndEvent
