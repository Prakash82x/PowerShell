####################################################################################################
#This PowerShell script can be used to fetch list of users and their Group membership along with   #
#few other details from remote Windows servers.Mention list of servers in a text file called       #
#Servers.txt and execute it. It takes less time to run against each server specified in the        # 
#servers.txt by first testing connection to them and only if the connection test passes it goes on #
#fetching user lists else it skips that server.                                                    #  
#                                                                                                  # 
#Read List of servers from a Text file and fetch all local users from the servers mentioned in it. #
#List of local users from servers is exported in CSV file at the same location.                    #
#Written by Prakash Kumar 12:58 PM 8/5/2015                                                        #
####################################################################################################

get-content "Servers.txt" | foreach-object {
    $Comp = $_
	if (test-connection -computername $Comp -count 1 -quiet)
{
                    ([ADSI]"WinNT://$comp").Children | ?{$_.SchemaClassName -eq 'user'} | %{
                    $groups = $_.Groups() | %{$_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null)}
                    $_ | Select @{n='Server';e={$comp}},
                    @{n='UserName';e={$_.Name}},
                    @{n='Active';e={if($_.PasswordAge -like 0){$false} else{$true}}},
                    @{n='PasswordExpired';e={if($_.PasswordExpired){$true} else{$false}}},
                    @{n='PasswordAgeDays';e={[math]::Round($_.PasswordAge[0]/86400,0)}},
                    @{n='LastLogin';e={$_.LastLogin}},
                    @{n='Groups';e={$groups -join ';'}},
                    @{n='Description';e={$_.Description}}
  
                 } 
           } Else {Write-Warning "Server '$Comp' is Unreachable hence Could not fetch data"}
     }|Export-Csv -NoTypeInformation LocalUsers.csv 
