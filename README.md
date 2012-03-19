PowerShell Profile
==================

Install msysgit from: http://code.google.com/p/msysgit

From Git Bash, install this profile as your default profile by cloning into your 
PowerShell directory:

```
git clone git@github.com:pagebrooks/PowerShell-Profile.git $HOME\\Documents\\WindowsPowerShell
```

From the PowerShell command prompt, install PsGet with the following command:

```
(new-object Net.WebClient).DownloadString("http://psget.net/GetPsGet.ps1") | iex
```

Features
--------
- Customized Font
- Support for Posh-Git
- Auto-add child paths to PATH for directories in C:\Dev\Utils
- Utility Functions
