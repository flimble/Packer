# Build tools for a Windows Teamcity agent

# Selenium
choco install googlechrome
choco install chromedriver

# Node (primarily for gulp)
choco install nodejs.install

# Java
choco install jdk8

# MS Building Tools
choco install windows-sdk-8.1
choco install nuget.commandline
choco install microsoft-build-tools

# Give Visual Studio 90 minutes (!!) to install
choco install visualstudio2015professional --execution-timeout=5400

# Git
choco install git

# .net core
choco install dotnetcore-sdk -pre