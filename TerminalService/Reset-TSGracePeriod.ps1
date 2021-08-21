# This Script is intended to be used for Querying remaining time and resetting Terminal Server (RDS) Grace Licensing Period to Default 120 Days.
## Developed by Prakash Kumar (prakash82x@gmail.com) May 28th 2016
## www.adminthing.blogspot.com
## Disclaimer: Please test this script in your test environment before executing on any production server.
## Author will not be responsible for any misuse/damage caused by using it.
Param(
        [Parameter(Mandatory=$false)] [Switch]$Force
     )

Clear-Host
$ErrorActionPreference = "SilentlyContinue"

## Check if PowerShell Console has been launched As Administrator
if (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {

## Display current Status of remaining days from Grace period.
$GracePeriod = (Invoke-CimMethod -InputObject (Get-CimInstance -Namespace root/CIMV2/TerminalServices -ClassName Win32_TerminalServiceSetting) -MethodName GetGracePeriodDays).DaysLeft
Write-Host -fore Green ======================================================
Write-Host -fore Green 'Terminal Server (RDS) grace period Days remaining are' : $GracePeriod
Write-Host -fore Green ======================================================  
Write-Host

## Check if -Force Parameter has been used, If so, It will not prompt for Y/N while executing the script and will simply reset the Grace Period.
If (-not $Force) 
{
$Response = Read-Host "Do you want to reset Terminal Server (RDS) Grace period to Default 120 Days ? (Y/N)"
}

if ($Response -eq "Y" -or $Force) {
## Reset Terminal Services Grace period to 120 Days

$definition = @"
using System;
using System.Runtime.InteropServices; 
namespace Win32Api
{
	public class NtDll
	{
		[DllImport("ntdll.dll", EntryPoint="RtlAdjustPrivilege")]
		public static extern int RtlAdjustPrivilege(ulong Privilege, bool Enable, bool CurrentThread, ref bool Enabled);
	}
}
"@ 

Add-Type -TypeDefinition $definition -PassThru

$bEnabled = $false

## Enable SeTakeOwnershipPrivilege
$res = [Win32Api.NtDll]::RtlAdjustPrivilege(9, $true, $false, [ref]$bEnabled)

## Take Ownership on the Key
$key = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey("SYSTEM\CurrentControlSet\Control\Terminal Server\RCM\GracePeriod", [Microsoft.Win32.RegistryKeyPermissionCheck]::ReadWriteSubTree,[System.Security.AccessControl.RegistryRights]::takeownership)
$acl = $key.GetAccessControl()
$acl.SetOwner([System.Security.Principal.NTAccount]"Administrators")
$key.SetAccessControl($acl)

## Assign Full Controll permissions to Administrators on the key.
$rule = New-Object System.Security.AccessControl.RegistryAccessRule ("Administrators","FullControl","Allow")
$acl.SetAccessRule($rule)
$key.SetAccessControl($acl)

## Finally Delete the key which resets the Grace Period counter to 120 Days.
Remove-Item 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\RCM\GracePeriod'

write-host
Write-host -ForegroundColor Red 'Resetting, Please Wait....'
Start-Sleep -Seconds 10

}

Else 
    {
Write-Host
Write-Host -ForegroundColor Yellow '**You Chose not to reset Grace period of Terminal Server (RDS) Licensing'
  }

## Display Remaining Days again as final status
tlsbln.exe
$GracePost = (Invoke-CimMethod -InputObject (Get-CimInstance -Namespace root/CIMV2/TerminalServices -ClassName Win32_TerminalServiceSetting) -MethodName GetGracePeriodDays).DaysLeft
Write-Host
Write-Host -fore Yellow =====================================================
Write-Host -fore Yellow 'Terminal Server (RDS) grace period Days remaining are' : $GracePost
Write-Host -fore Yellow =====================================================

if ($Response -eq "Y" -or $Force)
        {
            Write-Host -Fore Cyan `n"IMPORTANT: Please make sure you restart following services manually to bring this reset in effect:`n`n* Remote Desktop Configuration Properties `n* Remote Desktop Services"
        }
} 
Else
{
    Write-Host -fore RED =====================================================
    Write-host -ForegroundColor RED *`0`0`0`0 Please Launch PowerShell as Administrator `0`0`0`0*
    Write-Host -fore RED =====================================================
}
## Cleanup of Variables
Remove-Variable * -ErrorAction SilentlyContinue
