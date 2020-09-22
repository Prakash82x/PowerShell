$ServersToBeChecked = get-content C:\temp\servers.txt            # Server List to check for Disk space utilization
$Today = Get-Date -Format yyyy-MM-dd                             # Date Variable to be used in Report FileName  
$freeSpaceFileName = "C:\temp\Freespace_$Today.htm"              # Filename of the Report
$CreateFile = New-Item -ItemType file $freeSpaceFileName  -Force # Create a Blank FileName for the report
$TimeStamp  = $date = ( get-date ).ToString('yyyy-MM-dd hh:mm')  # TimeStamp to be used in the report
$ServerData=''

#HTML Header
$Header = @"
<html>
<head>
<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>
<title>Volume Usage Report</title>
<STYLE TYPE="text/css">
<!--
td {
font-family: Tahoma;
font-size: 14px;
border-top: 1px solid #999999;
border-right: 1px solid #999999;
border-bottom: 1px solid #999999;
border-left: 1px solid #999999;
padding-top: 0px;
padding-right: 0px;
padding-bottom: 0px;
padding-left: 0px;
}
body {
margin-left: 5px;
margin-top: 5px;
margin-right: 0px;
margin-bottom: 10px;
-->
"@

#HTML CSS Style
$Style = @"
</style>
</head>
<body>
<table width='75%'>
<tr bgcolor='#F0F8FF'>
<td colspan='9' height='25'  width=5% align='left'>
<font face='tahoma' color='#000000' size='5'><center>FileSystem Usage of servers</center></font>
</td>
<tr bgcolor='#1DACD6'>
<td colspan='9' height='25'  width=5% align='left'>
<font face='tahoma' color='#000000' size='4'><center>Volume Usage Report as on $TimeStamp </center></font>
</td>
</tr>
<tr bgcolor=#8C92AC>
<td><b>Server Name</b></td>
<td><b>Drive</b></td>
<td><b>Drive Label</b></td>
<td><b>Capacity(GB)</b></td>
<td><b>Used(GB)</b></td>
<td><b>Free(GB)</b></td>
<td><b>Free % </b></td>
<td><b>Status </b></td
</tr>
"@

#HTML footer
$Footer = @"
</tr>
</table>
</body>
</html>
"@

#Loop through servers and applicable Fixed volumes available on it.
$ServersToBeChecked | foreach {
$serverName = $_
# Check Filesystems with Drive Type 3 (Fixed Disks only)
$devices = (gwmi win32_logicaldisk -ComputerName $serverName | ? {$_.drivetype -eq 3}).deviceid

if ($devices -match '[a-zA-Z]')
    {
     $devices | foreach {
     $DriveLetter = $_ 
     $LOW = 20
     $WARNING = 10
     $CRITICAL = 5
     $status=''
$diskinfo= Get-WmiObject -Class Win32_LogicalDisk -Filter "DeviceID='$DriveLetter'" -ComputerName $serverName

ForEach ($disk in $diskinfo) { 
If ($diskinfo.Size -gt 0) {$percentFree = [Math]::round((($diskinfo.freespace/$diskinfo.size) * 100))}
Else {$percentFree = 0} 


#Process each disk in the collection and write 
$server=$disk.__Server
$deviceID=$disk.DeviceID 
$Volume=$disk.VolumeName 
$TotalSizeGB=[math]::Round(($disk.Size /1GB),2) 
$UsedSpaceGB=[math]::Round((($disk.Size - $disk.FreeSpace)/1GB),2) 
$FreeSpaceGB=[math]::Round(($disk.FreeSpace / 1GB),2) 
$FreePer=("{0:P}" -f ($disk.FreeSpace / $disk.Size)) 
       

#Check if the disk needs to be flagged as Good, Warning or Critical based on Usage 
If ($percentFree -le  $CRITICAL) { $status = "Critical"; $bgcolor="#FF4000" } 
ElseIf ($percentFree -le $WARNING -AND $percentFree -ge $CRITICAL) { $status = "Warning"; $bgcolor="#FFBF00" } 
ElseIf ($percentFree -le $LOW -AND $percentFree -ge $WARNING) { $status = "Low"; $bgcolor="#FFFF00" } 
Else { $status = "Good"; $bgcolor="#40FF00" } 


#Start appending volume Statistics to a Variable as HTML
$servers = ''
$Servers+="`n<tr>"
$Servers+="`n<td >$server</td>"
$Servers+="`n<td bgcolor='$bgcolor' >$deviceID</td>"
$servers+="`n<td >$Volume</td>"
$Servers+="`n<td >$TotalSizeGB</td>"
$Servers+="`n<td >$UsedSpaceGB</td>"
$Servers+="`n<td bgcolor='$bgcolor' >$FreeSpaceGB</td>"
$Servers+="`n<td bgcolor='$bgcolor' >$FreePer</td>"
$Servers+="`n<td bgcolor='$bgcolor' >$status</td>"
$Servers+="`n</tr>"

#Write-Output "$server `t$deviceID `t$Volume `t$TotalSizeGB `t$UsedSpaceGB `t$FreeSpaceGB `t$FreePer `t$status"
}
$ServerData+=$servers
}
}
}

#Generate HTML File as $freespaceFileName
$Header > $freeSpaceFileName
$Style >>$freeSpaceFileName
$ServerData >>$freeSpaceFileName
$Footer >>$freeSpaceFileName
