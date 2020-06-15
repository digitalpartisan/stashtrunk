Scriptname StashTrunk:FSMM:Activator extends ObjectReference
{Autofill everyting.}

Spawny:Modifier Property StashTrunk_FSMM_Activator_Modification Auto Const Mandatory
{Autofill}
StashTrunk:FSMM:InventoryState Property StashTrunk_FSMM_InventoryState Auto Const Mandatory
{Autofill}
MiscObject Property StashTrunk_FSMM_InventoryItem Auto Const Mandatory
{Autofill}
Container Property StashTrunk_FSMM_ScrapBox Auto Const Mandatory
{Autofill}
Furniture Property StashTrunk_FSMM_Workbench_Armor Auto Const Mandatory
{Autofill}
Furniture Property StashTrunk_FSMM_Workbench_Chems Auto Const Mandatory
{Autofill}
Furniture Property StashTrunk_FSMM_Workbench_Cooking Auto Const Mandatory
{Autofill}
Furniture Property StashTrunk_FSMM_Workbench_Weapon Auto Const Mandatory
{Autofill}
Message Property StashTrunk_FSMM_Activator_Message_Menu Auto Const Mandatory
{Autofill}
Message Property StashTrunk_FSMM_Activator_Message_Scrap Auto Const Mandatory
{Autofill}
Message Property StashTrunk_FSMM_Activator_Message_ScrapAll Auto Const Mandatory
{Autofill}
Message Property StashTrunk_FSMM_Activator_Message_ScrapAuto Auto Const Mandatory
{Autofill}
Message Property StashTrunk_FSMM_Activator_Message_ScrapPrompt Auto Const Mandatory
{Autofill}
Message Property StashTrunk_FSMM_Activator_Message_ScrappingComplete Auto Const Mandatory
{Autofill}
Sound Property UIWorkshopModeItemScrapGeneric Auto Const Mandatory
{Autofill}
Sound Property StashTrunk_FSMM_PlacementSound Auto Const Mandatory
{Autofill}

SimpleSettlementSolutions:Scrapper scrapContainer = None
ObjectReference workbenchArmor = None
ObjectReference workbenchChems = None
ObjectReference workbenchCooking = None
ObjectReference workbenchWeapon = None

ObjectReference Function placeReference(Form placeMe)
	ObjectReference result = PlaceAtMe(placeMe, 1, true, false, false)
	result.BlockActivation(true, true)
	return result
EndFunction

Function removeReference(ObjectReference akTargetRef)
	if (!akTargetRef)
		return
	endif
	
	akTargetRef.Disable(false)
	akTargetRef.Delete()
EndFunction

Function initializeReferences()
	scrapContainer = placeReference(StashTrunk_FSMM_ScrapBox) as SimpleSettlementSolutions:Scrapper
	RegisterForCustomEvent(scrapContainer, "Processing")
	RegisterForCustomEvent(scrapContainer, "Processed")
	RegisterForCustomEvent(scrapContainer, "Pulling")
	RegisterForCustomEvent(scrapContainer, "Pulled")
	workbenchArmor = placeReference(StashTrunk_FSMM_Workbench_Armor)
	workbenchChems = placeReference(StashTrunk_FSMM_Workbench_Chems)
	workbenchCooking = placeReference(StashTrunk_FSMM_Workbench_Cooking)
	workbenchWeapon = placeReference(StashTrunk_FSMM_Workbench_Weapon)
EndFunction

Function cleanupReferences()
	scrapContainer.RemoveAllItems(StashTrunk:ContainerHandler.getInstance().getContainer(), true)
	UnregisterForCustomEvent(scrapContainer, "Processing")
	UnregisterForCustomEvent(scrapContainer, "Processed")
	UnregisterForCustomEvent(scrapContainer, "Pulling")
	UnregisterForCustomEvent(scrapContainer, "Pulled")
	removeReference(scrapContainer)
	removeReference(workbenchArmor)
	removeReference(workbenchChems)
	removeReference(workbenchCooking)
	removeReference(workbenchWeapon)
