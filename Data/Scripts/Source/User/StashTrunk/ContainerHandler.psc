Scriptname StashTrunk:ContainerHandler extends Quest

Group ContainerSettings
	ReferenceAlias Property ContainerAlias Auto Const Mandatory
	ActorValue Property CarryWeight Auto Const Mandatory
	GlobalVariable Property StashTrunk_CaryWeightScale Auto Const Mandatory
EndGroup

Group Keywords
	Keyword Property StashTrunk_Activator_Keyword Auto Const Mandatory
	Keyword Property StashTrunk_Activator_Keyword_Flush Auto Const Mandatory
	Keyword Property StashTrunk_Activator_Keyword_Settlement Auto Const Mandatory
	FormList Property StashTrunk_SettlementFilterKeywords Auto Const Mandatory
EndGroup

Group FlushSettings
	Location Property DefaultFlushLocation Auto Const Mandatory
	Message Property StashTrunk_ContainerHandler_FlushMessage Auto Const Mandatory
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

Keyword Function getSettlementKeyword()
	return StashTrunk_Activator_Keyword_Settlement
EndFunction

Keyword Function getActivatorKeyword()
	return StashTrunk_Activator_Keyword
EndFunction

Keyword Function getFlushKeyword()
	return StashTrunk_Activator_Keyword_Flush
EndFunction

Message Function getFlushConfirmMessage()
	return StashTrunk_ContainerHandler_FlushMessage
EndFunction

Message Function getNoFlushMessage()
	return StashTrunk_ContainerHandler_NoFlushMessage
EndFunction

FormList Function getSettlementFilterList()
	return StashTrunk_SettlementFilterKeywords
EndFunction

Location Function pickFlushLocation(Location akSelectLocation)
	return getUnderlyingContainer().OpenWorkshopSettlementMenuEx(getFlushKeyword(), getFlushConfirmMessage(), akSelectLocation, getSettlementFilterList(), None, false, true, true, false, false)
EndFunction

Actor Function getUnderlyingContainer()
	return ContainerAlias.GetActorRef()
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

Function flushToLocation(Location akFlushTarget)
	if (!akFlushTarget)
		getNoFlushMessage().Show()
		return 
	endif

	WorkshopScript result = WorkshopParent.getWorkshopFromLocation(akFlushTarget)
	if (!result)
		result = WorkshopParent.getWorkshopFromLocation(getDefaultFlushLocation())
	endif
	
	if (result)
		getUnderlyingContainer().RemoveAllItems(result.GetContainer(), true)
	else
		getNoFlushMessage().Show()
	endif
EndFunction

Function flush(ObjectReference akTargetRef = None)
	Location selectLocation = None
	StashTrunk:TrunkActivator activatorRef = akTargetRef as StashTrunk:TrunkActivator
	if (activatorRef && activatorRef.hasWorkshop())
		selectLocation = activatorRef.getWorkshop().myLocation
	endif
	
	flushToLocation(pickFlushLocation(selectLocation))
EndFunction
