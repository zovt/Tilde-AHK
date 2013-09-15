UpdateMonitorDatabase()
{
	Global 

	WinGet, WindowListRaw, List
	
	WindowList := WindowListRaw
	Loop, %WindowListRaw%
	{
		tempid := WindowListRaw%A_Index%
		WinGetTitle, TempName, ahk_id %tempid%
		If(!(InStr, ExcludeList, TempName))
		{
			ExcludeList := ExcludeList . ", " . TempName
		}
		
	}
}

TileWindows()
{
}