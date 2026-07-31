<#
.SYNOPSIS
	Packs an assembled payload into an archive that can be handed to someone directly.

.DESCRIPTION
	For sharing a build outside a store: a tester, a friend with a Linux machine. Publishing through
	Itch does not need this, because butler sets the executable bits itself.

	It matters because NTFS has no execute bit and no Windows archiver writes a Unix permission field,
	so a zip made here produces a payload whose launcher and emulator cannot be run at all until the
	recipient works out which files to chmod. The archive is therefore packed inside WSL, where the
	permissions are real, and the script proves afterwards which entries came out executable.

.EXAMPLE
	.\New-Archive.ps1 -Platform linux -Store itch
#>
[CmdletBinding()]
param(
	[Parameter(Mandatory)][ValidateSet('linux', 'macos')][string] $Platform,
	[Parameter(Mandatory)][ValidateSet('steam', 'itch')] [string] $Store,
	[ValidateSet('main', 'demo')]                        [string] $Edition = 'main',

	# Any installed distribution will do: this only copies files and runs tar.
	[string] $Distro = 'Ubuntu-22.04'
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$staging = Join-Path $PSScriptRoot "staging\$Store-$Platform-$Edition"
if (-not (Test-Path -LiteralPath $staging))
{
	throw "nothing assembled at $staging; run New-Release.ps1 first"
}

$archive = Join-Path $PSScriptRoot "staging\$Store-$Platform-$Edition.tar.gz"

Write-Host ""
Write-Host "  packing $staging"
Write-Host "  into    $archive"
Write-Host ""

# Converted here rather than with wslpath inside the script, because a Windows path handed to bash
# loses its backslashes: bash reads them as escapes and D:\Git\... arrives as D:Git...
function ConvertTo-WslPath
{
	param([string] $WindowsPath)

	$drive = $WindowsPath.Substring(0, 1).ToLowerInvariant()
	return "/mnt/$drive" + ($WindowsPath.Substring(2) -replace '\\', '/')
}

# The script is run by path rather than piped into `bash -s`: Windows PowerShell re-encodes anything
# it pipes to a native command in the console codepage, which prepends a byte order mark, and bash
# then reports "#!/usr/bin/env: No such file or directory" -- an error that says nothing about the
# real cause.
$scriptPath = ConvertTo-WslPath (Join-Path $PSScriptRoot 'New-Archive.sh')

& wsl.exe -d $Distro -- bash $scriptPath (ConvertTo-WslPath $staging) (ConvertTo-WslPath $archive)

if ($LASTEXITCODE -ne 0)
{
	throw "packing failed with exit code $LASTEXITCODE"
}

if (-not (Test-Path -LiteralPath $archive))
{
	throw "packing reported success but $archive is not there"
}

Write-Host ""
Write-Host "  Extract with:  tar xzf $(Split-Path $archive -Leaf)"
Write-Host ""
