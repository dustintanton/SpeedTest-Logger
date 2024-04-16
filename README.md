# Speedtest Logger

This PowerShell script performs periodic Ookla Speedtests and logs the results to a CSV file.

## Description

This script automates the process of conducting speed tests using Ookla's Speedtest CLI tool and logs the results to a CSV file. It is designed to run indefinitely, performing a speed test every 15 minutes.

## Prerequisites

- Windows OS
- Ookla Speedtest CLI tool (not included in the repository)
- PowerShell

## Installation

1. Clone or download this repository to your local machine.
2. Download the Ookla Speedtest.exe CLI tool and place in the same folder as this project
3. Ensure that PowerShell execution policy allows script execution.
4. Modify the `$outputFile` variable in the script to specify the desired location and name for the log file.
5. Run the script by executing it in PowerShell.

## Usage

- Execute the script in PowerShell.
- Press `CTRL+C` to stop the script.

## Configuration

- Modify the `$outputFile` variable to specify the desired location and name for the log file.
- Adjust the interval of speed tests by changing the value passed to `Start-Sleep` in the main loop.

## File Structure

- `speedtest_log.csv`: CSV file where the speed test results are logged.
- `speedtest.ps1`: PowerShell script to perform speed tests and log results.

## Sample Log Format

The log file (`speedtest_log.csv`) has the following format:

TimeStamp,Server Name,Server ID,Ping Latency,Ping Jitter,Packet Loss,Download Bandwidth,Upload Bandwidth,Download Bytes,Upload Bytes,Result,,,,,,,,,,,,Download Speed MB/s,Upload Speed MB/s,Formula is cell/1048576


## License

This project is licensed under the [MIT License](LICENSE).
