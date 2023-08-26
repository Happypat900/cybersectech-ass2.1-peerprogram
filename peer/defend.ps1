param (
    [Parameter(Mandatory=$true)]
	#$arg
    [string]$arg
    )
echo $arg

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

function setupWDAC {
    $policyPath = "blockPolicy.xml"
    $outputPath = "BlockPolicy.cip"

    if (Test-Path $policyPath) {
        ConvertFrom-CIPolicy -XmlFilePath $policyPath -BinaryFilePath $outputPath
        Write-Host "WDAC policy has been compiled to $outputPath"
    } else {
        Write-Host "Policy file not found at $policyPath."
    }
}

function enableWDAC {
	CiTool --update-policy "BlockPolicy.cip"
}

function resetWDAC {
	CiTool --remove-policy "{A244370E-44C9-4C06-B551-F6016E563076}"
}

switch ($arg) {
    "testWDAC" {
        # Call the testWDAC function
        testWDAC
    }
    "setupWDAC" {
        # Call the setupWDAC function
        setupWDAC
    }
    "enableWDAC" {
        # Call the enableWDAC function
        enableWDAC
    }
	"resetWDAC" {
        # Call the resetWDAC function
        resetWDAC
    }
    default {
        Write-Output "Invalid argument provided."
    }
}