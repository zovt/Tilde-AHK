;Get Monitors and Resolutions from Config.ini
GetMonitorsAndResolutionsFromIni()
{
    IniRead, Monitor1Height, Config.ini, Resolution, Monitor1Height
    IniRead, Monitor1Width, Config.ini, Resolution, Monitor1Width
    IniRead, Monitor2Height, Config.ini, Resolution, Monitor2Height, 0
    IniRead, Monitor2Width, Config.ini, Resolution, Monitor2Width, 0
    IniRead, Monitor3Height, Config.ini, Resolution, Monitor3Height, 0
    IniRead, Monitor3Width, Config.ini, Resolution, Monitor3Width, 0
}

;Write the file Config.ini to 
WriteConfig()
{

}

;Set Up Window Dimensions
GetWindowOptionsFromIni()
{
    DefaultPortWindowHorizontalSize := Monitor1Width/3
    IniRead, PaddingVertical, Config.ini, Windows, PaddingVertical
    IniRead, PaddingHorizontal, Config.ini, Windows, PaddingHorizontal
    IniRead, PortWindowHorizontalSize, Config.ini, Windows, DefaultPortWindowHorizontalSize
    IniRead, MaxWindowsInPort, Config.ini, Settings, MaxWindowsInPort, 1
}

CalculateWindowSizes()
{
    PortWindowVerticalSize := Monitor1Height/MaxWindowsInPort
}
