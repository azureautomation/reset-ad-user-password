<#
AUTHOR:  Daniel Örneling
DATE:    13/1/2016
SCRIPT:  ResetADUserPwd.ps1
Version: 1.0
Twitter: @DanielOrneling
#>
		param (
		[Parameter(Mandatory=$true)]
			[string] $aduser,
			
		[Parameter(Mandatory=$true)]
			[string] $oldpassword,	
	
		[Parameter(Mandatory=$true)]
			[string] $password	
	)

$olduserpwd = ConvertTo-SecureString $oldpassword -AsPlainText -Force
$newuserpwd = ConvertTo-SecureString $password -AsPlainText -Force

# Unlock the account if locked out
Unlock-ADAccount -Identity $aduser

Function Test-ADAuthentication {
    (new-object directoryservices.directoryentry "",$aduser,$oldpassword).psbase.name -ne $null
}

$testoldpwd = Test-ADAuthentication $aduser $oldpassword
If ($testoldpwd -ne $false)

{

# Reset user password
Set-ADAccountPassword -Identity $aduser -OldPassword $olduserpwd -NewPassword $newuserpwd
Write-Output "The password have been reset for the following account" $aduser

}

Else

{

Write-Output "The current password entered is incorrect."

}