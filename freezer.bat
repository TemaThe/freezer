set process_name=OpenTouchConversation
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /format:list') do set datetime=%%I
set timestamp=%datetime:~0,4%-%datetime:~4,2%-%datetime:~6,2%_%datetime:~8,2%-%datetime:~10,2%-%datetime:~12,2%
set storage=%temp%\dumps
set target_folder=%storage%\%version%_%timestamp%
set log_path=%temp%\Alcatel-Lucent
set appdata=%appdata%\AlcatelLucent\OpenTouchConversation
set remoteStore=\\ruspbsdevt1\SWC_Tech_Share\frezzeDumpOTCPC

mkdir %target_folder%

procdump.exe -ma %process_name% %target_folder%\%process_name%.dmp

systeminfo | findstr "Memory" > %target_folder%\ram.txt

7za.exe a -tzip %target_folder%\%process_name%.zip %log_path% -ssw -xr!msi
7za.exe a -tzip %target_folder%\%process_name%_APPDATA.zip %appdata% -ssw

set /p situation= Please shortly describe the situation when freeze happened ?
echo %situation% >> %target_folder%\situation.txt

xcopy %target_folder% %remoteStore%\%version%_%timestamp%\* /s /e
rmdir %target_folder%

pause