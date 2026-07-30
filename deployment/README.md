# Encounter deployment

Builds every shipped artefact from source and assembles the store payloads, replacing the manual
copying, the `Clean*ContentFolder.bat` files and the by-hand steps in the launcher's README.

`../publishing/` holds store and marketing material. This folder holds the machinery.

Nothing here is written yet: this is the design and the running order. Sections marked **TODO**
are not implemented.


## What gets shipped

Three axes over one shared payload:

| Axis | Values |
|------|--------|
| Store | Steam, Itch.io |
| Platform | Windows, Linux, macOS |
| Edition | main, demo |

The demo is the same launcher and the same emulator as the main game, differing only in which
disk image is included, plus a short "about this demo" note. It is not a separate pipeline.

macOS shipping is **undecided**: Steam requires notarisation, which requires a paid Apple
Developer ID, so the choice is between paying for it and not shipping macOS. See *Code signing*
below. Counting macOS on Steam only, that is ten payloads: Steam x 3 platforms x 2 editions,
Itch x 2 platforms x 2 editions.

The physical edition DLC (Steam 4190940) is separate and stays manual for now.


## Where things are built

No single machine can build all of it, so one host orchestrates the other two. All three are
already working.

| Target | Host | Notes |
|--------|------|-------|
| Windows | this PC, MSVC | native |
| Linux | WSL, **Ubuntu 22.04 container** | not Debian 13, see *glibc* below |
| macOS arm64 + Intel | a Mac on the local network, reached over SSH | both slices come from the arm machine, merged with `lipo` |

Host names, account names, addresses and key paths are **deliberately not recorded in this
repository**. They live in `local.settings`, which is git-ignored: copy `local.settings.example`
and fill it in. Nothing in here should ever carry an internal address or account name, since this
repository is published.

The Mac needs the Xcode command line tools; the build script installs a user-local CMake if the
machine has none.


## Layout

Each project owns the builds it produces. This folder consumes them and owns only the assembly.

```
E:/git/oricutron/artifacts/            <- the emulator project's own output
  {windows,linux,macos}-<arch>-sdl2/
  manifest.json                        commit, SDL version, architectures

D:/Git/GameLauncher/artifacts/         <- the launcher project's own output
  {windows,linux,macos}-{steam,itch}/
  manifest.json

deployment/                            <- here
  base/                                payload common to every target, including the emulator
                                       data (ROMs, images) and the game's oricutron.cfg
  staging/<version>/<store>-<platform>-<edition>/
  logs/
```

Both `artifacts/` folders are build output, not source, and are **git-ignored**: binaries do not
belong in a repository, and the three build hosts collect their results onto the orchestrating
machine anyway. Oricutron's is ignored through `.git/info/exclude`, which is per-clone and never
committed, so that repository stays untouched.

`staging/` is what gets uploaded, kept separate so a payload can be reassembled without
rebuilding and one build can serve several editions.


## Sources of truth

