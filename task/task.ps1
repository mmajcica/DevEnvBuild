[CmdletBinding()]
param()

Trace-VstsEnteringInvocation $MyInvocation

try
{
	[string]$project = Get-VstsInput -Name project -Require
	[string]$buildPlatform = Get-VstsInput -Name buildPlatform
	[string]$buildCfg = Get-VstsInput -Name buildCfg
	[string]$vsVersion = Get-VstsInput -Name vsVersion
	[bool]$deploy = Get-VstsInput -Name deploy -AsBool
	[bool]$clean = Get-VstsInput -Name clean -AsBool

	Import-Module -Name $PSScriptRoot\ps_modules\utils.psm1

	# if project path doesn't exist or it's not valid
	if (-not (Test-Path $project -PathType Leaf -IsValid))
	{
		throw "Provided project file path is not a valid or it can't be found."
	}

	# Resolve a VS version.
	$vsVersion = Select-VSVersion -PreferredVersion $vsVersion

	# If no VS found, throw exception
	if (!$vsVersion)
	{
		throw "Visual Studio was not found. Try installing a supported version of Visual Studio. See the task definition for a list of supported versions."
	}

	$vsLocation = Get-VSPath -Version $vsVersion
	Write-Verbose "Resolved Visual Studio path is: $vsLocation"
	$devcmd = Join-Path $vsLocation "Common7\IDE\devenv.com"

	# if project path doesn't exist or it's not valid
	if (-not (Test-Path $devcmd -PathType Leaf -IsValid))
	{
		throw "Expected devenv.com path is not valid."
	}

	# Construct invocation arguments
	$vsArgs = """$project"""

	if ($deploy)
	{
		$vsArgs += " /Deploy"
	}
	else
	{
		if ($clean)
		{
			$vsArgs += " /Rebuild"
		}
		else
		{
			$vsArgs += " /Build"
		}
	}

	if ($buildCfg)
	{ 
		$solutionConfig = " $buildCfg"
		if ($buildPlatform)
		{
			$solutionConfig = (' "{0}|{1}"' -f $buildCfg, $buildPlatform)
		}

		$vsArgs += $solutionConfig
	}

	Invoke-VstsTool -FileName $devcmd -Arguments $vsArgs -RequireExitCodeZero

	Write-Output "Build succeeded."
}
finally
{
    Trace-VstsLeavingInvocation $MyInvocation
}