<#
	Shared by the deployment scripts. Dot-source it:  . "$PSScriptRoot\DeploymentHelpers.ps1"
#>

# The version is read out of the disk image filenames, which carry it, so a payload can never be
# labelled with a version different from the game inside it. Point this at the folder whose disks
# are authoritative: common/ when assembling, and the assembled payload itself when publishing,
# which is what makes the uploaded version describe what is actually being uploaded.
function Get-ContentVersion
{
	param([Parameter(Mandatory)][string] $GameFolder)

	if (-not (Test-Path -LiteralPath $GameFolder))
	{
		throw "no Game folder at $GameFolder"
	}

	$disks    = @(Get-ChildItem -Path $GameFolder -Filter 'Encounter*-*.dsk')
	$versions = @($disks | ForEach-Object { if ($_.Name -match '-v([0-9.]+)\.dsk$') { $Matches[1] } } | Sort-Object -Unique)

	if ($versions.Count -eq 0)
	{
		throw "no versioned disk images in $GameFolder"
	}
	if ($versions.Count -gt 1)
	{
		throw "the disk images in $GameFolder disagree about the version: $($versions -join ', ')"
	}

	return $versions[0]
}


# common/ is the source of truth for content, so there is nothing to validate it against: what is in
# there is what ships, by definition. The only thing worth checking is that it is actually populated,
# because assembling from an empty folder would otherwise produce a payload with no game in it.
function Assert-ContentIsPresent
{
	param([Parameter(Mandatory)][string] $Common)

	foreach ($expected in @('Game', 'Emulator'))
	{
		if (-not (Test-Path -LiteralPath (Join-Path $Common $expected)))
		{
			throw "common\ has no $expected folder, so there is no content to assemble"
		}
	}
}
