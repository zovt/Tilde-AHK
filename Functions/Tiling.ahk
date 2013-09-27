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

UpdateMonitorDatabase()
{
	Global 

	WinGet, WindowListRaw, List
	WinDBCount = 0

	
	WindowList := WindowListRaw
	Loop, %WindowListRaw%
	{
		tempid := WindowListRaw%A_Index%
		WinGetTitle, TempName, ahk_id %tempid%
		IfNotInString, IgnoreList, %TempName%
		{
			IfNotInString, ExcludeList, %TempName%
			{
				ExcludeList := ExcludeList . ", " . TempName
				Monitor := WhichMonitor(WindowListRaw%A_Index%)
				Monitor%Monitor%DBCount += 1
				TempCount := Monitor%Monitor%DBCount
				Monitor%Monitor%DBWindow%TempCount% := WindowListRaw%A_Index%
			}
		}
	}
}

TileWindows(Monitor)
{
	Global
	
	Monitor%Monitor%WindowsInPort = 0
	Monitor%Monitor%WindowsInDeck = 0
	
	Local Temp = Monitor%Monitor%DBCount
	
	Loop, %Temp%
	{
		If(Monitor%Monitor%WindowsInPort!=MaxWindowsInPort)
		{
			TempId := Monitor%Monitor%DBWindow%A_Index%
			ToggleWindowBorders(TempId)
			YHeight := (Monitor%Monitor%WorkingHeight-((MaxWindowsInPort+1)*PaddingVertical))/MaxWindowsInPort
			XMove := Monitor%Monitor%BoundingLeft + PaddingHorizontal
			YMove := PaddingVertical+(Monitor%Monitor%WindowsInPort*YHeight) + (Monitor%Monitor%WindowsInPort*MaxWindowsInPort * PaddingVertical/MaxWindowsInPort)
			WinMove, ahk_id %TempId%,, %XMove%, %YMove%, %PortWindowHorizontalSize%, %YHeight%
			Monitor%Monitor%WindowsInPort += 1
		}
		Else
		{
			Remaining%Monitor% := Monitor%Monitor%DBCount - MaxWindowsInPort
			TempId := Monitor%Monitor%DBWindow%A_Index%
			XWidth := Monitor%Monitor%WorkingWidth - PortWindowHorizontalSize - (3*PaddingHorizontal)
			YHeight := (Monitor%Monitor%WorkingHeight-((Remaining%Monitor%+1)*PaddingVertical))/(Remaining%Monitor%)
			XMove := (Monitor%Monitor%BoundingLeft)+PortWindowHorizontalSize+(2*PaddingHorizontal)
			If(Monitor%Monitor%WindowsInDeck)
			{
				YMove := (Monitor%Monitor%WindowsInDeck*YHeight)+(Monitor%Monitor%WindowsInDeck*Remaining%Monitor% * PaddingVertical)
			}
			Else
			{
				YMove := PaddingVertical+(Monitor%Monitor%WindowsInDeck*YHeight)+(Monitor%Monitor%WindowsInDeck*Remaining%Monitor% * PaddingVertical)
			}
			WinMove, ahk_id %TempId%,, %XMove%,% YMove, %XWidth%, %YHeight%
			Monitor%Monitor%WindowsInDeck += 1
		}
	}
	
}