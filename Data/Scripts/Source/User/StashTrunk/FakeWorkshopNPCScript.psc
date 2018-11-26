Scriptname StashTrunk:FakeWorkshopNPCScript extends WorkshopNPCScript

Event OnWorkshopNPCTransfer(Location akNewWorkshopLocation, Keyword akActionKW)
	WorkshopParent.unassignActor(self, true)
EndEvent
