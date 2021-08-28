Set-StrictMode -Version Latest

Add-Type -AssemblyName System.Drawing

function Add-FrameToImage {
    [CmdletBinding(DefaultParameterSetName="ARGB")]
    param (
        # Specifies a path to one or more locations.
        [Parameter(Mandatory=$true,
                   Position=0,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   HelpMessage="Path to one or more locations."
                   )]
        [Alias("PSPath")]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({Test-Path $_ -PathType 'Leaf'})]
        [string[]]
        $Path,

        # Specifies the line width.
        [Parameter(Mandatory=$false,
                   Position=1,
                   ParameterSetName="ARGB"
                   )]
        [Parameter(Mandatory=$false,
                   Position=1,
                   ParameterSetName="Color"
                   )]
        [Alias()]
        [ValidateScript({$_ -gt 0})]
        [int]
        $LineWidth = 1,

        # Specifies an color by .Net Color struct or color name in [System.Drawing.Color] enums.
        [Parameter(Mandatory=$false,
                   Position=2,
                   ParameterSetName="Color"
                   )]
        [Alias()]
        [System.Drawing.Color]
        $Color = [System.Drawing.Color]::Black,

        # Specifies an ARGB value for Alpha.
        [Parameter(Mandatory=$false,
                   Position=2,
                   ParameterSetName="ARGB"
                   )]
        [Alias()]
        [byte]
        $Alpha = 255,
        
        # Specifies an ARGB value for Red.
        [Parameter(Mandatory=$false,
                   Position=3,
                   ParameterSetName="ARGB"
                   )]
        [Alias()]
        [byte]
        $Red = 0,
        
        # Specifies an ARGB value for Green.
        [Parameter(Mandatory=$false,
                   Position=4,
                   ParameterSetName="ARGB"
                   )]
        [Alias()]
        [byte]
        $Green = 0,

        # Specifies an ARGB value for Blue.
        [Parameter(Mandatory=$false,
                   Position=5,
                   ParameterSetName="ARGB"
                   )]
        [Alias()]
        [byte]
        $Blue = 0,

        # Specifies whether the line will be drawn inside the picture.
        [Parameter(Mandatory=$false,
                   ParameterSetName="ARGB"
                   )]
        [Parameter(Mandatory=$false,
                   ParameterSetName="Color"
                   )]
        [switch]
        $Inner,

        # Specifies the path to a directory to save in.
        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true
                   )]
        [Alias("DirectoryName")]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({Test-Path $_ -PathType 'Container'})]
        [string]
        $Destination,

        # Specifies the name to save as.
        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true
                   )]
        [Alias()]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name
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

            $originalExtension = [System.IO.Path]::GetExtension($convertedPath)
            
            if ($originalExtension.ToLower() -notin $imageExtensions) {
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
            if ($Destination -ne '') {
                [string]$innerDestination = Convert-Path -Path $Destination
            } else {
                [string]$innerDestination = Split-Path $convertedPath -Parent
            }

            Write-Verbose $innerDestination
            
            Write-Verbose $Name

            [string]$originalName = Split-Path $convertedPath -Leaf

            if ($Name -notin @('', $originalName)) {
                [string]$newPath = Join-Path $innerDestination $Name
            } else {
                [string]$baseName = [System.IO.Path]::GetFileNameWithoutExtension($convertedPath)
                [string]$newName = "$($baseName)_A$($innerColor.A)R$($innerColor.R)G$($innerColor.G)B$($innerColor.B)_$($LineWidth)px$($originalExtension)"
                # [string]$newName = "$($baseName)_$(Get-Date -Format 'yyyy-MM-dd_HH-mm-ss')$($originalExtension)"
                [string]$newPath = Join-Path $innerDestination $newName
            }

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