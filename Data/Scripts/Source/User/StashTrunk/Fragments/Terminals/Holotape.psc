;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
Scriptname StashTrunk:Fragments:Terminals:Holotape Extends Terminal Hidden Const

;BEGIN FRAGMENT Fragment_Terminal_01
Function Fragment_Terminal_01(ObjectReference akTerminalRef)
;BEGIN CODE
StashTrunk_Engine_Handler.refreshStatus()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_03
Function Fragment_Terminal_03(ObjectReference akTerminalRef)
;BEGIN CODE
StashTrunk_FSMM_Handler.updateState()
StashTrunk_FSMM_Handler.draw(akTerminalRef)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_04
Function Fragment_Terminal_04(ObjectReference akTerminalRef)
;BEGIN CODE
Game.GetPlayer().MoveTo(StashTrunkDebugMarker)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Chronicle:Engine:Handler Property StashTrunk_Engine_Handler Auto Const Mandatory

InjectTec:Integrator:Handler Property StashTrunk_FSMM_Handler Auto Const Mandatory

ObjectReference Property StashTrunkDebugMarker Auto Const Mandatory
