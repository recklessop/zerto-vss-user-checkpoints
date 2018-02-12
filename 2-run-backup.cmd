REM #############################################################
REM #
REM # POWERSHELL: Zerto VSS User Checkpoints - Part #3: Zerto user Checkpoint Component
REM # By Justin Paul
REM # Github repo: https://github.com/recklessop/zerto-vss-checkpoint
REM #############################################################

REM # Intermediary batch script - called by the Disk Shadow script.

set USERPROFILE=C:\Users\Administrator\
powershell.exe -ExecutionPolicy Bypass -file "C:\zVSS\3-zerto-checkpoint.ps1"
