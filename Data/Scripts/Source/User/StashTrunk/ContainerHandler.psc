Scriptname StashTrunk:ContainerHandler extends Quest

ReferenceAlias Property ContainerAlias Auto Const Mandatory
ActorValue Property CarryWeight Auto Const Mandatory
WorkshopParentScript Property WorkshopParent Auto Const Mandatory
Keyword Property StashTrunk_Activator_Keyword_Local Auto Const Mandatory
Location Property DefaultFlushLocation Auto Const Mandatory
Float Property CarryWeightMultiplier = 2.0 Auto Const

Location myFlushLocation = None

Location Function getDefaultFlushLocation()
	return DefaultFlushLocation
EndFunction

Location Function getFlushLocation()
	return myFlushLocation
EndFunction

Function setFlushLocation(Location newValue)
	myFlushLocation = newValue
EndFunction

Function useDefaultFlushLocation()
	setFlushLocation(getDefaultFlushLocation())
EndFunction	

Keyword Function getWorkshopTrunkKeyword()
	return StashTrunk_Activator_Keyword_Local
EndFunction

Function updateCarryWeight()
	getUnderlyingContainer().SetValue(CarryWeight, CarryWeightMultiplier * Game.GetPlayer().GetValue(CarryWeight))
EndFunction

Event OnQuestInit()
	updateCarryWeight()
	setFlushLocation(getDefaultFlushLocation())
EndEvent

Function open()
	getUnderlyingContainer().OpenInventory(true)
EndFunction

Actor Function getUnderlyingContainer()
	return ContainerAlias.GetActorRef()
EndFunction

Function flushToWorkshop(WorkshopScript workshopRef)
	if (workshopRef)
		getUnderlyingContainer().RemoveAllItems(workshopRef.GetContainer(), true)
	endif
EndFunction

WorkshopScript Function getFlushWorkshop()
	WorkshopScript result = WorkshopParent.getWorkshopFromLocation(getFlushLocation())
	if (!result)
		result = WorkshopParent.getWorkshopFromLocation(getDefaultFlushLocation())
	endif
	
	return result
EndFunction

Function flush()
	flushToWorkshop(GetFlushWorkshop())
EndFunction

Function flushToLocalWorkshop(ObjectReference akTargetRef)
	StashTrunk:TrunkActivator trunkRef = akTargetRef as StashTrunk:TrunkActivator
	if (trunkRef && trunkRef.validateIsWorkshopObject())
		flushtoWorkshop(trunkRef.getWorkshop())
	endif
EndFunction
