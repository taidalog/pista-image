# Add-FrameToImage

Adds frame around an image.

## Syntax

```
Add-FrameToImage
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

Get-ChildItem *.jpg | Add-FrameToImage -LineWidth 2 @color
```
## Parameters

## Inputs

## Outputs
