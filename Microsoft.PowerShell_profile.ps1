$gitInstallDir = 'C:\Program Files (x86)\Git\'
$Env:HOME = $Env:USERPROFILE
$Env:Path = "C:\Dev\Utils\nano-2.0.3;$gitInstallDir\cmd;$gitInstallDir\mingw\bin;$Env:Path"

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


