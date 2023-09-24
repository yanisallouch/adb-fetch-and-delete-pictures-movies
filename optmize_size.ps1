# Définition des paramètres
$sourceFolder = Get-Location
$ffmpegPath = "ffmpeg.exe" # Remplacez par le chemin vers votre exécutable FFmpeg
$outputFolder = $sourceFolder

# Parcours des fichiers dans le dossier source
Get-ChildItem -Path $sourceFolder | ForEach-Object {
    $inputFile = $_.FullName
    $outputFile = Join-Path -Path $outputFolder -ChildPath $_.Name

    # Vérification du type de fichier (image ou vidéo)
    if ($_ -is [System.IO.FileInfo] -and ($_ -match '\.(jpg|jpeg|png|gif|mp4|avi|mkv)$')) {
        # Traitement des images
        if ($_ -match '\.(jpg|jpeg|png|gif)$') {
            # Utilisation de FFmpeg pour redimensionner les images
            & $ffmpegPath -y -i $inputFile -vf "scale=1920:-2,format=yuv420p" -q:v 2 -update 1 $outputFile
        }
        # Traitement des vidéos
        elseif ($_ -match '\.(mp4|avi|mkv)$') {
            & $ffmpegPath -y -i $inputFile -vf "scale=1920:-2,format=yuv420p" -color_range 2 -c:v libx264 -crf 23 -c:a aac -strict experimental -update 1 $outputFile
        }
        Write-Host "Traitement de $($_.Name) terminé."
    }
}

Write-Host "Le traitement est terminé."
