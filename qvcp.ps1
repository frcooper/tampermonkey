function qvcp {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Word,

        [Parameter(Mandatory = $true, Position = 1)]
        [string]$Url
    )

    $originalTitle = $Host.UI.RawUI.WindowTitle

    try {
        $Host.UI.RawUI.WindowTitle = $Word

        $safeWord = ($Word -replace '[\\\/\:\*\?\"\<\>\|]', '_').Trim()

        $now    = Get-Date
        $folder = Join-Path 'X:\in\clips' ('{0:yyyy-MM}' -f $now)

        if (-not (Test-Path -LiteralPath $folder -PathType Container)) {
            try {
                New-Item -ItemType Directory -Path $folder -Force -ErrorAction Stop | Out-Null
            }
            catch {
                throw "Unable to access output folder '$folder' : $_"
            }
        }

        $baseName   = $safeWord
        $baseFile   = Join-Path $folder ($baseName + '.mp4')
        $outputPath = $baseFile

        if ([System.IO.File]::Exists($baseFile)) {
            $i = 2
            do {
                $candidate = Join-Path $folder ("{0}-{1}.mp4" -f $baseName, $i)
                if (-not [System.IO.File]::Exists($candidate)) {
                    $outputPath = $candidate
                    break
                }
                $i++
            } while ($true)
        }

        & ffmpeg `
            -i $Url `
            -c copy `
            -metadata title="$Word" `
            -metadata comment="$Url" `
            $outputPath
    }
    finally {
        $Host.UI.RawUI.WindowTitle = $originalTitle
    }
}