# Text2Image
Convert Text to Image. Redirect your output into variable/file and then convert it to image. With our preset styles easily automate your screenshot capturing routine for your blog, twitter, etc.Image formats supported: Png, Bmp, Gif, Jpeg, Tiff.

## Install Module
Copy and Paste the following command to install this package using PowerShellGet
```powershell
Install-Module -Name Text2Image 
```
## Cmdlets
```powershell
New-Image
```

## Dependencies
This module has no dependencies.

## EXAMPLE
```powershell
PS C:\> t2i -ImageText "`r`nTesting Text2Image Powershell Module`r`n" -ImageStyle PuTTY -Verbose
		VERBOSE: Performing the operation "New-Image" on target "'Testing Text2Image Powershell Module'. Using PuTTY style". 
```