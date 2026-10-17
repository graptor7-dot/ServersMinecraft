@echo off
setlocal
chcp 65001 >nul
rem Repo git en la carpeta padre con "Server Mine" y "Server Mine - CREATIVO", subido a GitHub.
rem Se puede ejecutar varias veces: retoma donde se quedo.
cd /d "%~dp0.."
echo Carpeta del repositorio: %CD%
echo.
echo IMPORTANTE: cierra los dos servidores de Minecraft antes de continuar.
pause

where git >nul 2>nul || (echo No se encuentra git. Instalalo desde https://git-scm.com/download/win y vuelve a ejecutar este archivo. & pause & exit /b 1)

rem La carpeta esta en una unidad de red: hay que decirle a git que es de confianza.
git config --global --get-all safe.directory | findstr /c:"192.168.1.174/Datos Servidor/Almacenamiento Extra Gerard" >nul || git config --global --add safe.directory "%%(prefix)///192.168.1.174/Datos Servidor/Almacenamiento Extra Gerard"

set "REMOTE=https://github.com/graptor7-dot/ServersMinecraft.git"
echo Repositorio de destino: %REMOTE%

(
echo /*
echo !/Server Mine/
echo !/Server Mine - CREATIVO/
echo !/.gitignore
echo !/.gitattributes
) > .gitignore
echo * -text> .gitattributes

if not exist ".git" (git init -b main || goto :fallo)
git rev-parse --git-dir >nul || goto :fallo
git symbolic-ref HEAD refs/heads/main
git config core.longpaths true
git config http.postBuffer 524288000
git config user.name >nul || git config user.name "GerardLastres"
git config user.email >nul || git config user.email "graptor7@gmail.com"
git remote get-url origin >nul 2>nul && git remote set-url origin "%REMOTE%" || git remote add origin "%REMOTE%"

echo.
echo === 1/2: Server Mine (unos 1,4 GB, puede tardar) ===
git add .gitignore .gitattributes "Server Mine" || goto :fallo
git diff --cached --quiet || git commit -q -m "Server Mine" -m "Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>" -m "Claude-Session: https://claude.ai/code/session_018uuAp2aB7hV9oxDe48Tdsv" || goto :fallo
git push -u origin main || goto :fallo

echo.
echo === 2/2: Server Mine - CREATIVO (unos 1,4 GB, puede tardar) ===
git add "Server Mine - CREATIVO" || goto :fallo
git diff --cached --quiet || git commit -q -m "Server Mine - CREATIVO" -m "Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>" -m "Claude-Session: https://claude.ai/code/session_018uuAp2aB7hV9oxDe48Tdsv" || goto :fallo
git push -u origin main || goto :fallo

echo.
echo Listo: las dos carpetas estan subidas a %REMOTE%
pause
exit /b 0

:fallo
echo.
echo Algo ha fallado (mira el mensaje de arriba). Copiamelo y lo miramos.
pause
exit /b 1