| Content | Comes from |
|---------|------------|
| `Version History.txt`, `ReadMe.txt`, `LisezMoi.txt` | this repository's root |
| Disk images | `../build/EncounterHD-*.dsk` |
| Emulator binary | `E:\git\oricutronrtifacts\`, built by that project for every platform |
| Launcher binary | `D:\Git\GameLauncherrtifacts\`, built by that project per platform and store |
| Emulator data (ROMs, images, disks) | `base/`, from an official Oricutron distribution, see below |
| `oricutron.cfg` | `base/`: the game's own, which differs from Oricutron's stock one |

**The emulator is never taken from `%OSDK%\Oricutron`.** That folder is the OSDK's own deployment
target: fetching from it would make an Encounter release depend on whatever state the OSDK happens
to be in. Every platform's emulator is built here from a pinned Oricutron commit, Windows included.

**The ROM images are not in the Oricutron repository.** Git carries only the `.sym` and `.pch`
files, so a build from source produces a binary that exits immediately with
`Unable to open 'roms/basic11b.rom'` and friends. The `.rom` files come with official Oricutron
distributions; the currently shipped `Emulator/` folder is the known-good copy. An emulator payload
is therefore *our binary* plus *that data*, and the data needs its own pinned source rather than
being assumed to come out of the repository.

The game build should deposit the disk images and `Version History.txt` where the assembly step
expects them, so a release never depends on remembering to copy them. **TODO**


## Scripts

All **TODO**.

| Script | Does |
|--------|------|
| `Build-Emulator.ps1 -Platform windows\|linux\|macos` | builds a pinned static SDL2, then Oricutron against it |
| `Build-Launcher.ps1 -Platform ... -Store steam\|itch` | invokes the right host's toolchain |
| `New-Release.ps1 -Version x.y.z` | assembles `base` + emulator + launcher into `staging/`, per target |
| `Publish-Release.ps1 -Target ... [-WhatIf]` | Butler for Itch, SteamCMD for Steam |
| `Release.ps1` | interactive menu over the above |

`New-Release.ps1` also does what the `Clean*ContentFolder.bat` files do today: drop
`steam_appid.txt` and the emulator's scratch files (`stdout.txt`, `stderr.txt`,
`printer_out.txt`, `screenshot*.bmp`), and refresh the three text files from this repository.


## Running order

1. **Emulator builds, for all three platforms.** Windows is included: its emulator has to come
   from our own build too, not from the OSDK. macOS is **done** -- see `E:\git\oricutronrtifacts\macos-arm64-sdl2\`.

   Once a Windows build carrying `--title` and `--icon` is in the shipped payload, the launcher's
   `ORICUTRON_HAS_TITLE` and `ORICUTRON_HAS_ICON` gates can both be switched on and the
   `EnumWindows` / `SetWindowText` / `WM_SETICON` thread deleted. The gates describe what the
   *deployed* emulator understands, so they must not be flipped before that.
2. **Launcher builds** for all five platform/store combinations. Needs the Steamworks SDK
   present on each host; the Mac's Steam target is currently disabled because
   `STEAMWORKS_SDK_DIR` still points at a Windows path.
3. **Assembly**, retiring the `.bat` files and the manual copying.
4. **Publishing**, last and behind `-WhatIf`. `butler push` goes live immediately; a Steam
   upload still has to be set live by hand, which is a useful brake.

### Where Linux stands, 2026-07-30

Both Linux artefacts are built and self-contained, from Ubuntu 22.04:

| | size | requires |
|---|---|---|
| launcher | 11 MB | `GLIBC_2.35`, and no libstdc++ version at all |
| emulator | 4.3 MB | `GLIBC_2.34`, SDL2 linked in, audio backends dlopened |

A payload assembled from the two projects' `artifacts/` folders plus the shared data runs: both
binaries start, and the emulator needs no audio workaround. Being built from `9b7ad9f` it carries
`--title` and `--icon`, and reports that commit in its build name.

Remaining for Linux: the Steam variant, which needs the Steamworks SDK inside the build container.


## Decisions already taken

**SDL2 only.** SDL 1.2 is dead upstream, its Oricutron build segfaults during startup on a
current Linux desktop, and it is unlikely to build for arm64 macOS at all. The existing Windows
SDL1 binary stays as a frozen artefact because that is what ships today and works. This is what
took the emulator matrix from eight builds to three.

**Oricutron is read-only.** It is never modified, and it is built from a pinned commit copied out
of the worktree, never from the live tree: another agent works in that repository, so building
from it directly would be both irreproducible and a way to trip over each other. The commit hash
goes in `manifest.json`. If a build fix is ever needed, it is a change request, not a patch.

Its `Makefile` already takes `PLATFORM=` and `SDL_LIB=sdl2` and honours `SDL_CFLAGS`, with a
pkg-config fallback, so a vendored static SDL2 can be handed to it without touching anything.

**Static linking, and what it does not buy.** Worth taking: static SDL2, and
`-static-libstdc++ -static-libgcc` for the Linux launcher, which removes the `GLIBCXX`
requirement entirely. It does *not* make a Linux binary self-contained: SDL2 `dlopen`s its audio
backend, so `libpulse` or `libasound` still has to exist on the player's machine, and a fully
static glibc would break `dlopen` altogether. macOS cannot statically link system frameworks.

**SDL2's audio backends have to exist at its build time, or the game ships silent.** SDL2 decides
which backends to compile in when *it* is configured, from the development headers present on the
build machine, and dlopens the chosen one at run time. Built in a container without
`libasound2-dev` and `libpulse-dev` it ends up with **only the dummy driver**, and the emulator then
fails with `SDL init failed: dsp: No such audio device` on every machine, not only in WSL. That was
mistaken for a WSL quirk once, and would have shipped a game with no sound at all.

So the build container needs `libasound2-dev`, `libpulse-dev`, `libpipewire-0.3-dev` and
`libjack-jackd2-dev` installed *before* SDL2 is built, and the result is worth verifying rather than
assuming:

    strings <binary> | grep -qx pulseaudio && echo present

They are dlopened, so the shipped binary still carries no hard dependency on them; the player's
desktop provides whichever it has.

**glibc sets the Linux floor.** Symbol versioning is one-directional: a binary built against a
newer glibc refuses to start on an older one, while the reverse is fine. Built on Debian 13
(glibc 2.41) the launcher requires `GLIBC_2.38`, which does not exist on Ubuntu 22.04 LTS (2.35)
or Debian 12 (2.36). Hence building the release in an Ubuntu 22.04 container: the floor drops to
2.35 and one binary then covers every current desktop distribution. WSL Debian stays fine for
development.

The GTK3 stack is linked dynamically and must not be bundled; every desktop distribution has it.

**Code signing is required for Steam, so macOS needs an Apple Developer ID.** The Steamworks
platform documentation states: *"Starting October 14th, 2019 Steam will require all new macOS
Applications to be 64-bit and notarized by Apple."* Notarisation requires a Developer ID
Application certificate, which requires Apple Developer Program membership at $99/year.

This overturns an earlier assumption recorded here, that shipping on Steam avoided the
certificate. That reasoning was about the wrong thing: it considered only whether Gatekeeper
would fire, given that Steam's downloads do not carry the quarantine attribute. Valve's
requirement is policy and applies regardless.

What notarising actually involves, when it is decided:

- a Developer ID Application certificate in the Mac's keychain
- signing with the **hardened runtime**, plus the two entitlements Steamworks calls for so the
  Steam overlay can inject: `com.apple.security.cs.disable-library-validation` and
  `com.apple.security.cs.allow-dyld-environment-variables`
- signing **every** executable shipped, the emulator inside `Encounter.app` included, and signing
  after `lipo` so the universal binary is what carries the signature
- `xcrun notarytool submit`, then `xcrun stapler staple`

On Apple silicon every binary also needs at least an ad-hoc signature simply to execute, which
clang applies at link time; that part already works and is why local builds run.

So the macOS decision is now between paying $99/year and not shipping macOS at all. Paying also
removes the reason macOS was limited to Steam, since a notarised build is equally fine on Itch.

**Universal macOS binary.** Recommended before any macOS release. Rosetta only translates x64 to
arm, never the reverse, so an arm64-only build cannot start at all on an Intel Mac. One line,
`CMAKE_OSX_ARCHITECTURES "x86_64;arm64"`, at the cost of building wxWidgets twice.
