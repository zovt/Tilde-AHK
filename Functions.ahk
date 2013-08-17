;Get Monitors and Resolutions from Config.ini
GetMonitorsAndResolutionsFromIni()
{
    Global 
    IniRead, TotalMonitors, Config.ini, Monitors, TotalMonitors
    Loop, %TotalMonitors%
    {
        ArrayCount +=1
        IniRead, Monitor%ArrayCount%WorkingHeight, Config.ini, Resolution, Monitor%ArrayCount%WorkingHeight, 0
        IniRead, Monitor%ArrayCount%WorkingWidth, Config.ini, Resolution, Monitor%ArrayCount%WorkingWidth, 0

    }
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
    IniWrite,% TotalMonitors, Config.ini, Monitors, TotalMonitors
    IniWrite,% PrimaryMonitor, Config.ini, Monitors, PrimaryMonitor

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

; Get list of windows
UpdateWindowList()
{
    Global
    
    WinGet, WindowListWindow, List
    
    ArrayCount = 1
    Loop %WindowListWindow%
    {
        id := WindowListWindow%ArrayCount%
        WinGetTitle, WindowListWindow%ArrayCount%Title, ahk_id %id%
        ArrayCount += 1
    }
}

; Debug MsgBox for checking Variable valuse
DebugBox()
{
    ListVars
}

;Toggle Windows Borders
ToggleWindowBorders()
{
    WinSet, Style, ^0xC00000, A; Caption
    WinSet, Style, ^0x800000, A ; Border
}

;Simply Close the window
CloseWindow()
{
    WinClose, A
}

; Tile 