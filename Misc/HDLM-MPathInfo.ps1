# Developed by Prakash Kumar for fetching Multipath Information from Windows servers running with HDLM MPIO
# If used without any parameter, it will display information in simple way by processing information retrieved from HDLM binaries.
# There are three parameters defined in the script which can be used to get different type of information related to Multipathing
# Information retrieved with defined parameters are only raw (Plain Text) and needs to be interpreted properly.
# Use it at your own responsibility Developer will not be held responsible for any damage caused by running this script improperly.
# Developed on Jan-08-2019


Param(
  [Switch]$Verbose,
  [Switch]$PathOnly,
  [Switch]$Compact
)
if ($PathOnly )
    {
        dlnkmgr view -path -c
    }
elseif ($Verbose)
    {
        write-host "`n_________  Displaying HDLM agent Information _________`n"
            dlnkmgr view -sys
        write-host "`n__________    Displaying Luns Information    _________`n"
            dlnkmgr view -lu
        write-host "`n_________    Displaying Path Information     _________`n"
            dlnkmgr view -path
    }
elseif ($Compact)
    {
        write-host "`n_______________    Displaying HDLM Version    _______________`n"
            dlnkmgr view -sys |Select-String "HDLM Version"
        write-host "`n_________    Displaying Luns Information (Compact)   _________`n"
            dlnkmgr view -lu -c
        write-host "`n_________    Displaying Path Information (Compact)   _________`n"
            dlnkmgr view -path -c

    }
else 
    {
## HDLM Version
    $HDLMVer = dlnkmgr view -sys |Select-String "HDLM Version"
    $HDLMVer = $HDLMVer -replace " ","" -split ":"
    $HDLMVersion = "HDLMVersion   :: $($HDLMVer[1])"
    $Computername = "Computername  :: $env:COMPUTERNAME"

##Fetch total Number of Luns 
    $LunCount = dlnkmgr view -lu |Select-String "LUs"
    $Luns = $LunCount -replace " ","" -split ":"

  
##Online Paths Count
    $OnlinePaths = "OnlinePaths   :: $((dlnkmgr view -path |Select-String HITACHI |Select-String "online" |measure).Count)"

##Offline Paths Count
    $OfflineLuns = "OfflinePaths  :: $((dlnkmgr view -path |Select-String HITACHI |Select-String -NotMatch "online" |measure).Count)"

##First Line of "dlnkmgr view -lu -c" which contains Array Serial Number, first lun and its path details

    $Pathinfo = dlnkmgr view -lu -c | Select-String -notmatch "Product","HDLM command"
    $FirstLine = $Pathinfo -replace "\s{1,}",":" |select -First 1
    $info = ($firstline -split ":")

##Array Summary with Array Name, Array Serial Number and Total Number of Luns Presented
    $ArrayName = "ArrayName     :: $($info[0])" 
    $ArraySerial = "ArraySerial   :: $($info[1])"
    $TotalLuns = "TotalLuns     :: $($info[2])"

##Print Summary
    Write-Output "------------------------------------------------------------------------------------------"
    Write-Output "----------------------------------     Host Summary        -------------------------------"
    Write-Output "------------------------------------------------------------------------------------------"
    $Computername, $TotalLuns, $OnlinePaths, $OfflineLuns, $HDLMVersion, $ArrayName, $ArraySerial

##First Lun Details
    $FirstLun = Write-Output "LunID :: $($info[3]) `t DriveLetter :: $($info[4])`t TotalPaths :: $($info[5])`t OnlinePaths :: $($info[6])"

##Remaining Lines of "dlnkmgr view -lu -c" which contains Array Serial Number, remaining luns and their path details
    $otherpaths = $Pathinfo -replace "\s{1,}",":" |select -Skip 1
    $otherinfo = ($otherpaths -split ":")
    $allPaths = $Pathinfo |select -Skip 1 | foreach {$_ -replace "\s{1,}",":"} |foreach { $_ -replace "^:" }

    $Remaining = $allPaths | foreach { $Line = $_ -split ":"; write-output  "LunID :: $($Line[0]) `t DriveLetter :: $($Line[1]) `t TotalPaths :: $($Line[2])`t OnlinePaths :: $($Line[3]) "}

    Write-Output "------------------------------------------------------------------------------------------"
    Write-Output "----------------------------------     LUNs Summary       --------------------------------"
    Write-Output "------------------------------------------------------------------------------------------"
    Write-Output $FirstLun
    Write-Output $Remaining
    }