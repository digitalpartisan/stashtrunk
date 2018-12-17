Scriptname StashTrunk:FakeWorkshopNPCScript extends WorkshopNPCScript

Keyword Property StashTrunk_Activator_Keyword_Flush Auto Const Mandatory

Event OnWorkshopNPCTransfer(Location akNewWorkshopLocation, Keyword akActionKW)
	if (StashTrunk_Activator_Keyword_Flush == akActionKW)
		WorkshopParent.unassignActor(self, true)
	endif
EndEvent
