# VSS Usercheckpoint Setup Information

## Powershell Core 6.x

You will need to install powershell core on your system.

If you do not have powershell core installed you can run this command in a command prompt or powershell 5 window

iex "& { $(irm https://aka.ms/install-powershell.ps1) } -UseMSI"

## Install 3rd Party Modules

We need the Zerto REST API Wrapper module.

And the Windows Compatibility Modules

Install-Module -Name WindowsCompatibility

## Create an encrypted password file

To store your ZVM credentials we will create an encrypted password file. Run the following commands in Powershell to create the file.

$credential = Get-Credential
$credential.Password | ConvertFrom-SecureString | Set-Content c:\zvss\encrypted_password1.txt

If you want to save the file somewhere besides the c:\zvss directory check it in the command above and in the 3-zerto-checkpoint.ps1 script

## Update 3-zerto-checkpoint.ps1

Open the step 3 script and check the variables at the top to the appropriate settings for your environment.

## Manual Run

In powershell core, manually run step 1 to make sure everything is working.

cd c:\zvss
.\1-start-zerto-checkpoint.ps1

## Schedule future runs

You can schedule the above command via Windows Scheduled tasks in order to run it often.