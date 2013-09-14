#Include Functions.ahk

;Configure Tilde on load
CheckFirstRun()
if(FirstRun=0){
    GetMonitorsAndResolutionsFromIni()
    GetWindowOptionsFromIni()
} 
else 
{
    Autoconfigure()
}

UpdateWindowList()
CountWindowsPerMonitor()
UpdateMonitorDatabase()

Loop{

	ACount = 1
	Loop, %TotalMonitors%
	{
		TileHotkeySwitch(ACount)
		ACount += 1
	}
    Sleep 200
}


#A::DebugBox()
#;::ToggleWindowBorders(A)
#'::CloseWindow()
#,::
	WinGet, TempWin, ID, A
	WhichMonitor(TempWin)
Return

#o::CountWindowsPerMonitor()
