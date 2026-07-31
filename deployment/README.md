# Encounter deployment

Assembles the store payloads from the content baseline and the two build projects' binaries, and
uploads them.


## What gets shipped

Three axes over one payload:

| Axis | Values |
|------|--------|
| Store | Steam, Itch.io |
| Platform | Windows, Linux, macOS |
| Edition | main, demo |

The demo is the same launcher and the same emulator, differing only in which disk image it carries.

Itch currently has the `windows`, `windows_demo` and `linux` channels. The physical edition DLC
(Steam 4190940) is separate and stays manual.


## How a payload is composed

    common/  +  a launcher for this platform and store
             +  an emulator for this platform
             +  whatever else this target needs
    =  a published payload

**`common/` holds everything shared by every version of the game**: the disk images, the emulator's
data, and the text files. It is copied wholesale, so adding a file to a release means putting it in
`common/` rather than editing a script.

Everything else is per target:

| Part | Comes from | Varies by |
|------|------------|-----------|
| Launcher | `D:/Git/GameLauncher/artifacts/<platform>-<store>/` | platform, store |
| Emulator | `E:/git/oricutron/artifacts/<platform>-<arch>-sdl2/` | platform, architecture |
| Steam runtime library | the launcher project's artifacts, beside the launcher | platform, store |
| `.itch.toml` | generated during assembly | store |
| Which disk images are taken from `common/Game/` | main or demo | edition |

The version number is read from the disk image filenames, so `EncounterHD-EN-50HZ-v1.4.0.dsk`
publishes as 1.4.0.


## Layout

Each project owns the builds it produces. This folder consumes them and owns the assembly.

```
E:/git/oricutron/artifacts/            <- the emulator project's own output
  {windows,linux,macos}-<arch>-sdl2/
  manifest.json                        commit, SDL version, architectures

D:/Git/GameLauncher/artifacts/         <- the launcher project's own output
  {windows,linux,macos}-{steam,itch}/

deployment/                            <- here
  common/                              the shared content
  staging/<store>-<platform>-<edition>/
  logs/
```

`common/`, `staging/` and both `artifacts/` folders are git-ignored, so the content and the binaries
are not in version control.

`staging/` is scratch space for the payload being assembled now, and carries no version in its path.
Git and the stores are what remember versions.


## Where the binaries are built

No single machine builds all of it, so one host drives the other two.

| Binary | Host | Rebuild with | How it works |
|--------|------|--------------|--------------|
| Launcher, every platform and store | this PC, driving WSL and the Mac | `cmake --build build --target BuildAllPlatforms` | `BUILDING.md` in the launcher repository |
| Emulator | per platform | `Build-Emulator.ps1` (**TODO**) | that script, once it exists |

Both write into their own project's `artifacts/` folder, which is what assembly reads.

The Mac's address, account and key come from the `MAC_BUILD_HOST`, `MAC_BUILD_USER` and `MAC_BUILD_KEY`
environment variables, which the launcher's CMake reads when it configures — this repository is
published, so they stay out of it. Every other path the scripts need is a parameter with a default, so
they run with no configuration here and can be pointed elsewhere with a switch.

Oricutron is built from a pinned commit copied out of its worktree, and the hash goes in
`manifest.json`. Build fixes go through a change request to that project.


## Scripts

| Script | Does | State |
|--------|------|-------|
| `New-Release.ps1 -Platform ... -Store ... [-Edition ...]` | assembles `common/` + the two binaries into `staging/` | works |
| `New-Archive.ps1 -Platform ... -Store ...` | packs `staging/` into a tar.gz carrying real Unix permissions, to hand a build to someone directly | works |
| `New-Archive.sh` | the Linux half of the above, run inside WSL by it | works |
| `Publish-Release.ps1 -Platform ... -Store ... [-Live]` | uploads to Itch with Butler | Itch works, Steam **TODO** |
| `DeploymentHelpers.ps1` | dot-sourced by the others; the version rule lives here | works |
| `Build-Emulator.ps1 -Platform ...` | builds a pinned static SDL2, then Oricutron against it | **TODO** |
| `Release.ps1` | interactive menu over the above | **TODO** |

