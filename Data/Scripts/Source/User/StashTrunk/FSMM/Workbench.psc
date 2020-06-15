Scriptname StashTrunk:FSMM:Workbench extends ObjectReference

Event OnInit()
	StashTrunk:ContainerHandler.getInstance().linkWorkbench(self)
EndEvent

Event OnUnload()
	StashTrunk:ContainerHandler.getInstance().unlinkWorkbench(self)
EndEvent
