Set-StrictMode -Version Latest

Add-Type -AssemblyName System.Drawing

function Add-FrameToImage {
    [CmdletBinding()]
    param (
        # Specifies a path to one or more locations.
        [Parameter(Mandatory=$true,
                   Position=0,
                   ParameterSetName="Path",
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   HelpMessage="Path to one or more locations.")]
        [Alias("PSPath")]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({Test-Path $_ -PathType 'Leaf'})]
        [string[]]
        $Path,

        [ValidateRange(1,[int]::MaxValue)]
        [int]
        $LineWidth = 1,

        [byte]
        $Alpha = 255,
        
        [byte]
        $Red = 0,
        
        [byte]
        $Green = 0,

        [byte]
        $Blue = 0,

        [switch]
        $Inner
    )
    
    begin {
        #creating pen object
        $color = [System.Drawing.Color]::FromArgb($Alpha, $Red, $Green, $Blue)
        $pen = [System.Drawing.Pen]::new($color, $LineWidth)
        $pen.Alignment = [System.Drawing.Drawing2D.PenAlignment]::Inset
        $imageExtensions = @(".gif", ".ico", ".jpeg", ".jpg", ".jpe", ".png")
    }
    
    process {
        foreach ($p in $Path) {
            
            $convertedPath = Convert-Path $p
            Write-Verbose $convertedPath

            $targetExtension = [System.IO.Path]::GetExtension($convertedPath)
            
            if ($targetExtension.ToLower() -notin $imageExtensions) {
                continue
            }

            #creating image object
            
            if ($Inner) {
                $bitmap = [System.drawing.Bitmap]::new($convertedPath)
                $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
            } else {
                $bitmapBeforeExpanding = [System.drawing.Bitmap]::new($convertedPath)
                $bitmap = [System.drawing.Bitmap]::new($bitmapBeforeExpanding.Width + $LineWidth * 2, $bitmapBeforeExpanding.Height + $LineWidth * 2)
                $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
                $graphics.DrawImage($bitmapBeforeExpanding, $LineWidth, $LineWidth, $bitmapBeforeExpanding.Width, $bitmapBeforeExpanding.Height)
            }

            #creating rectangle object
            $rectangle = [System.Drawing.Rectangle]::new(0, 0, $bitmap.Width - 1, $bitmap.Height - 1)

            # drawing frame on image
            $graphics.DrawRectangle($pen, $rectangle)
            $graphics.Dispose()

            # saving image
            $baseName = [System.IO.Path]::GetFileNameWithoutExtension($convertedPath)
            $newPath = $convertedPath -replace $baseName, "$($baseName)_A$($Alpha)R$($Red)G$($Green)B$($Blue)_$($LineWidth)px"

            Write-Verbose $newPath

            $bitmap.Save($newPath)
            $bitmap.Dispose()

            Get-Item -Path $newPath
        }
    }
    
    end {
        $pen.Dispose()
    }
}

Set-Alias -Name addfr -Value Add-FrameToImage

Export-ModuleMember -Function * -Alias *