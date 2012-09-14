PowerShell Profile
==================

- Install msysgit from: http://code.google.com/p/msysgit
- From the PowerShell command prompt, install PsGet and Posh-Git with the following commands:

```
(new-object Net.WebClient).DownloadString("http://psget.net/GetPsGet.ps1") | iex
Install-Module posh-git
```

From Git Bash, install this profile as your default profile by cloning into your 
PowerShell directory:

```
git clone git@github.com:pagebrooks/PowerShell-Profile.git $Env:USERPROFILE\\Documents\\WindowsPowerShell
```


Features
--------
- Support for Posh-Git
- $HOME variable
- Auto-add child paths to PATH for directories in C:\Dev\Utils
- Utility Functions
