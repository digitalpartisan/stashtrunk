Scriptname StashTrunk:TrunkActivator extends WorkshopObjectScript Conditional

StashTrunk:ContainerHandler Property StashTrunk_ContainerHandler Auto Const Mandatory

Bool bIsWorkshopObject = false Conditional

WorkshopScript Function getWorkshopRef()
	return WorkshopParent.GetWorkshop(workshopID)
EndFunction

Event OnActivate(ObjectReference akActionRef)
	StashTrunk_ContainerHandler.open()
EndEvent

Event OnWorkshopObjectPlaced(ObjectReference akReference)
	bIsWorkshopObject = true
EndEvent

Event OnOpen(ObjectReference akActionRef)
	SetOpen(false)
EndEvent
