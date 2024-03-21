#ps1_sysnative
########
# Title: AddComputer.ps1
# Version & Date: v1 31 Oct 2018
# Updated: v2 31 Mar 2022
# Creator: john.s.parker@oracle.com
# Warning: This script is a representation of how to use PowerShell to add a computer to an Active Directory Domain.
# This script creates and uses the domain administrator account there are potential for mistakes and destructive actions.
# USE AT YOUR OWN RISK!!
# Source:
# From https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/add-computer?view=powershell5.1#examples
# Variables for this script
# $NewComputerName - this is the name of the new computer that you want to add to your domain
#
## Run as Administrator on a domain computer.
$NewComputerName = "WS16CN001"
New-ADComputer -Name $NewComputerName -AccountPassword (ConvertTo-SecureString -String 'TempJoinPA$$' -AsPlainText -Force)
