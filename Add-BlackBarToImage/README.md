# Add-BlackBarToImage

Adds a black bar to an image in order to hide something in the image.


## Syntax

```
Add-BlackBarToImage
    -Path <String[]>
    -TopLeftX <Int32>
    -TopLeftY <Int32>
    -BottomRightX <Int32>
    -BottomRightY <Int32>
    [-Alpha] <byte>
    [-Red] <byte>
    [-Green] <byte>
    [-Blue] <byte>
    [-Destination] <String>
    [-Name] <String>
    [<CommonParameters>]
```

```
Add-BlackBarToImage
    -Path <String[]>
    -TopLeftX <Int32>
    -TopLeftY <Int32>
    -BottomRightX <Int32>
    -BottomRightY <Int32>
    [-Color] <System.Drawing.Color>
    [-Destination] <String>
    [-Name] <String>
    [<CommonParameters>]
```

```
Add-BlackBarToImage
    -Path <String[]>
    -TopLeftX <Int32>
    -TopLeftY <Int32>
    -BottomRightX <Int32>
    -BottomRightY <Int32>
    [-UseBackgroundColor]
    [-Destination] <String>
    [-Name] <String>
    [<CommonParameters>]
```

```
Add-BlackBarToImage
    -Path <String[]>
    -X <Int32>
    -Y <Int32>
    -Width <Int32>
    -Height <Int32>
    [-Alpha] <byte>
    [-Red] <byte>
    [-Green] <byte>
    [-Blue] <byte>
    [-Destination] <String>
    [-Name] <String>
    [<CommonParameters>]
```

```
Add-BlackBarToImage
    -Path <String[]>
    -X <Int32>
    -Y <Int32>
    -Width <Int32>
    -Height <Int32>
    [-Color] <System.Drawing.Color>
    [-Destination] <String>
    [-Name] <String>
    [<CommonParameters>]
```

```
Add-BlackBarToImage
    -Path <String[]>
    -X <Int32>
    -Y <Int32>
    -Width <Int32>
    -Height <Int32>
    [-UseBackgroundColor]
    [-Destination] <String>
    [-Name] <String>
    [<CommonParameters>]
```

```
Add-BlackBarToImage
    -Path <String[]>
    -Rectangle <System.Drawing.Rectangle>
    [-Alpha] <byte>
    [-Red] <byte>
    [-Green] <byte>
    [-Blue] <byte>
    [-Destination] <String>
    [-Name] <String>
    [<CommonParameters>]
```

```
Add-BlackBarToImage
    -Path <String[]>
    -Rectangle <System.Drawing.Rectangle>
    [-Color] <System.Drawing.Color>
    [-Destination] <String>
    [-Name] <String>
    [<CommonParameters>]
```

```
Add-BlackBarToImage
    -Path <String[]>
    -Rectangle <System.Drawing.Rectangle>
    [-UseBackgroundColor]
    [-Destination] <String>
    [-Name] <String>
    [<CommonParameters>]
```


## Description

## Examples

### Example 1:

```ps1
Get-ChildItem *.jpg | Add-BlackBarToImage -X 154 -Y 65 -Width 1566 -Height 30
```


### Example 2:

```ps1
Get-ChildItem *.jpg | Add-BlackBarToImage -X 154 -Y 65 -Width 1566 -Height 30 -Alpha -Red -Green -Blue
```


### Example 3:

```ps1
Get-ChildItem *.jpg | Add-BlackBarToImage -X 154 -Y 65 -Width 1566 -Height 30 -Color ([System.Drawing.Color]::Black)
```


### Example 4:

```ps1
Get-ChildItem *.jpg | Add-BlackBarToImage -X 154 -Y 65 -Width 1566 -Height 30 -UseBackgroundColor
```


### Example 5:

```ps1
Get-ChildItem *.jpg | Add-BlackBarToImage -TopLeftX 154 -TopLeftY 65 -BottomRightX 1720 -BottomRightY 95
```


### Example 6:

```ps1
$rectangle = [System.Drawing.Rectangle]::new(600, 500, 200, 100)
Get-ChildItem *.jpg | Add-BlackBarToImage -Rectangle $rectangle
```


### Example 6:

```ps1
Get-ChildItem *.jpg | Add-BlackBarToImage -X 154 -Y 65 -Width 1566 -Height 30 -Destination .\blackbar\
```


### Example 7:

```ps1
Get-ChildItem *.jpg | Add-BlackBarToImage -X 154 -Y 65 -Width 1566 -Height 30 -Destination { Join-Path $_.DirectoryName \blackbar\ }
```


### Example 8:

```ps1
Get-ChildItem *.jpg | Add-BlackBarToImage -X 154 -Y 65 -Width 1566 -Height 30 -Name { $_.BaseName + '_' + (Get-Date -Format 'yyyy-MM-dd-HH-mm-ss') + $_.Extension }
```


## Parameters

## Inputs

**System.IO.FileInfo**


## Outputs

**System.IO.FileInfo**
