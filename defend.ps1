function testWDAC {
    $appPath = "C:\tools\Mimikatz\x64\Mimikatz.exe"
	$arguments = "privilege::debug", "token::elevate", "lsadump::lsa /inject"
	$processName = "mimikatz"

    if (Test-Path $appPath) {
        Start-Process -FilePath $appPath -ArgumentList $arguments -WindowStyle Hidden -PassThru | Out-Null
        $running = Get-Process -Name $processName -ErrorAction SilentlyContinue
        if ($running) {
            Write-Output "$processName has been run successfully. Killing it now."
			Stop-Process -Id $running.Id -Force
        } else {
            Write-Output "$processName has not been run successfully."
        }
    } else {
        Write-Output "File not found at $appPath."
    }
}

testWDAC