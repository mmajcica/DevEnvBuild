function Get-VSPath {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Version)
    BEGIN { Import-Module -Name $PSScriptRoot\VSSetup\Microsoft.VisualStudio.Setup.PowerShell.dll }
    PROCESS {
        Trace-VstsEnteringInvocation $MyInvocation
        try {
            if ($Version -eq "17.0" -and
                ($instance = Get-VSSetupInstance | Select-VSSetupInstance -Version '[17.0,)') -and
                $instance.installationPath) {
                return $instance.installationPath
            }
            if ($Version -eq "16.0" -and
                ($instance = Get-VSSetupInstance | Select-VSSetupInstance -Version '[16.0,)') -and
                $instance.installationPath) {
                return $instance.installationPath
            }
            # Search for a 15.0 Willow instance.
            if ($Version -eq "15.0" -and
                ($instance = Get-VSSetupInstance | Select-VSSetupInstance -Version '[15.0,16.0)') -and
                $instance.installationPath) {
                return $instance.installationPath
            }
        }
        finally {
            Trace-VstsLeavingInvocation $MyInvocation
        }
    }
    END { }
}

function Select-VSVersion {
    [CmdletBinding()]
    param([string]$PreferredVersion)

    Trace-VstsEnteringInvocation $MyInvocation
    try {
        $specificVersion = $PreferredVersion -and $PreferredVersion -ne 'latest'
        $versions = '17.0', '16.0', '15.0' | Where-Object { $_ -ne $PreferredVersion }

        # Look for a specific version of Visual Studio.
        if ($specificVersion) {
            if ((Get-VSPath -Version $PreferredVersion)) {
                return $PreferredVersion
            }

            # Attempt to fallback.
            Write-Verbose "Version '$PreferredVersion' not found. Looking for fallback version."
        }

        # Look for latest or a fallback version.
        foreach ($version in $versions) {
            if ((Get-VSPath -Version $version)) {
                # Warn falling back.
                if ($specificVersion) {
                    Write-Warning "Visual Studio version '$PreferredVersion' not found. Falling back to version '$version'."

                }

                return $version
            }
        }

        # Warn not found.
        if ($specificVersion) {
            Write-Warning "Visual Studio version '$PreferredVersion' not found."
        }
        else {
            Write-Warning "Visual Studio was not found. Try installing a supported version of Visual Studio. See the task definition for a list of supported versions."
        }
    }
    finally {
        Trace-VstsLeavingInvocation $MyInvocation
    }
}

function Get-SingleFile {
    param (
        [string]$pattern
    )

    Write-Verbose "Finding files with pattern $pattern"
    $files = Find-VstsFiles -LegacyPattern "$pattern"
    Write-Verbose "Matched files = $files"

    if ($files -is [system.array]) {
        throw "Found more than one file to deploy with search pattern $pattern. There can be only one."
    }
    else {
        if (!$files) {
            throw "No files were found to deploy with search pattern $pattern"
        }
        return $files
    }
}
