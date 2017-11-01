@echo off

setlocal

where /q perl
IF ERRORLEVEL 1 (
    ECHO Perl cannot be found. Please ensure it is installed and placed in your PATH.
	PAUSE
    EXIT /B
) 

where /q nasm
IF ERRORLEVEL 1 (
    ECHO nasm cannot be found. Please ensure it is installed and placed in your PATH.
	PAUSE
    EXIT /B
) 

SET VS_VERSION =VS2013
set SEVENZIP="C:\Program Files\7-Zip\7z.exe"
set VS2013="C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\bin\vcvars32.bat"
set VS2013_AMD64="C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\bin\amd64\vcvars64.bat"

::REM ### DAS HIER ANPASSEN!!! ########### 
::REM # Es muss in dem Ordner ein tar mit dem namen openssl-"Opensslversion".tar.gz liegen,
::REM # z.b. openssl-1.1.0f.tar.gz

set OPENSSL_VERSION=1.1.0f
set ROOT_DIR=D:\Entwicklung\2_git\paypal_proj\openssl
::REM ### DAS HIER AENDERN ########### 

set BASE_PATH=%ROOT_DIR%\openssl-%OPENSSL_VERSION%
set BUILD_DIR=%BASE_PATH%-src

set BUILD_DIR_WIN32=%BUILD_DIR%-win32
set BUILD_DIR_WIN64=%BUILD_DIR%-win64
set INSTALL_DIR=%BASE_PATH%-%VS_VERSION%
 
echo "OPENSSL_VERSION %OPENSSL_VERSION%"

REM Remove openssl source directories
IF NOT EXIST "%BUILD_DIR_WIN32%" GOTO NO_WIN32_SOURCE
DEL "%BUILD_DIR_WIN32%" /Q /F /S
RMDIR /S /Q "%BUILD_DIR_WIN32%"
:NO_WIN32_SOURCE

IF NOT EXIST "%BUILD_DIR_WIN64%" GOTO NO_WIN64_SOURCE
DEL "%BUILD_DIR_WIN64%" /Q /F /S
RMDIR /S /Q "%BUILD_DIR_WIN64%"
:NO_WIN64_SOURCE

IF NOT EXIST "%BUILD_DIR%" GOTO NO_OPENSSL_SOURCE
DEL "%BUILD_DIR%" /Q /F /S
RMDIR /S /Q "%BUILD_DIR%"
:NO_OPENSSL_SOURCE

del %ROOT_DIR%\openssl-%OPENSSL_VERSION%.tar
%SEVENZIP% e %ROOT_DIR%\openssl-%OPENSSL_VERSION%.tar.gz -o%ROOT_DIR%

@echo on

rem # Getrennte Source dirs für jeden Build anlegen!
%SEVENZIP% x %ROOT_DIR%\openssl-%OPENSSL_VERSION%.tar -o%ROOT_DIR%
SLEEP 1
move %BASE_PATH% %BUILD_DIR_WIN32%
%SEVENZIP% x %ROOT_DIR%\openssl-%OPENSSL_VERSION%.tar -o%ROOT_DIR%
SLEEP 1
move %BASE_PATH% %BUILD_DIR_WIN64%

CALL %VS2013%

cd %BUILD_DIR_WIN32%
perl Configure VC-WIN32 --prefix=%INSTALL_DIR%-32bit-release-DLL
nmake
nmake test
nmake install

perl Configure debug-VC-WIN32 --prefix=%INSTALL_DIR%-32bit-debug-DLL
nmake
nmake test
nmake install

perl Configure VC-WIN32 --prefix=%INSTALL_DIR%-32bit-release-static
nmake
nmake test
nmake install

perl Configure debug-VC-WIN32 --prefix=%INSTALL_DIR%-32bit-debug-static
nmake
nmake test
nmake install

CALL %VS2013_AMD64%

cd %BUILD_DIR%-win64
perl Configure VC-WIN64A --prefix=%INSTALL_DIR%-64bit-release-DLL
nmake
nmake test
nmake install

perl Configure debug-VC-WIN64A --prefix=%INSTALL_DIR%-64bit-debug-DLL
nmake
nmake test
nmake install

cd %BUILD_DIR%-win64
perl Configure VC-WIN64A --prefix=%INSTALL_DIR%-64bit-release-static
nmake
nmake test
nmake install

perl Configure debug-VC-WIN64A --prefix=%INSTALL_DIR%-64bit-debug-static
nmake
nmake test
nmake install

cd %BASE_PATH%
python copy_openssl_pys.py

%SEVENZIP% a -r %INSTALL_DIR%-32bit-debug-DLL.7z %INSTALL_DIR%-32bit-debug-DLL\*
%SEVENZIP% a -r %INSTALL_DIR%-32bit-release-DLL.7z %INSTALL_DIR%-32bit-release-DLL\*
%SEVENZIP% a -r %INSTALL_DIR%-64bit-debug-DLL.7z %INSTALL_DIR%-64bit-debug-DLL\*
%SEVENZIP% a -r %INSTALL_DIR%-64bit-release-DLL.7z %INSTALL_DIR%-64bit-release-DLL\*
%SEVENZIP% a -r %INSTALL_DIR%-32bit-debug-static.7z %INSTALL_DIR%-32bit-debug-static\*
%SEVENZIP% a -r %INSTALL_DIR%-32bit-release-static.7z %INSTALL_DIR%-32bit-release-static\*
%SEVENZIP% a -r %INSTALL_DIR%-64bit-debug-static.7z %INSTALL_DIR%-64bit-debug-static\*
%SEVENZIP% a -r %INSTALL_DIR%-64bit-release-static.7z %INSTALL_DIR%-64bit-release-static\*

DEL %INSTALL_DIR%-32bit-debug-DLL /Q /F /S
DEL %INSTALL_DIR%-32bit-release-DLL /Q /F /S
DEL %INSTALL_DIR%-64bit-debug-DLL /Q /F /S
DEL %INSTALL_DIR%-64bit-release-DLL /Q /F /S
DEL %INSTALL_DIR%-32bit-debug-static /Q /F /S
DEL %INSTALL_DIR%-32bit-release-static /Q /F /S
DEL %INSTALL_DIR%-64bit-debug-static /Q /F /S
DEL %INSTALL_DIR%-64bit-release-static /Q /F /S

RMDIR /S /Q %INSTALL_DIR%-32bit-debug-DLL
RMDIR /S /Q %INSTALL_DIR%-32bit-release-DLL
RMDIR /S /Q %INSTALL_DIR%-64bit-debug-DLL
RMDIR /S /Q %INSTALL_DIR%-64bit-release-DLL
RMDIR /S /Q %INSTALL_DIR%-32bit-debug-static
RMDIR /S /Q %INSTALL_DIR%-32bit-release-static
RMDIR /S /Q %INSTALL_DIR%-64bit-debug-static
RMDIR /S /Q %INSTALL_DIR%-64bit-release-static

