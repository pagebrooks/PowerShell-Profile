$here = Split-Path -Parent $MyInvocation.MyCommand.Path

$gitInstallDir = 'C:\Program Files (x86)\Git\'
$Env:HOME = $Env:USERPROFILE
$Env:Path = "$gitInstallDir\cmd;$gitInstallDir\bin;$gitInstallDir\mingw\bin;$Env:Path"

# Loop through the Utils directory and add each child directory to the path variable.
$paths = @("$($env:Path)")
gci "C:\Dev\Utils" | % { $paths += $_.FullName }
$Env:Path = [String]::Join(";", $paths)

Import-Module $here\Modules\posh-git

# Handy functions
function touch($file) { "" | Out-File $file -Encoding ASCII }
function Coalesce-Args { (@($args | ?{$_ -ne $null}) + $null)[0] }
Set-Alias ?? Coalesce-Args
Set-Alias npp "C:\Program Files (x86)\Notepad++\notepad++.exe"

function shorten-path([string] $path) { 
   $loc = $path.Replace($HOME, '~') 
   # remove prefix for UNC paths 
   $loc = $loc -replace '^[^:]+::', '' 
   # make path shorter like tabs in Vim, 
   # handle paths sing with \\ and . correctly 
   return ($loc -replace '\\(\.?)([^\\])[^\\]*(?=\\)','\$1$2') 
}

function Reload-Module($ModuleName) {
	if((get-module -list | where{$_.name -eq "$ModuleName"} | measure-object).count -gt 0)
	{
	 
		if((get-module -all | where{$_.Name -eq "$ModuleName"} | measure-object).count -gt 0)
		{
			rmo $ModuleName
			Write-Host "Module $ModuleName Unloading"
		}
	 
		ipmo $ModuleName
		Write-Host "Module $ModuleName Loaded"
	}
	else
	{
		Write-Host "Module $ModuleName Doesn't Exist"
	}
}
New-Alias -Name rlo -Value Reload-Module

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

Enable-GitColors

# Load posh-git example profile
. "$home\Documents\WindowsPowerShell\Modules\posh-git\profile.example.ps1"

