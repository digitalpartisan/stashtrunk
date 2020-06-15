Scriptname StashTrunk:WorkbenchScanner:PlayerAlias extends ReferenceAlias

StashTrunk:WorkbenchScanner Property StashTrunk_WorkbenchScanner Auto Const Mandatory

Event OnLocationChange(Location akOldLoc, Location akNewLoc)
	StashTrunk_WorkbenchScanner.scan()
EndEvent

Event OnPlayerLoadGame()
	StashTrunk_WorkbenchScanner.scan()
EndEvent

Event OnGetUp(ObjectReference akFurniture)
	StashTrunk:ContainerHandler.getInstance().takeContents(akFurniture)
EndEvent
