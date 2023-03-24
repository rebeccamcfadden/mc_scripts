@echo off
SetLocal EnableDelayedExpansion

echo Updating branch

git fetch
git pull
echo Pulled branch 

git submodule update --init --recursive

echo Pulled submodules

for /l %%a in (1,1,7) do (
    set /a next=%%a+1
    set param=%%a
    call set _param=%%!param!
    call set _next=%%!next!

    rem echo -!next! -!_next! #!_param! #%%a
    if not defined first_arg (
        set first_arg="done"
        if "!_param!" == "" goto :choices
    )

    if "!_param!" equ "-h" (
        goto :usage
    )

    if "!_param!" equ "--clean" (
        git clean -ffdx
        echo Cleaned :D 
    )

    if "!_param!" == "" goto :buildBranch
)
goto :buildBranch

:choices
:choice
set /P c=Do you want to run `git clean`?[Y/N]?
if /I "%c%" EQU "Y" goto :clean
if /I "%c%" EQU "N" goto :gen_proj
goto :choice

:clean
git clean -ffdx
echo Cleaned :D 

:gen_proj
if "%1" == "--build" set build_name=%2
if "%2" == "--build" set build_name=%3
if "%build_name%" neq "" goto :buildBranch
:choice
set /P c=Do you want to generate a build?[Y/N]?
if /I "%c%" EQU "Y" goto :gen_proj_confirm
if /I "%c%" EQU "N" goto :early_exit
goto :choice


:early_exit
echo I am exiting because you typed N.
pause 
exit

:gen_proj_confirm
:choice
set /P c=Which build?[a: win32_renderdragon_x64, b: uwp_renderdragon_x64_win10, c: custom]?
if /I "%c%" EQU "a" set build_name=win32
if /I "%c%" EQU "b" set build_name=uwp
goto :buildBranch

:buildBranch
if defined jk (
    if not defined build_name echo buildBranch %*
    if defined build_name echo buildBranch %build_name% %*
    exit
)
if not defined build_name buildBranch %*
if defined build_name buildBranch %build_name% %*
exit