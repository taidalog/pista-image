# Invoke-ImageTrimming

Trims an image.


## Syntax

```
Invoke-ImageTrimming
    -Path <String[]>
    -Top <Int32>
    -Right <Int32>
    -Bottom <Int32>
    -Left <Int32>
    [-Destination] <String>
    [-Name] <String>
    [<CommonParameters>]
```

```
Invoke-ImageTrimming
    -Path <String[]>
    -X <Int32>
    -Y <Int32>
    -Width <Int32>
    -Height <Int32>
    [-Destination] <String>
    [-Name] <String>
    [<CommonParameters>]
```

```
Invoke-ImageTrimming
    -Path <String[]>
    -Rectangle <Syste.Drawing.Rectangle>
    [-Destination] <String>
    [-Name] <String>
    [<CommonParameters>]
```

```
Invoke-ImageTrimming
    -Path <String[]>
    -Blank
    [-Color] <System.Drawing.Color>
    [-MarginTop] <Int32>
    [-MarginRight] <Int32>
    [-MarginBottom] <Int32>
    [-MarginLeft] <Int32>
    [-Destination] <String>
    [-Name] <String>
    [<CommonParameters>]
```


## Description


## Examples

### Example 1: Trim an image using pixels to cut

In this example `Invoke-ImageTrimming` uses the **Top**, **Right**, **Bottom** and **Left** parameters to specify trimming area. 100 pixels from the top, 120 pixels from the right, 380 pixels from the bottom, and 400 pixels from the left will be cut.

```ps1
Get-ChildItem *.jpg | Invoke-ImageTrimming -Top 100 -Right 120 -Bottom 380 -Left 400
```


### Example 2: Trim an image using Coordinates

In this example `Invoke-ImageTrimming` uses the **X**, **Y**, **Width** and **Height** parameters to specify trimming area. The pixel at (400, 100) will be the top left corner, and the area of 1400 pixels wide and 600 pixels high will be returned.

```ps1
Get-ChildItem *.jpg | Invoke-ImageTrimming -X 400 -Y 100 -Width 1400 -Height 600
```


### Example 3: Trim an image using Rectangle

In this example `Invoke-ImageTrimming` uses the **Rectangle** parameter to specify trimming area. The pixcel at (400, 100) will be the top left corner, and the area of 1400 pixels wide and 600 pixels high will be returned.

```ps1
$rectangle = [System.Drawing.Rectangle]::new(400, 100, 1400, 600)
Get-ChildItem *.jpg | Invoke-ImageTrimming -Rectangle $rectangle
```


### Example 4: Trim an image using Blank parameter and Color parameter

In this example `Invoke-ImageTrimming` uses the **Blank** parameter to trim blank area. The blank area can be specified with the **Color** parameter.

```ps1
Get-ChildItem *.jpg | Invoke-ImageTrimming -Blank -Color ([System.Drawing.Color]::White)
```


### Example 5: Trim an image using Blank parameter

In this example `Invoke-ImageTrimming` uses the **Blank** parameter to trim blank area. The blank area can be specified with the **Color** parameter. If **Color** is ommitted, the color of the pixel at (0, 0) will be used.

```ps1
Get-ChildItem *.jpg | Invoke-ImageTrimming -Blank
```


### Example 6: Trim an image using Blank parameter and Margin parameters

In this example `Invoke-ImageTrimming` uses the **Blank** parameter to trim blank area. **MarginTop**, **MarginRight**, **MarginBottom** and **MarginLeft** parameters specify pixels to keep.

```ps1
Get-ChildItem *.jpg | Invoke-ImageTrimming -Blank -MarginTop 20 -MarginRight 20 -MarginBottom 20 -MarginLeft 20
```


### Example 7: Trim an image and save in the specifued directory

In this example `Invoke-ImageTrimming` uses the **Destination** parameter to save the result in the specifued directory.

```ps1
Get-ChildItem *.jpg | Invoke-ImageTrimming -X 600 -Y 200 -Width 100 -Height 20 -Destination .\trimmed\
```


### Example 8: Trim an image and save in the specifued directory, using a scriptblock

In this example `Invoke-ImageTrimming` uses the **Destination** parameter to save the result in the specifued directory. **Destination** parameter accepts a scriptblock. In this case, each trimmed item will be saved in the 'trimmed' directory in the parent directory of each piped item.

```ps1
Get-ChildItem *.jpg | Invoke-ImageTrimming -X 600 -Y 200 -Width 100 -Height 20 -Destination { Join-Path $_.DirectoryName \trimmed\ }
```

|piped items|destination|
|---|---|
|C:\sample01.jpg|C:\trimmed\ |
|C:\test\sample01.jpg|C:\test\trimmed\ |


### Example 9: Trim an image and save with the specifued name

In this example `Invoke-ImageTrimming` uses the **Name** parameter to save the result with the specifued name. **Name** parameter accepts a scriptblock.

```ps1
Get-ChildItem *.jpg | Invoke-ImageTrimming -X 600 -Y 200 -Width 100 -Height 20 -Name { $_.BaseName + '_' + (Get-Date -Format 'yyyy-MM-dd-HH-mm-ss') + $_.Extension }
```


## Parameters

## Inputs

**System.IO.FileInfo**


## Outputs

**System.IO.FileInfo**
