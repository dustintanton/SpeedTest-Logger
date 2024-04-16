# Define the output file
$outputFile = "C:\path to folder\ookla-speedtest-1.2.0-win64\speedtest_log.csv"

# Getting Timestamp variable
$currentTimestamp = Get-Date -Format "MM-dd-yyyy HH:mm:ss"

# Check if the output file exists, and if not, create it with headers
if (-not (Test-Path $outputFile)) {
    "TimeStamp,Server Name,Server ID,Ping Latency,Ping Jitter,Packet Loss,Download Bandwidth,Upload Bandwidth,Download Bytes,Upload Bytes,Result,,,,,,,,,,,,Download Speed MB/s,Upload Speed MB/s,Formula is cell/1048576" | Out-File $outputFile
}

# Function to run speedtest and parse results
function Perform-SpeedTest {
    # Specify the full path to the speedtest executable
    $speedtestExecutable = "C:\path to folder\ookla-speedtest-1.2.0-win64\speedtest.exe"
    $currentTimestamp = Get-Date -Format "MM-dd-yyyy HH:mm:ss"

    # Using the call operator (&) to execute the speedtest with full path
    $result = & $speedtestExecutable -f csv
    $result = $currentTimestamp + "," + $result.Trim()
    Write-Host $result
    $result | Out-File $outputFile -Append
    Write-Host "Speed test performed and logged."
}

# Main loop to perform the speed test every hour
Write-Host "Starting speed tests, press CTRL+C to stop."
while ($true) {
    Perform-SpeedTest
    # Wait for 3600 seconds (1 hour) before the next test
    Start-Sleep -Seconds 900
}
