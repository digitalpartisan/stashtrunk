Scriptname StashTrunk:TrunkActivator extends ObjectReference

StashTrunk:ContainerHandler Function getContainerHandler()
	return StashTrunk:ContainerHandler.getInstance()
EndFunction

Event OnOpen(ObjectReference akActionRef)
	SetOpen(false) ; keeps the trunk closed when it isn't in use so players don't think they did something wrong or something broke
EndEvent

Event OnClose(ObjectReference akActionRef)
	SetOpen(false) ; paranoia
EndEvent

Event OnActivate(ObjectReference akActionRef)
	StashTrunk:ContainerHandler theHandler = getContainerHandler()
	theHandler.getEngine().getCorePackage().IsRunning() && theHandler.open()
EndEvent
