Set-StrictMode -Version Latest

Add-Type -AssemblyName System.Drawing

function Get-NotBackgroundColorRectangle {
    [CmdletBinding(DefaultParameterSetName="Path")]
    param (
        # Specifies a path to one or more locations.
        [Parameter(Mandatory=$true,
                   Position=0,
                   ParameterSetName="Path",
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   HelpMessage="Path to one or more locations.")]
        [Alias("PSPath")]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $Path,

        [Parameter(Mandatory=$true,
                   Position=0,
                   ParameterSetName="Bitmap",
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   HelpMessage="Bitmap"
                   )]
        [ValidateNotNullOrEmpty()]
        [System.Drawing.Bitmap[]]
        $Bitmap,

        [Parameter()]
        [System.Drawing.Color]
        $Color
    )
    
    begin {
        
    }
    
    process {
        if ($null -ne $Color) {
            $targetColorToArgb = $Color.ToArgb()
        } else {
            $topLeftPixel = $Bitmap.GetPixel(0, 0)
            $targetColorToArgb = [System.Drawing.Color]::FromArgb($topLeftPixel.A, $topLeftPixel.R, $topLeftPixel.G, $topLeftPixel.B).ToArgb()
        }

        $result = [PSCustomObject]@{
            X = $null
            Y = $null
            Width = $null
            Height = $null
        }

        # getting top-left x coordinate
        :loopForForTopLeftX for ($topLeftX = 0; $topLeftX -lt $Bitmap.Width; $topLeftX++) {
            for ($topLeftY = 0; $topLeftY -lt $Bitmap.Height; $topLeftY++) {

                $tmpPixel = $Bitmap.GetPixel($topLeftX, $topLeftY)

                if ($tmpPixel.ToArgb() -ne $targetColorToArgb) {
                    $result.X = $topLeftX
                    break loopForForTopLeftX
                }
                
            }
        }

        # getting top-left y coordinate
        :loopForTopLeftY for ($topLeftY = 0; $topLeftY -lt $Bitmap.Height; $topLeftY++) {
            for ($topLeftX = 0; $topLeftX -lt $Bitmap.Width; $topLeftX++) {
                
                $tmpPixel = $Bitmap.GetPixel($topLeftX, $topLeftY)
                
                if ($tmpPixel.ToArgb() -ne $targetColorToArgb) {
                    $result.Y = $topLeftY
                    break loopForTopLeftY
                }

            }
        }

        # getting bottom-right x coordinate
        :loopForBottomRightX for ($bottomRightX = $Bitmap.Width - 1; $bottomRightX -ge 0; $bottomRightX--) {
            for ($bottomRightY = $Bitmap.Height - 1; $bottomRightY -ge 0; $bottomRightY--) {
                
                $tmpPixel = $Bitmap.GetPixel($bottomRightX, $bottomRightY)
                
                if ($tmpPixel.ToArgb() -ne $targetColorToArgb) {
                    
                    if ($bottomRightX -eq $Bitmap.Width) {
                        $result.Width = $bottomRightX - $result.X
                    } else {
                        $result.Width = $bottomRightX - $result.X + 1
                    }

                    break loopForBottomRightX
                }
                
            }
        }

        # getting bottom-right y coordinate
        :loopForBottomRightY for ($bottomRightY = $Bitmap.Height - 1; $bottomRightY -ge 0; $bottomRightY--) {
            for ($bottomRightX = $Bitmap.Width - 1; $bottomRightX -ge 0; $bottomRightX--) {

                $tmpPixel = $Bitmap.GetPixel($bottomRightX, $bottomRightY)
                
                if ($tmpPixel.ToArgb() -ne $targetColorToArgb) {

                    if ($bottomRightY -eq $Bitmap.Height) {
                        $result.Height = $bottomRightY - $result.Y
                    } else {
                        $result.Height = $bottomRightY - $result.Y + 1
                    }

                    break loopForBottomRightY
                }
                
            }
        }

        $result
    }
    
    end {
        
    }
}
