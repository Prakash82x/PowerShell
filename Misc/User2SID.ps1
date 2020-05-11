######################################################################################################################################################
# Use this script to translate User Name to SID, SID to UserName and Local user to SID.                                                              #
# Script Written by Prakash Kumar (6th April 2020)                                                                                                   #
# Reference from https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-powershell-1.0/ff730940(v=technet.10)?redirectedfrom=MSDN #
######################################################################################################################################################
param($SID,
$ADUSER,
$LOCALUSER)

#Enter Your Domain Name Here:
$DOMAIN = "DomainName"

if ($SID)
    {
        $UserSID = New-Object System.Security.Principal.SecurityIdentifier("$SID")
        $UserID = $UserSID.Translate( [System.Security.Principal.NTAccount])
        Write-output "$SID `t : $UserID"
    }
ElseIf ($ADUSER)
    {
        $UserID = New-Object System.Security.Principal.NTAccount("$DOMAIN", "$ADUSER")
        $strSID = $UserID.Translate([System.Security.Principal.SecurityIdentifier])
        Write-output "$ADUSER `t : $strSID"
        
    }
ElseIf ($LOCALUSER)
    {
        $UserID = New-Object System.Security.Principal.NTAccount("$LOCALUSER")
        $strSID = $UserID.Translate([System.Security.Principal.SecurityIdentifier])
        Write-output "$LOCALUSER `t : $strSID"

    }