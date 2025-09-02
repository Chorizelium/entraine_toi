@echo off
:: ===========================================================
::  Mise à jour GitHub Pages en un clic (Windows .bat)
:: ===========================================================

setlocal enabledelayedexpansion

cd /d "%~dp0"

where git >nul 2>nul
if errorlevel 1 (
  echo [ERREUR] Git n'est pas installe ou non present dans le PATH.
  echo Telechargez-le: https://git-scm.com/downloads
  pause
  exit /b 1
)

git rev-parse --is-inside-work-tree >nul 2>nul
if errorlevel 1 (
  echo [ERREUR] Ce dossier n'est pas un repository Git.
  pause
  exit /b 1
)

for /f %%C in ('git status --porcelain ^| find /c /v ""') do set COUNT=%%C
if "!!COUNT!!"=="" set COUNT=0

if "%COUNT%"=="0" (
  echo Rien a envoyer. Aucun fichier modifie.
  pause
  exit /b 0
)

set MSG=%*
if "%MSG%"=="" (
  for /f "tokens=1-4 delims=/ " %%a in ('date /t') do set TODAY=%%a-%%b-%%c-%%d
  for /f "tokens=1 delims=." %%t in ("%time%") do set NOW=%%t
  set MSG=Mise a jour %TODAY% %NOW%
)

echo === Envoi de la mise a jour ===
echo Message: %MSG%

git add .
git commit -m "%MSG%"
git push

echo ✅ Mise a jour reussie. GitHub Pages va se redeployer sous peu.
pause
