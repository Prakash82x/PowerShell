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
<tr bgcolor='#1DACD6'>
<td colspan='9' height='25'  width=5% align='left'>
<font face='tahoma' color='#000000' size='4'><center>Service Status on Server $env:COMPUTERNAME </center></font>
</td>
</tr>
<tr bgcolor=#8C92AC>
<td><b>Status</b></td>
<td><b>Name</b></td>
<td><b>DisplayName</b></td>
</tr>
"@

#HTML footer
$Footer = @"
</tr>
</table>
</body>
</html>
"@

$Services = Get-Service       
$html = $services | select Status, Name, DisplayName | ConvertTo-Html

$html1 = $html |select -Skip 8 |select -SkipLast 2
$final = $html1 -replace ">Running"," bgcolor='#88FF00'>Running" -replace ">Stopped"," bgcolor='#FF8800'>Stopped"

#Generate HTML File as $freespaceFileName
$Header > C:\temp\1.html
$Style >>C:\temp\1.html
$final >>C:\temp\1.html
$Footer >>C:\temp\1.html
