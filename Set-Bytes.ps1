# Modifies bytes in the specified file.
# $Length indicates the number of bytes, starting from $Offset, to be set to $Value.
# Returns the original value of the first byte modified, or -1 if an error occurs.
param (
	[Parameter(Mandatory)] [string]$FileName,
	[Parameter(Mandatory)] [UInt64]$Offset,
	[Parameter(Mandatory)] [byte]$Value,
	[UInt64]$Length = 1
)
if (($Length -gt 0) -and (Test-Path -Path $FileName) -and (($Offset + $Length - 1) -lt (Get-Item $FileName).Length)) {
	$mmf = [System.IO.MemoryMappedFiles.MemoryMappedFile]::CreateFromFile($FileName)
	$accessor = $mmf.CreateViewAccessor($Offset, $Length)
	[byte]$original = $accessor.ReadByte(0)
	for ($i = 0; $i -lt $Length; $i++) {
		$accessor.Write($i, $Value)
	}
	$accessor.Dispose()
	$mmf.Dispose()
	return $original
}
return -1