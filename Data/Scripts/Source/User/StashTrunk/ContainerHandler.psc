Scriptname StashTrunk:ContainerHandler extends Quest

Group ContainerSettings
	ReferenceAlias Property ContainerAlias Auto Const Mandatory
	{Autofill}
	ActorValue Property CarryWeight Auto Const Mandatory
	{Autofill}
	GlobalVariable Property StashTrunk_CaryWeightScale Auto Const Mandatory
	{Autofill}
EndGroup

Group FlushSettings
	WorkshopScript Property RedRocketWorkshopREF Auto Const Mandatory
	{Autofill}
	Message Property StashTrunk_ContainerHandler_NoFlushMessage Auto Const Mandatory
	{Autofill}
EndGroup

WorkshopParentScript Property WorkshopParent Auto Const Mandatory
Chronicle:Engine Property StashTrunk_Engine Auto Const Mandatory

StashTrunk:ContainerHandler Function getInstance() Global
	return Game.GetFormFromFile(0x0000082E, "StashTrunk.esl") as StashTrunk:ContainerHandler
EndFunction

Chronicle:Engine Function getEngine()
	return StashTrunk_Engine
EndFunction

WorkshopScript Function getDefaultFlushWorkshop()
	return RedRocketWorkshopREF
EndFunction

Location Function getDefaultFlushLocation()
	WorkshopScript defaultWorkshop = getDefaultFlushWorkshop()
	if (defaultWorkshop)
		return defaultWorkshop.myLocation
	endif
	
	return None
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
	if (activatorRef)
		WorkshopScript activatorWorkshop = SimpleSettlementSolutions:Reference.getWorkshopReference(activatorRef)
		if (activatorWorkshop)
			selectLocation = activatorWorkshop.myLocation
		endif
	endif
	
	flushToTarget(pickFlushLocation(selectLocation))
EndFunction

Function uninstallFlush()
	flushToTarget(getDefaultFlushWorkshop())
EndFunction
