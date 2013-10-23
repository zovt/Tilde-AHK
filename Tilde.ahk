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

#O::
	curmon := DetectMonitorMouse()
	tempMon := mon%curmon%
	Ship(tempMon)
Return

#J::
	curmon := DetectMonitorMouse()
	mon%curmon%.details()
Return

#Numpad1::
	curmon := DetectMonitorMouse()
	actWin := WinExist("A")
	tempMon := mon%curmon%
	tempMon.Swap(actWin, 1)
	Ship(tempMon)
Return

#Numpad2::
	curmon := DetectMonitorMouse()
	actWin := WinExist("A")
	tempMon := mon%curmon%
	tempMon.Swap(actWin, 2)
	Ship(tempMon)
Return

#Numpad3::
	curmon := DetectMonitorMouse()
	actWin := WinExist("A")
	tempMon := mon%curmon%
	tempMon.Swap(actWin, 3)
	Ship(tempMon)
Return

#Numpad4::
	curmon := DetectMonitorMouse()
	actWin := WinExist("A")
	tempMon := mon%curmon%
	tempMon.Swap(actWin, 4)
	Ship(tempMon)
Return

#Numpad5::
	curmon := DetectMonitorMouse()
	actWin := WinExist("A")
	tempMon := mon%curmon%
	tempMon.Swap(actWin, 5)
	Ship(tempMon)
Return

#Numpad6::
	curmon := DetectMonitorMouse()
	actWin := WinExist("A")
	tempMon := mon%curmon%
	tempMon.Swap(actWin, 6)
	Ship(tempMon)
Return

#Numpad7::
	curmon := DetectMonitorMouse()
	actWin := WinExist("A")
	tempMon := mon%curmon%
	tempMon.Swap(actWin, 7)
	Ship(tempMon)
Return

#Numpad8::
	curmon := DetectMonitorMouse()
	actWin := WinExist("A")
	tempMon := mon%curmon%
	tempMon.Swap(actWin, 8)
	Ship(tempMon)
Return

#Numpad9::
	curmon := DetectMonitorMouse()
	actWin := WinExist("A")
	tempMon := mon%curmon%
	tempMon.Swap(actWin, 9)
	Ship(tempMon)
Return