

:: check the name of the current directory
:: if it is 'export' exit this script
for %%I in (.) do set CurrDirName=%%~nxI
if "%CurrDirName%"=="export" goto :eof

:: Check if folder export exists
IF NOT EXIST "%~dp0export" (
    echo "The export folder doesn't exist."
    :: create folder
    mkdir "%~dp0export"
)

:: navigate to the export folder
cd "%~dp0export"