`New-Release.ps1` rebuilds the staging folder from empty each time, so a payload contains what this
assembly put there.

**`Publish-Release.ps1` uploads only with `-Live`.** By default it prints the command it would run and
stops without contacting itch.io; `-DryRun` additionally asks butler what it would push. `butler push`
publishes the moment it finishes and a build can only be replaced, not withdrawn, so the default is
inert on purpose.

### Making a release

1. Update `common/` with the tested content for this version.
2. Build the emulator for each platform, into that project's `artifacts/`.
3. Build the launcher for each platform and store:
   `cmake --build build --target BuildAllPlatforms`.
4. `New-Release.ps1` per target.
5. `Publish-Release.ps1 -Live` per target. Steam uploads still go through the SteamPipe GUI, and a
   Steam build has to be set live by hand afterwards, which is a useful brake.


## Itch

Channel names follow the platform, with `_demo` appended for the demo, matching the existing
`windows` and `windows_demo`. Itch reads the platform from the channel name.

`butler push --fix-permissions` marks the Linux and macOS executables, which is what makes a payload
assembled on Windows runnable elsewhere: NTFS carries no executable bit.

Every Itch payload carries a `.itch.toml` naming the launcher as its `play` action, so the itch app
starts the launcher rather than offering a choice between it and the emulator.


## Steam

`steam_appid.txt` holds the AppID and belongs beside the launcher **while debugging**: without it a
Steam build started outside the Steam client cannot tell Steam which application it is,
`SteamAPI_InitEx` fails, and the launcher reports achievements and Cloud saves as disabled. A released
build takes its identity from Steam itself, so assembly leaves the file out.

macOS on Steam needs notarisation, which needs a paid Apple Developer ID at $99/year — Steam requires
all new macOS applications to be 64-bit and notarised. When that is decided, notarising means:

- a Developer ID Application certificate in the Mac's keychain
- signing with the hardened runtime, plus the two entitlements Steamworks asks for so the overlay can
  inject: `com.apple.security.cs.disable-library-validation` and
  `com.apple.security.cs.allow-dyld-environment-variables`
- signing every executable shipped, including the emulator inside the bundle, after `lipo` so the
  universal binary carries the signature
- `xcrun notarytool submit`, then `xcrun stapler staple`

On Apple silicon every binary needs at least an ad-hoc signature to execute at all, which clang
applies at link time; that is why local builds run today.


## Still to do

- **Steam publishing** from `Publish-Release.ps1`; SteamPipe by hand until then.
- **`Build-Emulator.ps1`**, building a pinned static SDL2 and then Oricutron against it. One
  constraint worth knowing before starting: SDL2 fixes its audio backends when *SDL2* is configured,
  from the development headers present then, so the build environment needs `libasound2-dev`,
  `libpulse-dev`, `libpipewire-0.3-dev` and `libjack-jackd2-dev` in place first or the result plays no
  sound anywhere. `strings <binary> | grep -qx pulseaudio` confirms it. Oricutron's `Makefile` takes
  `PLATFORM=` and `SDL_LIB=sdl2` and honours `SDL_CFLAGS`, so a vendored SDL2 can be handed to it
  as is.
- **Windows Oricutron** built from our own pinned commit like the other two. Once a build carrying
  `--title` is in the shipped Windows payload, `ORICUTRON_HAS_TITLE` can be turned on there and the
  `EnumWindows` / `SetWindowText` thread deleted; the gate describes what the deployed emulator
  understands. `--icon` additionally needs an uncompressed square BMP shipped beside the emulator.
- **macOS**: the notarisation decision, and `CMAKE_OSX_ARCHITECTURES "x86_64;arm64"` for a universal
  binary, since Rosetta translates x64 to arm and not the reverse.
- **The game build** depositing disk images and `Version History.txt` where assembly can pick them up,
  so a release does not depend on remembering to copy them into `common/`.
- **A `.desktop` file** in the Linux payload, which is the only way to give the launcher a window icon
  under Wayland.
