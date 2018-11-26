;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
Scriptname StashTrunk:Fragments:Perks:flush Extends Perk Hidden Const

;BEGIN FRAGMENT Fragment_Entry_01
Function Fragment_Entry_01(ObjectReference akTargetRef, Actor akActor)
;BEGIN CODE
StashTrunk_ContainerHandler.flush()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Entry_02
Function Fragment_Entry_02(ObjectReference akTargetRef, Actor akActor)
;BEGIN CODE
StashTrunk_ContainerHandler.flushToLocalWorkshop(akTargetRef)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

StashTrunk:ContainerHandler Property StashTrunk_ContainerHandler Auto Const
