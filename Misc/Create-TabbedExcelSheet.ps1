####################################################################################################
# Read List from a Text file and create an excel worksheet with multiple tabs in it.               #
# Name of tabs to be created are read from a text file named "input.txt".                          #
# Maximum number of charactors permitted for TAB name in Excel 2016 is 31 so keep that in mind     #
# Every Time It will create a file with unique name because it uses Date and Time in the name      #
####################################################################################################

# Get Date to use when naming the Excel sheet
$Today = Get-Date -Format yyyy_MM_dd_hhmmss

# Create a Excel Workspace
	$excel = New-Object -ComObject Excel.Application

# make excel visible
	$excel.visible = $true

# add a new blank worksheet
	$workbook = $excel.Workbooks.add()

# Adding Sheets
	foreach($input in (gc c:\temp\input.txt)){
		$s4 = $workbook.Sheets.add()
		$s4.name = $input
	}

# The default workbook has three sheets, remove them
	($s1 = $workbook.sheets | where {$_.name -eq "Sheet1"}).delete() 

#Saving File
	"`n"
	write-Host -for Yellow "Saving file in $env:userprofile\desktop"
	$workbook.SaveAs("$env:userprofile\desktop\ExcelSheet_$Today.xlsx")