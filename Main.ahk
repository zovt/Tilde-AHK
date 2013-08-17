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

EnumerateWindows()



#A::DebugBox()
#;::ToggleWindowBorders()
#"::CloseWindow()