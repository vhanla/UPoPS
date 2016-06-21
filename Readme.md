UPlay's Prince of Persia - The Sands of Time Settings Utility
=============================================================

![Snapshot]
(https://github.com/vhanla/UPoPS/raw/master/snapshot.png?raw=true "Snapshot")

Overview
--------
This is a tool specially crafted to be used with the
Ubisoft Prince of Persia The Sands of Time released as part
of its 30th anniversary giveaway. Yaay!

Since this old game doesn't support widescreen monitors and doesn't offer
changing language within its UI options itself either. I wrote this small
tool to make it easier to make some unofficial adjustments.

It requires patching POP.exe file to achieve a widescreen monitor support
and on tweak to Hardware.ini file.


How to use
----------
Download the latest release from the [Releases](https://github.com/vhanla/UPoPS/releases) section.

It is recommended to extract the executable inside the Ubisoft's Prince of Persia The Sands of Time path, next ot POP.EXE file, so it will detect it as soon as it is launched, otherwise you will have to search it manually.

The utility is self explanatory.

There are three options:

- **Patch for Widescreen monitors**, it is a patch that overwrites 4 bytes in the original POP.EXE file regarding to the main game resolution which by default is 640x480. After the patch is applied, you will be able to see your monitor (custom resolution) in the game's video option if it is supported.
- **Language chooser**, this option will replace the current language files with the specific ones for the available optional language files inside Support directory.
- **Extra options**, first option allows you to rename 4 video files inside Video directory, so it will launch the game faster. The other options are tweaks that need to lock Hardware.ini file so the game won't restore the chosen options, and one of it fixes the game UI if widescreen patch has been applied.
- **Launch game button**, you can start the game from this tool too.

Setting custom Windows 10 Tile
------------------------------
Appart from UPoPS.exe file there are some other files in that archive (UPoPS.VisualElementsManifest.xml and Assets folder) which you might want to extract along with the UPoPS.exe file.

By right clicking the UPoPS.exe file and selecting to Pin in Start, the game tile will have a picture contained in Assets folder.

Notice: if pinning fails, you might try opening the following directory in File Explorer : %APPDATA%\Microsoft\Windows\Start Menu\Programs 
there you can find listed the UPoPS.exe shortcut, if it is not there (or if it is there and start menu doesn't show its tile, delete its shortcut), then try by right-click dragging the UPoPS.exe to this location, and create a shortcut manually. Otherwise, you can opt out those extra .xml and logos.  

Contribution
------------
It compiles with Lazarus FreePascal, if you know pascal language, you can help to make this tool better.


Changelog:
----------
- 06-21-2016

 - First version, ported from Delphi to Lazarus, so if you don't have Delphi you can compile it with this awesome Open Source Freepascal IDE

- 06-19-2016

 - First working version written in Delphi



Author & Contributors
----------------------
[Victor Alberto Gil](http://profiles.google.com/vhanla) - Hope you like my work.

Special thanks to Universal Widescreen Patcher and PCGamingWiki tips.

UPlay and Ubisoft are trademarks registered to its respective owners. There is no affiliation of any kind with the author of this tool.


The MIT License (MIT)

Copyright (c) 2016 vhanla

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
