# UQCS Subject Guide - Web Edition
A version of the UQCS subject guide made for the web.

[Original Subject Guide](https://github.com/UQComputingSociety/subject-guide)

## Installation

### Requirements
* Powershell
* Jekyll

### Steps
1. Run `git submodule update --recursive --remote` to update the original subject guide submodule
2. In Powershell execute `_parse.ps1`. This will generate the website from the original LaTeX subject guide.
3. Run `jekyll build` to create the site.

## Disclaimer
This has only been tested in Powershell for Windows and not on Linux or MacOS.
While the code *should* be portable cross system, there is no guarentee of this fact.