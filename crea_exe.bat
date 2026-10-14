@echo off
REM Crea PC Booster.exe nella cartella "dist" (da dare anche a tuo fratello)
cd /d "%~dp0"
if not exist repo.txt type nul > repo.txt
python -m pip install -r requirements.txt --quiet
python -m PyInstaller --noconfirm --onefile --windowed --uac-admin ^
  --name "PC Booster" ^
  --add-data "ui;ui" ^
  --add-data "version.txt;." ^
  --add-data "repo.txt;." ^
  app.py
echo.
echo Fatto! Trovi "PC Booster.exe" nella cartella dist
pause
