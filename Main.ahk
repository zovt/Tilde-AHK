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


Loop{
    UpdateWindowList()
    Sleep 200
}


#A::DebugBox()
#;::ToggleWindowBorders()
#'::CloseWindow()
#,::
	WinGet, TempWin, ID, A
	WhichMonitor(TempWin)
Return

#o::CountWindowsPerMonitor()
