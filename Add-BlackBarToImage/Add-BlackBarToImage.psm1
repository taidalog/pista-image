Set-StrictMode -Version Latest

Add-Type -AssemblyName System.Drawing

function Add-BlackBarToImage {
    [CmdletBinding(DefaultParameterSetName="PointsByInt32")]
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
                   ParameterSetName="PointsByInt32",
                   HelpMessage="X coordinate of top left corner."
                   )]
        [Alias("Left")]
        [int]
        $X1,
        
        # Specifies a y coordinate of top left corner.
        [Parameter(Mandatory=$true,
                   Position=2,
                   ParameterSetName="PointsByInt32",
                   HelpMessage="Y coordinate of top left corner."
                   )]
        [Alias("Top")]
        [int]
        $Y1,
        
        # Specifies an x coordinate of bottom right corner.
        [Parameter(Mandatory=$true,
                   Position=3,
                   ParameterSetName="PointsByInt32",
                   HelpMessage="X coordinate of bottom right corner."
                   )]
        [Alias("Right")]
        [int]
        $X2,
        
        # Specifies a y coordinate of bottom right corner.
        [Parameter(Mandatory=$true,
                   Position=4,
                   ParameterSetName="PointsByInt32",
                   HelpMessage="Y coordinate of bottom right corner."
                   )]
        [Alias("Bottom")]
        [int]
        $Y2,

        # Specifies a top left point.
        [Parameter(Mandatory=$true,
                   Position=1,
                   ParameterSetName="Points",
                   HelpMessage="Top left point."
                   )]
        [Alias()]
        [System.Drawing.Point]
        $Point1,

        # Specifies a right bottom point.
        [Parameter(Mandatory=$true,
                   Position=2,
                   ParameterSetName="Points",
                   HelpMessage="Right bottom point."
                   )]
        [Alias()]
        [System.Drawing.Point]
        $Point2,

        # Specifies the x-coordinate of the upper-left corner of the rectangle.
        [Parameter(Mandatory=$true,
                   Position=1,
                   ParameterSetName="RectangleByInt32",
                   HelpMessage="The X coordinate of the upper-left corner of the rectangle."
                   )]
        [Alias()]
        [int]
        $X,

        # Specifies the y-coordinate of the upper-left corner of the rectangle.
        [Parameter(Mandatory=$true,
                   Position=2,
                   ParameterSetName="RectangleByInt32",
                   HelpMessage="The Y coordinate of the upper-left corner of the rectangle."
                   )]
        [Alias()]
        [int]
        $Y,

        # Specifies the width of the rectangle.
        [Parameter(Mandatory=$true,
                   Position=3,
                   ParameterSetName="RectangleByInt32",
                   HelpMessage="The width of the rectangle."
                   )]
        [Alias()]
        [int]
        $Width,

        # Specifies the height of the rectangle.
        [Parameter(Mandatory=$true,
                   Position=4,
                   ParameterSetName="RectangleByInt32",
                   HelpMessage="The height of the rectangle."
                   )]
        [Alias()]
        [int]
        $Height,

        # Specifies the System.Drawing.Rectangle object.
        [Parameter(Mandatory=$true,
                   Position=1,
                   ParameterSetName="Rectangle",
                   ValueFromPipelineByPropertyName=$true,
                   HelpMessage="The System.Drawing.Rectangle object."
                   )]
        [Alias()]
        [System.Drawing.Rectangle]
        $Rectangle,

        # Specifies an color by .Net Color struct or color name in [System.Drawing.Color] enums.
        [Parameter(ValueFromPipelineByPropertyName=$true
                   )]
        [System.Drawing.Color]
        $Color = [System.Drawing.Color]::Black,

        # Specifies an ARGB value for Blue.
        [Parameter()]
        [switch]
        $UseBackgroundColor,

        # Specifies the path to a directory to save in.
        [Parameter(ValueFromPipelineByPropertyName=$true
                   )]
        [Alias("DirectoryName")]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({Test-Path $_ -PathType 'Container'})]
        [string]
        $Destination,

        # Specifies the name to save as.
        [Parameter(ValueFromPipelineByPropertyName=$true
                   )]
        [Alias()]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name
    )
    
    begin {
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

            # creating image object
            $bitmap = [System.Drawing.Bitmap]::new($convertedPath)
            $graphics = [System.Drawing.Graphics]::FromImage($bitmap)

            # creating rectangle object
            switch ($PSCmdlet.ParameterSetName) {
                "PointsByInt32" {
                    $rectangleToFill = [System.Drawing.Rectangle]::new($X1, $Y1, $X2 - $X1, $Y2 - $Y1)
                }
                "Points" {
                    $rectangleToFill = [System.Drawing.Rectangle]::new(
                        $Point1.X,
                        $Point1.Y,
                        $Point2.X - $Point1.X + 1,
                        $Point2.Y - $Point1.Y + 1
                    )
                }
                "RectangleByInt32" {
                    $rectangleToFill = [System.Drawing.Rectangle]::new($X, $Y, $Width, $Height)
                }
                "Rectangle" {
                    $rectangleToFill = $Rectangle
                }
            }
            
            # creating brush object
            if ($UseBackgroundColor) {
                $colorForBrush = $bitmap.GetPixel($rectangleToFill.X, $rectangleToFill.Y)
                $brush = [System.Drawing.SolidBrush]::new($colorForBrush)
            } else {
                $brush = [System.Drawing.SolidBrush]::new($Color)
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
                [string]$newName = "$($baseName)_A$($brush.Color.A)R$($brush.Color.R)G$($brush.Color.G)B$($brush.Color.B)_X$($rectangleToFill.X)Y$($rectangleToFill.Y)W$($rectangleToFill.Width)H$($rectangleToFill.Height)$($originalExtension)"
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