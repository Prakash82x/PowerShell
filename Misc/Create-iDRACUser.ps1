Function Create-iDRACUser {
param($DracName,
[string]$LogonPassword,
[string]$SetPassword)

#LogFile Path
$LogPath = "C:\Work\Logs\iDRACPasswordset.txt"

    #Display Working Drac and start processing
    write-host $DracName -ForegroundColor Green
    
    #Test Connectivity of iDRAC
    $Svctag = racadm --nocertwarn -r $DracName -u root -p $LogonPassword getsvctag
    
    if ($LASTEXITCODE -eq 0)
         {
            #Create User
            Write-Output "$DracName : Creating User " | Tee-Object $LogPath -Append 
            racadm --nocertwarn -r $DracName -u root -p $LogonPassword set idrac.users.8.username computeadmin | Tee-Object $LogPath -Append |Out-Null
                    
            #Set User Password
            write-output "$DracName : Setting Password " | Tee-Object $LogPath -Append
            racadm --nocertwarn -r $DracName -u root -p $LogonPassword set idrac.users.8.password $SetPassword | Tee-Object $LogPath -Append |Out-Null
            
            #Enable User
            Write-Output "$DracName : Enabling User " | Tee-Object $LogPath -Append
            racadm --nocertwarn -r $DracName -u root -p $LogonPassword set idrac.users.8.enable 1 | Tee-Object $LogPath -Append |Out-Null
            
            #Set User Privilege as Administrator
            write-output "$DracName : Setting Privilege " | Tee-Object $LogPath -Append
            racadm --nocertwarn -r $DracName -u root -p $LogonPassword set idrac.users.8.privilege 0x1ff | Tee-Object $LogPath -Append |Out-Null
         }
    Else 
        {
            Write-Host -ForegroundColor Yellow $DracName : not accessible 
            Write-Output "Error working on : $DracName " |Tee-Object $LogPath -Append |Out-Null
        }
    Remove-Variable Svctag -ErrorAction SilentlyContinue
}
