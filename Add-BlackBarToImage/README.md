# Add-BlackBarToImage

Adds a black bar to an image in order to hide something in the image.

## Syntax

```
Add-BlackBarToImage
    -Path <string[]>
    [-LineWidth] <int>
    [-Alpha] <int>
    [-Red] <int>
    [-Green] <int>
    [-Blue] <int>
    [-Inner]
    [<CommonParameters>]
```

## Description

## Examples
```ps1
Get-ChildItem *.jpg | Add-FrameToImage -LineWidth 2 -Alpha 40 -Blue 128
```

```ps1
$color = @{
    Alpha = 128
    Red = 100
    Green = 100
    Blue = 100
}

$coordinates = @{
    TopLeftX = 200
    TopLeftY = 50
    BottomRightX = 1600
    BottomRightY = 80
}

Get-ChildItem *.jpg | Add-BlackBarToImage @color @coordinates
```

```ps1
$color = @{
    Alpha = 128
    Red = 100
    Green = 100
    Blue = 100
}

$coordinates = @{
    CTop = 50
    CRight = 1600
    CBottom = 80
    CLeft = 200
}

Get-ChildItem *.jpg | Add-BlackBarToImage @color @coordinates
```

## Parameters

## Inputs

## Outputs
