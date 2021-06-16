Param($LastDays,
$VMName)
$Today = Get-date -Format yyyy_dd_MM
New-Item -ItemType Directory c:\temp\VMPerfReports_$Today\$VMName -Force |Out-Null
Write-Host -ForegroundColor Yellow "Retrieving Stats for VM `t `t`t`t`t`t`t $VMName"

Write-Output "Getting CPU Usage report for last $LastDays days for `t`t $VMName"
Get-Stat -entity $VMName -Stat "cpu.usage.average" -Start (Get-Date).AddDays(-$LastDays) -IntervalMins 30 | select  Entity, MetricID, IntervalSecs, TimeStamp, Value, Unit |Export-Csv -NoTypeInformation "c:\temp\VMPerfReports_$Today\$VMName\CPUUsage.csv"

Write-Output "Getting Memory Usage report for last $LastDays days for `t $VMName"
Get-Stat -entity $VMName -Stat "mem.usage.average" -Start (Get-Date).AddDays(-$LastDays) -IntervalMins 30 | select  Entity, MetricID, IntervalSecs, TimeStamp, Value, Unit |Export-Csv -NoTypeInformation "c:\temp\VMPerfReports_$Today\$VMName\MemUsage.csv"

Write-Output "Getting Disk Usage report for last $LastDays days for `t`t $VMName"
Get-Stat -entity $VMName -Stat "disk.usage.average" -Start (Get-Date).AddDays(-$LastDays) -IntervalMins 30 | select Entity, MetricID, IntervalSecs, TimeStamp, Value, Unit |Export-Csv -NoTypeInformation "c:\temp\VMPerfReports_$Today\$VMName\DiskUsage.csv"

Write-Output "Getting Network Usage report for last $LastDays days for `t $VMName"
Get-Stat -entity $VMName -Stat "net.usage.average" -Start (Get-Date).AddDays(-$LastDays) -IntervalMins 30 | select  Entity, MetricID, IntervalSecs, TimeStamp, Value, Unit |Export-Csv -NoTypeInformation "c:\temp\VMPerfReports_$Today\$VMName\NetworkUsage.csv"