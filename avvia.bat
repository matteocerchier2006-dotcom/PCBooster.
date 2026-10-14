@echo off
REM Avvia PC Booster dal codice sorgente (serve Python installato)
cd /d "%~dp0"
python -m pip install -r requirements.txt --quiet
python app.py
