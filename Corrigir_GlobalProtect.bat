echo .........Criado por Gleriston Sampaio................
echo .....................................................
echo .....................................................


echo.
echo Procurando atualizações do Windows...

timeout 10 > NUL
echo Executando Windows Update...
net start "Windows Update"
timeout 10 > NUL

echo.
echo Atualizando WindowsDefender...


	"C:\Program Files\Windows Defender\MpCmdRun.exe" -SignatureUpdate

echo Procurando ameaças no computador com WindowsDefender...

	"C:\Program Files\Windows Defender\MpCmdRun.exe" -scan

timeout 10 > NUL

echo Atualizando Symantec Antivirus...

if not exist "C:\Suporte\" mkdir C:\Suporte
if exist "C:\Program Files (x86)\Symantec\Symantec Endpoint Protection\" goto :SYMANTEC
if exist "C:\Program Files\AVG\Antivirus" goto :AVG

:SYMANTEC
if exist "C:\Program Files (x86)\Symantec\Symantec Endpoint Protection\" bitsadmin /transfer mydownloadjob  /download /priority normal http://10.6.0.30:8014/secars/HI/ATUALIZACAO_SEP.exe C:\Suporte\ATUALIZACAO_SEP.exe
"C:\Suporte\ATUALIZACAO_SEP.exe" \s
cd "C:\Program Files (x86)\Symantec\Symantec Endpoint Protection\"
SepLiveUpdate.exe
timeout 10 > NUL
cd "C:\Program Files (x86)\Symantec\Symantec Endpoint Protection\"
DoScan.exe /C

timeout 30 > NUL

:AVG

cd "C:\Program Files\AVG\Antivirus"
AVGUI.exe

timeout 30 > NUL
 
echo.
echo As Atualizações foram aplicadas no seu computador!
echo.
echo Tentando reconectar ao Global Protect
taskkill /im PanGPA.exe /f
sc stop PanGPS
rem sc config PanGPS start= demand
rem pause
timeout 10 > NUL


Sleep, 1000



:ERRO
echo.
echo.
