# set_wallpaper.ps1
# TP Digispark : Télécharger une image et mettre en fond d'écran correctement

# --- 1️⃣ URL de l'image RAW sur GitHub ---
$url = "https://raw.githubusercontent.com/FogBound-IT/test/refs/heads/main/wallpapersden.com_hilarious-donald-trump-facial-expression_1920x1080.jpg"

# --- 2️⃣ Chemin de destination temporaire ---
$dest = "$env:TEMP\wallpaper.jpg"

# --- 3️⃣ Télécharger l'image ---
Try {
    Invoke-WebRequest -Uri $url -OutFile $dest -ErrorAction Stop
    Write-Output "Image téléchargée avec succès : $dest"
} Catch {
    Write-Error "Erreur lors du téléchargement de l'image : $_"
    Exit 1
}

# --- 4️⃣ Forcer le style du fond d'écran dans le registre ---
# WallpaperStyle = 2 => Stretch, TileWallpaper = 0 => pas de mosaïque
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name WallpaperStyle -Value "2"
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name TileWallpaper -Value "0"

# --- 5️⃣ Définir le fond d'écran via C# ---
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
    public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
    public const int SPI_SETDESKWALLPAPER = 0x0014;
    public const int SPIF_UPDATEINIFILE = 0x01;
    public const int SPIF_SENDCHANGE = 0x02;
    public static void SetDesktopWallpaper(string path) {
        SystemParametersInfo(SPI_SETDESKWALLPAPER, 0, path, SPIF_UPDATEINIFILE | SPIF_SENDCHANGE);
    }
}
"@

Try {
    [Wallpaper]::SetDesktopWallpaper($dest)
    Write-Output "Fond d'écran mis à jour correctement !"
} Catch {
    Write-Error "Erreur lors du changement du fond d'écran : $_"
    Exit 1
}

# --- 6️⃣ Pause pour voir le message si lancé manuellement ---
Read-Host "Appuyez sur Entrée pour fermer"
