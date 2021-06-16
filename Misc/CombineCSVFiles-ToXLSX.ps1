Param ($Path_To_CSVs)

cd $Path_To_CSVs;
$PathArray = $Path_To_CSVs -replace '\\$' -split '\\'
$FileName = $PathArray[-1]

Write-Host $Path_To_CSVs
Write-host $filename 

$csvs = Get-ChildItem .\* -Include *.csv
$y=$csvs.Count

Write-Host "Detected the following CSV files: ($y)"
foreach ($csv in $csvs)
{
    Write-Host " "$csv.Name
}

$outputfilename = ($Path_To_CSVs -replace '\\$') + '\' + $FileName + "_$(get-date -f yyyyMMdd).xlsx" #creates file name with FolderName

Write-Host Creating: $outputfilename
$excelapp = new-object -comobject Excel.Application
$excelapp.sheetsInNewWorkbook = $csvs.Count
$xlsx = $excelapp.Workbooks.Add()
$sheet=1

foreach ($csv in $csvs)
    {
        $row=1
        $column=1
        $worksheet = $xlsx.Worksheets.Item($sheet)
        $worksheet.Name = $csv.Name
        $file = (Get-Content $csv)
        foreach($line in $file)
    {
$linecontents=$line -split ',(?!\s*\w+")'
foreach($cell in $linecontents)
    {
        $cell=$cell.TrimStart('"')
        $cell=$cell.TrimEnd('"')
        $worksheet.Cells.Item($row,$column) = $cell
        $column++
    }
$column=1
$row++
}
$sheet++
}
$output = $outputfilename
$xlsx.SaveAs($output)
$excelapp.quit()
