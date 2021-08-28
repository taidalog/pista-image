Set-StrictMode -Version Latest

Add-Type -AssemblyName System.Drawing

function Add-BlackBarToImage {
    [CmdletBinding(DefaultParameterSetName="CornerARGB")]
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
                   ParameterSetName="CornerARGB",
                   HelpMessage="X coordinate of top left corner."
                   )]
        [Parameter(Mandatory=$true,
                   Position=1,
                   ParameterSetName="CornerColor",
                   HelpMessage="X coordinate of top left corner."
                   )]
        [Alias("Left")]
        [int]
        $TopLeftX,
        
        # Specifies a y coordinate of top left corner.
        [Parameter(Mandatory=$true,
                   Position=2,
                   ParameterSetName="CornerARGB",
                   HelpMessage="Y coordinate of top left corner."
                   )]
        [Parameter(Mandatory=$true,
                   Position=2,
                   ParameterSetName="CornerColor",
                   HelpMessage="Y coordinate of top left corner."
                   )]
        [Alias("Top")]
        [int]
        $TopLeftY,
        
        # Specifies an x coordinate of bottom right corner.
        [Parameter(Mandatory=$true,
                   Position=3,
                   ParameterSetName="CornerARGB",
                   HelpMessage="X coordinate of bottom right corner."
                   )]
        [Parameter(Mandatory=$true,
                   Position=3,
                   ParameterSetName="CornerColor",
                   HelpMessage="X coordinate of bottom right corner."
                   )]
        [Alias("Right")]
        [int]
        $BottomRightX,
        
        # Specifies a y coordinate of bottom right corner.
        [Parameter(Mandatory=$true,
                   Position=4,
                   ParameterSetName="CornerARGB",
                   HelpMessage="Y coordinate of bottom right corner."
                   )]
        [Parameter(Mandatory=$true,
                   Position=4,
                   ParameterSetName="CornerColor",
                   HelpMessage="Y coordinate of bottom right corner."
                   )]
        [Alias("Bottom")]
        [int]
        $BottomRightY,

        # Specifies the x-coordinate of the upper-left corner of the rectangle.
        [Parameter(Mandatory=$true,
                   Position=1,
                   ParameterSetName="RectangleARGB",
                   HelpMessage="The x-coordinate of the upper-left corner of the rectangle."
                   )]
        [Parameter(Mandatory=$true,
                   Position=1,
                   ParameterSetName="RectangleColor",
                   HelpMessage="The x-coordinate of the upper-left corner of the rectangle."
                   )]
        [Alias()]
        [int]
        $X,

        # Specifies the y-coordinate of the upper-left corner of the rectangle.
        [Parameter(Mandatory=$true,
                   Position=2,
                   ParameterSetName="RectangleArgb",
                   HelpMessage="The y-coordinate of the upper-left corner of the rectangle."
                   )]
        [Parameter(Mandatory=$true,
                   Position=2,
                   ParameterSetName="RectangleColor",
                   HelpMessage="The y-coordinate of the upper-left corner of the rectangle."
                   )]
        [Alias()]
        [int]
        $Y,

        # Specifies the width of the rectangle.
        [Parameter(Mandatory=$true,
                   Position=3,
                   ParameterSetName="RectangleARGB",
                   HelpMessage="The width of the rectangle."
                   )]
        [Parameter(Mandatory=$true,
                   Position=3,
                   ParameterSetName="RectangleColor",
                   HelpMessage="The width of the rectangle."
                   )]
        [Alias()]
        [int]
        $Width,

        # Specifies the height of the rectangle.
        [Parameter(Mandatory=$true,
                   Position=4,
                   ParameterSetName="RectangleARGB",
                   HelpMessage="The height of the rectangle."
                   )]
        [Parameter(Mandatory=$true,
                   Position=4,
                   ParameterSetName="RectangleColor",
                   HelpMessage="The height of the rectangle."
                   )]
        [Alias()]
        [int]
        $Height,

        # Specifies an color by .Net Color struct or color name in [System.Drawing.Color] enums.
        [Parameter(ParameterSetName="CornerColor",
                   Position=5
                   )]
        [Parameter(ParameterSetName="RectangleColor",
                   Position=5
                   )]
        [System.Drawing.Color]
        $Color = [System.Drawing.Color]::Black,

        # Specifies an ARGB value for Alpha.
        [Parameter(ParameterSetName="CornerARGB",
                   Position=5
                   )]
        [Parameter(ParameterSetName="RectangleARGB",
                   Position=5
                   )]
        [byte]
        $Alpha = 255,
        
        # Specifies an ARGB value for Red.
        [Parameter(ParameterSetName="CornerARGB",
                   Position=6
                   )]
        [Parameter(ParameterSetName="RectangleARGB",
                   Position=6
                   )]
        [byte]
        $Red = 0,
        
        # Specifies an ARGB value for Green.
        [Parameter(ParameterSetName="CornerARGB",
                   Position=7
                   )]
        [Parameter(ParameterSetName="RectangleARGB",
                   Position=7
                   )]
        [byte]
        $Green = 0,
        
        # Specifies an ARGB value for Blue.
        [Parameter(ParameterSetName="CornerARGB",
                   Position=8
                   )]
        [Parameter(ParameterSetName="RectangleARGB",
                   Position=8
                   )]
        [byte]
        $Blue = 0,

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
        #creating brush object
        
        switch ($PSCmdlet.ParameterSetName) {
            "CornerARGB" {
                $colorForBrush = [System.Drawing.Color]::FromArgb($Alpha, $Red, $Green, $Blue)
            }
            "RectangleARGB" {
                $colorForBrush = [System.Drawing.Color]::FromArgb($Alpha, $Red, $Green, $Blue)
            }
            "CornerColor" {
                $colorForBrush = $Color
            }
            "RectangleColor" {
                $colorForBrush = $Color
            }
        }

        $brush = [System.Drawing.SolidBrush]::new($colorForBrush)
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
            $bitmap = [System.Drawing.Bitmap]::new($convertedPath)
            $graphics = [System.Drawing.Graphics]::FromImage($bitmap)

            switch ($PSCmdlet.ParameterSetName) {
                "CornerARGB" {
                    $blackBarTopLeftX = $TopLeftX
                    $blackBarTopLeftY = $TopLeftY
                    $blackBarWidth = $BottomRightX - $TopLeftX
                    $blackBarHeight = $BottomRightY - $TopLeftY
                }
                "CornerColor" {
                    $blackBarTopLeftX = $TopLeftX
                    $blackBarTopLeftY = $TopLeftY
                    $blackBarWidth = $BottomRightX - $TopLeftX
                    $blackBarHeight = $BottomRightY - $TopLeftY
                }
                "RectangleARGB" {
                    $blackBarTopLeftX = $X
                    $blackBarTopLeftY = $Y
                    $blackBarWidth = $Width
                    $blackBarHeight = $Height
                }
                "RectangleColor" {
                    $blackBarTopLeftX = $X
                    $blackBarTopLeftY = $Y
                    $blackBarWidth = $Width
                    $blackBarHeight = $Height
                }
            }
            
            #creating rectangle object
            $rectangle = [System.Drawing.Rectangle]::new($blackBarTopLeftX, $blackBarTopLeftY, $blackBarWidth, $blackBarHeight)

            $graphics.FillRectangle($brush, $rectangle)
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
                [string]$newName = "$($baseName)_A$($colorForBrush.A)R$($colorForBrush.R)G$($colorForBrush.G)B$($colorForBrush.B)_X$($blackBarTopLeftX)Y$($blackBarTopLeftY)W$($blackBarWidth)H$($blackBarHeight)$($originalExtension)"
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