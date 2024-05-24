:inicio
@echo off

cls
CHCP 65001 >NUL
echo. ----------------------------------------------------
echo .....................................................
echo .....................................................
echo ...Script para resolver problemas no Global Protect..
echo .........Criado por Gleriston Sampaio................
echo .....................................................
echo .....................................................

echo   Menu Principal

echo. ----------------------------------------------------

echo  1 - Executar Verificação Completa

echo. 2 - Resetar Somente o Global Protect

echo. 3 - Verificar atualizações do Windows

echo  4 - Remover o Symantec

echo  5 - Baixar e Instalar Global Protect

echo  0 - SAIR

echo. ---------------------------

set /p Comando= Digite uma Opcao :

if "%Comando%" equ "1" (goto:op1)

if "%Comando%" equ "2" (goto:op2)

if "%Comando%" equ "3" (goto:op3)

if "%Comando%" equ "4" (goto:op4)

if "%Comando%" equ "5" (goto:op5)

if "%Comando%" equ "0" (goto:exit)

:op1

echo.
echo Procurando atualizações do Windows...

timeout 10 > NUL
echo Executando Windows Update...
net start "Windows Update"
timeout 10 > NUL

echo.

echo Removendo o Symantec...


cd C:\Program Files (x86)\Symantec\Symantec Endpoint Protection\uninstall.exe /silent



echo Procurando ameaças no computador com WindowsDefender...

	"C:\Program Files\Windows Defender\MpCmdRun.exe" -scan

timeout 10 > NUL

echo Atualizando politicas do FIREWALL...

netsh advfirewall set allprofiles state on


timeout 30 > NUL
 
echo.
echo As Atualizações foram aplicadas no seu computador!

:op2

echo Resetando Somente o Global Protect
echo.

taskkill /im PanGPA.exe /f
sc stop PanGPS
rem sc config PanGPS start= demand
rem pause
timeout 10 > NUL

echo Tentando reconectar ao Global Protect
sc start PanGPS
Sleep, 1000

pause

goto:inicio


:ERRO
echo.
echo.
echo.
echo Ver Global Protect.
timeout 5
echo.

goto:inicio


:op3

echo Verificando Atualizações...

REM Remover chaves de registro relacionadas às políticas de atualização do Windows
Reg Delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /f >nul 2>&1
Reg Delete "HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /f >nul 2>&1

REM Parar os serviços relevantes
echo Parando os serviços relacionados...
net stop bits >nul 2>&1
net stop wuauserv >nul 2>&1
net stop appidsvc >nul 2>&1
net stop cryptsvc >nul 2>&1

REM Renomear as pastas relevantes
echo Renomeando pastas...
Ren %systemroot%\SoftwareDistribution SoftwareDistribution.bak >nul 2>&1
Ren %systemroot%\system32\catroot2 catroot2.bak >nul 2>&1

REM Redefinindo as configurações de Winsock e WinHTTP
echo Redefinindo configurações de rede...
netsh winsock reset >nul 2>&1
netsh winhttp reset proxy >nul 2>&1

REM Iniciar novamente os serviços relevantes
echo Iniciando os serviços relacionados...
net start bits >nul 2>&1
net start wuauserv >nul 2>&1
net start appidsvc >nul 2>&1
net start cryptsvc >nul 2>&1
net start "Windows Update" >nul 2>&1

REM Forçar o cliente do Windows Update a detectar e relatar atualizações
echo Detectando atualizações...
wuauclt /detectnow >nul 2>&1

echo Relatando atualizações...
wuauclt /reportnow >nul 2>&1

echo Atualização concluída.

pause

goto:inicio

:op4

echo Removendo o Symantec...

cd C:\Program Files (x86)\Symantec\Symantec Endpoint Protection\uninstall.exe /silent

pause

goto:inicio

:op5

echo Baixando Global Protect...

md "C:\Suporte\"

bitsadmin /transfer mydownloadjob /download /priority normal https://ars.bnb.gov.br/global-protect/msi/GlobalProtect64.msi C:\Suporte\GlobalProtect64.msi

echo Instalando Global Protect...

"C:\Suporte\GlobalProtect64.msi" /q

pause

goto:inicio

:exit

exit




 

goto END

 

:END