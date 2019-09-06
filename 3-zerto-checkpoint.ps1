#############################################################
#
# POWERSHELL: Zerto VSS User Checkpoints - Part #3: Zerto user Checkpoint Component
# By Justin Paul
# Github repo: https://github.com/recklessop/zerto-vss-checkpoint
#############################################################

Import-WinModule Microsoft.PowerShell.Management

## Set Variables
$ZVMIP = "172.16.1.20"
$ZVMUSER = "administrator@vsphere.local"
$ZVMPWDFile = "c:\encrypted_password1.txt"
$VPGName = "Z6to7LTR"


Set-StrictMode -Version Latest
$nl = [Environment]::NewLine
$volume_list = @()
$snapshot_list = @()
$global:log_message = $null
$hostname = hostname
$today = Get-Date -format yyyy-MM-dd


## Function Declarations

# Check if an event log source for this script exists; create one if it doesn't.
function logsetup {
	if (!([System.Diagnostics.EventLog]::SourceExists('User-VSS-Checkpoint')))
		{ New-Eventlog -LogName "Application" -Source "User-VSS-Checkpoint" }
}

# Write to console and Application event log (event ID: 1337)
function log ($type) {
	Write-Host $global:log_message
	Write-EventLog -LogName Application -Source "User-VSS-Checkpoint" -EntryType $type -EventID 9669 -Message $global:log_message
}

# Pre-requisite check: make sure AWS CLI is installed properly.
function prereqcheck {
	if ((Get-Command "Connect-ZertoServer" -ErrorAction SilentlyContinue) -eq $null) {
		$global:log_message = "Unable to find ZertoPSWrapper commands in your PATH." + $nl + "Visit https://www.powershellgallery.com/packages/ZertoApiWrapper to download the PowerShell Module."
		log "Error"
		break 
	}
	if (!$ZVMPWDFile) {
		$global:log_message = "Encrypted Password File is NULL." + $nl + "Please review Setup instructions."
		log "Error"
		break 
	}
}

function loginzerto {
    # get password from file and create credential object
    $encrypted = Get-Content $ZVMPWDFile | ConvertTo-SecureString
    $credential = New-Object System.Management.Automation.PsCredential($ZVMUSER, $encrypted)

    connect-ZertoServer $ZVMIP -Credential $credential

    
    if(!$?) {
        $global:log_message = "Unable to login to Zerto Virtual Manager."
        log "Error"
		break
    }
}

function insertcheckpoint {
    $msg = "Inserted by VSS Script on host: " + $($hostname)
    $checkpointId = Checkpoint-ZertoVpg -vpgName $VPGName -checkpointName $msg

    if(!$checkpointId) {
        $global:log_message = "Unable to insert Zerto checkpoint."
        log "Error"
		break
    } else {
        $global:log_message = "Checkpoint ID:" + $nl + $($checkpointId) + $nl + "Inserted Successfully."  
    }
}

function logoutzerto {
    Disconnect-ZertoServer
}

## START COMMANDS

# Initialization functions
logsetup
prereqcheck

# worker functions
loginzerto
insertcheckpoint
logoutzerto

# Write output to Event Log
log "Info"
write-host "Script complete. Results written to the Event Log (check under Applications, Event ID 9669)."