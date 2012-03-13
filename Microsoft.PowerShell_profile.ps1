$here = Split-Path -Parent $MyInvocation.MyCommand.Path

$gitInstallDir = 'C:\Program Files (x86)\Git\'
$Env:HOME = $Env:USERPROFILE
$Env:Path = "$gitInstallDir\cmd;$gitInstallDir\mingw\bin;$Env:Path"

# Loop through the Utils directory and add each child directory to the path variable.
$paths = @("$($env:Path)")
gci "C:\Dev\Utils" | % { $paths += $_.FullName }
$Env:Path = [String]::Join(";", $paths)

function touch($file) { "" | Out-File $file -Encoding ASCII }

Import-Module $Env:HOME\Documents\WindowsPowerShell\Modules\posh-git

function shorten-path([string] $path) { 
   $loc = $path.Replace($HOME, '~') 
   # remove prefix for UNC paths 
   $loc = $loc -replace '^[^:]+::', '' 
   # make path shorter like tabs in Vim, 
   # handle paths starting with \\ and . correctly 
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

Enable-GitColors


