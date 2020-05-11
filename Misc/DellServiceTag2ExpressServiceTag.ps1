## This Script has been written for converting a Dell Service Tag into Express service Tag
## Author : Prakash Kumar (prakash82x@gmail.com) May 22th 2018
## www.adminthing.blogspot.com
## Please use this script at your own risk.
##
## Usage:
## Since this has a function so it needs to be loaded into the memory of PS console by dot sourcing it: **
## PS C:\> . ./ConvertTo-ExpressServiceTag.ps1
## PS C:\> Convertto-ExpressServiceTag A1B2C3D

Function ConvertTo-ExpressServiceTag{
param(
    [Parameter(
    Mandatory=$True,
    Position=0,
    ValueFromPipeline=$True,
    ValueFromPipelineByPropertyName=$True ,
    HelpMessage="A Valid Service tag as input is needed !!")][System.String]$ValB36 )
   
    Begin{}
   
        Process{
        $Range = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        $ca = $ValB36.ToUpper().ToCharArray()
        [System.Array]::Reverse($ca)
        [System.Int64]$ValB10=0
    
        $i=0
        foreach($c in $ca){
            $ValB10 += $Range.IndexOf($c) * [System.Int64][System.Math]::Pow(36,$i)
            $i+=1
        }

        Write-Host -ForegroundColor Yellow "`nService Tag `t `t `t : `t $ValB36 `nExpress Service Tag `t :`t $ValB10"
    }

    End{}
    
}