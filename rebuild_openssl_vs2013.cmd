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


T:
set OPENSSL_VERSION=1.1.0c
set SEVENZIP="C:\Program Files\7-Zip\7z.exe"
set VS2013="C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\bin\vcvars32.bat"
set VS2013_AMD64="C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\bin\amd64\vcvars64.bat"


REM Remove openssl source directories
IF NOT EXIST "T:\openssl-src-win32" GOTO NO_WIN32_SOURCE
DEL "T:\openssl-src-win32" /Q /F /S
RMDIR /S /Q "T:\openssl-src-win32"
:NO_WIN32_SOURCE

IF NOT EXIST "T:\openssl-src-win64" GOTO NO_WIN64_SOURCE
DEL "T:\openssl-src-win64" /Q /F /S
RMDIR /S /Q "T:\openssl-src-win64"
:NO_WIN64_SOURCE

IF NOT EXIST "T:\openssl-%OPENSSL_VERSION%" GOTO NO_OPENSSL_SOURCE
DEL "T:\openssl-%OPENSSL_VERSION%" /Q /F /S
RMDIR /S /Q "T:\openssl-%OPENSSL_VERSION%"
:NO_OPENSSL_SOURCE

del openssl-%OPENSSL_VERSION%.tar
%SEVENZIP% e openssl-%OPENSSL_VERSION%.tar.gz
%SEVENZIP% x openssl-%OPENSSL_VERSION%.tar
ren openssl-%OPENSSL_VERSION% openssl-src-win32-VS2013
%SEVENZIP% x openssl-%OPENSSL_VERSION%.tar
ren openssl-%OPENSSL_VERSION% openssl-src-win64-VS2013

CALL %VS2013%

cd \openssl-src-win32-VS2013
perl Configure VC-WIN32 --prefix=T:\openssl-%OPENSSL_VERSION%-32bit-release-DLL-VS2013
nmake
nmake test
nmake install

perl Configure debug-VC-WIN32 --prefix=T:\openssl-%OPENSSL_VERSION%-32bit-debug-DLL-VS2013
nmake
nmake test
nmake install

perl Configure VC-WIN32 --prefix=T:\openssl-%OPENSSL_VERSION%-32bit-release-static-VS2013
nmake
nmake test
nmake install

perl Configure debug-VC-WIN32 --prefix=T:\openssl-%OPENSSL_VERSION%-32bit-debug-static-VS2013
nmake
nmake test
nmake install

CALL %VS2013_AMD64%

cd \openssl-src-win64-VS2013
perl Configure VC-WIN64A --prefix=T:\openssl-%OPENSSL_VERSION%-64bit-release-DLL-VS2013
nmake
nmake test
nmake install

perl Configure debug-VC-WIN64A --prefix=T:\openssl-%OPENSSL_VERSION%-64bit-debug-DLL-VS2013
nmake
nmake test
nmake install

cd \openssl-src-win64-VS2013
perl Configure VC-WIN64A --prefix=T:\openssl-%OPENSSL_VERSION%-64bit-release-static-VS2013
nmake
nmake test
nmake install

perl Configure debug-VC-WIN64A --prefix=T:\openssl-%OPENSSL_VERSION%-64bit-debug-static-VS2013
nmake
nmake test
nmake install

cd \
python copy_openssl_pys.py

%SEVENZIP% a -r openssl-%OPENSSL_VERSION%-32bit-debug-DLL-VS2013.7z openssl-%OPENSSL_VERSION%-32bit-debug-DLL-VS2013\*
%SEVENZIP% a -r openssl-%OPENSSL_VERSION%-32bit-release-DLL-VS2013.7z openssl-%OPENSSL_VERSION%-32bit-release-DLL-VS2013\*
%SEVENZIP% a -r openssl-%OPENSSL_VERSION%-64bit-debug-DLL-VS2013.7z openssl-%OPENSSL_VERSION%-64bit-debug-DLL-VS2013\*
%SEVENZIP% a -r openssl-%OPENSSL_VERSION%-64bit-release-DLL-VS2013.7z openssl-%OPENSSL_VERSION%-64bit-release-DLL-VS2013\*
%SEVENZIP% a -r openssl-%OPENSSL_VERSION%-32bit-debug-static-VS2013.7z openssl-%OPENSSL_VERSION%-32bit-debug-static-VS2013\*
%SEVENZIP% a -r openssl-%OPENSSL_VERSION%-32bit-release-static-VS2013.7z openssl-%OPENSSL_VERSION%-32bit-release-static-VS2013\*
%SEVENZIP% a -r openssl-%OPENSSL_VERSION%-64bit-debug-static-VS2013.7z openssl-%OPENSSL_VERSION%-64bit-debug-static-VS2013\*
%SEVENZIP% a -r openssl-%OPENSSL_VERSION%-64bit-release-static-VS2013.7z openssl-%OPENSSL_VERSION%-64bit-release-static-VS2013\*

DEL openssl-%OPENSSL_VERSION%-32bit-debug-DLL-VS2013 /Q /F /S
DEL openssl-%OPENSSL_VERSION%-32bit-release-DLL-VS2013 /Q /F /S
DEL openssl-%OPENSSL_VERSION%-64bit-debug-DLL-VS2013 /Q /F /S
DEL openssl-%OPENSSL_VERSION%-64bit-release-DLL-VS2013 /Q /F /S
DEL openssl-%OPENSSL_VERSION%-32bit-debug-static-VS2013 /Q /F /S
DEL openssl-%OPENSSL_VERSION%-32bit-release-static-VS2013 /Q /F /S
DEL openssl-%OPENSSL_VERSION%-64bit-debug-static-VS2013 /Q /F /S
DEL openssl-%OPENSSL_VERSION%-64bit-release-static-VS2013 /Q /F /S

RMDIR /S /Q openssl-%OPENSSL_VERSION%-32bit-debug-DLL-VS2013
RMDIR /S /Q openssl-%OPENSSL_VERSION%-32bit-release-DLL-VS2013
RMDIR /S /Q openssl-%OPENSSL_VERSION%-64bit-debug-DLL-VS2013
RMDIR /S /Q openssl-%OPENSSL_VERSION%-64bit-release-DLL-VS2013
RMDIR /S /Q openssl-%OPENSSL_VERSION%-32bit-debug-static-VS2013
RMDIR /S /Q openssl-%OPENSSL_VERSION%-32bit-release-static-VS2013
RMDIR /S /Q openssl-%OPENSSL_VERSION%-64bit-debug-static-VS2013
RMDIR /S /Q openssl-%OPENSSL_VERSION%-64bit-release-static-VS2013

