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
        $folder = ('X:\in\clips\{0:yyyy-MM}' -f $now)

        if (-not (Test-Path -LiteralPath $folder)) {
            New-Item -ItemType Directory -Path $folder -Force | Out-Null
        }

        $baseName   = $safeWord
        $outputPath = Join-Path $folder ($baseName + '.mp4')
        $i = 1

        while (Test-Path -LiteralPath $outputPath) {
            $outputPath = Join-Path $folder ("{0}-{1}.mp4" -f $baseName, $i)
            $i++
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