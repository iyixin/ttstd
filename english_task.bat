@echo off

rem �������ڻ�ȡ��Ҫ���ŵ��ļ� 

REM ��ʼ�͵�ǰ����
set start_dt=2022-03-02
set end_dt=%date%

rem ���ú�����ȡ���ڼ��������ƥ�������Ÿ�ʽ���ļ���
call :DateDiff2Days %start_dt% %end_dt% diff
REM echo ==== %diff%

REM ý���Ŀ¼
SET root_dir=D:\��ս�߿�

REM �����ļ���
if %diff% lss 10 (
	set file_no=0%diff%
)else (
	set file_no=%diff%
)
echo %file_no% 


SET _path=NONE
for %%i in (%root_dir%\Ӣ������\%file_no%*.mp3) DO (
	set _file=%%i
)

REM echo "%_file%"

REM 0-13�������
REM set /a file_random=%random%%%(13-0+1)+0
REM ��ʱ�̶����ſ�����
set /a file_random=5


d:
cd %root_dir%\autotask\python

rem ִ��python���ɸ��Ի�������ʾ
python app\app.py en_task false

set playlist="%root_dir%\otheraudio\sk_%file_random%.mp3" "%root_dir%\autotask\python\slogan.mp3" "%_file%"
rem echo %playlist%

rem ����VLCĿ¼
c:
cd C:\Program Files\VideoLAN\VLC

REM ��VLC��ָ����Ƶ����ָ����С���������
REM .1 ������������
REM vlc "%root_dir%\otheraudio\sk_1.mp3" --aout="directx" --directx-audio-device="{20434ffe-1087-45bf-89bc-3ee9c6a53337}" --stop-time 12 
REM .2 ������Ƭ ����������
vlc %playlist% --aout="directx" --directx-audio-device="{20434ffe-1087-45bf-89bc-3ee9c6a53337}" --no-volume-save --gain=3 vlc://quit

REM vlc "%root_dir%\otheraudio\sk_%file_random%.mp3" "%_file%" --no-volume-save vlc://quit

REM --stop-time 50 vlc://quit  ��ʾ50����˳�
REM -I dummy --dummy-quiet ����ʾ���Ž���

REM echo end
REM Pause


REM ����������ڼ��������
:DateDiff2Days
@echo off
setlocal enabledelayedexpansion 
set /a diffDays=0
set start_dt=%1
set end_dt=%2

set /a start_year=%start_dt:~0,4%
set /a start_month=10000%start_dt:~5,2%%%100 - 1
set /a start_day=10000%start_dt:~8,2%%%100

set /a end_year=%end_dt:~0,4%
set /a end_month=10000%end_dt:~5,2%%%100 - 1
set /a end_day=10000%end_dt:~8,2%%%100

call :CheckLeapYear %end_year% isLeapYear

set m[0]=31
set m[1]=28
set m[2]=31
set m[3]=30
set m[4]=31
set m[5]=30
set m[6]=31
set m[7]=31
set m[8]=30
set m[9]=31
set m[10]=30
set m[11]=31
if %isLeapYear% equ 1 (
	set m[1]=29
)

REM ���㿪ʼ���������еĵڼ���
set /a start_dayn=0
for /l %%i in (0,1,12) do (
	if %%i lss %start_month% (
		echo !m[%%i]!
		set /a start_dayn=!m[%%i]! + !start_dayn!
	)
)
set /a start_dayOfYear=%start_dayn% + %start_day%
REM @echo %start_dayOfYear%

REM ����������������еĵڼ���
set /a end_dayn=0
for /l %%i in (0,1,12) do (
	if %%i lss %end_month% (
		echo !m[%%i]!
		set /a end_dayn=!m[%%i]! + !end_dayn!
	)
)
set /a end_dayOfYear=%end_dayn% + %end_day%
REM @echo %end_dayOfYear%

set /a diffDays=%end_dayOfYear% - %start_dayOfYear%
@echo ���ڼ����%diffDays%

endlocal&set %~4=%diffDays%&goto :EOF

REM �ж��Ƿ�Ϊ���� 
REM ʹ�÷�����call :CheckLeapYear 2022 isLeapYear
REM ���� isLeapYear ���Ǽ�⵽�Ľ��
REM �����������:һ:�ܱ�4�����������ܱ�100��������ݣ�(����2008�����꣬1900��������) ��:�ܱ�400���������(����2000��)Ҳ������
:CheckLeapYear
@echo off&setlocal
set end_year=%1
set /a is_leap=0
REM ����
REM set end_year=2000
set /a end_rem=%end_year% %% 4
echo %end_rem%
if %end_rem% equ 0 (
	echo �����ȡ��4������ȡ��100
	set /a end_rem=%end_year% %% 100
	echo %end_rem%
	if %end_rem% gtr 0 (
		set /a is_leap=1
	)
)

REM �����жϺ������꣬����ȡ��400�����ж�
if %is_leap% equ 0 (
	echo ��ȡ��400�ж�
	set /a end_rem=%end_year% %% 400
	if %end_rem% equ 0 (
		set /a is_leap=1
	)
)
endlocal&set %~2=%is_leap%&goto :EOF

