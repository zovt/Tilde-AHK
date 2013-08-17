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
    EnumerateWindows()
    UpdateWindowList()
    Sleep 200
}

#A::DebugBox()
#;::ToggleWindowBorders()
#'::CloseWindow()