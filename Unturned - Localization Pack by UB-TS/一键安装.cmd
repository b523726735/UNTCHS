@echo off
setlocal ENABLEEXTENSIONS
set BATLOC=%~dp0
rem
rem this batchfile does read a single registry on your pc: the steam installation folder
rem located at HKEY_CURRENT_USER\Software\Valve\Steam\SteamPath
rem feel free to avoid using this script if you feel that the script　might hurt your PC or triggers thermonuclear war or get you rekt by zombies.
rem
rem #################################################
rem #                                               #
rem #        randomeel's langpack installer         #
rem #               for your laziness               #
rem #                                               #
rem #          I HAVE NO RESPONSIBILITIES           #
rem #        OF CORRUPTING YOUR UNTURNED FILES      #
rem #            USE AT YOUR OWN RISK               #
rem #                                               #
rem #################################################
rem
rem 给真的怎么弄都搞不定的人的全自动安装脚本
rem ※用了的话出现问题和作者无关
rem
rem 亲测下虽然没有问题
rem 应该是Steam的游戏下载目录没有改的原因吧，下在其他地方的话不清楚。
rem
rem
rem TODO : 升级后的旧文件清理
rem 	 : 
rem 	 : 因为有时候Nelson会增加一些稀有度分类导致会出现多余的文件夹。
rem 	 : 请务必要清理一下
rem 	 : 
rem
rem TODO : 安装方法变更
rem 	 : 
rem 	 : 搜索Unturned.exe所在位置的话应该能找到游戏安装目录
rem 	 : 因为要检查所有文件夹，耗时长是这个方法的缺点。
rem 	 : 
rem
rem PS: 正在编写在Linux和Mac也能像在Windows那样直接安装的脚本安装器（才怪嘞） 相比那个有没有人会检查这个脚本的内容都是个迷……
rem

rem ## you need to edit lines below for your own language ##

set COPY_TEXT=即将复制翻译文件。
set COPY_WARNING=游戏默认安装目录被更改了的话该脚本将不会运行。
rem set COPY_QUESTION=继续吗（确认输入y/取消输入/n）？
set COPY_QUESTION=要中途停止的话请直接关闭窗口，或者按Ctrl+C → y → Enter。

set COPY_FILESLOCATION=源目录：
set COPY_TO=复制到
set COPY_DESTINATION=游戏目录：

set ERROR_OCCURED=发生错误！
set INSTALLATION_MISSINGREG=找不到相应注册表。
set INSTALLATION_NODEST=找不到游戏目录。请手动复制文件。
set INSTALLATION_ABORT=安装中断。
set INSTALLATION_COMPLETE=安装完成。

rem ##                  do not edit beyond here                  ##

set ERRORTEXT=

:readreg
rem # thanks for Patrick Cuff @ stackoverflow.com
rem # http://stackoverflow.com/questions/445167/how-can-i-get-the-value-of-a-registry-key-from-within-a-batch-script

set REGKEY=HKEY_CURRENT_USER\Software\Valve\Steam
set REGVALUE=SteamPath

FOR /F "usebackq skip=2 tokens=1-2*" %%A IN (`REG QUERY %REGKEY% /v %REGVALUE% 2^>nul`) DO (
	set ValueName=%%A
	set ValueType=%%B
	set ValueValue=%%C
)

if not defined ValueName (
	@echo %REGKEY%\%REGVALUE% not found.
	goto error_noreg
)

set INST_LOC=%ValueValue%/steamapps/common/Unturned
if not exist "%INST_LOC%" goto error_nodest

:welcome
echo.
echo #################################################
echo #                                               #
echo #        randomeel's langpack installer         #
echo #               for your laziness               #
echo #                                               #
echo #          I HAVE NO RESPONSIBILITIES           #
echo #    OF CORRUPTING YOUR UNTURNED INSTALLATION   #
echo #          OR SPREADING ZOMBIE INFECTION        #
echo #               USING THIS FILE.                #
echo #                                               #
echo #            USE AT YOUR OWN RISK               #
echo #                                               #
echo #################################################
echo.

echo %COPY_TEXT%
echo %COPY_WARNING%
echo.
echo %COPY_FILESLOCATION% %BATLOC%*
echo  %COPY_TO%
echo %COPY_DESTINATION% %INST_LOC%/
echo.
echo %COPY_QUESTION%
echo.
pause
rem 
rem set /P ANS=%COPY_QUESTION% 
rem if "%ANS%" == "y" (
rem 	goto install
rem ) else if "%ANS%" == "Y" (
rem 	goto install
rem ) else (
rem 	goto abort
rem )

:install
if not exist "%INST_LOC%" goto error_nodest
xcopy /S /E /Y "%BATLOC%*" "%INST_LOC%"
del "%INST_LOC%\iamnoob.cmd"
goto finish

:error_noreg
rem cls
SET ERRORTEXT=%INSTALLATION_NODEST%
goto error

:error_nodest
cls
SET ERRORTEXT=%INSTALLATION_NODEST%
goto error

:error
color 4f
echo.
echo %ERROR_OCCURED%
echo %ERRORTEXT%

:abort
echo.
echo %INSTALLATION_ABORT%
pause
exit

:finish
color 2f
cls
echo.
echo %INSTALLATION_COMPLETE%
pause
exit

