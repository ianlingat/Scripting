@echo off
setlocal enabledelayedexpansion

set LOCAL_DIR=C:\Users\SSI-CLINGAT\Desktop\TEST\SYNC_FILES
set REMOTE_DIR=/root/TEST/*
set LINUX_SERVER_IP=172.1.86.100
set SSH_USER=root
set PRIVATE_KEY=C:\Users\SSI-CLINGAT\Desktop\TEST\private.ppk

echo Copying new files from the Linux server to %LOCAL_DIR%...

"C:\Users\SSI-CLINGAT\Desktop\TEST\pscp.exe" -v -r -P 22 -i %PRIVATE_KEY% %SSH_USER%@%LINUX_SERVER_IP%:%REMOTE_DIR% %LOCAL_DIR%

for %%f in (%REMOTE_DIR%) do (
    set FILE_NAME=%%~nxf
    set REMOTE_FILE="%LOCAL_DIR%\!FILE_NAME!"
    if not exist "!REMOTE_FILE!" (
        "C:\Users\SSI-CLINGAT\Desktop\TEST\pscp.exe" -v -r  -P 22 -i %PRIVATE_KEY% %SSH_USER%@%LINUX_SERVER_IP%:%%f "%LOCAL_DIR%"
    ) else (
        for /f %%a in ('wmic datafile where name^="!REMOTE_FILE!" get lastmodified ^| findstr /r "^20[0-9][0-9]"') do set LOCAL_TIMESTAMP=%%a
        for /f %%b in ('"C:\Users\SSI-CLINGAT\Desktop\TEST\pscp.exe" -v -P 22 -i %PRIVATE_KEY% %SSH_USER%@%LINUX_SERVER_IP%:%%f') do set REMOTE_TIMESTAMP=%%b

        if !REMOTE_TIMESTAMP! gtr !LOCAL_TIMESTAMP! (
            "C:\Users\SSI-CLINGAT\Desktop\TEST\pscp.exe" -v -r  -P 22 -i %PRIVATE_KEY% %SSH_USER%@%LINUX_SERVER_IP%:%%f "%LOCAL_DIR%"
        )
    )
)

echo Files have been copied.

endlocal
pause
