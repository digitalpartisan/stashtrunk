Scriptname StashTrunk:TrunkActivator extends WorkshopObjectScript

StashTrunk:ContainerHandler Property StashTrunk_ContainerHandler Auto Const Mandatory

Event Chronicle:Package.UninstallComplete(Chronicle:Package sender, Var[] arguments)
	if (StashTrunk_ContainerHandler.getEngine().getCorePackage() == sender)
		watchCorePackage(false)
		Disable()
		Delete()
	endif
EndEvent

Function watchCorePackage(Bool bWatch = true)
	Chronicle:Package:Core corePackage = StashTrunk_ContainerHandler.getEngine().getCorePackage()

	if (bWatch)
		RegisterForCustomEvent(corePackage, "UninstallComplete")
	else
		UnregisterForCustomEvent(corePackage, "UninstallComplete")
	endif
EndFunction

Event OnInit()
	watchCorePackage()
EndEvent

Event OnWorkshopObjectPlaced(ObjectReference akReference)
	WorkshopScript workshopRef = akReference as WorkshopScript
	if (workshopRef)
		workshopRef.AddKeyword(StashTrunk_ContainerHandler.getSettlementKeyword())
	endif
	watchCorePackage()
EndEvent

Event OnWorkshopObjectDestroyed(ObjectReference akReference)
	WorkshopScript workshopRef = akReference as WorkshopScript
	if (workshopRef)
		workshopRef.RemoveKeyword(StashTrunk_ContainerHandler.getSettlementKeyword())
	endif
	watchCorePackage(false)
EndEvent

WorkshopScript Function getWorkshop()
	if (workshopID > 0)
		return WorkshopParent.GetWorkshop(workshopID)
	endif
	
	return None
EndFunction

Bool Function hasWorkshop()
	return getWorkshop() as Bool
EndFunction

Event OnOpen(ObjectReference akActionRef)
	SetOpen(false) ; keeps the trunk closed when it isn't in use so players don't think they did something wrong or something broke
EndEvent

Event OnActivate(ObjectReference akActionRef)
	if (StashTrunk_ContainerHandler.getEngine().getCorePackage().IsRunning())
		StashTrunk_ContainerHandler.open()
	endif
EndEvent
