Scriptname StashTrunk:ContainerHandler extends Quest

Group ContainerSettings
	ReferenceAlias Property ContainerAlias Auto Const Mandatory
	ActorValue Property CarryWeight Auto Const Mandatory
	GlobalVariable Property StashTrunk_CaryWeightScale Auto Const Mandatory
EndGroup

Group FlushSettings
	Location Property DefaultFlushLocation Auto Const Mandatory
	Message Property StashTrunk_ContainerHandler_NoFlushMessage Auto Const Mandatory
EndGroup

WorkshopParentScript Property WorkshopParent Auto Const Mandatory
Chronicle:Engine Property StashTrunk_Engine Auto Const Mandatory

Chronicle:Engine Function getEngine()
	return StashTrunk_Engine
EndFunction

Location Function getDefaultFlushLocation()
	return DefaultFlushLocation
EndFunction

Message Function getNoFlushMessage()
	return StashTrunk_ContainerHandler_NoFlushMessage
EndFunction

WorkshopScript Function pickFlushLocation(Location akSelectLocation)
	return getSettlementLocationPicker().pick(akSelectLocation)
EndFunction

Actor Function getUnderlyingContainer()
	return ContainerAlias.GetActorRef()
EndFunction

SimpleSettlementSolutions:Picker Function getSettlementLocationPicker()
	return getUnderlyingContainer() as SimpleSettlementSolutions:Picker
EndFunction

Function open()
	getUnderlyingContainer().OpenInventory(true)
EndFunction

Function updateCarryWeight()
	getUnderlyingContainer().SetValue(CarryWeight, StashTrunk_CaryWeightScale.GetValue() * Game.GetPlayer().GetValue(CarryWeight))
EndFunction

Event OnQuestInit()
	updateCarryWeight()
EndEvent

Function flushToTarget(WorkshopScript akFlushTarget)
	if (!akFlushTarget)
		getNoFlushMessage().Show()
		return 
	endif

	getUnderlyingContainer().RemoveAllItems(akFlushTarget.GetContainer(), true)
EndFunction

Function flush(ObjectReference akTargetRef = None)
	Location selectLocation = None
	StashTrunk:TrunkActivator activatorRef = akTargetRef as StashTrunk:TrunkActivator
	if (activatorRef && activatorRef.hasWorkshop())
		selectLocation = activatorRef.getWorkshop().myLocation
	endif
	
	flushToTarget(pickFlushLocation(selectLocation))
EndFunction
