#############################################################
#
# POWERSHELL: EBS Automatic Snapshot - Part #1: DISKSHADOW Component
# By Casey Labs Inc. Diskshadow commands contributed by phiber232.
# Github repo: https://github.com/CaseyLabs/aws-ec2-ebs-automatic-snapshot-powershell
#
############################################################

Set-StrictMode -Version Latest

# User variables: Set file locations
$diskshadowscript = "C:\zVSS\diskshadow.txt"
$runbackupscript = "C:\zVSS\2-run-backup.cmd"

# Global Variables
$nl = [Environment]::NewLine
$scriptTxt = ""

# Gather list of local disks that aren't instance stores
$drives = Get-CimInstance Win32_LogicalDisk | where {$_.VolumeName -notlike "TemporaryStorage*"} | where { $_.DriveType -like "3"} | Select-Object DeviceId

# Output diskshadow commands to a text file
$scriptTxt = $scriptTxt + "begin backup" + $nl
$drives | ForEach-Object { $scriptTxt = $scriptTxt + "add volume " + $_.DeviceID  + $nl }
$scriptTxt = $scriptTxt + "create"  + $nl
$scriptTxt = $scriptTxt + "exec $runbackupscript" + $nl
$scriptTxt = $scriptTxt + "end backup" + $nl
$scriptTxt | Set-Content $diskshadowscript

# Run diskshadow with our new script file
diskshadow /s $diskshadowscript