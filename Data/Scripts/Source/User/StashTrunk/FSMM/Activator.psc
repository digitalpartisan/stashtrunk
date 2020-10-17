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
Message Property StashTrunk_FSMM_Activator_Message_ScrapPrompt Auto Const Mandatory
{Autofill}
Message Property StashTrunk_FSMM_Activator_Message_ScrappingComplete Auto Const Mandatory
{Autofill}
Sound Property UIWorkshopModeItemScrapGeneric Auto Const Mandatory
{Autofill}
Sound Property StashTrunk_FSMM_PlacementSound Auto Const Mandatory
{Autofill}

Jiffy:Scrapper scrapContainer = None
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
	scrapContainer = placeReference(StashTrunk_FSMM_ScrapBox) as Jiffy:Scrapper
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

Event Jiffy:Scrapper.Processed(Jiffy:Scrapper sender, Var[] args)
	if (sender != scrapContainer)
		return
	endif
	
	StashTrunk:Logger.log(self + " finished processing")
	BlockActivation(false, false)
	StashTrunk_FSMM_Activator_Message_ScrappingComplete.Show()
	scrapContainer.RemoveAllItems(Game.GetPlayer(), true)
EndEvent

Event Jiffy:Scrapper.Pulled(Jiffy:Scrapper sender, Var[] args)
	if (sender != scrapContainer)
		return
	endif
	
	StashTrunk:Logger.log(self + " finished pulling")
	scrap()
EndEvent

Function openScrapContainer()
	StashTrunk:Logger.log(self + " opening scrap container")
	RegisterForRemoteEvent(scrapContainer, "OnClose")
	scrapContainer.Activate(Game.GetPlayer(), true)
EndFunction

Event ObjectReference.OnClose(ObjectReference akSender, ObjectReference AkActionRef)
	if (akSender != scrapContainer)
		return
	endif
	
	StashTrunk:Logger.log(self + " scrap container closed")
	UnregisterForRemoteEvent(scrapContainer, "OnClose")
	scrapContainer.GetItemCount(None) && scrapContainer(0)
EndEvent

Function activateReference(ObjectReference akTargetRef)
	if (!akTargetRef)
		return
	endif
	
	akTargetRef.Activate(Game.GetPlayer(), true)
EndFunction

Function scrap()
	StashTrunk:Logger.log(self + " started scrapping")
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

Function scrapAll(Int iButton)
	iButton = StashTrunk_FSMM_Activator_Message_ScrapAll.Show()
	if (0 == iButton)
		StashTrunk:Logger.log(self + " starting pulling")
		BlockActivation(true, true)
		scrapContainer.pull(Game.GetPlayer())
	else
		showScrapMenu(0)
	endif
EndFunction

Function scrapContainer(Int iButton)
	iButton = StashTrunk_FSMM_Activator_Message_ScrapPrompt.Show()
	0 == iButton && scrap()
	1 == iButton && scrapContainer.RemoveAllItems(Game.GetPlayer(), true)
	2 == iButton && showScrapMenu(0)
EndFunction

Function showScrapMenu(Int iButton)
	iButton = StashTrunk_FSMM_Activator_Message_Scrap.Show()
	0 == iButton && scrapAll(0)
	1 == iButton && scrapContainer(0)
	2 == iButton && openScrapContainer()
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
