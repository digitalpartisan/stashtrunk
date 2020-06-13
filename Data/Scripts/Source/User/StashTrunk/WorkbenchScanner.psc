Scriptname StashTrunk:WorkbenchScanner extends Quest

GlobalVariable Property StashTrunk_WorkbenchScanner_Radius Auto Const Mandatory
GlobalVariable Property StashTrunk_WorkbenchScanner_Interval Auto Const Mandatory
Int Property TimerID = 1 Auto Const

ObjectReference[] workbenches = None

Int Function findWorkbench(ObjectReference akTargetRef)
	return workbenches.Find(akTargetRef)
EndFunction

Bool Function isValidLinkTarget(ObjectReference akTargetRef)
	return SimpleSettlementSolutions:Reference.isWorkbench(akTargetRef) && !SimpleSettlementSolutions:Reference.isWorkshopItem(akTargetRef)
EndFunction

Bool Function isLinked(ObjectReference akTargetRef)
	ObjectReference containerRef = StashTrunk:ContainerHandler.getInstance().getContainer()
	return containerRef == SimpleSettlementSolutions:Reference.getLinkedRef(akTargetRef, SimpleSettlementSolutions:Utility:Keyword.getWorkshopItem()) && containerRef == SimpleSettlementSolutions:Reference.getLinkedRef(akTargetRef, SimpleSettlementSolutions:Utility:Keyword.getContainerLink())
EndFunction

Function linkWorkbench(ObjectReference akTargetRef)
	if (!isValidLinkTarget(akTargetRef) || -1 < workbenches.Find(akTargetRef))
		return
	endif
	
	StashTrunk:Logger.log("linking workbench: " + akTargetRef)
	
	ObjectReference containerRef = StashTrunk:ContainerHandler.getInstance().getContainer()
	SimpleSettlementSolutions:Reference.linkToWorkshop(akTargetRef, containerRef)
	SimpleSettlementSolutions:Reference.linkToContainer(akTargetRef, containerRef)
	workbenches.Add(akTargetRef)
	RegisterForRemoteEvent(akTargetRef, "OnUnload")
EndFunction

Function unlinkWorkbench(ObjectReference akTargetRef)
	UnregisterForRemoteEvent(akTargetRef, "OnUnload")
	
	Int iIndex = workbenches.Find(akTargetRef)
	iIndex > -1 && workbenches.Remove(iIndex)
	
	if (isLinked(akTargetRef))
		StashTrunk:Logger.log("unlinking workbench: " + akTargetRef)
		SimpleSettlementSolutions:Reference.unlinkFromContainer(akTargetRef)
		SimpleSettlementSolutions:Reference.unlinkFromWorkshop(akTargetRef)
	endif
EndFunction

Event ObjectReference.OnUnload(ObjectReference akSender)
	unlinkWorkbench(akSender)
EndEvent

Function scan()
	
EndFunction

Function handleContentsTransfer(ObjectReference akFurnitureRef)

EndFunction

Auto State Unstarted
	Event OnQuestInit()
		GoToState("Operating")
	EndEvent
EndState

State Operating
	Event OnBeginState(String asOldState)
		workbenches = new ObjectReference[0]
		scan()
	EndEvent
	
	Function scan()
		ObjectReference[] potentialBenches = Game.GetPlayer().FindAllReferencesWithKeyword(SimpleSettlementSolutions:Utility:Keyword.getWorkbenchGeneral(), StashTrunk_WorkbenchScanner_Radius.GetValue())
		ObjectReference linkMe = none
		while (potentialBenches.Length)
			linkWorkbench(potentialBenches[0])
			potentialBenches.Remove(0)
		endWhile
		
		StartTimer(StashTrunk_WorkbenchScanner_Interval.GetValue(), TimerID)
	EndFunction
	
	Function handleContentsTransfer(ObjectReference akFurnitureRef)
		isLinked(akFurnitureRef) && akFurnitureRef.RemoveAllItems(StashTrunk:ContainerHandler.getInstance().getContainer(), true)
	EndFunction

	Event OnTimer(Int aiTimerID)
		scan()
	EndEvent
	
	Event OnQuestShutdown()
		GoToState("Stopped")
	EndEvent
EndState

State Stopped
	Event OnBeginState(String asOldState)
		CancelTimer(TimerID)
		
		ObjectReference targetRef = None
		while (workbenches.Length > 0)
			unlinkWorkbench(workbenches[0])
		endWhile
	EndEvent
EndState
