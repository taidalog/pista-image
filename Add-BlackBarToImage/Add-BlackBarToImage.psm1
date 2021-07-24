Set-StrictMode -Version Latest

Add-Type -AssemblyName System.Drawing

function Add-BlackBarToImage {
    [CmdletBinding(DefaultParameterSetName="CornerARGB")]
    param (
        # Specifies a path to one or more locations.
        [Parameter(Mandatory=$true,
                   Position=0,
                   ParameterSetName="CornerARGB",
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   HelpMessage="Path to one or more locations."
                   )]
        [Parameter(Mandatory=$true,
                   Position=0,
                   ParameterSetName="CornerColor",
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   HelpMessage="Path to one or more locations."
                   )]
        [Parameter(Mandatory=$true,
                   Position=0,
                   ParameterSetName="RectangleARGB",
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   HelpMessage="Path to one or more locations."
                   )]
        [Parameter(Mandatory=$true,
                   Position=0,
                   ParameterSetName="RectangleColor",
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   HelpMessage="Path to one or more locations."
                   )]
        [Alias("PSPath")]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({Test-Path $_ -PathType 'Leaf'})]
        [string[]]
        $Path,

        [Parameter(ParameterSetName="CornerARGB",
                   HelpMessage="ARGB value for Alpha."
                   )]
        [Parameter(ParameterSetName="RectangleARGB",
                   HelpMessage="ARGB value for Alpha."
                   )]
        [byte]
        $Alpha = 255,
        
        [Parameter(ParameterSetName="CornerARGB",
                   HelpMessage="ARGB value for Red."
                   )]
        [Parameter(ParameterSetName="RectangleARGB",
                   HelpMessage="ARGB value for Red."
                   )]
        [byte]
        $Red = 0,
        
        [Parameter(ParameterSetName="CornerARGB",
                   HelpMessage="ARGB value for Green."
                   )]
        [Parameter(ParameterSetName="RectangleARGB",
                   HelpMessage="ARGB value for Green."
                   )]
        [byte]
        $Green = 0,
        
        [Parameter(ParameterSetName="CornerARGB",
                   HelpMessage="ARGB value for Blue."
                   )]
        [Parameter(ParameterSetName="RectangleARGB",
                   HelpMessage="ARGB value for Blue."
                   )]
        [byte]
        $Blue = 0,

        [Parameter(ParameterSetName="CornerColor",
                   HelpMessage="Color struct or color name in <color> enums."
                   )]
        [Parameter(ParameterSetName="RectangleColor",
                   HelpMessage="Color struct or color name in <color> enums."
                   )]
        [System.Drawing.Color]
        $Color,

        [Parameter(Mandatory=$true,
                   ParameterSetName="CornerARGB",
                   HelpMessage="X coordinate of top left corner."
                   )]
        [Parameter(Mandatory=$true,
                   ParameterSetName="CornerColor",
                   HelpMessage="X coordinate of top left corner."
                   )]
        [Alias("Left")]
        [int]
        $TopLeftX,
        
        [Parameter(Mandatory=$true,
                   ParameterSetName="CornerARGB",
                   HelpMessage="Y coordinate of top left corner."
                   )]
        [Parameter(Mandatory=$true,
                   ParameterSetName="CornerColor",
                   HelpMessage="Y coordinate of top left corner."
                   )]
        [Alias("Top")]
        [int]
        $TopLeftY,
        
        [Parameter(Mandatory=$true,
                   ParameterSetName="CornerARGB",
                   HelpMessage="X coordinate of bottom right corner."
                   )]
        [Parameter(Mandatory=$true,
                   ParameterSetName="CornerColor",
                   HelpMessage="X coordinate of bottom right corner."
                   )]
        [Alias("Right")]
        [int]
        $BottomRightX,
        
        [Parameter(Mandatory=$true,
                   ParameterSetName="CornerARGB",
                   HelpMessage="Y coordinate of bottom right corner."
                   )]
        [Parameter(Mandatory=$true,
                   ParameterSetName="CornerColor",
                   HelpMessage="Y coordinate of bottom right corner."
                   )]
        [Alias("Bottom")]
        [int]
        $BottomRightY,

        [Parameter(Mandatory=$true,
                   ParameterSetName="RectangleARGB",
                   HelpMessage="The x-coordinate of the upper-left corner of the rectangle."
                   )]
        [Parameter(Mandatory=$true,
                   ParameterSetName="RectangleColor",
                   HelpMessage="The x-coordinate of the upper-left corner of the rectangle."
                   )]
        [Alias()]
        [int]
        $X,

        [Parameter(Mandatory=$true,
                   ParameterSetName="RectangleArgb",
                   HelpMessage="The y-coordinate of the upper-left corner of the rectangle."
                   )]
        [Parameter(Mandatory=$true,
                   ParameterSetName="RectangleColor",
                   HelpMessage="The y-coordinate of the upper-left corner of the rectangle."
                   )]
        [Alias()]
        [int]
        $Y,

        [Parameter(Mandatory=$true,
                   ParameterSetName="RectangleARGB",
                   HelpMessage="The width of the rectangle."
                   )]
        [Parameter(Mandatory=$true,
                   ParameterSetName="RectangleColor",
                   HelpMessage="The width of the rectangle."
                   )]
        [Alias()]
        [int]
        $Width,

        [Parameter(Mandatory=$true,
                   ParameterSetName="RectangleARGB",
                   HelpMessage="The height of the rectangle."
                   )]
        [Parameter(Mandatory=$true,
                   ParameterSetName="RectangleColor",
                   HelpMessage="The height of the rectangle."
                   )]
        [Alias()]
        [int]
        $Height
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

            $targetExtension = [System.IO.Path]::GetExtension($convertedPath)
            if ($targetExtension.ToLower() -notin $imageExtensions) {
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
            $baseName = [System.IO.Path]::GetFileNameWithoutExtension($convertedPath)
            $newBaseName = "$($baseName)_A$($colorForBrush.A)R$($colorForBrush.R)G$($colorForBrush.G)B$($colorForBrush.B)_X$($blackBarTopLeftX)Y$($blackBarTopLeftY)W$($blackBarWidth)H$($blackBarHeight)"
            $newPath = $convertedPath -replace $baseName, $newBaseName
            
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