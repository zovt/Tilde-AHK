;Get Monitors and Resolutions from Config.ini
GetMonitorsAndResolutionsFromIni()
{
    Global 
    IniRead, TotalMonitors, Config.ini, Monitors, TotalMonitors
    IniRead, PrimaryMonitor, Config.ini, Monitors, PrimaryMonitor
	Loop, %TotalMonitors%
    {
        Local ArrayCount +=1
        IniRead, Monitor%ArrayCount%WorkingHeight, Config.ini, Resolution, Monitor%ArrayCount%WorkingHeight, 0
        IniRead, Monitor%ArrayCount%WorkingWidth, Config.ini, Resolution, Monitor%ArrayCount%WorkingWidth, 0
		
		SysGet, Monitor%ArrayCount%Bounding, Monitor, %ArrayCount%
			
		IniRead, Monitor%ArrayCount%BoundingLeft, Config.ini, Monitors, Monitor%ArrayCount%BoundingLeft
		IniRead, Monitor%ArrayCount%BoundingRight, Config.ini, Monitors, Monitor%ArrayCount%BoundingRight
       	IniRead, Monitor%ArrayCount%BoundingBottom, Config.ini, Monitors, Monitor%ArrayCount%BoundingBottom
		IniRead, Monitor%ArrayCount%BoundingTop, Config.ini, Monitors, Monitor%ArrayCount%BoundingTop
		

    }
}

; Check for firstrun
CheckFirstRun()
{
    Global

    IniRead, FirstRun, Config.ini, Basic, FirstRun, 1
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
            Local ArrayCount +=1
            SysGet, MonitorWorkingArea,MonitorWorkArea, %ArrayCount%
            Monitor%ArrayCount%WorkingHeight := MonitorWorkingAreaBottom
            Monitor%ArrayCount%WorkingWidth := MonitorWorkingAreaRight

            IniWrite,% Monitor%ArrayCount%WorkingHeight, Config.ini, Resolution, Monitor%ArrayCount%WorkingHeight
            IniWrite,% Monitor%ArrayCount%WorkingWidth, Config.ini, Resolution, Monitor%ArrayCount%WorkingWidth
			
			SysGet, Monitor%ArrayCount%Bounding, Monitor, %ArrayCount%
			
			IniWrite,% Monitor%ArrayCount%BoundingLeft, Config.ini, Monitors, Monitor%ArrayCount%BoundingLeft
			IniWrite,% Monitor%ArrayCount%BoundingRight, Config.ini, Monitors, Monitor%ArrayCount%BoundingRight
        	IniWrite,% Monitor%ArrayCount%BoundingBottom, Config.ini, Monitors, Monitor%ArrayCount%BoundingBottom
			IniWrite,% Monitor%ArrayCount%BoundingTop, Config.ini, Monitors, Monitor%ArrayCount%BoundingTop
		
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

; Check which monitor a window is on
WhichMonitor(ByRef Window){
    Global
	
	MonitorPosition = 0
	
	id = %Window%
	
    WinGetPos, WinX, WinY,,, ahk_id %Window%
	
	Local ArrayCount=1
	Loop, %TotalMonitors%
	{
		if(Monitor%ArrayCount%BoundingLeft<WinX)
		{
			if(WinX<Monitor%ArrayCount%BoundingRight){
				MonitorPosition = %ArrayCount%
				Return MonitorPosition
			}
		}
		ArrayCount+=1
	}
}

; Count how many windows are on each monitor
CountWindowsPerMonitor()
{
	Global
	Local ArrayCount = 1
	Loop, %TotalMonitors%
	{
		Monitor%ArrayCount%TotalWindows = 0
		ArrayCount +=1
	}
	
	
	ArrayCount = 1
	Loop, %WindowListWindow%
	{
		MsgBox,% WindowListWindow%ArrayCount%Title
		CurrentPosition := WhichMonitor(WindowListWindow%ArrayCount%)
		Monitor%CurrentPosition%TotalWindows += 1
		ArrayCount += 1
	}
}
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    