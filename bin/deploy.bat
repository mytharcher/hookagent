 :: This is a deploy shell for windows systerm.

@echo off
set PROJECT=%1
set remote=%2
set branch=%3

set git=%4

@echo start deploying %remote%/%branch%;

set found=0
@echo on

cd

@echo git reset --hard HEAD
@%git% reset --hard HEAD

@echo git fetch %remote%
@%git% fetch %remote%



@for /f "tokens=1,2 delims= " %%i in ('%git% branch') do (
	@if "%branch%" == "%%i" @set found=1
	@if "%branch%" == "%%j" @set found=1
)

@if %found% equ 1 goto merge
@if %found% equ 0 goto checkout

:merge
@echo git checkout -q %branch%
@%git% checkout -q %branch%
echo git merge %remote%/%branch%
@%git% merge %remote%/%branch%
@%git% submodule update --init --recursive
exit

:checkout
@echo git checkout %remote%/%branch% -b %branch%
@%git% checkout %remote%/%branch% -b %branch%
@%git% submodule update --init --recursive
exit

:end