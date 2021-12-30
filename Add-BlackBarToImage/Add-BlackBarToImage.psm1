Set-StrictMode -Version Latest

Add-Type -AssemblyName System.Drawing

function Add-BlackBarToImage {
    [CmdletBinding(DefaultParameterSetName="CornerArgb")]
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

        # Specifies an x coordinate of top left corner.
        [Parameter(Mandatory=$true,
                   Position=1,
                   ParameterSetName="CornerArgb",
                   HelpMessage="X coordinate of top left corner."
                   )]
        [Parameter(Mandatory=$true,
                   Position=1,
                   ParameterSetName="CornerColor",
                   HelpMessage="X coordinate of top left corner."
                   )]
        [Parameter(Mandatory=$true,
                   Position=1,
                   ParameterSetName="CornerUseBackgroundColor",
                   HelpMessage="X coordinate of top left corner."
                   )]
        [Alias("Left")]
        [int]
        $TopLeftX,
        
        # Specifies a y coordinate of top left corner.
        [Parameter(Mandatory=$true,
                   Position=2,
                   ParameterSetName="CornerArgb",
                   HelpMessage="Y coordinate of top left corner."
                   )]
        [Parameter(Mandatory=$true,
                   Position=2,
                   ParameterSetName="CornerColor",
                   HelpMessage="Y coordinate of top left corner."
                   )]
        [Parameter(Mandatory=$true,
                   Position=2,
                   ParameterSetName="CornerUseBackgroundColor",
                   HelpMessage="Y coordinate of top left corner."
                   )]
        [Alias("Top")]
        [int]
        $TopLeftY,
        
        # Specifies an x coordinate of bottom right corner.
        [Parameter(Mandatory=$true,
                   Position=3,
                   ParameterSetName="CornerArgb",
                   HelpMessage="X coordinate of bottom right corner."
                   )]
        [Parameter(Mandatory=$true,
                   Position=3,
                   ParameterSetName="CornerColor",
                   HelpMessage="X coordinate of bottom right corner."
                   )]
        [Parameter(Mandatory=$true,
                   Position=3,
                   ParameterSetName="CornerUseBackgroundColor",
                   HelpMessage="X coordinate of bottom right corner."
                   )]
        [Alias("Right")]
        [int]
        $BottomRightX,
        
        # Specifies a y coordinate of bottom right corner.
        [Parameter(Mandatory=$true,
                   Position=4,
                   ParameterSetName="CornerArgb",
                   HelpMessage="Y coordinate of bottom right corner."
                   )]
        [Parameter(Mandatory=$true,
                   Position=4,
                   ParameterSetName="CornerColor",
                   HelpMessage="Y coordinate of bottom right corner."
                   )]
        [Parameter(Mandatory=$true,
                   Position=4,
                   ParameterSetName="CornerUseBackgroundColor",
                   HelpMessage="Y coordinate of bottom right corner."
                   )]
        [Alias("Bottom")]
        [int]
        $BottomRightY,

        # Specifies the x-coordinate of the upper-left corner of the rectangle.
        [Parameter(Mandatory=$true,
                   Position=1,
                   ParameterSetName="CoordinateArgb",
                   HelpMessage="The X coordinate of the upper-left corner of the rectangle."
                   )]
        [Parameter(Mandatory=$true,
                   Position=1,
                   ParameterSetName="CoordinateColor",
                   HelpMessage="The X coordinate of the upper-left corner of the rectangle."
                   )]
        [Parameter(Mandatory=$true,
                   Position=1,
                   ParameterSetName="CoordinateUseBackgroundColor",
                   HelpMessage="The X coordinate of the upper-left corner of the rectangle."
                   )]
        [Alias()]
        [int]
        $X,

        # Specifies the y-coordinate of the upper-left corner of the rectangle.
        [Parameter(Mandatory=$true,
                   Position=2,
                   ParameterSetName="CoordinateArgb",
                   HelpMessage="The Y coordinate of the upper-left corner of the rectangle."
                   )]
        [Parameter(Mandatory=$true,
                   Position=2,
                   ParameterSetName="CoordinateColor",
                   HelpMessage="The Y coordinate of the upper-left corner of the rectangle."
                   )]
        [Parameter(Mandatory=$true,
                   Position=2,
                   ParameterSetName="CoordinateUseBackgroundColor",
                   HelpMessage="The Y coordinate of the upper-left corner of the rectangle."
                   )]
        [Alias()]
        [int]
        $Y,

        # Specifies the width of the rectangle.
        [Parameter(Mandatory=$true,
                   Position=3,
                   ParameterSetName="CoordinateArgb",
                   HelpMessage="The width of the rectangle."
                   )]
        [Parameter(Mandatory=$true,
                   Position=3,
                   ParameterSetName="CoordinateColor",
                   HelpMessage="The width of the rectangle."
                   )]
        [Parameter(Mandatory=$true,
                   Position=3,
                   ParameterSetName="CoordinateUseBackgroundColor",
                   HelpMessage="The width of the rectangle."
                   )]
        [Alias()]
        [int]
        $Width,

        # Specifies the height of the rectangle.
        [Parameter(Mandatory=$true,
                   Position=4,
                   ParameterSetName="CoordinateArgb",
                   HelpMessage="The height of the rectangle."
                   )]
        [Parameter(Mandatory=$true,
                   Position=4,
                   ParameterSetName="CoordinateColor",
                   HelpMessage="The height of the rectangle."
                   )]
        [Parameter(Mandatory=$true,
                   Position=4,
                   ParameterSetName="CoordinateUseBackgroundColor",
                   HelpMessage="The height of the rectangle."
                   )]
        [Alias()]
        [int]
        $Height,

        # Specifies the System.Drawing.Rectangle object.
        [Parameter(Mandatory=$true,
                   Position=1,
                   ParameterSetName="RectangleArgb",
                   ValueFromPipelineByPropertyName=$true,
                   HelpMessage="The System.Drawing.Rectangle object."
                   )]
        [Parameter(Mandatory=$true,
                   Position=1,
                   ParameterSetName="RectangleColor",
                   ValueFromPipelineByPropertyName=$true,
                   HelpMessage="The System.Drawing.Rectangle object."
                   )]
        [Parameter(Mandatory=$true,
                   Position=1,
                   ParameterSetName="RectangleUseBackgroundColor",
                   ValueFromPipelineByPropertyName=$true,
                   HelpMessage="The System.Drawing.Rectangle object."
                   )]
        [Alias()]
        [System.Drawing.Rectangle]
        $Rectangle,

        # Specifies an color by .Net Color struct or color name in [System.Drawing.Color] enums.
        [Parameter(ParameterSetName="CornerColor",
                   ValueFromPipelineByPropertyName=$true,
                   Position=5
                   )]
        [Parameter(ParameterSetName="CoordinateColor",
                   ValueFromPipelineByPropertyName=$true,
                   Position=5
                   )]
        [System.Drawing.Color]
        $Color = [System.Drawing.Color]::Black,

        # Specifies an ARGB value for Alpha.
        [Parameter(ParameterSetName="CornerArgb",
                   ValueFromPipelineByPropertyName=$true,
                   Position=5
                   )]
        [Parameter(ParameterSetName="CoordinateArgb",
                   Position=5
                   )]
        [byte]
        $Alpha = 255,
        
        # Specifies an ARGB value for Red.
        [Parameter(ParameterSetName="CornerArgb",
                   Position=6
                   )]
        [Parameter(ParameterSetName="CoordinateArgb",
                   Position=6
                   )]
        [byte]
        $Red = 0,
        
        # Specifies an ARGB value for Green.
        [Parameter(ParameterSetName="CornerArgb",
                   Position=7
                   )]
        [Parameter(ParameterSetName="CoordinateArgb",
                   Position=7
                   )]
        [byte]
        $Green = 0,
        
        # Specifies an ARGB value for Blue.
        [Parameter(ParameterSetName="CornerArgb",
                   Position=8
                   )]
        [Parameter(ParameterSetName="CoordinateArgb",
                   Position=8
                   )]
        [byte]
        $Blue = 0,

        # Specifies an ARGB value for Blue.
        [Parameter(ParameterSetName="CornerUseBackgroundColor"
                   )]
        [Parameter(ParameterSetName="CoordinateUseBackgroundColor"
                   )]
        [Parameter(ParameterSetName="RectangleUseBackgroundColor"
                   )]
        [switch]
        $UseBackgroundColor,

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
        $imageExtensions = @(".gif", ".ico", ".jpeg", ".jpg", ".jpe", ".png")

        # creating brush object
        
        switch -Regex -CaseSensitive ($PSCmdlet.ParameterSetName) {
            "Argb" {
                $colorForBrush = [System.Drawing.Color]::FromArgb($Alpha, $Red, $Green, $Blue)
            }
            "Color" {
                $colorForBrush = $Color
            }
        }

        $brush = [System.Drawing.SolidBrush]::new($colorForBrush)
    }
    
    process {
        foreach ($p in $Path) {
            
            $convertedPath = Convert-Path $p
            Write-Verbose $convertedPath

            $originalExtension = [System.IO.Path]::GetExtension($convertedPath)
            if ($originalExtension.ToLower() -notin $imageExtensions) {
                continue
            }

            # creating image object
            $bitmap = [System.Drawing.Bitmap]::new($convertedPath)
            $graphics = [System.Drawing.Graphics]::FromImage($bitmap)

            # creating rectangle object
            switch -Regex -CaseSensitive ($PSCmdlet.ParameterSetName) {
                "Corner" {
                    $blackBarWidth = $BottomRightX - $TopLeftX
                    $blackBarHeight = $BottomRightY - $TopLeftY
                    $rectangleToFill = [System.Drawing.Rectangle]::new($TopLeftX, $TopLeftY, $blackBarWidth, $blackBarHeight)
                }
                "Coordinate" {
                    $rectangleToFill = [System.Drawing.Rectangle]::new($X, $Y, $Width, $Height)
                }
                "Rectangle" {
                    $rectangleToFill = $Rectangle
                }
            }
            
            if ($PSCmdlet.ParameterSetName -match "UseBackgroundColor") {
                $colorForBrush = $bitmap.GetPixel($rectangleToFill.X, $rectangleToFill.Y)
                $brush = [System.Drawing.SolidBrush]::new($colorForBrush)
            }
            
            $graphics.FillRectangle($brush, $rectangleToFill)
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
                [string]$newName = "$($baseName)_A$($colorForBrush.A)R$($colorForBrush.R)G$($colorForBrush.G)B$($colorForBrush.B)_X$($rectangleToFill.X)Y$($rectangleToFill.Y)W$($rectangleToFill.Width)H$($rectangleToFill.Height)$($originalExtension)"
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
        $brush.Dispose()
    }
}

Set-Alias -Name addbb -Value Add-BlackBarToImage

Export-ModuleMember -Function * -Alias *