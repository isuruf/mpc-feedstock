if "%ARCH%"=="32" (
    set PLATFORM=Win32
) else (
    set PLATFORM=x64
)

set mpc_root=%cd%
cd ..

for %%d in (mpir, mpfr) do (
    mkdir %%d\dll\%PLATFORM%\Release
    mkdir %%d\lib\%PLATFORM%\Release

    REM copy libraries
    copy %LIBRARY_BIN%\%%d.dll %%d\dll\%PLATFORM%\Release\%%d.dll
    copy %LIBRARY_LIB%\%%d.lib %%d\dll\%PLATFORM%\Release\%%d.lib
    copy %LIBRARY_LIB%\%%d_static.lib %%d\lib\%PLATFORM%\Release\%%d.lib
)

REM copy headers
xcopy %LIBRARY_INC%\*.h mpir\lib\%PLATFORM%\Release\ /E
xcopy %LIBRARY_INC%\*.h mpir\dll\%PLATFORM%\Release\ /E

cd %mpc_root%\build.vc14

msbuild.exe /p:Platform=%PLATFORM% /p:Configuration=Release /p:PostBuildEvent="" mpc_lib\mpc_lib.vcxproj
msbuild.exe /p:Platform=%PLATFORM% /p:Configuration=Release /p:PostBuildEvent="" mpc_dll\mpc_dll.vcxproj

copy dll\%PLATFORM%\Release\mpc.lib %LIBRARY_LIB%\mpc.lib
copy dll\%PLATFORM%\Release\mpc.dll %LIBRARY_BIN%\mpc.dll
copy dll\%PLATFORM%\Release\mpc.pdb %LIBRARY_BIN%\mpc.pdb

copy lib\%PLATFORM%\Release\mpc.lib %LIBRARY_LIB%\mpc_static.lib

cd %mpc_root%
copy src\mpc.h %LIBRARY_INC%\mpc.h

cd build.vc14

for /d %%d in (dll_tests\*) do (
    for %%f in (%%d\*.vcxproj) do (
        msbuild.exe /property:SolutionDir=..\..\ /property:OutDir=..\..\%PLATFORM%\Release\ /p:Platform=%PLATFORM% /p:Configuration=Release /p:PostBuildEvent="" %%f
    )
)

for /r "dll_tests\" %%a in (*.exe) do %%~fa
