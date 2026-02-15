$apps = @(

)

foreach($app in $apps){
	Write-host "Desistalando o app => $app ..." -ForegroundColor Cyan
	winget uninstall $app --silent
	# Get-WinGetPackage | Where-Object { $_.name -like "*Microsoft Edge*"} | Uninstall-WinGetPackage
}