EndFunction

Event SimpleSettlementSolutions:Scrapper.Processed(SimpleSettlementSolutions:Scrapper sender, Var[] args)
	if (sender == scrapContainer)
		BlockActivation(false, false)
		StashTrunk_FSMM_Activator_Message_ScrappingComplete.Show()
		scrapContainer.RemoveAllItems(Game.GetPlayer(), true)
	endif
EndEvent

Event SimpleSettlementSolutions:Scrapper.Pulled(SimpleSettlementSolutions:Scrapper sender, Var[] args)
	if (sender == scrapContainer)
		BlockActivation(false, false)
		scrap()
	endif
EndEvent

Function openScrapContainer()
	RegisterForRemoteEvent(scrapContainer, "OnClose")
	scrapContainer.BlockActivation(false, false)
	scrapContainer.Activate(Game.GetPlayer(), true)
EndFunction

Event ObjectReference.OnClose(ObjectReference akSender, ObjectReference AkActionRef)
	if (akSender != scrapContainer)
		return
	endif
	
	scrapContainer.BlockActivation(true, true)
	UnregisterForRemoteEvent(scrapContainer, "OnClose")
	scrapContainer.GetItemCount(None) && scrapJunkInContainerWithPrompt(0)
EndEvent

Function activateReference(ObjectReference akTargetRef)
	if (!akTargetRef)
		return
	endif
	
	akTargetRef.BlockActivation(false, true)
	akTargetRef.Activate(Game.GetPlayer(), false)
	akTargetRef.BlockActivation(true, true)
EndFunction

Function scrap()
	BlockActivation(true, true)
	scrapContainer.process(StashTrunk:ContainerHandler.getInstance().getContainer())
EndFunction

Function pickUp()
	cleanupReferences()
	UIWorkshopModeItemScrapGeneric.Play(self)
	Disable(false)
	Delete()
	Game.GetPlayer().AddItem(StashTrunk_FSMM_InventoryItem, 1, false)
EndFunction

Function scrapAllAuto()
	BlockActivation(true, true)
	scrapContainer.pull(Game.GetPlayer())
EndFunction

Function scrapAllAutoWithPrompt(Int iButton)
	iButton = StashTrunk_FSMM_Activator_Message_ScrapAuto.Show()
	if (0 == iButton)
		scrapAllAuto()
	else
		showScrapMenu(0)
	endif
EndFunction

Function scrapJunkInContainerWithPrompt(Int iButton)
	iButton = StashTrunk_FSMM_Activator_Message_ScrapPrompt.Show()
	if (0 == iButton)
		scrap()
	else
		scrapContainer.RemoveAllItems(Game.GetPlayer(), true)
	endif
EndFunction

Function showScrapMenu(Int iButton)
	iButton = StashTrunk_FSMM_Activator_Message_Scrap.Show()
	0 == iButton && scrapAllAutoWithPrompt(0)
	1 == iButton && openScrapContainer()
EndFunction

Function showMainMenu(Int iButton)
	StashTrunk_FSMM_InventoryState.refreshState()
	iButton = StashTrunk_FSMM_Activator_Message_Menu.Show()
	0 == iButton && activateReference(workbenchArmor)
	1 == iButton && activateReference(workbenchChems)
	2 == iButton && activateReference(workbenchCooking)
	3 == iButton && showScrapMenu(0)
	4 == iButton && activateReference(workbenchWeapon)
	5 == iButton && pickUp()
EndFunction

Event OnInit()
	MoveTo(Game.GetPlayer(), 0, 0, 0, true)
	SetAngle(0, 0, Game.GetPlayer().GetAngleZ())
	StashTrunk_FSMM_Activator_Modification.apply(self)
	initializeReferences()
	StashTrunk_FSMM_PlacementSound.Play(self)
EndEvent

Event OnActivate(ObjectReference akActionRef)
	showMainMenu(0)
EndEvent
