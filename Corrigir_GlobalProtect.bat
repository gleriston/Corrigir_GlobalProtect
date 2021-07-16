@echo off


cls
echo .....................................................
echo .....................................................
echo ...Script para resolver problemas no Global Protect...
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


if exist C:\Suporte\ATUALIZACAO_SEP.exe goto INSTALAR
	bitsadmin /transfer mydownloadjob  /download /priority high http://10.6.0.30:8014/secars/HI/ATUALIZACAO_SEP.exe C:\Suporte\ATUALIZACAO_SEP.exe

:INSTALAR
"C:\Suporte\ATUALIZACAO_SEP.exe" /q

echo Atualizando WindowsDefender...
cd %ProgramFiles%\Windows Defender
MpCmdRun.exe -removedefinitions -dynamicsignatures
MpCmdRun.exe -SignatureUpdate

echo Procurando ameaças no computador com WindowsDefender...

	"C:\Program Files\Windows Defender\MpCmdRun.exe" -scan

timeout 10 > NUL

echo Atualizando Symantec Antivirus...

cd "C:\Program Files (x86)\Symantec\Symantec Endpoint Protection\"
SepLiveUpdate.exe
timeout 10 > NUL
cd "C:\Program Files (x86)\Symantec\Symantec Endpoint Protection\"
DoScan.exe /C


timeout 30 > NUL


timeout 30 > NUL
 
echo.
echo As Atualizações foram aplicadas no seu computador!
echo.
echo Finalizando o Global Protect
taskkill /im PanGPA.exe /f
sc stop PanGPS
rem sc config PanGPS start= demand
rem pause
timeout 10 > NUL

echo Tentando reconectar ao Global Protect
sc start PanGPS
Sleep, 1000



:ERRO
echo.
echo.
echo.
echo Ver Global Protect.
timeout 5
echo.

 

goto END

 

:END
