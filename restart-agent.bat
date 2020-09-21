@echo off

REM Определение типа агента
if "%1" EQU "x64" (
    SET AGENT_NAME="1C:Enterprise 8.3 Server Agent (x86-64)"
) else (
    SET AGENT_NAME="1C:Enterprise 8.3 Server Agent"
)


REM Остановка агента
net stop %AGENT_NAME%
timeout /t 3 /nobreak


REM Вырубаем зависшие процессы 1С
TASKKILL /F /IM "rphost.exe"
TASKKILL /F /IM "rmngr.exe"
TASKKILL /F /IM "ragent.exe"
timeout /t 3 /nobreak


GOTO START
REM Очистка кэша сервера
:CACHE
if "%1" EQU "x64" (
    SET SRV_DIR="C:\Program Files\1cv8\srvinfo\reg_1541"
) else (
    SET SRV_DIR="C:\Program Files (x86)\1cv8\srvinfo\reg_1541"
)

pushd %SRV_DIR%
for /f %%i in ('dir/ad/b "*snccntx*"') do (
    rd /s /q "%%i"
)
popd


Rem Запуск службы
:START
net start %AGENT_NAME%