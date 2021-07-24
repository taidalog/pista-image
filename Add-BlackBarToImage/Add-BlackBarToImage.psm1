Add-Type -AssemblyName System.Drawing

function Add-BlackBarToImage {
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
                   ParameterSetName="ColorName",
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   HelpMessage="Path to one or more locations."
                   )]
        [Alias("PSPath")]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({Test-Path $_ -PathType 'Leaf'})]
        [string[]]
        $Path,

        [Parameter(ParameterSetName="ARGB",
                   HelpMessage="ARGB value for Alpha."
                   )]
        [byte]
        $Alpha = 255,
        
        [Parameter(ParameterSetName="ARGB",
                   HelpMessage="ARGB value for Red."
                   )]
        [byte]
        $Red = 0,
        
        [Parameter(ParameterSetName="ARGB",
                   HelpMessage="ARGB value for Green."
                   )]
        [byte]
        $Green = 0,
        
        [Parameter(ParameterSetName="ARGB",
                   HelpMessage="ARGB value for Blue."
                   )]
        [byte]
        $Blue = 0,

        [Parameter(ParameterSetName="ColorName",
                   HelpMessage="Color name in <color> enums."
                   )]
        [System.Drawing.Color]
        $ColorName,

        [Parameter(Mandatory=$true,
                   ParameterSetName="ARGB",
                   HelpMessage="X coordinate of top left corner."
                   )]
        [Parameter(Mandatory=$true,
                   ParameterSetName="ColorName",
                   HelpMessage="X coordinate of top left corner."
                   )]
        [Alias("CLeft")]
        [int]
        $TopLeftX,
        
        [Parameter(Mandatory=$true,
                   ParameterSetName="ARGB",
                   HelpMessage="Y coordinate of top left corner."
                   )]
        [Parameter(Mandatory=$true,
                   ParameterSetName="ColorName",
                   HelpMessage="Y coordinate of top left corner."
                   )]
        [Alias("CTop")]
        [int]
        $TopLeftY,
        
        [Parameter(Mandatory=$true,
                   ParameterSetName="ARGB",
                   HelpMessage="X coordinate of bottom right corner."
                   )]
        [Parameter(Mandatory=$true,
                   ParameterSetName="ColorName",
                   HelpMessage="X coordinate of bottom right corner."
                   )]
        [Alias("CRight")]
        [int]
        $BottomRightX,
        
        [Parameter(Mandatory=$true,
                   ParameterSetName="ARGB",
                   HelpMessage="Y coordinate of bottom right corner."
                   )]
        [Parameter(Mandatory=$true,
                   ParameterSetName="ColorName",
                   HelpMessage="Y coordinate of bottom right corner."
                   )]
        [Alias("CBottom")]
        [int]
        $BottomRightY
    )
    
    begin {
        #creating pen object
        $colorForBrush = [System.Drawing.Color]::FromArgb($Alpha, $Red, $Green, $Blue)
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

            $maskWidth = $BottomRightX - $TopLeftX
            $maskHeight = $BottomRightY - $TopLeftY
            
            #creating rectangle object
            $rectangle = [System.Drawing.Rectangle]::new($TopLeftX, $TopLeftY, $maskWidth, $maskHeight)

            $graphics.FillRectangle($brush, $rectangle)
            $graphics.Dispose()

            # saving image
            $baseName = [System.IO.Path]::GetFileNameWithoutExtension($convertedPath)
            $newPath = $convertedPath -replace $baseName, "$($baseName)_A$($Alpha)R$($Red)G$($Green)B$($Blue)_W$($maskWidth)_H$($maskHeight)"
            
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