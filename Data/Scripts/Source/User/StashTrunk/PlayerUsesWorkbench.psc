Scriptname StashTrunk:PlayerUsesWorkbench extends ReferenceAlias

StashTrunk:ContainerHandler Property StashTrunk_ContainerHandler Auto Const Mandatory
FormList Property StashTrunk_WorkbenchList Auto Const Mandatory
Keyword Property WorkshopLinkContainer Auto Const Mandatory
Keyword Property WorkshopItemKeyword Auto Const Mandatory

Bool Function isReferenceEligible(ObjectReference akReference)
	if (!akReference)
		return false
	endif
	
	if (!akReference || !StashTrunk_WorkbenchList)
		return false
	endif
	
	Furniture furnitureForm = akReference.GetBaseObject() as Furniture
	if (!furnitureForm)
		return false
	endif
	
	return StashTrunk_WorkbenchList.HasForm(furnitureForm) && !akReference.GetLinkedRef(WorkshopLinkContainer) && !akReference.GetLinkedRef(WorkshopItemKeyword)
EndFunction

Function handleLinking(ObjectReference akReference)
	if (!akReference || !StashTrunk_ContainerHandler || !WorkshopLinkContainer || !WorkshopItemKeyword || !isReferenceEligible(akReference))
		return
	endif
	
	StashTrunk:Logger.logAddingContainerLink(akReference)
	ObjectReference containerRef = StashTrunk_ContainerHandler.getUnderlyingContainer()
	akReference.SetLinkedRef(containerRef, WorkshopLinkContainer)
	akReference.SetLinkedRef(containerRef, WorkshopItemKeyword)
EndFunction

Function handleUnlinking(ObjectReference akReference)
	if (!akReference || !StashTrunk_ContainerHandler || !WorkshopLinkContainer || !WorkshopItemKeyword)
		return
	endif
	
	if (StashTrunk_ContainerHandler.getUnderlyingContainer() == akReference.GetLinkedRef(WorkshopLinkContainer))
		;StashTrunk:Logger.logRemovingContainerLink(akReference)
		;akReference.SetLinkedRef(None, WorkshopLinkContainer)
		;akReference.SetLinkedRef(None, WorkshopItemKeyword)
	endif
EndFunction

Event OnSit(ObjectReference akFurniture)
	handleLinking(akFurniture)
EndEvent

Event OnGetUp(ObjectReference akFurniture)
	handleUnlinking(akFurniture)
EndEvent
