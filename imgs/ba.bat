@echo off

if "%docompiledsp%"=="" goto build:

pushd ..\Components\Audio\Dsp\Images\Default
echo Building Default DSP project
call ba.bat
if errorlevel 1 goto error1:
popd
echo.
echo Building ARM project


:build

call SetSocId.bat

if exist ..\..\..\..\Tools\Dextor\Dextor.exe (
pushd ..\Config\Api
call ba.bat %*
if errorlevel 1 popd & exit /B 1
popd
)

pushd ..\Loader\195
if exist Ldr195.spihex del Ldr195.spihex
call ba.bat %*
if errorlevel 1 popd & exit /b 1
popd

pushd ..\FWR\195
if exist Fwr195.spihex del Fwr195.spihex
call ba.bat %*
if errorlevel 1 popd & exit /b 1
popd

rem @echo on

if not exist Nx4.ini copy _Nx4.ini Nx4.ini

setlocal
set PJROOT=..\..\..\..
set GMAKEARGS=%*
if exist BuildLog.txt del BuildLog.txt
%PJROOT%\Tools\xtee\xtee.exe -at BuildLog.txt %PJROOT%\Tools\RtxBuild\gmake.bat %PJROOT% clean prepare process
GOTO end

:error1
popd
echo ERROR! - DSP IMAGE FAILED (Using old image)

:end
