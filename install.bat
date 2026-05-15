@echo off
chcp 65001 >nul
title 公文技能安装器 — GB/T 9704-2012

echo ═══════════════════════════════════
echo   公文skills 安装器
echo   GB/T 9704-2012
echo ═══════════════════════════════════
echo.

:: 1. 检测 LobsterAI 安装位置
set LOBSTER_DIR=
if exist "%APPDATA%\LobsterAI\SKILLs" (
    set LOBSTER_DIR=%APPDATA%\LobsterAI\SKILLs
)
if exist "%USERPROFILE%\AppData\Local\Programs\lobsterai\resources\app\SKILLs" (
    set LOBSTER_DIR=%USERPROFILE%\AppData\Local\Programs\lobsterai\resources\app\SKILLs
)

if "%LOBSTER_DIR%"=="" (
    echo [未找到 LobsterAI]
    echo 请手动将本文件夹复制到 LobsterAI 的 SKILLs 目录下
    echo.
    pause
    exit /b 1
)

echo [找到] %LOBSTER_DIR%
echo.

:: 2. 复制技能文件
set TARGET=%LOBSTER_DIR%\gongwen
if exist "%TARGET%" (
    echo [覆盖] 已有旧版本，正在更新...
    rd /s /q "%TARGET%"
)

xcopy /E /I /Q "%~dp0." "%TARGET%"
echo [完成] 技能文件已复制
echo.

:: 3. 检查配置文件
set CONFIG=%LOBSTER_DIR%\..\skills.config.json
if not exist "%CONFIG%" (
    echo [警告] 未找到 skills.config.json，请手动添加配置
    echo.
    pause
    goto done
)

:: 检查是否已配置
findstr /C:"gongwen" "%CONFIG%" >nul
if %ERRORLEVEL%==0 (
    echo [跳过] skills.config.json 中已存在 gongwen 配置
) else (
    echo [配置] 正在更新 skills.config.json...
    powershell -Command ^
        "$cfg = Get-Content '%CONFIG%' -Raw | ConvertFrom-Json; ^
         $cfg.defaults | Add-Member -NotePropertyName 'gongwen' -NotePropertyValue @{order=11;enabled=$true} -Force; ^
         $cfg | ConvertTo-Json -Depth 10 | Set-Content '%CONFIG%' -Encoding UTF8"
    echo [完成] 已添加到 skills.config.json
)

:done
echo.
echo ═══════════════════════════════════
echo   安装完成！
echo   重启 LobsterAI 后即可使用
echo   用法：在对话框说"写一份通知"
echo ═══════════════════════════════════
pause
