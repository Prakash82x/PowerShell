#####################################################################################
# This Script can be used to enable AD integration on Dell iDRACs so that Members   #
# of a specific AD Group can logon to the iDRAC with their domain id.               #
# Just fill in the details below in the Set variables section.                      #
# Example below:                                                                    #   
# .\iDRAC-SetADConfig.ps1 -iDRACName iDRAC.mydomain.com -User root -Password calvin #
#####################################################################################

Param($iDRACName,                          
$User,                                      
$Password)                                  
$ErrorActionPreference = "SilentlyContinue"

#==================================================================================
#Set Necessary Variables to be used in AD Configuration of the iDRAC.
#==================================================================================

$DNS1 = "IP Address DNS1"
$DNS2 = "IP Address DNS2"
$DomainController = "dc.mydomain.com"
$GlobalCatalog = "dc.mydomain.com"
$Domain = "mydomain.com"
$AuthorizedGroup = "iDRAC-ADGroup"

#==================================================================================
#Check if remote iDRAC Commands are available on the server.
#==================================================================================

if (Test-Path 'C:\Program Files\Dell\SysMgt\rac5\racadm.exe')

#==================================================================================    

    {
        #==================================================================================
        #Test supplied credentials if it works before starting to process further.
        #==================================================================================

        racadm --nocertwarn -r $iDRACName -u $User -p $Password getsvctag > null
        if ($LASTEXITCODE -eq 0)

        #==================================================================================
        #If Credentials are working fine then process with configuration.
        #==================================================================================

            {
                    
                Write-host -ForegroundColor Green "Working on iDRAC : $iDRACName"
                racadm --nocertwarn -r $iDRACName -u $User -p $Password set iDRAC.IPv4.DNS1 $DNS1
                racadm --nocertwarn -r $iDRACName -u $user -p $Password set iDRAC.IPv4.DNS2 $DNS2
                racadm --nocertwarn -r $iDRACName -u $user -p $Password set idrac.ActiveDirectory.Enable 1
                racadm --nocertwarn -r $iDRACName -u $user -p $Password set idrac.ActiveDirectory.DomainController1 $DomainController
                racadm --nocertwarn -r $iDRACName -u $user -p $Password set idrac.ActiveDirectory.GlobalCatalog1 $GlobalCatalog
                racadm --nocertwarn -r $iDRACName -u $user -p $Password set idrac.ActiveDirectory.Schema 2
                racadm --nocertwarn -r $iDRACName -u $user -p $Password set idrac.ADgroup.1.Domain $Domain
                racadm --nocertwarn -r $iDRACName -u $user -p $Password set idrac.ADgroup.1.Name $AuthorizedGroup
                racadm --nocertwarn -r $iDRACName -u $user -p $Password set idrac.ADgroup.1.Privilege 0x1ff
                racadm --nocertwarn -r $iDRACName -u $user -p $Password set idrac.UserDomain.1.Name $Domain
                
            }
        #==================================================================================
        #If supplied Credentials did not work then abort the process.
        #==================================================================================

        Else
            {
                Write-Host -ForegroundColor Yellow "Error connecting to iDRAC : $iDRACName"
            }
    
    }
#==================================================================================
# Racadm remote commands are not available on the server
#==================================================================================

Else
    {
        Write-Host -ForegroundColor Yellow -BackgroundColor Red "Racadm commands/binaries are not available on the server, before executing this script download and install it from here "https://www.dell.com/support/home/us/en/04/drivers/driversdetails?driverid=n3gc9""
    }