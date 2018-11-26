Scriptname StashTrunk:TrunkActivator extends WorkshopObjectScript

StashTrunk:ContainerHandler Property StashTrunk_ContainerHandler Auto Const Mandatory
Chronicle:Package:Core Property StashTrunk_PackageCore Auto Const Mandatory

Event Chronicle:Package.UninstallComplete(Chronicle:Package sender, Var[] arguments)
	if (sender == StashTrunk_PackageCore)
		Disable()
		Delete()
	endif
EndEvent

Function watchCorePackage(Bool bWatch = true)
	if (bWatch)
		RegisterForCustomEvent(StashTrunk_PackageCore, "UninstallComplete")
	else
		UnregisterForCustomEvent(StashTrunk_PackageCore, "UninstallComplete")
	endif
EndFunction

Event OnWorkshopObjectPlaced(ObjectReference akReference)
	AddKeyword(StashTrunk_ContainerHandler.getWorkshopTrunkKeyword())
	watchCorePackage()
EndEvent

Event OnWorkshopObjectDestroyed(ObjectReference akReference)
	watchCorePackage(false)
EndEvent

WorkshopScript Function getWorkshop()
	return WorkshopParent.GetWorkshop(workshopID)
EndFunction

Bool Function validateIsWorkshopObject()
	return HasKeyword(StashTrunk_ContainerHandler.getWorkshopTrunkKeyword()) && getWorkshop()
EndFunction

Event OnOpen(ObjectReference akActionRef)
	SetOpen(false) ; keeps the trunk closed when it isn't in use so players don't think they did something wrong or something broke
EndEvent

Event OnActivate(ObjectReference akActionRef)
	if (StashTrunk_PackageCore.IsRunning())
		StashTrunk_ContainerHandler.open()
	endif
EndEvent
