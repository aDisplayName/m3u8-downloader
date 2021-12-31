Param (
    [Parameter(Mandatory=$true)]
    [Alias('Path')]
    [string] $InputPath,

    [Parameter(Mandatory=$true)]
    [Alias('Output')]
    [string] $OutputPath
)

Process {

    If( Test-Path -Path $OutputPath) {
        Write-Error File $OutputPath already exists.
        Exit;
    }

    $targetFile=[System.IO.File]::OpenWrite($OutputPath)
    try {
        Get-Content $InputPath |
        Where-Object { $_ -match '^[^#]+'} |
        ForEach-Object {
            Write-Host Downloading $_
            $tmp=New-TemporaryFile
            Start-BitsTransfer -Source $_ -Destination $tmp.FullName
   
            $inputSeg = [System.IO.File]::OpenRead($tmp.FullName)
            
   
            $inputSeg.CopyTo($targetFile);
            $inputSeg.Close();
            Remove-Item $tmp
        }
           
    }
    catch {
        
    }
    finally
    {
        $targetFile.Close();
    }
}