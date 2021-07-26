Set-StrictMode -Version Latest

Add-Type -AssemblyName System.Drawing

function Add-FrameToImage {
    [CmdletBinding(DefaultParameterSetName="ARGB")]
    param (
        # Specifies a path to one or more locations.
        [Parameter(Mandatory=$true,
                   Position=0,
                   ParameterSetName="ARGB",
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   HelpMessage="Path to one or more locations."
                   )]
        [Parameter(Mandatory=$true,
                   Position=0,
                   ParameterSetName="Color",
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   HelpMessage="Path to one or more locations."
                   )]
        [Alias("PSPath")]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({Test-Path $_ -PathType 'Leaf'})]
        [string[]]
        $Path,

        [Parameter(Mandatory=$false,
                   Position=1,
                   ParameterSetName="ARGB",
                   HelpMessage="ARGB value for Alpha."
                   )]
        [Alias()]
        [byte]
        $Alpha = 255,
        
        [Parameter(Mandatory=$false,
                   Position=2,
                   ParameterSetName="ARGB",
                   HelpMessage="ARGB value for Red."
                   )]
        [Alias()]
        [byte]
        $Red = 0,
        
        [Parameter(Mandatory=$false,
                   Position=3,
                   ParameterSetName="ARGB",
                   HelpMessage="ARGB value for Green."
                   )]
        [Alias()]
        [byte]
        $Green = 0,

        [Parameter(Mandatory=$false,
                   Position=4,
                   ParameterSetName="ARGB",
                   HelpMessage="ARGB value for Blue."
                   )]
        [Alias()]
        [byte]
        $Blue = 0,

        [Parameter(Mandatory=$false,
                   Position=1,
                   ParameterSetName="Color",
                   HelpMessage="Color struct or color name in <color> enums."
                   )]
        [Alias()]
        [System.Drawing.Color]
        $Color,

        [Parameter(Mandatory=$false,
                   Position=5,
                   ParameterSetName="ARGB",
                   HelpMessage="Width of line."
                   )]
        [Parameter(Mandatory=$false,
                   Position=2,
                   ParameterSetName="Color",
                   HelpMessage="Width of line."
                   )]
        [Alias()]
        [ValidateScript({$_ -gt 0})]
        [int]
        $LineWidth = 1,

        [Parameter(Mandatory=$false,
                   ParameterSetName="ARGB",
                   HelpMessage="Indicates that the line will be drawn inside the picture."
                   )]
        [Parameter(Mandatory=$false,
                   ParameterSetName="Color",
                   HelpMessage="Indicates that the line will be drawn inside the picture."
                   )]
        [switch]
        $Inner,

        [Parameter(Mandatory=$false,
                   # Position=1,
                   # ParameterSetName="",
                   # ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   HelpMessage="Path to a directory to save in."
                   )]
        [Alias("DirectoryName")]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({Test-Path $_ -PathType 'Container'})]
        [string]
        $Destination
    )
    
    begin {
        #creating pen object
        switch ($PSCmdlet.ParameterSetName) {
            "ARGB" {
                $innerColor = [System.Drawing.Color]::FromArgb($Alpha, $Red, $Green, $Blue)
            }
            "Color" {
                $innerColor = $Color
            }
        }

        $pen = [System.Drawing.Pen]::new($innerColor, $LineWidth)
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
            if ($Destination -eq '') {
                $innerDestination = Split-Path $convertedPath -Parent
            } else {
                $innerDestination = $Destination
            }

            $baseName = [System.IO.Path]::GetFileNameWithoutExtension($convertedPath)
            $originalExtension = [System.IO.Path]::GetExtension($convertedPath)
            $newBaseName = "$($baseName)_A$($innerColor.A)R$($innerColor.R)G$($innerColor.G)B$($innerColor.B)_$($LineWidth)px"
            $newPath = Join-Path $innerDestination "$($newBaseName)$($originalExtension)"

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