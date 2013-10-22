#NoEnv
#SingleInstance Force
#WinActivateForce
SetTitleMatchMode, 3
Gui +LastFound

#Include Functions\Misc.ahk
#Include Functions\Configuration.ahk
#Include Functions\Tiling.ahk

Configure()
CreateWindows()
SendAllWindowsToMonitorArray()
Loop, %numMonitors%
{
	Ship(mon%A_Index%)
}
DllCall("RegisterShellHookWindow", UInt, WinExist())
MsgNum := DllCall("RegisterWindowMessage",Str,"SHELLHOOK")
OnMessage(MsgNum, "ShellMessage")
Return

#A::DebugBox()
#;::ToggleWindowBorders(A)
#O::
	curmon := DetectMonitorMouse()
	Ship(curmon)
Return
#Q::createWindows()

#'::CloseWindow()
#,::
	WinGet, TempWin, ID, A
	curWinMon := DetectMonitorWindow(TempWin)
Return
#E::
	WinGet, TempWin, ID, A
	SendWindowToMonitorArray(TempWin)
Return
#J::
	curmon := DetectMonitorMouse()
	mon%curmon%.details()
Return


;#o::CountWindowsPerMonitor()
