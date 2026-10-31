@echo off
title Minecraft Server
cd /d "%~dp0server"

rem Find Java 25 (Temurin). Folder name changes when Java updates, so search for it.
set "JAVA=java"
for /d %%D in ("C:\Program Files\Eclipse Adoptium\jre-25*" "C:\Program Files\Eclipse Adoptium\jdk-25*") do set "JAVA=%%~D\bin\java.exe"

:loop
rem The server fetches Mojang's login service info at startup. If Wi-Fi is not up yet, friends
rem may not be able to join for a while, so wait until it is reachable (up to ~3 min).
echo [%date% %time%] Waiting for internet connection...
powershell -NoProfile -Command "for($i=0;$i -lt 90;$i++){ try { $c=New-Object Net.Sockets.TcpClient; $c.Connect('discovery.minecraftservices.com',443); $c.Close(); exit 0 } catch { Start-Sleep 2 } }; exit 1"
if errorlevel 1 echo Internet still not reachable - starting anyway. Friends may not be able to join for a few minutes.

echo [%date% %time%] Starting server...
"%JAVA%" -Xms4G -Xmx6G ^
  -XX:+AlwaysPreTouch -XX:+DisableExplicitGC -XX:+ParallelRefProcEnabled -XX:+PerfDisableSharedMem ^
  -XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:G1HeapRegionSize=8M -XX:G1HeapWastePercent=5 ^
  -XX:G1MaxNewSizePercent=40 -XX:G1MixedGCCountTarget=4 -XX:G1MixedGCLiveThresholdPercent=90 ^
  -XX:G1NewSizePercent=30 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:G1ReservePercent=20 ^
  -XX:InitiatingHeapOccupancyPercent=15 -XX:MaxGCPauseMillis=200 -XX:MaxTenuringThreshold=1 ^
  -XX:SurvivorRatio=32 ^
  -jar paper.jar --nogui

echo.
echo Server stopped. Restarting in 10 seconds...
choice /c YN /t 10 /d Y /m "Restart now? (press N to quit)"
if errorlevel 2 goto :eof
goto loop
