function Save-ExeIcon {
    <#
    .SYNOPSIS
    Saves the icon file associated to an executive file.
    
    .DESCRIPTION
    Save-ExeIcon function saves the icon file associated to an executive file.
    
    .EXAMPLE
    Save-ExeIcon -Path "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -SavePath "C:\Users\[username]\Pictures\" -SaveName "powershell.ico"
    
    .EXAMPLE
    Save-ExeIcon -Path "C:\Program Files\PowerShell\7\pwsh.exe" -SaveName "powershell7.png"
    
    An icon file will be saved in the current directory.
    
    .EXAMPLE
    Save-ExeIcon -Path "C:\Program Files\PowerShell\7\pwsh.exe" -Destination "powershell6.aaa"
    
    An icon file will be saved in the current directory as "powershell6.ico", because the extention ".aaa" is not supported as a format for picture file format.
    (.ico will be used instead of unknown extentions.)
    
    .PARAMETER Path
    An absolute path to the executive file of which you want to get an associated icon.
    
    .PARAMETER SavePath
    A path for the icon file created by Save-ExeIcon function.
    An absolute path or a relative path.
    
    .PARAMETER SaveName
    A name for the icon file created by Save-ExeIcon function.

    .INPUTS
    
    .OUTPUTS
    
    .LINK
    
    #>
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory=$true,
            Position = 0,
            ValueFromPipelineByPropertyName
            )]
        [String]
        $Path,

        [Parameter(
            Position = 1
            )]
        [String]
        $SavePath = (Convert-Path .),

        [Parameter(
            Position = 2
            )]
        [String]
        $SaveName
    )
    
    begin {
        Add-Type -AssemblyName System.Drawing

        $imageFormatsAndExtensions = @{
            [System.Drawing.Imaging.ImageFormat]::Bmp = @(".bmp")
            [System.Drawing.Imaging.ImageFormat]::Gif = @(".gif")
            [System.Drawing.Imaging.ImageFormat]::Icon = @(".ico")
            [System.Drawing.Imaging.ImageFormat]::Jpeg = @(".jpeg", ".jpg", ".jpe")
            [System.Drawing.Imaging.ImageFormat]::Png = @(".png")
        }
    }
    
    process {
        if (Split-Path $SavePath -IsAbsolute) {
            [string]$absoluteSavePath = $SavePath
        } else {
            [string]$absoluteSavePath = Join-Path (Convert-Path .) $SavePath
        }

        if ($SaveName -ne '') {
            if ([System.IO.Path]::GetExtension($SaveName) -ne '') {
                [string]$tmpSaveName = $SaveName
            } else {
                [string]$tmpSaveName = $SaveName + '.ico'
            }
        } else {
            [string]$tmpSaveName = [System.IO.Path]::GetFileNameWithoutExtension($Path) + '.ico'
        }
        
        [string]$saveFullName = Join-Path ($absoluteSavePath, $tmpSaveName)
        $targetExtension = [System.IO.Path]::GetExtension($tmpSaveName).ToLower()
        
        foreach ($key in $imageFormatsAndExtensions.Keys) {
            if ($targetExtension -in $imageFormatsAndExtensions[$key]) {
                $saveFormat = $key
            } else {
                $saveFormat = [System.Drawing.Imaging.ImageFormat]::Icon
            }
        }

        $icon = [System.Drawing.Icon]::ExtractAssociatedIcon($Path)
        $icon.ToBitmap().Save($saveFullName, $saveFormat)
    }
    
    end {
        $icon.Dispose()
    }
}

Set-Alias seico -Value Save-ExeIcon

Export-ModuleMember -Function * -Alias *