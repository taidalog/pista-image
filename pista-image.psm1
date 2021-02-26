Get-ChildItem -Path $PSScriptRoot -Directory | 
    Get-ChildItem -File | 
    Where-Object {$_.Extension -eq '.psm1'} | 
    Foreach-Object {Import-Module $_.FullName}

Export-ModuleMember -Function * -Alias *