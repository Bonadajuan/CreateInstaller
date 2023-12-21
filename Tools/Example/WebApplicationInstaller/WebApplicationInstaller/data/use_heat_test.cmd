@ECHO OFF

ECHO ------------Generating files with heat.exe----------------

heat dir "C:\Users\jbonada\Desktop\WebApplicationInstaller\WebApplicationInstaller\data\SourceFiles" -dr INSTALLFOLDER -gg -sfrag -srd -var var.SourceFilesDir -out "Components.wxs

PAUSE