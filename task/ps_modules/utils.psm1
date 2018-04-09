function Get-VSPath
{
    [CmdletBinding()]
    param
    (
        [string][Parameter(Mandatory = $true)]$Version
    )
    BEGIN { Import-Module -Name $PSScriptRoot\VSSetup\Microsoft.VisualStudio.Setup.PowerShell.dll }
    PROCESS
    {
        Trace-VstsEnteringInvocation $MyInvocation

        try
	    {
            # Search for a 15.0 Willow instance.
            if ($Version -eq "15.0" -and ($instance = Get-VSSetupInstance | Select-VSSetupInstance -Version '[15.0,)') -and $instance.installationPath)
		    {
                return $instance.InstallationPath
            }

            # Fallback to searching for an older install.
            if ($path = (Get-ItemProperty -LiteralPath "HKLM:\SOFTWARE\WOW6432Node\Microsoft\VisualStudio\$Version" -Name 'ShellFolder' -ErrorAction Ignore).ShellFolder)
		    {
                return $path
            }
        }
	    finally
	    {
            Trace-VstsLeavingInvocation $MyInvocation
        }
    }
    END { }
}

function Select-VSVersion
{
    [CmdletBinding()]
    param
    (
        [string]$PreferredVersion
    )
    BEGIN { }
    PROCESS
    {

        Trace-VstsEnteringInvocation $MyInvocation

        try
	    {
            $specificVersion = $PreferredVersion -and $PreferredVersion -ne 'latest'
            $versions = '15.0', '14.0', '12.0', '11.0', '10.0' | Where-Object { $_ -ne $PreferredVersion }

            # Look for a specific version of Visual Studio.
            if ($specificVersion) {
                if ((Get-VSPath -Version $PreferredVersion)) {
                    return $PreferredVersion
                }

                # Error. Do not fallback from 15.0.
                if ($PreferredVersion -eq '15.0')
			    {
                    throw ("Visual Studio 2017 was not found." -f $PreferredVersion)
                }

                # Attempt to fallback.
                $versions = $versions | Where-Object { $_ -ne '15.0' } # Fallback is only between 14.0-10.0.
                Write-Verbose "Version '$PreferredVersion' not found. Looking for fallback version."
            }

            # Look for latest or a fallback version.
            foreach ($version in $versions)
		    {
                if ((Get-VSPath -Version $version))
			    {
                    # Warn falling back.
                    if ($specificVersion)
				    {
                        Write-Warning ("Visual Studio version '{0}' not found. Falling back to version '{1}'." -f $PreferredVersion, $version)
                    }

                    return $version
                }
            }

            # Warn not found.
            if ($specificVersion)
		    {
                Write-Warning ("Visual Studio version '{0}' not found." -f $PreferredVersion)
            }
		    else
		    {
                Write-Warning "Visual Studio was not found. Try installing a supported version of Visual Studio. See the task definition for a list of supported versions."
            }
        }
	    finally
	    {
            Trace-VstsLeavingInvocation $MyInvocation
        }
    }
    END { }
}