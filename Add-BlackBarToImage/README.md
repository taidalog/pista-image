# Add-BlackBarToImage

Adds a black bar to an image in order to hide something in the image.


## Syntax

```
Add-BlackBarToImage
    -Path <String[]>
    -X1 <Int32>
    -Y1 <Int32>
    -X2 <Int32>
    -Y2 <Int32>
    [-Color] <Color>
    [-UseBackgroundColor]
    [-Destination] <String>
    [-Name] <String>
    [<CommonParameters>]
```

```
Add-BlackBarToImage
    -Path <String[]>
    -Point1 <Point>
    -Point2 <Point>
    [-Color] <Color>
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
    [-Color] <Color>
    [-UseBackgroundColor]
    [-Destination] <String>
    [-Name] <String>
    [<CommonParameters>]
```

```
Add-BlackBarToImage
    -Path <String[]>
    -Rectangle <Rectangle>
    [-Color] <Color>
    [-UseBackgroundColor]
    [-Destination] <String>
    [-Name] <String>
    [<CommonParameters>]
```


## Description

## Examples

### Example 1:

```ps1
Get-ChildItem *.jpg | Add-BlackBarToImage -X1 154 -Y1 65 -X2 1720 -Y2 95
```


### Example 2:

```ps1
$point1 = [System.Drawing.Point]::new(154, 65)
$point2 = [System.Drawing.Point]::new(1720, 95)

Get-ChildItem *.jpg | Add-BlackBarToImage -Point1 $point1 -Point2 $point2
```


### Example 3:

```ps1
Get-ChildItem *.jpg | Add-BlackBarToImage -X 154 -Y 65 -Width 1566 -Height 30
```


### Example 4:

```ps1
$rectangle = [System.Drawing.Rectangle]::new(154, 65, 1566, 30)

Get-ChildItem *.jpg | Add-BlackBarToImage -Rectangle $rectangle
```


### Example 5:

```ps1
Get-ChildItem *.jpg | Add-BlackBarToImage -X1 154 -Y1 65 -X2 1720 -Y2 95 -UseBackgroundColor
```


### Example 6:

```ps1
Get-ChildItem *.jpg | Add-BlackBarToImage -X1 154 -Y1 65 -X2 1720 -Y2 95 -Color ([System.Drawing.Color]::White)
```


### Example 7:

```ps1
$color = [System.Drawing.Color]::FromArgb(255, 1, 36, 86)

Get-ChildItem *.jpg | Add-BlackBarToImage -X1 154 -Y1 65 -X2 1720 -Y2 95 -Color $color
```


### Example 8:

```ps1
Get-ChildItem *.jpg | Add-BlackBarToImage -X1 154 -Y1 65 -X2 1720 -Y2 95 -Destination .\blackbar\
```


### Example 9:

```ps1
Get-ChildItem *.jpg | Add-BlackBarToImage -X1 154 -Y1 65 -X2 1720 -Y2 95 -Destination { Join-Path $_.DirectoryName \blackbar\ }
```


### Example 10:

```ps1
Get-ChildItem *.jpg | Add-BlackBarToImage -X1 154 -Y1 65 -X2 1720 -Y2 95 -Name { $_.BaseName + '_' + (Get-Date -Format 'yyyy-MM-dd-HH-mm-ss') + $_.Extension }
```


## Parameters

## Inputs

**System.IO.FileInfo**


## Outputs

**System.IO.FileInfo**
