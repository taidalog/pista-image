Set-StrictMode -Version Latest

Add-Type -AssemblyName System.Drawing

function Save-ExeIcon {
    <#
    .SYNOPSIS
    Saves the icon file associated to an executive file.
    
    .DESCRIPTION
    Save-ExeIcon function saves the icon file associated to an executive file.
    
    .EXAMPLE
    Save-ExeIcon -Path "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -Destination "C:\Users\[username]\Pictures\" -SaveName "powershell.ico"
    
    .EXAMPLE
    Save-ExeIcon -Path "C:\Program Files\PowerShell\7\pwsh.exe" -SaveName "powershell7.png"
    # An icon file will be saved in the current directory.
    
    .EXAMPLE
    Save-ExeIcon -Path "C:\Program Files\PowerShell\7\pwsh.exe" -SaveName "powershell6.text"
    # An icon file will be saved in the current directory as "powershell6.ico".
    # The extention ".text" is not a picture file format, so ".ico" will be used.
    # (".ico" will be used instead of unknown extentions.)
    
    .PARAMETER Path
    A path to the executive file of which you want to get an associated icon.
    An absolute path or a relative path.
    
    .PARAMETER Destination
    A path to the directory in which the created icon file will be saved.
    An absolute path or a relative path.
    
    .PARAMETER SaveName
    A name for the icon file to be created.

    .INPUTS
    
    .OUTPUTS
    
    .LINK
    
    #>
    [CmdletBinding()]
    param (
        # Specifies a path to one or more locations.
        [Parameter(Mandatory=$true,
                   Position=0,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   HelpMessage="Path to one or more locations.")]
        [Alias("PSPath")]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({Test-Path $_ -PathType 'Leaf'})]
        [string[]]
        $Path,

        [Parameter(
            Position = 1
            )]
            [ValidateScript({Test-Path $_ -PathType 'Container'})]
        [String]
        $Destination = (Convert-Path .),

        [Parameter(
            Position = 2
            )]
        [String]
        $SaveName
    )
    
    begin {
        $imageFormatsAndExtensions = @{
            [System.Drawing.Imaging.ImageFormat]::Bmp = @(".bmp")
            [System.Drawing.Imaging.ImageFormat]::Gif = @(".gif")
            [System.Drawing.Imaging.ImageFormat]::Icon = @(".ico")
            [System.Drawing.Imaging.ImageFormat]::Jpeg = @(".jpeg", ".jpg", ".jpe")
            [System.Drawing.Imaging.ImageFormat]::Png = @(".png")
        }
    }
    
    process {
        foreach ($p in $Path) {
            $convertedPath = Convert-Path $p

            # creating save name
            if ($SaveName -eq '') {
                [string]$tmpSaveName = [System.IO.Path]::GetFileNameWithoutExtension($convertedPath) + '.ico'
            } else {
                if ([System.IO.Path]::GetExtension($SaveName) -eq '') {
                    [string]$tmpSaveName = $SaveName + '.ico'
                } else {
                    [string]$tmpSaveName = $SaveName
                }
            }
            
            # creating save path
            $absoluteDestination = Convert-Path $Destination
            $saveFullName = Join-Path ($absoluteDestination, $tmpSaveName)
            
            # deciding extension to save with
            $targetExtension = [System.IO.Path]::GetExtension($tmpSaveName).ToLower()
            
            foreach ($key in $imageFormatsAndExtensions.Keys) {
                if ($targetExtension -in $imageFormatsAndExtensions[$key]) {
                    $saveFormat = $key
                } else {
                    $saveFormat = [System.Drawing.Imaging.ImageFormat]::Icon
                }
            }

            $icon = [System.Drawing.Icon]::ExtractAssociatedIcon($convertedPath)
            $icon.ToBitmap().Save($saveFullName, $saveFormat)
            $icon.Dispose()
        }
    }
    
    end {
    }
}

Set-Alias seico -Value Save-ExeIcon

Export-ModuleMember -Function * -Alias *