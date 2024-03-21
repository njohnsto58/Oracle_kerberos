#ps1_sysnative
########
# Title: newcomputer.ps1
# Version & Date: v1 31 Oct 2018
# Udated: v2 31 Mar 2022
# Creator: lawrence.gabriel@oracle.com & john.s.parker@oracle.com
# Warning: This script is a representation of how to use PowerShell to add a new computer to an Active Directory Domain
# Warning there are potential for mistakes and destructive actions. USE AT YOUR OWN RISK!!
# This is the fourth script in the Active Directory Series that will join a computer to your new Active Directory Domain.
# This script will join the newly created host to an Active Directory Domain.
#
# Variables for this script
# $DnsServer - this is the private IP address of the Primary Domain Controller
# $DnsServer2 - this is the private IP address of the Secondary Domain Controller
# $DomaintoJoin - this is the full name of the domain you want to join.
# $JoinCred - this will be the encrypted credential
#
Try {
Start-Transcript -Path "C:\DomainJoin\Stage4.txt" -Force
$DnsServer = '10.0.1.110'
$DnsServer2 = '169.254.169.254'
$DomainToJoin = 'cmgsol.corp'
#######
# Sets the DNS to the DC.
#######
Set-DnsClientServerAddress -InterfaceAlias Ethernet -ServerAddresses ($DnsServer, $DnsServer2)
#######
# Build the one time use password
#######
$JoinCred = New-Object pscredential -ArgumentList ([pscustomobject]@{
 UserName = $null
 Password = (ConvertTo-SecureString -String 'TempJoinPA$$' -AsPlainText -Force)[0]
})
Add-Computer -Domain $DomainToJoin -Options UnsecuredJoin,PasswordPass -Credential $JoinCred
} Catch {
Write-Host $_
} Finally {
Stop-Transcript
}
#######
#
# This wait is to ensure that the Add-Computer command finishes before the restart.
#
#######
start-sleep -s 300
Restart-Computer -ComputerName "localhost" -Force
