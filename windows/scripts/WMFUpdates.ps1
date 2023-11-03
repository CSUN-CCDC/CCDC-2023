# Check for WMF updates
$wmfUpdates = Get-HotFix -Description "Windows Management Framework" | Where-Object {$_.HotFixID -notlike "*KB*"}

if ($wmfUpdates) {
    Write-Host "WMF updates available:" -ForegroundColor Green
    $wmfUpdates | Format-Table -AutoSize
} else {
    Write-Host "No WMF updates available." -ForegroundColor Yellow
}
