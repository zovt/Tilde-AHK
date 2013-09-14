
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

	UpdateWindowList()
	CountWindowsPerMonitor()
	
	If(Monitor%Monitor%TotalWindows!=PrevTotWin%Monitor%)
	{
		UpdateWindowList()
		CountWindowsPerMonitor()
		UpdateMonitorDatabase()
		
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