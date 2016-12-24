# UQCS Subject Guide - Web Edition
A version of the UQCS subject guide made for the web.

[Original Subject Guide](https://github.com/UQComputingSociety/subject-guide)

## Installation

### Requirements
* Powershell
* Jekyll

### Steps
1. Run `git submodule update --init --recursive` to update the original subject guide submodule
2. In Powershell execute `_parse.ps1`. This will generate the website from the original LaTeX subject guide.
3. Run `jekyll build` to create the site.

#### Note
If there is any issue running the script try running this first
```Powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted
```

## Disclaimer
This has had limited testing on Powershell running on Amazon Linux 
and it seems to run fine. Please understand that testing on non-Windows platforms 
is very limited at the present point in time. Powershell for Mac and Linux is only
in a Preview stage at the current point in time.
