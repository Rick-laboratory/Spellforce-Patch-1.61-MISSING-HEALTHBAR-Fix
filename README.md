# SpellForce 1.61 — Missing Health Bar Hex Patch

A historical patch for the missing health bar problem in **SpellForce Platinum Edition 1.61**. It was created by editing the game binary directly in a hex editor. This repository preserves the resulting executable and its bundled Direct3D wrapper.

**Format:** binary hex patch · **Platform:** Windows · **Game executable:** x86 (32-bit)

## What is included

| File | Architecture | Size | Embedded DLL description |
| --- | --- | ---: | --- |
| [SpellForce V1.61.exe](<Spellforce Platinum Edition/SpellForce V1.61.exe>) | x86 | 10,449,920 bytes | — |
| [Windows/SysWOW64/V3D9.dll](Windows/SysWOW64/V3D9.dll) | x86 | 408,576 bytes | dgVoodoo 2.74 — Direct3D9 |
| [Windows/System32/V3D9.dll](Windows/System32/V3D9.dll) | x64 | 475,136 bytes | dgVoodoo 2.74 — Direct3D9 |

Both DLLs report file version `4.9.0.904`. The executable has no embedded file version; **1.61 is the original package label**, not a version detected from its resources.

The executable imports `V3D9.dll`. This is observable in its PE import table. The original unmodified executable and a byte-offset change log are not included, so the complete set of hex edits cannot be reconstructed from this archive alone. There is no separate source project or compilation step.

## Package layout and use

This package requires an existing game installation matching the intended 1.61 build. The executable also imports other game DLLs, which are not part of this patch.

1. Close the game and keep a copy of the original executable and any DLL you intend to replace.
2. Verify the downloaded files using the command below.
3. The original layout places the patched executable in the game's installation directory. Its `Windows` folders record the original system-wide DLL destinations: `SysWOW64` for the x86 DLL and `System32` for the x64 DLL on **64-bit Windows**.
4. Keep the architecture distinction intact. The 32-bit game needs the **x86** wrapper; the x64 DLL cannot be loaded by that executable.
5. To undo a manual installation, restore the backed-up files and remove only files that you added.

The directory names follow [Windows' architecture-specific system folders](https://learn.microsoft.com/en-us/windows/win32/winprog64/file-system-redirector). They are preserved here as historical packaging, not as an automated installer.

Windows normally searches an application's directory before its system directory. Placing the **x86** `V3D9.dll` beside the patched executable may therefore allow an installation confined to the game directory. This is an inference from the [documented DLL search order](https://learn.microsoft.com/en-us/windows/win32/dlls/dynamic-link-library-search-order), **not a game-tested procedure for this package**.

## Verify the files

From the extracted repository in PowerShell:

```powershell
powershell -NoProfile -File .\Verify-Package.ps1
```

[Verify-Package.ps1](Verify-Package.ps1) compares each binary against [SHA256SUMS](SHA256SUMS) and fails on missing or changed files. It only reads files; it does not execute the game, load the DLLs, or install anything.

The hashes identify the preserved repository files. They do not establish compatibility or reproduce the original patching process.

## Status and related version

The documentation refresh checked file sizes, PE architectures, embedded DLL metadata, imports, and SHA-256 hashes. **The game and health bar fix were not run or retested.** The original binaries are unchanged.

The separate [GOG / 1.54 patch](https://github.com/Rick-laboratory/gog-spellforce-Missing-HEALTHBAR-fix) targets another package version. Keep the two packages separate.

The DLL resources identify [dgVoodoo 2 by Dege](https://github.com/dege-diosg/dgVoodoo2). Game and wrapper components retain their respective ownership; this archive does not add a new license to those binaries.
