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
	
	IniWrite, "", Config.ini, Settings, IgnoreList

}

;Set Up Window Dimensions
GetWindowOptionsFromIni()
{
    Global

    IniRead, PaddingVertical, Config.ini, Windows, PaddingVertical
    IniRead, PaddingHorizontal, Config.ini, Windows, PaddingHorizontal
    IniRead, PortWindowHorizontalSize, Config.ini, Windows, PortWindowHorizontalSize, DefaultPortWindowHorizontalSize
    IniRead, MaxWindowsInPort, Config.ini, Settings, MaxWindowsInPort, 1
	
	IniRead, IgnoreList, Config.ini, Settings, IgnoreList, ""
}

; Get list of windows
UpdateWindowList()
{
    Global
    
    WinGet, WindowList, List
    
    Local ArrayCount = 1
    Loop %WindowList%
    {
        id := WindowList%ArrayCount%
        WinGetTitle, WindowList%ArrayCount%Title, ahk_id %id%
        ArrayCount += 1
    }
	
	ArrayCount = 1
	
	
	Local IgnoreMe = 0
	
	Loop %WindowList%
	{
		IgnoreMe := InStr(WindowIdList,WindowList%ArrayCount%)
		;MsgBox,% WindowList%A_Index% . " | IgnoreMe: " . IgnoreMe
		if(!IgnoreMe){
			WindowListWindow += 1
			WindowListWindow%WindowListWindow% := WindowList%A_Index%
			WindowListWindow%WindowListWindow%Window := WindowList%A_Index%Title
		}
		ArrayCount +=1
	}
	
	WindowIdList :=
	
	Loop %WindowListWindow%
	{
		WindowIdList := WindowIdList . ", " WindowList%A_Index%
	}
	
}

; Debug MsgBox for checking Variable valuse
DebugBox()
{
    ListVars
}

;Toggle Windows Borders
ToggleWindowBorders(ByRef Window)
{
	Global 
    WinSet, Style, -0xC00000, ahk_id %Window%
    WinSet, Style, -0x800000, ahk_id %Window%
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
		if(Monitor%ArrayCount%BoundingLeft<=WinX)
		{
			if(WinX<=Monitor%ArrayCount%BoundingRight){
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
		if(WindowListWindow%ArrayCount%Title)
		{
			CurrentPosition := WhichMonitor(WindowListWindow%ArrayCount%)
			Monitor%CurrentPosition%TotalWindows += 1
		}
		ArrayCount += 1
	}
}
    
; Build Monitor Database
UpdateMonitorDatabase()
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
		if(WindowListWindow%ArrayCount%Title)
		{
			IsIgnore = 0
			IsIgnore := InStr(IgnoreList,WindowListWindow%ArrayCount%Title)
			if(!IsIgnore)
			{
				CurrentPosition := WhichMonitor(WindowListWindow%ArrayCount%)
				if(CurrentPosition)
				{
					Monitor%CurrentPosition%TotalWindows += 1
					Local Temp := Monitor%CurrentPosition%TotalWindows
					Monitor%CurrentPosition%Window%Temp% := ahk_id WindowListWindow%ArrayCount%
				}
			}
		}
		ArrayCount += 1
	}
}

; Tile A Monitor's Windows
TileAutoSwitch(Monitor)
{	
		
	Local ArrayCount = 1
	
	Local VarsSetUp = 1
	Loop, %TotalMonitors%
	{
		Monitor%VarsSetUp%WindowsInDeck = 0
		Monitor%VarsSetUp%WindowsInPort = 0
		VarsSetUp +=1
	}
	
				
	


	TMPST := Monitor%Monitor%TotalWindows
	
	If(MaxWindowsInPort>=Monitor%Monitor%TotalWindows)
	{
		Local Shumpa := % Monitor%Monitor%TotalWindows - 1
	}
	Else
	{
		Shumpa := MaxWindowsInPort
	}
	
	Local MaxWindowsInPort = Shumpa
	
	Loop, %TMPST%
	{
		If(Monitor%Monitor%WindowsInPort!=MaxWindowsInPort)
		{
			Local TempId := Monitor%Monitor%Window%ArrayCount%
			ToggleWindowBorders(%TempId%)
			YHeight := (Monitor%Monitor%WorkingHeight-((MaxWindowsInPort+1)*PaddingVertical))/MaxWindowsInPort
			XMove := Monitor%Monitor%BoundingLeft + PaddingHorizontal
			YMove := PaddingVertical+(Monitor%Monitor%WindowsInPort*YHeight) + (Monitor%Monitor%WindowsInPort*MaxWindowsInPort * PaddingVertical/MaxWindowsInPort)
			WinMove, ahk_id %TempId%,, %XMove%, %YMove%, %PortWindowHorizontalSize%, %YHeight%
			Monitor%Monitor%WindowsInPort += 1
		}
		Else
		{
			Remaining%Monitor% := Monitor%Monitor%TotalWindows - MaxWindowsInPort
			TempId := Monitor%Monitor%Window%ArrayCount%
			XWidth := Monitor%Monitor%WorkingWidth - PortWindowHorizontalSize - (3*PaddingHorizontal)
			YHeight := (Monitor%Monitor%WorkingHeight-((Remaining%Monitor%+1)*PaddingVertical))/(Remaining%Monitor%)
			XMove := (Monitor%Monitor%BoundingLeft)+PortWindowHorizontalSize+(2*PaddingHorizontal)
			YMove := PaddingVertical+(Monitor%Monitor%WindowsInDeck*YHeight)+(Monitor%Monitor%WindowsInDeck*Remaining%Monitor% * PaddingVertical/Remaining%Monitor%)
			WinMove, ahk_id %TempId%,, %XMove%,% YMove, %XWidth%, %YHeight%
			Monitor%Monitor%WindowsInDeck += 1
		}
		ArrayCount += 1
	}
}   

