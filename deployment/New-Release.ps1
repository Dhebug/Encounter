<#
.SYNOPSIS
	Assembles a store payload from common/ plus the two build projects' binaries.

.DESCRIPTION
	common/ is the source of truth for content and is copied wholesale: what gets shipped is exactly
	what is in that folder. Binaries come from each build project's own artifacts folder.

	Nothing is read from a working folder, and nothing from this repository's root: the repository is
	where the next version is being written, so its Version History.txt describes a release that has
	not happened yet.

	Assembly only. Nothing is built here and nothing is uploaded; see Publish-Release.ps1.

.EXAMPLE
	.\New-Release.ps1 -Platform linux -Store itch
#>
[CmdletBinding()]
param(
	[Parameter(Mandatory)][ValidateSet('windows', 'linux', 'macos')][string] $Platform,
	[Parameter(Mandatory)][ValidateSet('steam', 'itch')]             [string] $Store,
	[ValidateSet('main', 'demo')]                                    [string] $Edition = 'main',

	# The two build projects. Each owns the binaries it produces; this script only consumes them.
	[string] $LauncherArtifacts = 'D:\Git\GameLauncher\artifacts',
	[string] $EmulatorArtifacts = 'E:\git\oricutron\artifacts'
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

. "$PSScriptRoot\DeploymentHelpers.ps1"

$deployment = $PSScriptRoot
$common     = Join-Path $deployment 'common'


function Copy-Verified
{
	param([string] $Source, [string] $Destination)

	if (-not (Test-Path -LiteralPath $Source))
	{
		throw "missing: $Source"
	}

	$parent = Split-Path $Destination -Parent
	if (-not (Test-Path -LiteralPath $parent))
	{
		New-Item -ItemType Directory -Path $parent -Force | Out-Null
	}

	Copy-Item -LiteralPath $Source -Destination $Destination -Recurse -Force
}


# --- what this platform's binaries are called ------------------------------------------------

# The launcher hardcodes the emulator's filename per platform, in its platform module, so the
# payload has to match that rather than the other way round.
switch ($Platform)
{
	'windows'
	{
		$launcherName         = 'GameLauncher.exe'
		$emulatorName         = 'oricutron-sdl2.exe'
		$emulatorSourceFolder = 'windows-x64-sdl2'
		$emulatorSourceName   = 'oricutron.exe'
	}
	'linux'
	{
		$launcherName         = 'GameLauncher'
		$emulatorName         = 'oricutron-sdl2'
		$emulatorSourceFolder = 'linux-x64-sdl2'
		$emulatorSourceName   = 'oricutron'
	}
	'macos'
	{
		$launcherName         = 'GameLauncher.app'
		$emulatorName         = 'oricutron'
		$emulatorSourceFolder = 'macos-arm64-sdl2'
		$emulatorSourceName   = 'oricutron'
	}
}

$launcherSource = Join-Path $LauncherArtifacts "$Platform-$Store\$launcherName"
$emulatorSource = Join-Path $EmulatorArtifacts "$emulatorSourceFolder\$emulatorSourceName"


# --- the baseline ----------------------------------------------------------------------------

Assert-ContentIsPresent -Common $common
$version = Get-ContentVersion -GameFolder (Join-Path $common 'Game')

# No version in the path. A staging folder is scratch space for the payload being assembled now;
# git and the published stores are what remember versions, and any version can be reassembled from
# common/ or fetched back from the store.
$staging = Join-Path $deployment "staging\$Store-$Platform-$Edition"

Write-Host ""
Write-Host "Assembling $Store $Platform $Edition, version $version"
Write-Host "  from $common"
Write-Host "  into $staging"
Write-Host ""

# Built from empty every time. A payload that accumulates whatever a previous assembly left behind
# is how a file nobody meant to ship gets shipped.
#
# Emptied rather than deleted and recreated. A directory in use cannot be unlinked on Windows even
# when nothing holds a file inside it -- an Explorer window, an indexer or a WSL mount is enough --
# and there is no reason for assembly to fail over that when clearing the contents does the job.
New-Item -ItemType Directory -Path $staging -Force | Out-Null
Get-ChildItem -Path $staging -Force | Remove-Item -Recurse -Force

$leftovers = @(Get-ChildItem -Path $staging -Force)
if ($leftovers.Count -gt 0)
{
	throw "could not empty $staging; $($leftovers.Count) item(s) are in use"
}


# --- content -----------------------------------------------------------------------------------

# The whole of common/, in one copy. Nothing here decides what content ships: everything in there is
# payload by definition, so adding a text file to a release means putting it in common/ rather than
# editing this script.
#
# Game/ is the one exception, because the disk images are what distinguishes the editions.
Get-ChildItem -Path $common -Exclude 'Game' | ForEach-Object {
	Copy-Item -LiteralPath $_.FullName -Destination $staging -Recurse -Force
}

$contentFiles = @(Get-ChildItem -Path $staging -Recurse -File -Force)
Write-Host "  $($contentFiles.Count) content files"

$diskFilter = if ($Edition -eq 'demo') { 'EncounterDemo-*' } else { 'EncounterHD-*' }
New-Item -ItemType Directory -Path (Join-Path $staging 'Game') -Force | Out-Null

$disks = @(Get-ChildItem -Path (Join-Path $common 'Game') -Filter $diskFilter)
if ($disks.Count -eq 0)
{
	throw "common\ has no disk images matching $diskFilter"
}
foreach ($disk in $disks)
{
	Copy-Item -LiteralPath $disk.FullName -Destination (Join-Path $staging "Game\$($disk.Name)") -Force
}
Write-Host "  $($disks.Count) disk image files, $Edition edition"


# --- binaries ----------------------------------------------------------------------------------

Copy-Verified $launcherSource (Join-Path $staging $launcherName)
Write-Host "  launcher   $launcherName"

# Renamed to the name the launcher looks for. The emulator project names its artifact after the
# emulator; the shipped name additionally says which SDL it links.
Copy-Verified $emulatorSource (Join-Path $staging "Emulator\$emulatorName")
Write-Host "  emulator   Emulator\$emulatorName"

# Steam's runtime library sits beside the launcher. steam_appid.txt is deliberately absent: in a
# released build it would override the identity Steam assigns.
if ($Store -eq 'steam')
{
	switch ($Platform)
	{
		'windows' { $steamLibrary = 'steam_api64.dll'    }
		'linux'   { $steamLibrary = 'libsteam_api.so'    }
		'macos'   { $steamLibrary = 'libsteam_api.dylib' }
	}
	Copy-Verified (Join-Path $LauncherArtifacts "$Platform-$Store\$steamLibrary") (Join-Path $staging $steamLibrary)
	Write-Host "  $steamLibrary"
}

# On Itch the payload has to say which of its executables is the game, or the itch app offers the
# player a choice between the launcher and the emulator, and the emulator started on its own has no
# disk in the drive.
if ($Store -eq 'itch')
{
	$playPath = if ($Platform -eq 'macos') { 'GameLauncher.app' } else { $launcherName }
	$manifest = @(
		'# Tells the itch app which executable is the game. Without it the player is offered a'
		'# choice between the launcher and the emulator, and the emulator started directly has no'
		'# disk in the drive.'
		''
		'[[actions]]'
		'name = "play"'
		"path = `"$playPath`""
	)

	# Written without a byte order mark. Set-Content -Encoding UTF8 emits one in Windows
	# PowerShell, and a BOM ahead of the first key is not valid TOML.
	[System.IO.File]::WriteAllLines(
		(Join-Path $staging '.itch.toml'),
		$manifest,
		(New-Object System.Text.UTF8Encoding($false)))
	Write-Host "  .itch.toml, play action -> $playPath"
}


# --- what came out ---------------------------------------------------------------------------

# The two binaries only. Whether the payload actually works is answered by running it, not by a list
# of files here -- but a wrong -LauncherArtifacts or an emulator that was never built for this
# platform is worth catching now rather than after an upload.
foreach ($item in @($launcherName, "Emulator\$emulatorName"))
{
	if (-not (Test-Path -LiteralPath (Join-Path $staging $item)))
	{
		throw "assembled, but $item is missing"
	}
}

$files = @(Get-ChildItem -Path $staging -Recurse -File -Force)
$size  = ($files | Measure-Object -Property Length -Sum).Sum

Write-Host ""
Write-Host ("  version {0}, {1} files, {2:N1} MB" -f $version, $files.Count, ($size / 1MB))
Write-Host ""

return $staging
