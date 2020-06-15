;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
Scriptname StashTrunk:Fragments:Terminals:MobileMechanic Extends Terminal Hidden Const

;BEGIN FRAGMENT Fragment_Terminal_01
Function Fragment_Terminal_01(ObjectReference akTerminalRef)
;BEGIN CODE
StashTrunk_FSMM_Handler.startup(akTerminalRef)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_02
Function Fragment_Terminal_02(ObjectReference akTerminalRef)
;BEGIN CODE
StashTrunk_FSMM_Handler.shutdown(akTerminalRef)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_03
Function Fragment_Terminal_03(ObjectReference akTerminalRef)
;BEGIN CODE
StashTrunk_FSMM_Handler.rerun(akTerminalRef)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

InjectTec:Integrator:Handler Property StashTrunk_FSMM_Handler Auto Const Mandatory
