Scriptname StashTrunk:TrunkActivator extends WorkshopObjectScript

Group StashTrunkSettings
	StashTrunk:ContainerHandler Property StashTrunk_ContainerHandler Auto Const Mandatory
EndGroup

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
	watchCorePackage()
EndEvent

Event OnWorkshopObjectDestroyed(ObjectReference akReference)
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
	;SetOpen(false) ; keeps the trunk closed when it isn't in use so players don't think they did something wrong or something broke
EndEvent

Event OnClose(ObjectReference akActionRef)
	;SetOpen(false) ; paranoia
EndEvent

Event OnActivate(ObjectReference akActionRef)
	if (StashTrunk_ContainerHandler.getEngine().getCorePackage().IsRunning())
		StashTrunk_ContainerHandler.open()
	endif
EndEvent
