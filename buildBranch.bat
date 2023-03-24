@echo off
setlocal enableDelayedExpansion

set "arg_char=-"
set "extra_args=--config Release"
set "bb_string=--unity --pch --noBuildTelemetry --cmakeCommandArgs='--graphviz=mcpe_deps.dot -DENABLE_WPO_BUILD=0 -DPARTNER_BUILD=false -DMOJANG_INTERNAL_PLAYTEST=false '"

for /l %%a in (1,1,6) do (
    set /a next=%%a+1
    set param=%%a
    call set _param=%%!param!
    call set _next=%%!next!

    rem echo -!next! -!_next! #!_param! #%%a 
    if not defined first_arg (
        if "!_param:%arg_char%=!" == "!_param!" (
            set build_name=!_param!
        )
        set first_arg="done"
    )

    if "!_param!" equ "--build" (
        set build_name=!_next!
    )
    
    if "!_param!" equ "--dir" (
        set directory=!_next!
        if "%directory%" neq "" cd %directory%
    )

    if "!_param!" equ "--bb" (
        set extra_args=%bb_string%
    )

    if "!_param!" equ "-h" (
        goto :usage
    )

    if "!_param!" equ "--jk" (
        set jk="true"
    )
)

if not defined build_name goto :set_build
if %build_name:~-3% neq .py goto :fixup_build_name
echo here

:gen_build
echo Generating a %build_name% build!
echo Running: python .\gen_proj\%build_name% %extra_args%
if not defined jk py .\gen_proj\%build_name% %extra_args%
echo "Success!"
exit

:set_build
set /P build_name=Enter a build name (To see a list of options, enter 'list'):
@REM pause
if "%build_name%" == "list" goto print_dir
goto :gen_build

:fixup_build_name
if "%build_name%" == "win32" set build_name=win32_renderdragon_x64
if "%build_name%" == "uwp" set build_name=uwp_renderdragon_x64_win10
set build_name=%build_name%.py
goto :gen_build

:print_dir
cd gen_proj
@echo on
dir
@echo off
goto :set_build

:usage
echo Branch building script!
echo usage: "buildBranch <build_name> <directory (optional)>"
echo ***
echo To see possible build flavors: run "buildBranch" and type "list" at the prompt.
exit