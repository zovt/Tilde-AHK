#Include Functions\Misc.ahk
#Include Functions\Configuration.ahk
#Include Functions\Tiling.ahk

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

Loop
{
	UpdateMonitorDatabase()
}

#A::DebugBox()
#;::ToggleWindowBorders(A)
#'::CloseWindow()
#,::
	WinGet, TempWin, ID, A
	;WhichMonitor(TempWin)
Return

;#o::CountWindowsPerMonitor()
