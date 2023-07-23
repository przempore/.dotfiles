$Env:PSModulePath += ";C:\Users\Porebski\Projects\posh"
& $env:USERPROFILE\python\Scripts\Activate.ps1
pushd 'C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\'; cmd /c "vcvars64.bat&set" |
foreach {
   if ($_ -match "=") {
     $v = $_.split("="); set-item -force -path "ENV:\$($v[0])"  -value "$($v[1])"
   }
}
popd

Set-Alias ll ls;
