Scriptname StashTrunk:ContainerHandler extends Quest

Group ContainerSettings
	ReferenceAlias Property PickerAlias Auto Const Mandatory
	{Autofill}
	ObjectReference Property StashTrunkContainer Auto Const Mandatory
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

Bool Function isValidLinkTarget(ObjectReference akTargetRef)
	return SimpleSettlementSolutions:Reference.isWorkbench(akTargetRef) && !SimpleSettlementSolutions:Reference.isWorkshopItem(akTargetRef)
EndFunction

Bool Function isLinked(ObjectReference akTargetRef)
	ObjectReference containerRef = getContainer()
	return containerRef == SimpleSettlementSolutions:Reference.getLinkedRef(akTargetRef, SimpleSettlementSolutions:Utility:Keyword.getWorkshopItem()) && containerRef == SimpleSettlementSolutions:Reference.getLinkedRef(akTargetRef, SimpleSettlementSolutions:Utility:Keyword.getContainerLink())
EndFunction

Bool Function linkWorkbench(ObjectReference akTargetRef)
	if (!akTargetRef || !isValidLinkTarget(akTargetRef))
		return false
	endif
	
	StashTrunk:Logger.log("linking workbench: " + akTargetRef)
	ObjectReference containerRef = getContainer()
	SimpleSettlementSolutions:Reference.linkToWorkshop(akTargetRef, containerRef)
	SimpleSettlementSolutions:Reference.linkToContainer(akTargetRef, containerRef)
	
	return true
EndFunction

Bool Function unlinkWorkbench(ObjectReference akTargetRef)
	if (!akTargetRef || !isLinked(akTargetRef))
		return false
	endif
	
	StashTrunk:Logger.log("unlinking workbench: " + akTargetRef)
	SimpleSettlementSolutions:Reference.unlinkFromContainer(akTargetRef)
	SimpleSettlementSolutions:Reference.unlinkFromWorkshop(akTargetRef)
	
	return true
EndFunction

Function takeContents(ObjectReference akTargetRef)
	isLinked(akTargetRef) && akTargetRef.RemoveAllItems(getContainer(), true)
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

ObjectReference Function getContainer()
	return StashTrunkContainer
EndFunction

SimpleSettlementSolutions:Picker Function getSettlementLocationPicker()
	return PickerAlias.GetActorRef() as SimpleSettlementSolutions:Picker
EndFunction

Function open()
	getContainer().Activate(Game.GetPlayer())
EndFunction

Function updateCarryWeight()
	;PickerAlias.GetActorRef().SetValue(CarryWeight, StashTrunk_CaryWeightScale.GetValue() * Game.GetPlayer().GetValue(CarryWeight))
	getContainer().SetValue(CarryWeight, 1)
EndFunction

Event OnQuestInit()
	updateCarryWeight()
EndEvent

Function flushToTarget(WorkshopScript akFlushTarget)
	if (!akFlushTarget)
		getNoFlushMessage().Show()
		return 
	endif

	getContainer().RemoveAllItems(akFlushTarget.GetContainer(), true)
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
