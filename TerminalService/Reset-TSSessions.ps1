########################################################################################
## Written by Prakash Kumar to Query and reset Remote RDP Sessions on Windows Servers ##
## Usage : .\Reset-TSSessions.ps1 -UserName My_User_Name -ServerName MyServerName     ##
########################################################################################
param ($UserName,
$ServerName)

Write-host -ForegroundColor Green `nQuerying Sessions for $UserName on $ServerName
$Sessions = qwinsta /server:$ServerName
$MySessions = $Sessions |Select-String "$UserName"
$FinalSessions = $MySessions -replace ' {2,}', ',' -split ","

if ($MySessions -match "$UserName")
    {
        $User = $FinalSessions[1]
        $SessionID = $FinalSessions[2]
        $SessionState = $FinalSessions[3]
        Write-host `n"UserName        SessionID        SessionState"
        Write-host "--------        ---------        ------------"
        Write-Host "$User   $SessionID                $SessionState"
        Write-host "--------        ---------        ------------"
        Write-host -ForegroundColor Red `n"Resetting Session for`t $User on $env:COMPUTERNAME : Session ID $SessionID : SessionState $SessionState"
        rwinsta /server:$ServerName $SessionID
}

Else
    {
        Write-host -ForegroundColor Yellow No Sessions Exist for user $UserName on Server $ServerName

}
