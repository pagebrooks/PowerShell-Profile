$here = Split-Path -Parent $MyInvocation.MyCommand.Path

$gitInstallDir = 'C:\Program Files (x86)\Git\'
$Env:HOME = $Env:USERPROFILE
$Env:Path = "$gitInstallDir\cmd;$gitInstallDir\bin;$gitInstallDir\mingw\bin;$Env:Path"

Set-Alias vi "C:\Program Files (x86)\Vim\vim74\gvim.exe"
Set-Alias vim "C:\Program Files (x86)\Vim\vim74\gvim.exe"

# Handy functions
function touch($file) { "" | Out-File $file -Encoding ASCII }
function Coalesce-Args { (@($args | ?{$_ -ne $null}) + $null)[0] }
Set-Alias ?? Coalesce-Args
Set-Alias npp "C:\Program Files (x86)\Notepad++\notepad++.exe"

function profile-edit() {
   vim ~\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
}

function profile-git-pull() {
   Push-Location Get-Location
   cd ~\Documents\WindowsPowerShell
   git pull origin master
   Pop-Location
}

function profile-directory() {
   cd ~\Documents\WindowsPowerShell
}

function shorten-path([string] $path) { 
   $loc = $path.Replace($HOME, '~') 
   # remove prefix for UNC paths 
   $loc = $loc -replace '^[^:]+::', '' 
   # make path shorter like tabs in Vim, 
   # handle paths sing with \\ and . correctly 
   return ($loc -replace '\\(\.?)([^\\])[^\\]*(?=\\)','\$1$2') 
}

function prompt { 
   
   $cdelim = [ConsoleColor]::DarkCyan 
   $chost = [ConsoleColor]::Green 
   $cloc = [ConsoleColor]::Cyan    

   $hostName = [net.dns]::GetHostName()
   $machineName = $hostName
   if($hostName -eq 'CHS23L-F1723Q1') {
		$machineName = 'BROPN-PSA'
   }
   
   write-host ($machineName) -n -f $chost 
   write-host ' ' -n -f $cdelim 
   write-host (shorten-path (pwd).Path) -n -f $cloc 
   
   $global:GitStatus = Get-GitStatus
   Write-GitStatus $GitStatus
   
   write-host "`r`n$" -n -f $cdelim 
   return ' ' 
}
# Load posh-git example profile
#. "$home\Documents\WindowsPowerShell\Modules\posh-git\profile.example.ps1"
#. 'C:\tools\poshgit\dahlbyk-posh-git-b3cb9b6\profile.example.ps1'

Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)
Import-Module .\posh-git\posh-git

function prompt {
    $realLASTEXITCODE = $LASTEXITCODE

    # Reset color, which can be messed up by Enable-GitColors
    $Host.UI.RawUI.ForegroundColor = $GitPromptSettings.DefaultForegroundColor

    Write-Host($pwd) -nonewline

    Write-VcsStatus

    $global:LASTEXITCODE = $realLASTEXITCODE
    return "> "
}

Enable-GitColors

Pop-Location

Start-SshAgent -Quiet
