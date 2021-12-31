Set-StrictMode -Version Latest

Add-Type -AssemblyName System.Drawing

Import-Module (Join-Path $PSScriptRoot Get-NotBlankRange.psm1) -Force

function Invoke-ImageTrimming {
    [CmdletBinding(DefaultParameterSetName="Padding")]
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

        # Specifies the x coordinate of bottom right corner.
        [Parameter(Mandatory=$false,
                   Position=1,
                   ParameterSetName="Padding"
                   )]
        [Alias()]
        [int]
        $Top = 0,

        # Specifies the x coordinate of bottom right corner.
        [Parameter(Mandatory=$false,
                   Position=2,
                   ParameterSetName="Padding"
                   )]
        [Alias()]
        [int]
        $Right = 0,
        
        # Specifies the y coordinate of bottom right corner.
        [Parameter(Mandatory=$false,
                   Position=3,
                   ParameterSetName="Padding"
                   )]
        [Alias()]
        [int]
        $Bottom = 0,

        # Specifies the y coordinate of bottom right corner.
        [Parameter(Mandatory=$false,
                   Position=4,
                   ParameterSetName="Padding"
                   )]
        [Alias()]
        [int]
        $Left = 0,

        # Specifies the x-coordinate of the upper-left corner of the rectangle.
        [Parameter(Mandatory=$true,
                   Position=1,
                   ParameterSetName="Coordinate",
                   HelpMessage="The x-coordinate of the upper-left corner of the rectangle."
                   )]
        [Alias()]
        [int]
        $X,
        
        # Specifies the y-coordinate of the upper-left corner of the rectangle.
        [Parameter(Mandatory=$true,
                   Position=2,
                   ParameterSetName="Coordinate",
                   HelpMessage="The y-coordinate of the upper-left corner of the rectangle."
                   )]
        [Alias()]
        [int]
        $Y,

        # Specifies the width of the rectangle.
        [Parameter(Mandatory=$true,
                   Position=3,
                   ParameterSetName="Coordinate",
                   HelpMessage="The width of the rectangle."
                   )]
        [Alias()]
        [int]
        $Width,

        # Specifies the  height of the rectangle.
        [Parameter(Mandatory=$true,
                   Position=4,
                   ParameterSetName="Coordinate",
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

        # Blank
        [Parameter(Mandatory=$false,
                   ParameterSetName="Blank"
                   )]
        [switch]
        $Blank,

        # Color
        [Parameter(Mandatory=$false,
                   ParameterSetName="Blank",
                   ValueFromPipelineByPropertyName=$true
                   )]
        [System.Drawing.Color]
        $Color,

        # Specifies the margin for top.
        [Parameter(Mandatory=$false,
                   ParameterSetName="Blank"
                   )]
        [int]
        $MarginTop = 0,

        # Specifies the margin for right.
        [Parameter(Mandatory=$false,
                   ParameterSetName="Blank"
                   )]
        [int]
        $MarginRight = 0,

        # Specifies the margin for bottom.
        [Parameter(Mandatory=$false,
                   ParameterSetName="Blank"
                   )]
        [int]
        $MarginBottom = 0,

        # Specifies the margin for left.
        [Parameter(Mandatory=$false,
                   ParameterSetName="Blank"
                   )]
        [int]
        $MarginLeft = 0,

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
    }
    
    process {
        foreach ($p in $Path) {
            
            [string]$convertedPath = Convert-Path $p
            Write-Verbose $convertedPath

            [string]$originalExtension = [System.IO.Path]::GetExtension($convertedPath)
            if ($originalExtension.ToLower() -notin $imageExtensions) {
                continue
            }
            
            #creating image object
            $sourceBitmap = [System.Drawing.Bitmap]::new($convertedPath)
            
            $rectangleParameters = [PSCustomObject]@{
                X = $null
                Y = $null
                Width = $null
                Height = $null
            }
            
            switch ($PSCmdlet.ParameterSetName) {
                "Padding" {
                    $rectangleParameters.X = $Left
                    $rectangleParameters.Y = $Top
                    $rectangleParameters.Width  = $sourceBitmap.Width - ($Right + $Left)
                    $rectangleParameters.Height = $sourceBitmap.Height - ($Top + $Bottom)
                }
                "Coordinate" {
                    $rectangleParameters.X = $X
                    $rectangleParameters.Y = $Y
                    $rectangleParameters.Width  = $Width
                    $rectangleParameters.Height = $Height
                }
                "Rectangle" {
                    $rectangleParameters.X = $Rectangle.X
                    $rectangleParameters.Y = $Rectangle.Y
                    $rectangleParameters.Width  = $Rectangle.Width
                    $rectangleParameters.Height = $Rectangle.Height
                }
                "Blank" {
                    if ($null -ne $Color) {
                        $backGroundColor = $Color
                    } else {
                        $firstPixel = $sourceBitmap.GetPixel(0, 0)
                        $backGroundColor = [System.Drawing.Color]::FromArgb($firstPixel.A, $firstPixel.R, $firstPixel.G, $firstPixel.B)
                    }

                    $blankRectangle = Get-NotBlankRange -Bitmap $sourceBitmap -Color $backGroundColor
                    
                    $rectangleParameters.X = $blankRectangle.X - $MarginLeft
                    $rectangleParameters.Y = $blankRectangle.Y - $MarginTop
                    $rectangleParameters.Width  = $blankRectangle.Width + $MarginLeft + $MarginRight
                    $rectangleParameters.Height = $blankRectangle.Height + $MarginTop + $MarginBottom
                }
            }
            
            #creating rectangle object
            $sourceRecangle      = [System.Drawing.Rectangle]::new($rectangleParameters.X, $rectangleParameters.Y, $rectangleParameters.Width, $rectangleParameters.Height)
            $destinationRecatngle = [System.Drawing.Rectangle]::new(0, 0, $sourceRecangle.Width, $sourceRecangle.Height)

            $canvasBitmap = [System.Drawing.Bitmap]::new($destinationRecatngle.Width, $destinationRecatngle.Height)
            $canvasGraphics = [System.Drawing.Graphics]::FromImage($canvasBitmap)

            if ($PSCmdlet.ParameterSetName -eq 'Blank') {
                $brush = [System.Drawing.SolidBrush]::new($backGroundColor)
                $canvasGraphics.FillRectangle($brush, $destinationRecatngle)
            }
            
            $canvasGraphics.DrawImage($sourceBitmap, $destinationRecatngle, $sourceRecangle, [System.Drawing.GraphicsUnit]::Pixel)

            $canvasGraphics.Dispose()
            $sourceRecangle = $null
            $destinationRecatngle = $null
            $sourceBitmap.Dispose()

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
                [string]$newName = "$($baseName)_X$($rectangleParameters.X)Y$($rectangleParameters.Y)W$($rectangleParameters.Width)H$($rectangleParameters.Height)$($originalExtension)"
                # [string]$newName = "$($baseName)_$(Get-Date -Format 'yyyy-MM-dd_HH-mm-ss')$($originalExtension)"
                [string]$newPath = Join-Path $innerDestination $newName
            }
            
            Write-Verbose $newPath
            
            $canvasBitmap.Save($newPath)
            $canvasBitmap.Dispose()
            
            Get-Item -Path $newPath
        }
    }
    
    end {
        if ($PSCmdlet.ParameterSetName -eq 'Blank') {
            $brush.Dispose()
        }
    }
}

Set-Alias -Name itrim -Value Invoke-ImageTrimming
Set-Alias -Name trimg -Value Invoke-ImageTrimming

Export-ModuleMember -Function * -Alias *