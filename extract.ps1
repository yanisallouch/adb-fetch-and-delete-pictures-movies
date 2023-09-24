# Définir le répertoire de destination actuel (le répertoire depuis lequel le script est exécuté).
$destinationDirectory = "."

# Exécuter la commande ADB pour lister tous les fichiers vidéo et image sur votre téléphone, y compris les nouvelles extensions ajoutées.
$files = & adb shell "find /sdcard/ -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.mp4' -o -iname '*.mov' -o -iname '*.mkv' -o -iname '*.gif' -o -iname '*.avi' -o -iname '*.webp' -o -iname '*.dng' \)"

# Convertir la sortie en un tableau de chaînes.
$filesArray = $files -split [Environment]::NewLine

# Parcourir chaque fichier trouvé sur le téléphone.
foreach ($file in $filesArray) {
    # Extraire le chemin du fichier sur le téléphone.
    $filePathOnPhone = $file.Trim()

    # Extraire le nom du fichier à partir du chemin complet.
    $fileName = [System.IO.Path]::GetFileName($filePathOnPhone)

    # Construire le chemin complet de destination en utilisant le répertoire actuel.
    $destinationPath = Join-Path -Path $destinationDirectory -ChildPath $fileName

    # Exécuter la commande ADB pour copier le fichier sur l'ordinateur.
    & adb pull "$filePathOnPhone" "$destinationPath"

    # Vérifier si la commande de copie a réussi (exit code 0).
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Copié : $fileName"

        # Exécuter la commande ADB pour supprimer le fichier du téléphone.
        & adb shell "rm '$filePathOnPhone'"

        # Vérifier si la commande de suppression a réussi (exit code 0).
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Supprimé : $fileName"
        } else {
            Write-Host "Échec de la suppression : $fileName"
        }
    } else {
        Write-Host "Échec de la copie : $fileName"
    }
}
