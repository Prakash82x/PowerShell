#####################################################################################################################################################
# Script to find out last reboot event from list of servers in servers.txt, it searchesin System Events on servers and looks for event id 1074:     #
# Prints ServerName, Time when the Event got created, Event ID, Event Severity and the message which contains user name who initiated the reboot:   #
# To get the output in CSV file just replace "|Out-Gridview" at the fourth last line with "| Export-Csv -NoTypeInformation ServerRebootEvents.csv": #
# This script only queries the event logs and does not perform any write/modification anywhere on the servers, Use it at your own wish.             #
# Written by Prakash Kumar Prakash82x@gmail.com on Thursday, March 9, 2017 11:48:55 AM                                                              #
#####################################################################################################################################################

$ErrorServers = @()
Get-Content .\Servers.txt |foreach {
$ComputerName = $_
if (Test-Connection -ComputerName $ComputerName -Count 1 -ErrorAction SilentlyContinue ) {
    Write-Host -ForegroundColor Yellow "Reading Eventlogs on $ComputerName"
    try { Get-WinEvent -computername $ComputerName -FilterHashtable @{logname="System";id="1074"} -MaxEvents 1  -ErrorAction Stop |select @{N='ServerName';E={"$ComputerName"}},TimeCreated,Id,LevelDisplayName,Message
         }
    catch [Exception] {
            if ($_.Exception -match "No events were found that match the specified selection criteria") {
                Write-Host -ForegroundColor Red "No events found of selected event Search criteria on Server $ComputerName"
                }
    }
}
Else { $ErrorServers += "$ComputerName" }
} |Out-GridView
Write-Host " "
Write-Warning "following Servers are not Pingable"
$ErrorServers