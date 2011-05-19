@echo off

setlocal
REM parse command line options
set full=0
set mod=0
:loopParams
if "%1" NEQ "" (
  if "%1"=="-f" (set full=1) else if "%1"=="-m" (set mod=1) else (
    echo usage: vc [-f] [-m]
    exit /b 1
  )
  shift
  goto loopParams
)


set LC_ALL=C
hg tip --template "Hash: {node}\nAbr. Hash: {node|short}\nAbr. Parent Hashes: {parents|nonempty}\nCommitter Name: {author|person}\nCommitter Email: {author|email}\nCommit Date: {date|isodate}\nCommit Description: {desc|nonempty|firstline}\nCommit Date Raw: {date}\nTags: {tags}\n" | gawk -v script=log -v full=%full% -f vc-hg.awk > vc.tex

if "%mod%" == "1" (
    hg status | gawk -v script=status -f vc-hg.awk >> vc.tex
}
