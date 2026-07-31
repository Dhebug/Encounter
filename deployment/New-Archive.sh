#!/usr/bin/env bash
#
# The Linux half of New-Archive.ps1, which is the only caller:
#
#   wsl -d <distro> -- bash <this script> <linux staging path> <linux output file>
#
# Packs an assembled payload into a tar.gz that carries real Unix permissions. It is a separate file
# because the work has to happen inside Linux: NTFS has no execute bit and a Windows archiver stores
# no Unix permission field, so chmod and tar in here are what make the bits real.
#
# Both arguments are /mnt style paths, converted by the caller. Passing Windows paths through
# `bash -s` does not work: bash reads the backslashes as escapes and D:\Git\... arrives as D:Git...
#
set -u

STAGING="${1:-}"
OUTPUT="${2:-}"

if [ -z "$STAGING" ] || [ -z "$OUTPUT" ]; then
	echo "usage: $0 <staging path> <output file>"
	exit 2
fi

if [ ! -d "$STAGING" ]; then
	echo "no payload at $STAGING"
	exit 1
fi

# The archive's top-level folder, so extracting does not scatter files into the current directory
NAME=$(basename "$STAGING")
WORK="$HOME/.encounter-archive"
rm -rf "$WORK"
mkdir -p "$WORK"

cp -r "$STAGING" "$WORK/$NAME" || exit 1
cd "$WORK" || exit 1

# Everything readable and nothing executable, then the two binaries. Copying off a 9p mount leaves
# every file 0755, which would mark disk images and text files executable.
find "$NAME" -type f -exec chmod 644 {} +
find "$NAME" -type d -exec chmod 755 {} +

EXECUTABLES=0
for BINARY in "$NAME/GameLauncher" "$NAME/Emulator/oricutron-sdl2" "$NAME/Emulator/oricutron"; do
	if [ -f "$BINARY" ]; then
		chmod 755 "$BINARY"
		EXECUTABLES=$((EXECUTABLES + 1))
	fi
done

if [ "$EXECUTABLES" -eq 0 ]; then
	echo "found nothing to mark executable in $NAME, refusing to write an unrunnable archive"
	exit 1
fi

mkdir -p "$(dirname "$OUTPUT")"
rm -f "$OUTPUT"
# --owner/--group so the archive does not carry this machine's account into someone else's extract
tar czf "$OUTPUT" --owner=0 --group=0 "$NAME" || exit 1

echo "  $(basename "$OUTPUT"), $(du -h "$OUTPUT" | cut -f1), $EXECUTABLES executables marked"
echo "  entries that will extract as executable:"
tar tzvf "$OUTPUT" | awk '$1 ~ /^-rwx/ {print "    " $1, $NF}'

rm -rf "$WORK"
