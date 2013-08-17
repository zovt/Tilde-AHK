;Get Monitors and Resolutions from Config.ini
GetMonitorsAndResolutionsFromIni()
{
    Global 

    IniRead, Monitor1WorkingHeight, Config.ini, Resolution, Monitor1WorkingHeight, 0
    IniRead, Monitor1WorkingWidth, Config.ini, Resolution, Monitor1WorkingWidth, 0
    IniRead, Monitor2WorkingHeight, Config.ini, Resolution, Monitor2WorkingHeight, 0
    IniRead, Monitor2WorkingWidth, Config.ini, Resolution, Monitor2WorkingWidth, 0
    IniRead, Monitor3WorkingHeight, Config.ini, Resolution, Monitor3WorkingHeight, 0
    IniRead, Monitor3WorkingWidth, Config.ini, Resolution, Monitor3WorkingWidth, 0
}

; Check for firstrun
CheckFirstRun()
{
    Global

    IniRead, FirstRun, Config.ini, Basic, FirstRun, 1
}



;Write the file Config.ini to 
WriteConfig()
{

}

;Auto Configure
Autoconfigure()
{
    Global

    IniWrite, 0, Config.ini, Basic, FirstRun

    SysGet, TotalMonitors, MonitorCount
    SysGet, PrimaryMonitor, MonitorPrimary

    if(TotalMonitors>1){
        Loop, %TotalMonitors% 
        {
            ArrayCount +=1
            SysGet, MonitorWorkingArea,MonitorWorkArea, %A_LoopField%
            Monitor%ArrayCount%WorkingHeight := MonitorWorkingAreaBottom
            Monitor%ArrayCount%WorkingWidth := MonitorWorkingAreaRight

            IniWrite,% Monitor%ArrayCount%WorkingHeight, Config.ini, Resolution, Monitor%ArrayCount%WorkingHeight
            IniWrite,% Monitor%ArrayCount%WorkingWidth, Config.ini, Resolution, Monitor%ArrayCount%WorkingWidth
        }
    }

    DefaultPortWindowHorizontalSize := Monitor1WorkingWidth*(2/3)

    IniWrite, 0, Config.ini, Windows, PaddingVertical
    IniWrite, 0, Config.ini, Windows, PaddingHorizontal
    IniWrite,% DefaultPortWindowHorizontalSize, Config.ini, Windows, PortWindowHorizontalSize 
    IniWrite, 1, Config.ini, Settings, MaxWindowsInPort

}

;Set Up Window Dimensions
GetWindowOptionsFromIni()
{
    Global

    IniRead, PaddingVertical, Config.ini, Windows, PaddingVertical
    IniRead, PaddingHorizontal, Config.ini, Windows, PaddingHorizontal
    IniRead, PortWindowHorizontalSize, Config.ini, Windows, PortWindowHorizontalSize, DefaultPortWindowHorizontalSize
    IniRead, MaxWindowsInPort, Config.ini, Settings, MaxWindowsInPort, 1
}

CalculateWindowSizes()
{

}
;Get Number of Windows
EnumerateWindows()
{
    Global

    WinGet, NumWindows, Count,,,,
}

GetTaskBarLocation()
{
    ; get dimensions and position of taskbar (specialcase autohide ?)
    WinGetPos, taskbarX, taskbarY, taskbarWidth, taskbarHeight, ahk_class Shell_TrayWnd

    ; find out if its on top/left/bottom/right with its x,y
    ; x0,y0 ( width < height )  means its on top
    if ( taskbarX < 10 and taskbarWidth < taskbarHeight )
        taskbarPosition = left

    ; x0,y0 ( width >=  height )  means its on left
    if ( taskbarX < 10 and taskbarWidth >= taskbarHeight )     
        taskbarPosition = top

    ; x+,y0 means its on right
    if ( taskbarX > 10 )
        taskbarPosition = right

    ; x0,y+ means its on bottom
    if ( taskbarY > 10 )
        taskbarPosition = bottom

    if ( (taskbarX = "") and (taskbarY = "") and (taskbarWidth = "") and (taskbarHeight = "") )
        taskbarPosition = hidden

    Return
}
; source: http://www.autohotkey.com/forum/topic8597.html (holomind)


; Debug MsgBox for checking Variable valuse
DebugBox()
{
    ListVars
    Pause
}