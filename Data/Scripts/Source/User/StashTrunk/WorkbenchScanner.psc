Scriptname StashTrunk:WorkbenchScanner extends Quest Conditional

GlobalVariable Property StashTrunk_WorkbenchScanner_Radius Auto Const Mandatory
GlobalVariable Property StashTrunk_WorkbenchScanner_Interval Auto Const Mandatory
Int Property TimerID = 1 Auto Const

Bool bUnstarted = true Conditional
Bool bOperating = false Conditional
Bool bStopped = false Conditional

ObjectReference[] workbenches = None

Int Function findWorkbench(ObjectReference akTargetRef)
	return workbenches.Find(akTargetRef)
EndFunction

Function linkWorkbench(ObjectReference akTargetRef)
	if (-1 < workbenches.Find(akTargetRef))
		return
	endif
	
	if (StashTrunk:ContainerHandler.getInstance().linkWorkbench(akTargetRef))
		workbenches.Add(akTargetRef)
		RegisterForRemoteEvent(akTargetRef, "OnUnload")
	endif
EndFunction

Function unlinkWorkbench(ObjectReference akTargetRef)
	if (!akTargetRef)
		return
	endif
	
	UnregisterForRemoteEvent(akTargetRef, "OnUnload")
	
	Int iIndex = workbenches.Find(akTargetRef)
	iIndex > -1 && workbenches.Remove(iIndex)
	
	StashTrunk:ContainerHandler.getInstance().unlinkWorkbench(akTargetRef)
EndFunction

Event ObjectReference.OnUnload(ObjectReference akSender)
	unlinkWorkbench(akSender)
EndEvent

Function scan()
	
EndFunction

Auto State Unstarted
	Event OnBeginState(String asOldState)
		bUnstarted = true
	EndEvent

	Event OnEndState(String asNewState)
		bUnstarted = false
	EndEvent

	Event OnQuestInit()
		GoToState("Operating")
	EndEvent
EndState

State Operating
	Event OnBeginState(String asOldState)
		bOperating = true
		workbenches = new ObjectReference[0]
		scan()
	EndEvent

	Event OnEndState(String asNewState)
		bOperating = false
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
	
	Event OnTimer(Int aiTimerID)
		scan()
	EndEvent
	
	Event OnQuestShutdown()
		GoToState("Stopped")
	EndEvent
EndState

State Stopped
	Event OnBeginState(String asOldState)
		bStopped = true

		CancelTimer(TimerID)
		
		ObjectReference targetRef = None
		while (workbenches.Length > 0)
			unlinkWorkbench(workbenches[0])
		endWhile

		GoToState("Unstarted")
	EndEvent

	Event OnEndState(String asNewState)
		bStopped = false
	EndEvent
EndState
