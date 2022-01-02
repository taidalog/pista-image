Set-StrictMode -Version Latest

Add-Type -AssemblyName System.Drawing

Import-Module (Join-Path $PSScriptRoot Get-NotBackgroundColorRectangle.psm1) -Force

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

        # Specifies an x coordinate of top left corner.
        [Parameter(Mandatory=$true,
                   Position=1,
                   ParameterSetName="PointsByInt32",
                   HelpMessage="X coordinate of top left corner."
                   )]
        [Alias()]
        [int]
        $X1,
        
        # Specifies a y coordinate of top left corner.
        [Parameter(Mandatory=$true,
                   Position=2,
                   ParameterSetName="PointsByInt32",
                   HelpMessage="Y coordinate of top left corner."
                   )]
        [Alias()]
        [int]
        $Y1,
        
        # Specifies an x coordinate of bottom right corner.
        [Parameter(Mandatory=$true,
                   Position=3,
                   ParameterSetName="PointsByInt32",
                   HelpMessage="X coordinate of bottom right corner."
                   )]
        [Alias()]
        [int]
        $X2,
        
        # Specifies a y coordinate of bottom right corner.
        [Parameter(Mandatory=$true,
                   Position=4,
                   ParameterSetName="PointsByInt32",
                   HelpMessage="Y coordinate of bottom right corner."
                   )]
        [Alias()]
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
                   HelpMessage="The x-coordinate of the upper-left corner of the rectangle."
                   )]
        [Alias()]
        [int]
        $X,
        
        # Specifies the y-coordinate of the upper-left corner of the rectangle.
        [Parameter(Mandatory=$true,
                   Position=2,
                   ParameterSetName="RectangleByInt32",
                   HelpMessage="The y-coordinate of the upper-left corner of the rectangle."
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

        # Specifies the  height of the rectangle.
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

        # TrimBackgroundColor
        [Parameter(ParameterSetName="TrimBackgroundColor"
                   )]
        [switch]
        $TrimBackgroundColor,

        # Color
        [Parameter(ParameterSetName="TrimBackgroundColor",
                   ValueFromPipelineByPropertyName=$true
                   )]
        [System.Drawing.Color]
        $Color,

        # Specifies the margin for top.
        [Parameter(ParameterSetName="TrimBackgroundColor"
                   )]
        [int]
        $MarginTop = 0,

        # Specifies the margin for right.
        [Parameter(ParameterSetName="TrimBackgroundColor"
                   )]
        [int]
        $MarginRight = 0,

        # Specifies the margin for bottom.
        [Parameter(ParameterSetName="TrimBackgroundColor"
                   )]
        [int]
        $MarginBottom = 0,

        # Specifies the margin for left.
        [Parameter(ParameterSetName="TrimBackgroundColor"
                   )]
        [int]
        $MarginLeft = 0,

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
            
            [string]$convertedPath = Convert-Path $p
            Write-Verbose $convertedPath

            [string]$originalExtension = [System.IO.Path]::GetExtension($convertedPath)
            if ($originalExtension.ToLower() -notin $imageExtensions) {
                continue
            }
            
            # creating image object
            $sourceBitmap = [System.Drawing.Bitmap]::new($convertedPath)
            
            switch ($PSCmdlet.ParameterSetName) {
                "Padding" {
                    $trimmingAreaRectangle = [System.Drawing.Rectangle]::new(
                        $Left,
                        $Top,
                        $sourceBitmap.Width - ($Right + $Left),
                        $sourceBitmap.Height - ($Top + $Bottom)
                    )
                }
                "PointsByInt32" {
                    $trimmingAreaRectangle = [System.Drawing.Rectangle]::new($X1, $Y1, $X2 - $X1, $Y2 - $Y1)
                }
                "Points" {
                    $trimmingAreaRectangle = [System.Drawing.Rectangle]::new(
                        $Point1.X,
                        $Point1.Y,
                        $Point2.X - $Point1.X,
                        $Point2.Y - $Point1.Y
                    )
                }
                "RectangleByInt32" {
                    $trimmingAreaRectangle = [System.Drawing.Rectangle]::new($X, $Y, $Width, $Height)
                }
                "Rectangle" {
                    $trimmingAreaRectangle = $Rectangle
                }
                "TrimBackgroundColor" {
                    if ($null -ne $Color) {
                        $brush = [System.Drawing.SolidBrush]::new($Color)
                    } else {
                        $brush = [System.Drawing.SolidBrush]::new($sourceBitmap.GetPixel(0, 0))
                    }

                    $notBackgroundColorRectangle = Get-NotBackgroundColorRectangle -Bitmap $sourceBitmap -Color $brush.Color
                    
                    $trimmingAreaRectangle = [System.Drawing.Rectangle]::new(
                        $notBackgroundColorRectangle.X - $MarginLeft,
                        $notBackgroundColorRectangle.Y - $MarginTop,
                        $notBackgroundColorRectangle.Width + $MarginLeft + $MarginRight,
                        $notBackgroundColorRectangle.Height + $MarginTop + $MarginBottom
                    )
                }
            }
            
            # creating rectangle object
            $trimmedSizeRectangle = [System.Drawing.Rectangle]::new(0, 0, $trimmingAreaRectangle.Width, $trimmingAreaRectangle.Height)
            $trimmedSizeBitmap = [System.Drawing.Bitmap]::new($trimmedSizeRectangle.Width, $trimmedSizeRectangle.Height)
            $trimmedSizeGraphics = [System.Drawing.Graphics]::FromImage($trimmedSizeBitmap)

            if ($PSCmdlet.ParameterSetName -eq 'TrimBackgroundColor') {
                $trimmedSizeGraphics.FillRectangle($brush, $trimmedSizeRectangle)
            }
            
            $trimmedSizeGraphics.DrawImage($sourceBitmap, $trimmedSizeRectangle, $trimmingAreaRectangle, [System.Drawing.GraphicsUnit]::Pixel)

            $trimmedSizeGraphics.Dispose()
            $trimmedSizeRectangle = $null
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
                [string]$newName = "$($baseName)_X$($trimmingAreaRectangle.X)Y$($trimmingAreaRectangle.Y)W$($trimmingAreaRectangle.Width)H$($trimmingAreaRectangle.Height)$($originalExtension)"
                [string]$newPath = Join-Path $innerDestination $newName
            }
            
            Write-Verbose $newPath
            
            $trimmedSizeBitmap.Save($newPath)
            $trimmedSizeBitmap.Dispose()
            $trimmingAreaRectangle = $null
            
            Get-Item -Path $newPath
        }
    }
    
    end {
        if ($PSCmdlet.ParameterSetName -eq 'TrimBackgroundColor') {
            $brush.Dispose()
        }
    }
}

Set-Alias -Name itrim -Value Invoke-ImageTrimming
Set-Alias -Name trimg -Value Invoke-ImageTrimming

Export-ModuleMember -Function * -Alias *