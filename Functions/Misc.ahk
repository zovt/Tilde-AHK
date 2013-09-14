
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