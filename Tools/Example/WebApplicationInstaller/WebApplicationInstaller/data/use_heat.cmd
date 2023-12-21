@ECHO OFF

ECHO ------------Generating files with heat.exe----------------

"%WIX%bin\heat.exe" dir "SourceFiles" -cg MyComponentGroup -dr INSTALLFOLDER -gg -sfrag -srd -var var.SourceFilesDir -out "Components.wxs"

PAUSE