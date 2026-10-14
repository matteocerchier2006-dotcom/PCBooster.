@echo off
REM Pubblica una nuova versione su GitHub: tutti i PC con PC Booster si aggiorneranno da soli.
REM Serve GitHub CLI (https://cli.github.com) e aver fatto una volta: gh auth login
cd /d "%~dp0"
setlocal

where gh >nul 2>&1 || (echo GitHub CLI non trovato. Installalo da https://cli.github.com e riprova. & pause & exit /b 1)
gh auth status >nul 2>&1 || (echo Prima collegati a GitHub: apri il Prompt dei comandi e scrivi  gh auth login & pause & exit /b 1)

REM ---- Prima volta: crea il repository e salva il nome in repo.txt ----
set REPO=
if exist repo.txt set /p REPO=<repo.txt
if "%REPO%"=="" (
  for /f %%u in ('gh api user --jq .login') do set UTENTE=%%u
  call :crearepo
)
echo Repository: %REPO%

set /p ATTUALE=<version.txt
echo Versione attuale: %ATTUALE%
set NUOVA=
set /p NUOVA=Numero della nuova versione (es. 1.0.1): 
if "%NUOVA%"=="" (echo Nessuna versione inserita. & pause & exit /b 1)
set NOTE=
set /p NOTE=Cosa cambia in questa versione (una riga): 
if "%NOTE%"=="" set NOTE=Miglioramenti vari

> version.txt echo %NUOVA%
if exist "dist\PC Booster.exe" del "dist\PC Booster.exe"
call crea_exe.bat <nul
if not exist "dist\PC Booster.exe" (echo Creazione dell'exe non riuscita. & > version.txt echo %ATTUALE% & pause & exit /b 1)

copy /y "dist\PC Booster.exe" "dist\PCBooster.exe" >nul
gh release create "v%NUOVA%" "dist\PCBooster.exe" --repo "%REPO%" --title "PC Booster %NUOVA%" --notes "%NOTE%"
if errorlevel 1 (echo Pubblicazione non riuscita. & > version.txt echo %ATTUALE% & pause & exit /b 1)

echo.
echo Pubblicata la versione %NUOVA%. Al prossimo avvio, ogni PC si aggiornera' da solo.
pause
exit /b 0

:crearepo
set REPO=%UTENTE%/PCBooster
gh repo view "%REPO%" >nul 2>&1 || gh repo create "%REPO%" --public --add-readme --description "PC Booster - aggiornamenti" >nul
if errorlevel 1 (echo Non riesco a creare il repository %REPO%. & pause & exit 1)
> repo.txt echo %REPO%
echo Creato il repository %REPO%.
exit /b 0
