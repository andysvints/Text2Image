<#
.Synopsis
   Convert Text to Image. Automate your screenshots.
.DESCRIPTION
   Convert Text to Image. Redirect your output into variable/file and then convert it to image. With our preset styles easily automate your screenshot capturing routine for your blog, twitter, etc.
   Image formats supported: Png, Bmp, Gif, Jpeg, Tiff.
.EXAMPLE
    PS C:\> t2i -ImageText "`r`nTesting Text2Image Powershell Module`r`n" -ImageStyle PuTTY  -Verbose
    VERBOSE: Performing the operation "New-Image" on target "'
    Testing Text2Image Powershell Module
    '. Using PuTTY style".
#>
function New-Image
{
    [CmdletBinding(SupportsShouldProcess=$true, 
                  PositionalBinding=$false,
                  ConfirmImpact='Medium')]
    [Alias('t2i')]
    Param
    (
        # Text which should be converted to Image
        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=0)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [Alias("Text")] 
        [string]
        $ImageText,

        # Generated Image Style
        [Parameter(ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false)]
        [ValidateNotNull()]
        [ValidateSet("PowerShell","CMD","PuTTY","LinuxTerminal")]
        [Alias("Style")]
        $ImageStyle="PowerShell",

     
        
        # New Image Format
        [Parameter(ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false)]
        [ValidateSet("Png", "Bmp", "Gif", "Jpeg", "Tiff")]
        $ImageFormat="Png",

        # New Image Output Path. Default to Current Lcoation
        [Parameter(ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false)]
        [Alias("path")]
        $OutputPath,

        # New Image Name
        [Parameter(ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false)]
        [Alias("name","ImageName")]
        $NewImageName="NewImage"

    )

    Begin
    {
    }
    Process
    {
        if ($pscmdlet.ShouldProcess("'$($ImageText)'. Using $ImageStyle style"))
        {
            try
              {
                  
                  switch ($ImageStyle)
                  {
                      'PowerShell' {
                        $ImageStyleObjProps=@{
                            FontName="Lucida Console"
                            FontSize=9
                            TextColor=[System.Drawing.Brushes]::White
                            BackgroundColor=[System.Drawing.Color]::FromArgb(1,36,86)
                        }
                        break
                      }
                      'CMD' {
                        $ImageStyleObjProps=@{
                            FontName="Consolas"
                            FontSize=10
                            TextColor=[System.Drawing.Brushes]::LightGray
                            BackgroundColor=[System.Drawing.Color]::FromArgb(12,12,12)
                        }
                        break
                      }
                      'PuTTY' {
                        $ImageStyleObjProps=@{
                            FontName="Courier New"
                            FontSize=10
                            TextColor=[System.Drawing.Brushes]::LightGray
                            BackgroundColor=[System.Drawing.Color]::FromArgb(0,0,0)
                        }
                        break
                      }
                      'LinuxTerminal' {
                        $ImageStyleObjProps=@{
                            FontName="Terminus Font"
                            FontSize=9
                            TextColor=[System.Drawing.Brushes]::White
                            BackgroundColor=[System.Drawing.Color]::FromArgb(0,0,0)
                        }
                        break
                      }
                      Default {}
                  }
                  $ImageStyleObj=New-Object -TypeName psobject -Property $ImageStyleObjProps
                  $Format=[System.Drawing.Imaging.ImageFormat]::$ImageFormat
                  $FontObj=New-Object System.Drawing.Font $ImageStyleObj.FontName,$ImageStyleObj.FontSize
                  $BitmapObj=New-Object System.Drawing.Bitmap 1,1
                  $GraphicsObj=[System.Drawing.Graphics]::FromImage($BitmapObj)
                  $StringSize=$GraphicsObj.MeasureString($ImageText, $FontObj)
                  $BitmapObj=New-Object System.Drawing.Bitmap $([int]$StringSize.Width),$([int]$StringSize.Height)
                  $GraphicsObj=[System.Drawing.Graphics]::FromImage($BitmapObj)

                  $GraphicsObj.CompositingQuality=[System.Drawing.Drawing2D.CompositingQuality]::HighQuality
                  $GraphicsObj.InterpolationMode=[System.Drawing.Drawing2D.InterpolationMode]::HighQualityBilinear
                  $GraphicsObj.PixelOffsetMode=[System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
                  $GraphicsObj.SmoothingMode=[System.Drawing.Drawing2D.SmoothingMode]::HighQuality

                  $GraphicsObj.Clear($ImageStyleObj.BackgroundColor)
                  $GraphicsObj.DrawString($ImageText, $FontObj, $ImageStyleObj.TextColor, 0, 0)

                  $FontObj.Dispose()
                  $GraphicsObj.Flush()
                  $GraphicsObj.Dispose()
                  
                  if($OutputPath -eq $null){
                    $OutputPath=Get-Location
                    $OutputPath=$OutputPath.Path.Replace("\","\\")+"\\"
                  }else{
                    $OutputPath=$OutputPath.Replace("\","\\")+"\\"
                  }
                  
                  $ImageFileName="$OutputPath"+"$NewImageName.$($ImageFormat.ToLower())"
                  
                  $BitmapObj.Save("$ImageFileName", $ImageFormat);


              }
              catch 
              {
                Write-Verbose "Failed -  please review exception message for more details"
                Write-Output ("Catched Exception: - $($_.exception.message)")
              }
              
              
        }
    }
    End
    {
    }
}