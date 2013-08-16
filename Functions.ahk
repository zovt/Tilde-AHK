;Get Monitors and Resolutions from Config.ini
GetMonitorsAndResolutionsFromIni()
{
    IniRead, Monitor1Height, Config.ini, Resolution, Monitor1WorkingHeight
    IniRead, Monitor1Width, Config.ini, Resolution, Monitor1WorkingWidth
    IniRead, Monitor2Height, Config.ini, Resolution, Monitor2WorkingHeight, 0
    IniRead, Monitor2Width, Config.ini, Resolution, Monitor2WorkingWidth, 0
    IniRead, Monitor3Height, Config.ini, Resolution, Monitor3WorkingHeight, 0
    IniRead, Monitor3Width, Config.ini, Resolution, Monitor3WorkingWidth, 0
}

;Write the file Config.ini to 
WriteConfig()
{

}

Autoconfigure()
{
    SysGet, TotalMonitors, MonitorCount
    SysGet, PrimaryMonitor, MonitorPrimary

    if(TotalMonitors>1){
        Loop, %TotalMonitors% 
        {
            
        }
    }
}

;Set Up Window Dimensions
GetWindowOptionsFromIni()
{
    DefaultPortWindowHorizontalSize := Monitor1Width/3
    IniRead, PaddingVertical, Config.ini, Windows, PaddingVertical
    IniRead, PaddingHorizontal, Config.ini, Windows, PaddingHorizontal
    IniRead, PortWindowHorizontalSize, Config.ini, Windows, PortWindowHorizontalSize, DefaultPortWindowHorizontalSize
    IniRead, MaxWindowsInPort, Config.ini, Settings, MaxWindowsInPort, 1
}

CalculateWindowSizes()
{

}

EnumerateWindows()
{
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