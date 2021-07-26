Set-StrictMode -Version Latest

Add-Type -AssemblyName System.Drawing

function Invoke-TrimImage {
    [CmdletBinding(DefaultParameterSetName="Padding")]
    param (
        # Specifies a path to one or more locations.
        [Parameter(Mandatory=$true,
                   Position=0,
                   ParameterSetName="Padding",
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   HelpMessage="Path to one or more locations."
                   )]
        [Parameter(Mandatory=$true,
                   Position=0,
                   ParameterSetName="Rectangle",
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
                   ParameterSetName="Padding",
                   HelpMessage="X coordinate of bottom right corner."
                   )]
        [Alias()]
        [int]
        $Top = 0,

        [Parameter(Mandatory=$false,
                   Position=2,
                   ParameterSetName="Padding",
                   HelpMessage="X coordinate of bottom right corner."
                   )]
        [Alias()]
        [int]
        $Right = 0,
        
        [Parameter(Mandatory=$false,
                   Position=3,
                   ParameterSetName="Padding",
                   HelpMessage="Y coordinate of bottom right corner."
                   )]
        [Alias()]
        [int]
        $Bottom = 0,

        [Parameter(Mandatory=$false,
                   Position=4,
                   ParameterSetName="Padding",
                   HelpMessage="Y coordinate of bottom right corner."
                   )]
        [Alias()]
        [int]
        $Left = 0,

        [Parameter(Mandatory=$true,
                   Position=1,
                   ParameterSetName="Rectangle",
                   HelpMessage="The x-coordinate of the upper-left corner of the rectangle."
                   )]
        [Alias()]
        [int]
        $X,
        
        [Parameter(Mandatory=$true,
                   Position=2,
                   ParameterSetName="Rectangle",
                   HelpMessage="The y-coordinate of the upper-left corner of the rectangle."
                   )]
        [Alias()]
        [int]
        $Y,

        [Parameter(Mandatory=$true,
                   Position=3,
                   ParameterSetName="Rectangle",
                   HelpMessage="The width of the rectangle."
                   )]
        [Alias()]
        [int]
        $Width,

        [Parameter(Mandatory=$true,
                   Position=4,
                   ParameterSetName="Rectangle",
                   HelpMessage="The height of the rectangle."
                   )]
        [Alias()]
        [int]
        $Height,

        [Parameter(Mandatory=$false,
                   # Position=1,
                   ParameterSetName="Padding",
                   # ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   HelpMessage="Path to a directory to save in."
                   )]
        [Parameter(Mandatory=$false,
                   # Position=1,
                   ParameterSetName="Rectangle",
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
            $sourceBitmap = [System.Drawing.Bitmap]::new($convertedPath)
            
            switch ($PSCmdlet.ParameterSetName) {
                "Padding" {
                    [int]$xCoordinateForRectangle = $Left
                    [int]$yCoordinateForRectangle = $Top
                    [int]$widthForRectangle  = $sourceBitmap.Width - ($Right + $Left)
                    [int]$heightForRectangle = $sourceBitmap.Height - ($Top + $Bottom)
                }
                "Rectangle" {
                    [int]$xCoordinateForRectangle = $X
                    [int]$yCoordinateForRectangle = $Y
                    [int]$widthForRectangle  = $Width
                    [int]$heightForRectangle = $Height
                }
            }
            
            #creating rectangle object
            $sourceRecangle      = [System.Drawing.Rectangle]::new($xCoordinateForRectangle, $yCoordinateForRectangle, $widthForRectangle, $heightForRectangle)
            $destinationRecangle = [System.Drawing.Rectangle]::new(0, 0, $sourceRecangle.Width, $sourceRecangle.Height)

            $canvasBitmap = [System.Drawing.Bitmap]::new($destinationRecangle.Width, $destinationRecangle.Height)
            $canvasGraphics = [System.Drawing.Graphics]::FromImage($canvasBitmap)

            $canvasGraphics.DrawImage($sourceBitmap, $destinationRecangle, $sourceRecangle, [System.Drawing.GraphicsUnit]::Pixel)
            $canvasGraphics.Dispose()
            $sourceRecangle = $null
            $destinationRecangle = $null
            $sourceBitmap.Dispose()

            # saving image
            if ($Destination -eq '') {
                $innerDestination = Split-Path $convertedPath -Parent
            } else {
                $innerDestination = $Destination
            }

            $baseName = [System.IO.Path]::GetFileNameWithoutExtension($convertedPath)
            $originalExtension = [System.IO.Path]::GetExtension($convertedPath)
            $newBaseName = "$($baseName)_X$($xCoordinateForRectangle)Y$($yCoordinateForRectangle)W$($widthForRectangle)H$($heightForRectangle)"
            $newPath = Join-Path $innerDestination "$($newBaseName)$($originalExtension)"
            
            Write-Verbose $newPath
            
            $canvasBitmap.Save($newPath)
            $canvasBitmap.Dispose()
            
            Get-Item -Path $newPath
        }
    }
    
    end {
        
    }
}

Set-Alias -Name itrim -Value Invoke-TrimImage
Set-Alias -Name trimg -Value Invoke-TrimImage

Export-ModuleMember -Function * -Alias *