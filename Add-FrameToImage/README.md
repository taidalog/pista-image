# Add-FrameToImage

Adds frame around an image.


## Syntax

```
Add-FrameToImage
    -Path <String[]>
    [-LineWidth] <Int32>
    [-Alpha] <Byte>
    [-Red] <Byte>
    [-Green] <Byte>
    [-Blue] <Byte>
    [-Inner]
    [-Destination] <String>
    [-Name] <String>
    [<CommonParameters>]
```

```
Add-FrameToImage
    -Path <String[]>
    [-LineWidth] <Int32>
    [-Color] <System.Drawing.Color>
    [-Inner]
    [-Destination] <String>
    [-Name] <String>
    [<CommonParameters>]
```


## Description

## Examples

### Example 1:

```ps1
Get-ChildItem *.jpg | Add-FrameToImage
```


### Example 2:

```ps1
Get-ChildItem *.jpg | Add-FrameToImage -LineWidth 10
```


### Example 3:

```ps1
Get-ChildItem *.jpg | Add-FrameToImage -Alpha 255 -Red 255 -Green 0 -Blue 0
```


### Example 4:

```ps1
$color = [System.Drawing.Color]::FromArgb(255, 255, 0, 0)
Get-ChildItem *.jpg | Add-FrameToImage -LineWidth 10 -Color $color
```


### Example 5:

```ps1
Get-ChildItem *.jpg | Add-FrameToImage -Alpha 255 -Red 255 -Green 0 -Blue 0
```


### Example 6:

```ps1
Get-ChildItem *.jpg | Add-FrameToImage -Destination .\frame\
```


### Example 7:

```ps1
Get-ChildItem *.jpg | Add-FrameToImage -Destination { Join-Path $_.DirectoryName \frame\ }
```


### Example 8:

```ps1
Get-ChildItem *.jpg | Add-FrameToImage -Name { $_.BaseName + '_' + (Get-Date -Format 'yyyy-MM-dd-HH-mm-ss') + $_.Extension }
```


## Parameters

## Inputs

**System.IO.FileInfo**


## Outputs

**System.IO.FileInfo**
