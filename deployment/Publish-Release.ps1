<#
.SYNOPSIS
	Uploads an assembled payload from staging/ to Itch.io with Butler.

.DESCRIPTION
	Shows what would be uploaded and does nothing else. Uploading for real needs -Live, because
	`butler push` publishes immediately: there is no staging step on Itch and no way to unpublish a
	build, only to push another one over it.

	The version recorded with the upload is read from the payload's own disk images, so it always
	describes what is actually being uploaded.

.EXAMPLE
	.\Publish-Release.ps1 -Platform linux -Store itch
	.\Publish-Release.ps1 -Platform linux -Store itch -Live
#>
[CmdletBinding()]
param(
	[Parameter(Mandatory)][ValidateSet('windows', 'linux', 'macos')][string] $Platform,
	[Parameter(Mandatory)][ValidateSet('steam', 'itch')]             [string] $Store,
	[ValidateSet('main', 'demo')]                                    [string] $Edition = 'main',

	# Defaults to the convention the game already uses on Itch: the platform, with _demo appended
	# for the demo.
	[string] $Channel,

	# Off by default. Without it nothing is uploaded.
	[switch] $Live,

	# Asks butler what it would push. Talks to itch.io, so it is not the default, but it uploads
	# nothing and creates no build.
	[switch] $DryRun,

	[string] $Butler = "$env:APPDATA\itch\apps\butler\butler.exe"
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

. "$PSScriptRoot\DeploymentHelpers.ps1"

if ($Store -eq 'steam')
{
	throw "Steam publishing is not implemented yet; upload with the SteamPipe GUI for now"
}

$staging = Join-Path $PSScriptRoot "staging\$Store-$Platform-$Edition"
if (-not (Test-Path -LiteralPath $staging))
{
	throw "nothing assembled at $staging; run New-Release.ps1 first"
}

if (-not (Test-Path -LiteralPath $Butler))
{
	throw "butler not found at $Butler"
}

$version = Get-ContentVersion -GameFolder (Join-Path $staging 'Game')

if (-not $Channel)
{
	# The existing channels are 'windows' and 'windows_demo'.
	$Channel = if ($Edition -eq 'demo') { "${Platform}_demo" } else { $Platform }
}

$target = "defenceforce/encounter:$Channel"

# steam_appid.txt would override the identity Steam assigns, and an Itch payload should not carry
# the other store's runtime library either.
if ($Store -eq 'itch')
{
	foreach ($name in @('steam_appid.txt', 'steam_api64.dll', 'libsteam_api.so', 'libsteam_api.dylib'))
	{
		if (Test-Path -LiteralPath (Join-Path $staging $name))
		{
			throw "$name is in the payload and must not be uploaded to Itch"
		}
	}

	if (-not (Test-Path -LiteralPath (Join-Path $staging '.itch.toml')))
	{
		throw "the payload has no .itch.toml, so the itch app would not know which executable to run"
	}
}

$files = @(Get-ChildItem -Path $staging -Recurse -File -Force)
$size  = ($files | Measure-Object -Property Length -Sum).Sum

Write-Host ""
Write-Host "  from     $staging"
Write-Host "  to       $target"
Write-Host ("  payload  version {0}, {1} files, {2:N1} MB" -f $version, $files.Count, ($size / 1MB))
Write-Host ""

# --fix-permissions is what makes a payload assembled on Windows runnable on Linux and macOS: NTFS
# carries no executable bit, so butler detects the executables itself and marks them.
$arguments = @(
	'push'
	$staging
	$target
	'--userversion', $version
	'--fix-permissions'
)

if (-not $Live)
{
	# Deliberately does not run butler at all: the default has to be something you can invoke
	# without wondering whether it reached itch.io.
	Write-Host "  Nothing was uploaded. This is the command that -Live would run:" -ForegroundColor Yellow
	Write-Host ""
	Write-Host "    $Butler $($arguments -join ' ')"
	Write-Host ""

	if ($DryRun)
	{
		Write-Host "  Asking butler what it would push:"
		& $Butler @arguments --dry-run
	}
	return
}

Write-Host "  Uploading. This publishes immediately and cannot be undone." -ForegroundColor Yellow
Write-Host ""

& $Butler @arguments
if ($LASTEXITCODE -ne 0)
{
	throw "butler push failed with exit code $LASTEXITCODE"
}

Write-Host ""
& $Butler status $target
