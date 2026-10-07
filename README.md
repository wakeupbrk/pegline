# Pegline

Screenshots, and any file you drop, hung on a line.

Pegline is a modified copy of [Tendedero](https://github.com/alejandrobujan/tendedero) by Alejandro Buján. The code there is MIT. This copy has its own name and icon.

<p align="center">
  Free and open source. For macOS 14 and later.
  <br>
  <a href="../../releases/latest">Download&nbsp;&rsaquo;</a>
  &nbsp;&nbsp;
  <a href="#build-from-source">Build from source&nbsp;&rsaquo;</a>
</p>

<br>

## Out of sight. Within reach.

Every screenshot you take hangs on a line just above your screen.
Rest the pointer in the menu bar and it glides down. Move away and it's gone.
Drag any file to the menu bar and a temporary copy hangs there too. The original stays where it was.

<br>
<br>

## A gesture for everything.

<br>
<br>

| | |
|:--|:--|
| Click | Copy the image. |
| Press and hold | Open it in Markup. |
| Double click | Open it in Preview. |
| Drag into an app | Send a copy. It stays on the line. |
| Drag into a folder | Keep it there. It leaves the line. |
| Drag to the Trash, or click the cross | Let it go. |
| Rest the pointer in the menu bar | Bring the line down on that screen. |
| Click anything in the menu bar | Put it away. |
| <kbd>⌃</kbd>&thinsp;<kbd>⌥</kbd>&thinsp;<kbd>T</kbd> | Show or hide the line. |
| Drag a file onto the menu bar | Hang a temporary copy. The original stays put. |

<br>

## Your Desktop. Finally clear.

Hand Pegline your screenshots<sup>1</sup> and they skip the Desktop
entirely. No floating thumbnail. No five-second wait. Each capture hangs
the instant you take it, and only what you drag out is kept.

Same shortcuts. Same muscle memory. Just less mess.

<br>

## Private by design.

No account. No network. No analytics.
Pegline runs entirely on your Mac, and your screenshots never leave it.

<br>

## Tech Specs

| | |
|:--|:--|
| **Compatibility** | macOS 14 Sonoma or later, on Apple silicon and Intel. Designed for macOS 27. |
| **Size** | 1.7 MB |
| **Languages** | English, Spanish |
| **Built with** | Swift, AppKit and SwiftUI |
| **Network access** | None |
| **Price** | Free |
| **License** | MIT for the code, from Tendedero. Pegline's name and icon are its own. |

<br>

## Install

Download the disk image from the [latest release](../../releases/latest),
open it and drag Pegline to Applications.

Pegline is not notarized by Apple yet, so the first time macOS will say it
cannot verify it. Open System Settings, go to Privacy & Security, and click
Open Anyway next to the message about Pegline. You only need to do this once.

<br>

## Build from source

```sh
git clone git@github.com:wakeupbrk/pegline.git
cd pegline
scripts/build-app.sh
open build/Pegline.app
```

Requires the Swift toolchain. Xcode is optional. With the Command Line Tools for macOS 27, the script falls back to the macOS 26 SDK they install alongside, because the new SDK needs a SwiftUI macro plugin only Xcode includes. Local builds are signed ad hoc,
so macOS asks again for access to the Desktop after each rebuild.

<details>
<summary>Inside the app</summary>
<br>

| File | Role |
|:--|:--|
| `AppDelegate.swift` | Menu bar, shortcut, revealing and tucking away the line |
| `LinePanel.swift` | The transparent strip along the top of the screen |
| `LineView.swift` | The line and where each photo hangs |
| `PeggedView.swift` | One photo: glass frame, clip, swing and breeze |
| `GrabArea.swift` | Click, long press, drag and drop |
| `Clips.swift` | Temporary copies of files dropped on the line |
| `DropCatcher.swift` | Accepts a file dropped from Finder |
| `ScreenshotWatcher.swift` | Notices new screenshots |
| `Inbox.swift` | Takes over screenshot settings and puts them back |
| `Markup.swift` | Opens the system Markup editor and saves the result |
| `FullScreen.swift` | Knows when to stay hidden |
| `Line.swift` | What is hanging, and what you can do with it |

Every image here, the icon included, is drawn in code by
`scripts/make-icon.swift` and `scripts/make-readme-art.swift`.
`scripts/make-dmg.sh` builds the disk image for releases.

</details>

<br>

---

<sub>
1. On first launch, Pegline offers to handle your screenshots. If you accept, it turns off the floating thumbnail and saves new screenshots to its own folder, two settings also found under Options in Cmd+Shift+5. Your previous settings are saved and restored when Pegline quits or the option is turned off from the menu bar. Pegline hides automatically while an app is in full screen.
</sub>

<br>
<br>

<p align="center">
  <sub>Code MIT, from Tendedero by <a href="https://alejandrobujan.com">Alejandro Buján</a>. The Tendedero name and icon stay his. See <a href="LICENSE">LICENSE</a>.</sub>
</p>