;Tile Without the Focused window automatically swapping into the port



TileHotkeySwitch(Monitor)
{ 		
	Local ArrayCount = 1
	Local VarsSetUp = 1
	
	Loop, %TotalMonitors%
	{
		Monitor%VarsSetUp%WindowsInDeck = 0
		Monitor%VarsSetUp%WindowsInPort = 0
		VarsSetUp +=1
	}


	TMPST := Monitor%Monitor%TotalWindows
	
	If(MaxWindowsInPort>=Monitor%Monitor%TotalWindows)
	{
		Local Shumpa := % Monitor%Monitor%TotalWindows - 1
	}
	Else
	{
		Shumpa := MaxWindowsInPort
	}
	
	Local MaxWindowsInPort = Shumpa


	If(Monitor%Monitor%TotalWindows!=PrevTotWin%Monitor%)
	{
		Loop, %TMPST%
		{
			If(Monitor%Monitor%WindowsInPort!=MaxWindowsInPort)
			{
				Monitor%Monitor%PortWindow%ArrayCount% := Monitor%Monitor%Window%ArrayCount%
			}
			Else
			{
				Local AcCount := ArrayCount - MaxWindowsInPort
				Monitor%Monitor%DeckWindow%AcCount% := Monitor%Monitor%Window%ArrayCount%
			}
			ArrayCount += 1
		}
	}
	
	PrevTotWin%Monitor% := Monitor%Monitor%TotalWindows	
	
	ArrayCount = 1
	AcCount = 1
	Loop, %TMPST%
	{
		If(Monitor%Monitor%WindowsInPort!=MaxWindowsInPort)
		{
			TempId := Monitor%Monitor%PortWindow%ArrayCount%
			ToggleWindowBorders(%TempId%)
			YHeight := (Monitor%Monitor%WorkingHeight-((MaxWindowsInPort+1)*PaddingVertical))/MaxWindowsInPort
			XMove := Monitor%Monitor%BoundingLeft + PaddingHorizontal
			YMove := PaddingVertical+(Monitor%Monitor%WindowsInPort*YHeight) + (Monitor%Monitor%WindowsInPort*MaxWindowsInPort * PaddingVertical/MaxWindowsInPort)
			WinMove, ahk_id %TempId%,, %XMove%, %YMove%, %PortWindowHorizontalSize%, %YHeight%
			Monitor%Monitor%WindowsInPort += 1
		}
		Else
		{
			AcCount := ArrayCount - MaxWindowsInPort
			Remaining%Monitor% := Monitor%Monitor%TotalWindows - MaxWindowsInPort
			TempId := Monitor%Monitor%PortWindow%ArrayCount%
			XWidth := Monitor%Monitor%WorkingWidth - PortWindowHorizontalSize - (3*PaddingHorizontal)
			YHeight := (Monitor%Monitor%WorkingHeight-((Remaining%Monitor%+1)*PaddingVertical))/(Remaining%Monitor%)
			XMove := (Monitor%Monitor%BoundingLeft)+PortWindowHorizontalSize+(2*PaddingHorizontal)
			YMove := PaddingVertical+(Monitor%Monitor%WindowsInDeck*YHeight)+(Monitor%Monitor%WindowsInDeck*Remaining%Monitor% * PaddingVertical/Remaining%Monitor%)
			WinMove, ahk_id %TempId%,, %XMove%,% YMove, %XWidth%, %YHeight%
			Monitor%Monitor%WindowsInDeck += 1
		}
		ArrayCount += 1
	}
}   
    
    
    
    
    
    
    
    
    