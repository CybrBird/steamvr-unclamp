This script disables SteamVR's black clamp and restores removed debug commands.
For more information, refer to guide.md.

unclamp.cmd is the main batch script.
Set-Bytes.ps1 is a small PowerShell script used by unclamp.cmd for modifying files (since batch can't easily read/write binary data).