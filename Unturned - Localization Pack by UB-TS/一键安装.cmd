@echo off
setlocal ENABLEEXTENSIONS
set BATLOC=%~dp0
rem
rem this batchfile does read a single registry on your pc: the steam installation folder
rem located at HKEY_CURRENT_USER\Software\Valve\Steam\SteamPath
rem feel free to avoid using this script if you feel that the script��might hurt your PC or triggers thermonuclear war or get you rekt by zombies.
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
rem �������ôŪ���㲻�����˵�ȫ�Զ���װ�ű�
rem �����˵Ļ���������������޹�
rem
rem �ײ�����Ȼû������
rem Ӧ����Steam����Ϸ����Ŀ¼û�иĵ�ԭ��ɣ����������ط��Ļ��������
rem
rem
rem TODO : ������ľ��ļ�����
rem 	 : 
rem 	 : ��Ϊ��ʱ��Nelson������һЩϡ�жȷ��ർ�»���ֶ�����ļ��С�
rem 	 : �����Ҫ����һ��
rem 	 : 
rem
rem TODO : ��װ�������
rem 	 : 
rem 	 : ����Unturned.exe����λ�õĻ�Ӧ�����ҵ���Ϸ��װĿ¼
rem 	 : ��ΪҪ��������ļ��У���ʱ�������������ȱ�㡣
rem 	 : 
rem
rem PS: ���ڱ�д��Linux��MacҲ������Windows����ֱ�Ӱ�װ�Ľű���װ�����Ź��ϣ� ����Ǹ���û���˻�������ű������ݶ��Ǹ��ԡ���
rem

rem ## you need to edit lines below for your own language ##

set COPY_TEXT=�������Ʒ����ļ���
set COPY_WARNING=��ϷĬ�ϰ�װĿ¼�������˵Ļ��ýű����������С�
rem set COPY_QUESTION=������ȷ������y/ȡ������/n����
set COPY_QUESTION=Ҫ��;ֹͣ�Ļ���ֱ�ӹرմ��ڣ����߰�Ctrl+C �� y �� Enter��

set COPY_FILESLOCATION=ԴĿ¼��
set COPY_TO=���Ƶ�
set COPY_DESTINATION=��ϷĿ¼��

set ERROR_OCCURED=��������
set INSTALLATION_MISSINGREG=�Ҳ�����Ӧע���
set INSTALLATION_NODEST=�Ҳ�����ϷĿ¼�����ֶ������ļ���
set INSTALLATION_ABORT=��װ�жϡ�
set INSTALLATION_COMPLETE=��װ��ɡ�

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

