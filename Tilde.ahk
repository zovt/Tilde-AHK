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
	mon%A_Index%.Ship()
}
DllCall("RegisterShellHookWindow", UInt, WinExist())
MsgNum := DllCall("RegisterWindowMessage",Str,"SHELLHOOK")
OnMessage(MsgNum, "ShellMessage")
Return

#A::DebugBox()

#O::
	curmon := DetectMonitorMouse()
	tempMon := mon%curmon%
	tempMon.Ship()
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
	tempMon.Ship()
Return

#Numpad2::
	curmon := DetectMonitorMouse()
	actWin := WinExist("A")
	tempMon := mon%curmon%
	tempMon.Swap(actWin, 2)
	tempMon.Ship()
Return

#Numpad3::
	curmon := DetectMonitorMouse()
	actWin := WinExist("A")
	tempMon := mon%curmon%
	tempMon.Swap(actWin, 3)
	tempMon.Ship()
Return

#Numpad4::
	curmon := DetectMonitorMouse()
	actWin := WinExist("A")
	tempMon := mon%curmon%
	tempMon.Swap(actWin, 4)
	tempMon.Ship()
Return

#Numpad5::
	curmon := DetectMonitorMouse()
	actWin := WinExist("A")
	tempMon := mon%curmon%
	tempMon.Swap(actWin, 5)
	tempMon.Ship()
Return

#Numpad6::
	curmon := DetectMonitorMouse()
	actWin := WinExist("A")
	tempMon := mon%curmon%
	tempMon.Swap(actWin, 6)
	tempMon.Ship()
Return

#Numpad7::
	curmon := DetectMonitorMouse()
	actWin := WinExist("A")
	tempMon := mon%curmon%
	tempMon.Swap(actWin, 7)
	tempMon.Ship()
Return

#Numpad8::
	curmon := DetectMonitorMouse()
	actWin := WinExist("A")
	tempMon := mon%curmon%
	tempMon.Swap(actWin, 8)
	tempMon.Ship()
Return

#Numpad9::
	curmon := DetectMonitorMouse()
	actWin := WinExist("A")
	tempMon := mon%curmon%
	tempMon.Swap(actWin, 9)
	tempMon.Ship()
Return

#NumpadAdd::
	curmon := DetectMonitorMouse()
	actWin := WinExist("A")
	tempMon := mon%curmon%
	tempMon.WindowsInPort := tempMon.WindowsInPort + 1
	tempMon.Ship()
Return

#NumpadSub::
	curmon := DetectMonitorMouse()
	actWin := WinExist("A")
	tempMon := mon%curmon%
	tempMon.WindowsInPort := tempMon.WindowsInPort - 1
	tempMon.Ship()
Return

#NumpadEnter::
	curmon := DetectMonitorMouse()
	actWin := WinExist("A")
	tempMon := mon%curmon%
	if(curmon+1>numMonitors){
		nextMon := mon1
	} else {
		temp := curmon+1
		nextMon := mon%temp%
	}
	tempMon.SendWindowToMonitor(actWin, nextMon)
return

#NumpadDot::
	WinClose,A
return