@echo off
setlocal
if not exist "Set-Bytes.ps1" (
	echo Set-Bytes.ps1 is missing
	exit /b 1
)

rem default SteamVR path
set "def_vr=%ProgramFiles(x86)%\Steam\steamapps\common\SteamVR"

rem SteamVR path
set "vr="

rem file to modify
set "filename=vrcompositor.exe"
set "file=bin\win64\%filename%"

rem check default path
if exist "%def_vr%\%file%" (
	echo SteamVR installation found at "%def_vr%"
	echo Would you like to use this installation?
	choice
	if not errorlevel 2 (
		set "vr=%def_vr%"
	)
)

rem loop until we have a valid path
:needvr
if defined vr goto havevr
set /p "vr=SteamVR path:"
set "vr=%vr:"=%"
:havevr
if not exist "%vr%\%file%" echo invalid path& set "vr=" & goto needvr

rem flags for which methods should be applied
set "method1="
set "method2="

echo Which method(s) would you like to use?
echo 1 - Forcibly disable the black clamp
echo 2 - Restore removed debug commands
echo B - Both
choice /c 12B

if not errorlevel 2 (
	set "method1=1"
) else (
	if not errorlevel 3 (
		set "method2=1"
	) else (
		set "method1=1"
		set "method2=1"
	)
)

rem prompt user for offset(s)
set "offset1="
set "offset2="
if defined method1 (
	set /p "offset1=Method 1 Offset:"
)
if defined method2 (
	set /p "offset2=Method 2 Offset:"
)

echo creating backup of %filename%...
copy /v /y "%vr%\%file%" "%vr%\%file%.bak"

rem apply methods
if defined offset1 (
	echo applying method 1...
	call PowerShell -NoProfile -ExecutionPolicy Bypass -File Set-Bytes.ps1 -FileName "%vr%\%file%" -Offset 0x%offset1% -Value 0xEB -Length 1
)
if defined offset2 (
	echo applying method 2...
	call PowerShell -NoProfile -ExecutionPolicy Bypass -File Set-Bytes.ps1 -FileName "%vr%\%file%" -Offset 0x%offset2% -Value 0x90 -Length 6
)

echo finished
pause
exit /b 0