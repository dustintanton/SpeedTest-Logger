Function PerformSpeedtest{
# Run Speedtest CLI and capture the output in JSON format
$jsonOutput = & ./speedtest.exe -f json | ConvertFrom-Json
 
# Extract and convert data
$downloadSpeed = [int]($jsonOutput.download.bandwidth * 8) / 1MB  # Convert to Mbps
$downloadSpeed = [int]$downloadSpeed.ToString("N0")
$uploadSpeed = [int]($jsonOutput.upload.bandwidth * 8) / 1MB    # Convert to Mbps
$uploadSpeed = [int]$uploadSpeed.ToString("N0")
$ping = [int]$jsonOutput.ping.latency
$pingJitter = [int]$jsonOutput.ping.jitter
$packetLoss = [int]$jsonOutput.packetLoss
$serverName = [string]$jsonOutput.server.name.replace("&", "")
$isp = [string]$jsonOutput.isp.replace("&", "")
$isp = [string]$isp.replace(" ", "_")

$fromIP = [string]$jsonOutput.interface.externalIp
$toIP = [string]$jsonOutput.server.ip
$isVPN = [bool]$jsonOutput.interface.isVpn



#list all results in shell
Write-Host "Test Results:"
$jsonOutput
Write-Host Download Speed: $downloadSpeed Mbps
Write-Host Upload Speed: $uploadSpeed Mbps
Write-Host

 # Format data into InfluxDB Line Protocol
 #$lineProtocolData = "speedtest,from_ip=$fromIP,to_IP=$toIP isp=$isp,download=$downloadSpeed"#,upload=$uploadSpeed,ping=$ping,ping_jitter=$pingJitter,packet_loss=$packetLoss"#,is_vpn=$isVPN"
 $lineProtocolData = "speedtest,from_ip=$fromIP,to_IP=$toIP isp=`"$isp`",download=$downloadSpeed,upload=$uploadSpeed,ping=$ping,ping_jitter=$pingJitter,packet_loss=$packetLoss,is_vpn=$isVPN"

#InfluxDB variables

# InfluxDB parameters
$influxDBUrl = 'X'
$influxDBUrl2 = 'X'
$bucket = 'X'
$org = 'X'
$token = 'X'

$writeApiUrl = "$influxDBUrl/api/v2/write?org=$org&bucket=$bucket&precision=s"
$writeApiUrl2 = "$influxDBUrl/api/v2/write?org=$org&bucket=$bucket&precision=s"

# Headers for Authorization and Content-Type
$headers = @{
    'Authorization' = "Token $token"
    'Content-Type' = 'text/plain; charset=utf-8'
}

 # Send the data
 try {
     Invoke-RestMethod -Uri $writeApiUrl -Method Post -Body $lineProtocolData -Headers $headers
    Write-Host "Data successfully written to InfluxDB via VPN."
    } catch {
    Write-Host "Failed to write data to InfluxDB via VPN: $_"
    }
try {
     Invoke-RestMethod -Uri $writeApiUrl2 -Method Post -Body $lineProtocolData -Headers $headers
    Write-Host "Data successfully written to InfluxDB via WAN."
    } catch {
    Write-Host "Failed to write data to InfluxDB via WAN: $_"
    }
}
while($True){
    Write-Host "Starting Speed Test"
    PerformSpeedtest
    # Wait for 3600 seconds (1 hour) before the next test
    Write-Host "Sleeping for 10 Minutes"
    Start-Sleep -Seconds 600
    }