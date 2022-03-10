@echo off

rem 根据日期获取需要播放的文件 

REM 开始和当前日期
set start_dt=2022-03-02
set end_dt=%date%

rem 调用函数获取日期间隔天数，匹配递增序号格式的文件名
call :DateDiff2Days %start_dt% %end_dt% diff
REM echo ==== %diff%

REM 媒体根目录
SET root_dir=D:\决战高考

REM 生成文件名
if %diff% lss 10 (
	set file_no=0%diff%
)else (
	set file_no=%diff%
)
echo %file_no% 


SET _path=NONE
for %%i in (%root_dir%\英语听力\%file_no%*.mp3) DO (
	set _file=%%i
)

REM echo "%_file%"

REM 0-13的随机数
REM set /a file_random=%random%%%(13-0+1)+0
REM 暂时固定播放开场曲
set /a file_random=5


d:
cd %root_dir%\autotask\python

rem 执行python生成个性化语音提示
python app\app.py en_task false

set playlist="%root_dir%\otheraudio\sk_%file_random%.mp3" "%root_dir%\autotask\python\slogan.mp3" "%_file%"
rem echo %playlist%

rem 进入VLC目录
c:
cd C:\Program Files\VideoLAN\VLC

REM 用VLC打开指定音频，并指定由小米音响输出
REM .1 播放醒脑神曲
REM vlc "%root_dir%\otheraudio\sk_1.mp3" --aout="directx" --directx-audio-device="{20434ffe-1087-45bf-89bc-3ee9c6a53337}" --stop-time 12 
REM .2 播放正片 音量调整到
vlc %playlist% --aout="directx" --directx-audio-device="{20434ffe-1087-45bf-89bc-3ee9c6a53337}" --no-volume-save --gain=3 vlc://quit

REM vlc "%root_dir%\otheraudio\sk_%file_random%.mp3" "%_file%" --no-volume-save vlc://quit

REM --stop-time 50 vlc://quit  表示50秒后退出
REM -I dummy --dummy-quiet 不显示播放界面

REM echo end
REM Pause


REM 计算二个日期间隔的天数
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

REM 计算开始日期在年中的第几天
set /a start_dayn=0
for /l %%i in (0,1,12) do (
	if %%i lss %start_month% (
		echo !m[%%i]!
		set /a start_dayn=!m[%%i]! + !start_dayn!
	)
)
set /a start_dayOfYear=%start_dayn% + %start_day%
REM @echo %start_dayOfYear%

REM 计算结束日期在年中的第几天
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
@echo 日期间隔：%diffDays%

endlocal&set %~4=%diffDays%&goto :EOF

REM 判断是否为闰年 
REM 使用方法：call :CheckLeapYear 2022 isLeapYear
REM 变量 isLeapYear 就是检测到的结果
REM 闰年的条件是:一:能被4整除，但不能被100整除的年份；(例如2008是闰年，1900不是闰年) 二:能被400整除的年份(例如2000年)也是闰年
:CheckLeapYear
@echo off&setlocal
set end_year=%1
set /a is_leap=0
REM 测试
REM set end_year=2000
set /a end_rem=%end_year% %% 4
echo %end_rem%
if %end_rem% equ 0 (
	echo 已完成取余4，继续取余100
	set /a end_rem=%end_year% %% 100
	echo %end_rem%
	if %end_rem% gtr 0 (
		set /a is_leap=1
	)
)

REM 以上判断后不是闰年，继续取余400进行判断
if %is_leap% equ 0 (
	echo 用取余400判断
	set /a end_rem=%end_year% %% 400
	if %end_rem% equ 0 (
		set /a is_leap=1
	)
)
endlocal&set %~2=%is_leap%&goto :EOF

