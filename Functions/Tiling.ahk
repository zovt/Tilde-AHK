#NoEnv
#SingleInstance Force
#WinActivateForce
SetTitleMatchMode, 3
CoordMode, Mouse, Screen
DetectHiddenWindows, Off



class Monitor{
	__New(leftBound, topBound, rightBound, bottomBound, taskbarLeft, taskbarRight, taskbarTop, taskbarBottom){
		
		this.workspace := 1
		this.Mode := 1
		
		this.LeftX := leftBound
		this.TopY := topBound
		this.RightX := rightBound
		this.BottomY := bottomBound
		
		this.Width := this.RightX - this.LeftX
		this.Height := this.BottomY - this.TopY
		
		this.usableSpace(taskbarLeft, taskbarRight, taskbarTop, taskbarBottom)
		
		this.Windows := Object()
		this.NumberWindows := 0
		
		this.WindowsInPort := 0
		this.WindowsInDeck := 0
	}
		
	usableSpace(taskbarLeftSize, taskbarRightSize, taskbarTopSize, taskbarBottomSize){
		this.UsableWidth := this.Width - taskbarRightSize - taskbarLeftSize
		this.UsableHeight := this.Height - taskbarTopSize - taskbarBottomSize
	}
	
	details(){
		MsgBox, % "Monitor Details - Height: " this.Height " - Width: " this.Width " - LeftBound, RightBound, TopBound, BottomBound, in order: " this.LeftX "," this.RightX "," this.TopY "," this.BottomY
		temp := this.NumberWindows
		Loop, %temp%
		{
			String := String ", " this.Windows[A_Index]
		}
		MsgBox, % String
	}
}

class Window{
	__New(aHwnd, aTitle){
		this.Hwnd := aHwnd
		WinGetClass, class, ahk_id %aHwnd%
		
		this.Title := 1
		this.OnTop := 0
		this.Initialized := 1
	}
	
	titleAway(Force = 0){
		temp := this.Hwnd
		if(this.Title = 1 && Force = 0){
			WinSet, Style, -0xC00000, ahk_id %temp%
			WinSet, Style, -0x800000, ahk_id %temp%
			this.Title := 0
		} else {
			WinSet, Style, +0xC00000, ahk_id %temp%
			WinSet, Style, +0x800000, ahk_id %temp%
			This.Title := 1
		}
		WinSet, Redraw,, ahk_id %temp%
	}
}

Configure(){
	global

	titlesOn := 1
	ignoreList := "Shell_SecondaryTrayWnd, Shell_TrayWnd, EdgeUiInputTopWndClass, WorkerW, Progman"
	
	SysGet, numMonitors, MonitorCount
	Loop, %numMonitors%
	{
		topTaskbar := 0
		bottomTaskbar := 0
		rightTaskbar := 0
		leftTaskbar := 0
		
		SysGet, mon, Monitor, %A_Index%
		mon%A_Index% := new Monitor(monLeft, monTop, monRight, monBottom, leftTaskbar, rightTaskbar, topTaskbar, bottomTaskbar)
		
	}
	return
}
CreateWindows(){
	global
	local tempid, tempTitle, tempclass
	DetectHiddenWindows, Off
	windowArray := Object()
	tempTitle := 
	
	Loop, %windows%
	{
		VarSetCapacity(windows%A_Index%,0)
	}
	
	WinGet, windows, List
	Loop, %windows%
	{
		tempid := windows%A_Index%
		WinGetTitle, tempTitle, ahk_id %tempid%
		WinGetClass, tempclass, ahk_id%tempid%
		if(tempTitle != ""){
			ifNotInString, ignoreList, %tempclass%
			{
				windowArray[A_Index] := new window(tempid, titlesOn)
			}
		}
	}
	return
}

DetectMonitorMouse(){
	global
	local mouseTempX, mouseTempY, currentMonitor
	
	MouseGetPos, mouseTempX, mouseTempY
	Loop, %numMonitors%{
		currentMonitor := mon%A_Index%
		if(currentMonitor.LeftX <= mouseTempX && mouseTempX < currentMonitor.RightX && currentMonitor.TopY <= mouseTempY && mouseTempY < currentMonitor.BottomY){
			return %A_Index%
		}
	}
	return 0
}

DetectMonitorWindow(WindowID){
	global 
	local winX, winY, currentMonitor
	
	WinGetPos, winX, winY,,,ahk_id %WindowID%
	Loop, %numMonitors% {
		currentMonitor := mon%A_Index%
		if(currentMonitor.LeftX <= winX && winX < currentMonitor.RightX && currentMonitor.TopY <= winY && winY < currentMonitor.BottomY){
			return %A_Index%
		}
	}
	return 0
}

SendWindowToMonitorArray(WindowID){
		global
		local windowLocation, temp, tempmon
		
		windowLocation := DetectMonitorWindow(WindowID)
		tempmon := mon%windowLocation%
		temp := tempmon.NumberWindows+1
		tempmon.Windows[temp] := WindowID
		tempmon.NumberWindows := temp
	
		return
}

SendAllWindowsToMonitorArray(){
	global
	local temp
	Loop, %windows%
	{
		temp := windowArray[A_Index].Hwnd
		SendWindowToMonitorArray(temp)
	}
}

SearchAndDestroyWindow(WindowID)
{
	global
	local temp, temp2, temp3, tempID, monitor
	Loop, %numMonitors%
	{
		monitor := mon%A_Index%
		temp := monitor.NumberWindows
		Loop, %temp%
		{
			tempID := monitor.Windows[A_Index]
			if(WindowID = tempID)
			{
				temp2 := temp - A_Index
				temp3 := A_Index
				Loop, %temp2%
				{
					monitor.Windows[temp3+A_Index-temp2] := monitor.Windows[temp3+A_Index]
				}
				monitor.Windows[temp] := ""
				monitor.NumberWindows := temp - 1
				return monitor
			}
		}
	}
}


Ship(monitor){
	global
	local tempWin, tempNum
	
	tempNum := monitor.NumberWindows
	Loop, %tempNum%
	{	
		tempWin := monitor.Windows[A_index]
		; Move Windows in the Ports
		if(A_Index<=1){
			WinMove, ahk_id %tempWin%,, monitor.LeftX, monitor.TopY, 2*monitor.Width/3, monitor.Height
		} else {
			WinMove, ahk_id %tempWin%,, monitor.LeftX + (2*monitor.Width/3), monitor.TopY + (monitor.UsableHeight/(monitor.NumberWindows - 1))*(A_Index-2), monitor.Width/3, monitor.UsableHeight/(monitor.NumberWindows-1)
		}
	}
}

ShellMessage(wParam, lParam){
	Global
	local temp, tempmon
	if(wParam = 1){
		;Window Created
		temp := DetectMonitorWindow(lParam)
		tempmon := mon%temp%
		SendWindowToMonitorArray(lParam)
		Ship(tempmon)
	} else if(wParam = 4 || wParam = 3 || wParam = 6){
		;Window active
		temp := DetectMonitorWindow(lParam)
		tempmon := mon%temp%
		Ship(tempmon)
	} else if(wParam = 2){
		temp := DetectMonitorWindow(lParam)
		tempmon := mon%temp%
		Ship(SearchAndDestroyWindow(lParam))
	}
	return
}

























