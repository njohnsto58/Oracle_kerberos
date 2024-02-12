# Oracle_kerberos
Kerberos setup scripts
Here are a suite of scripts to enable the setting up of Kerberos authentication from AD to an Oracle database running on UNIX.
I have tested them on AD-2016 and a database running on a UNIX OCI compute node, and on a Database Cloud Service running on OCI, and on a Windows 10 client.
I have NOT tested these on an Autonomous Database (might be the next step)

The scripts have been extended to cover generating the AD certificate (for CMU), but NOT the delegation rights required for setting the user lockoutTime (see Matalink note 2462012.1). I Don't know how to do this.

I have used PPKs between AD and all UNIX nodes to ease transfer of files. In the .ssh directory I have generates public and private keys that seem to work - you should really generate your own.
frank_id_rsk.ppk - the private key that can be used in Windows using pscp;
frank_id_rsa - the private key that can be used on UNIX
frank_id_rsa.pub - the public key that can be placed into the UNIX file .ssh/authorized_keys

There are 2 parts - Windows Server and UNIX server. I haven't finished the scripts to set up the Windows client. They may come later.

## ASSUMPTIONS:
The executer of the Windows scripts is able to create and update users in AD, and generate the AD certificate.

In addition to AD Domain Services, also requires Certificate Services to generte the certificate
PSCP has been installed on the Windows AD Server
The executer of the UNIX scripts is oracle
The files sqlnet.ora, dsi.ora are placed in the directory $ORACLE_HOME/network/admin - the scripts enable other directories to be used, but I have not tested this.

The UNIX machines must be able to find the WinAD with its domain - especially if the FQDN on UNIX is different from the FQDN of the AD Controller
e.g. 
AD Controller: tsewin-ad.cmgsol.corp
UNIX database: dbaas1.subnet1.oraclevcn.com

Here I simply added tsewin-ad.cmgsol.corp into the /etc/hosts file

## Windows AD Server
1. Update the AD environment file - I think the variables are self explanatory
The DB_DOMAIN_REALMS parameter will take multiple domains separated by spaces
2. If you want to transfer the files seamlessly to the UNIX box, then create a public and private key. I've created one for ease, but you should create your own.
3. Create an environment file FOR EACH database that you need to authenticate to - use DBAAS1.bat DBAAS2.bat as examples
4. Run the scripts in numerical order...

### 01-newuser dbaas1
Must be run as an administrator - there's a little check at the beginning of the script.
This will create a service account for the oracle database that you'll be authenticating to in AD. I'm not sure that the account name will need to be as long as the name generated - but this works for now

### 02-ktp dbaas1
This will generate the key tab file - again, must be run as an administrator
There is an option to transfer the file to the UNIX box (03-transfer-keytab.bat) - as long as you have the keys and remote keytab directory set up (I have tested this with $ORACLE_HOME) - this should work.

### 03-transfer-keytab dbaas1
If you want to transfer the keytab again - or it didn't work in the previous step (and you've fixed the error)

### 04-remote-env dbaas1
This should generate an environment file that gets called on the UNIX box. In our example, the file will be called 00_env_dbaas1.sh
The script can be called as many times as you want. For example, if you've made changes to the to the environment file (e.g. DBAAS1.bat) and want to regenerate the remote env file.
There is the option to transfer the file to the UNIX box (05-transfer-env.bat) - same comment about certificates

### 05-transfer-env dbaas1
Ditto for 03-transfer-keytab - if there was a mistake, this can be run again

### 06-export-cert dbaas1
Required for CMU. Assumes that the person running this has permissions to generate the cert
The certificate only needs to be generated once - it can be transferred to as many environments as required
The only reason the UNIX environment file is used is in the transfer
There is the option to transfer the certificate to the UNIX box (07-transfer-cert.bat) - same comment about certificates

### 07-transfer-cert dbaas1
Transfer the certificate to the UNIX enviromment. The certificate can be transferred to as many environments as required

## UNIX Server
There are a separate set of scripts to run in the UNIX environment. 

The file 00_env_DOS.sh should have been transferred from the AD machine. Its first run should remove the redundant carriage returns, and rename itself to 00_env.sh. You could run this file first, but it shouldn't be necessary. 

CHECK THE FILE FOR CORRECTNESS BEFORE YOU RUN THE SCRIPTS

There is also the file 00_cmu_env.sh - this is NOT generated, you'll need to update this manually
The database node SHOULD have the Oracle Kerberos utilities installed (okinit, okdstry,...)
There will need to be a node SOMEWHERE on the network with the Kerberos workstation utilities. I've tried this with the Krb6-workstation installed (yum install krb5-workstation) on an OCI node, and a DCS node with no additional kerberos utilities installed.
Scripts should be run in numerical order ...

### 01_krb5.sh
Generate the krb5.conf. You'll need to transfer this file to /etc manually. Check it before you do, take a backup of the original, but don't try to comment out the original and append the new - you're bound to make a mistake.

### 02_sqlnet.sh
Updates the sqlnet.ora file in $ORACLE_HOME/network/admin. If your sqlnet.ora is in a different place, then you'll need to change the file to reflect the new position.

### 03_oracle_ticket.sh
Generates the oracle Kerberos ticket.
IMPORTANT - the Key version number in AD MUST match the key version number in the KeyTab file. The utility kvno will check, but there is no kvno utility on DCS (I've raised an enhancement request 30298291  - but it might take until the end of the next millenium for someone to look at it), so in this case transfer the file to a machine with krb5-workstation.
The utility 03_oracle_ticket.sh SHOULD give clear instructions -

If the utility detects kvno on the current node, it will run and check ...
Keytab name: FILE:db-oracle-dbaas4.keytab
KVNO Timestamp         Principal
---- ----------------- --------------------------------------------------------
  11 01/01/70 00:00:00 oracle/dbaas4.dbsn2.dbsec.oraclevcn.com@WINSN1.DBSEC.ORACLEVCN.COM
oracle/dbaas4.dbsn2.dbsec.oraclevcn.com@WINSN1.DBSEC.ORACLEVCN.COM: kvno = 11

The above is 11 in the keytab and 11 in AD

If the script detets that there is no kvno utility, then you need to transfer the generated script to a node with krb-workstation ...
Configuration file : /etc/krb5.conf.
Ticket cache: FILE:/tmp/krb5cc_101
Default principal: oracle/dbaas4.dbsn2.dbsec.oraclevcn.com@WINSN1.DBSEC.ORACLEVCN.COM

Valid starting     Expires            Service principal
11/13/19 14:41:51  11/14/19 00:41:51  krbtgt/WINSN1.DBSEC.ORACLEVCN.COM@WINSN1.DBSEC.ORACLEVCN.COM
        renew until 11/20/19 14:41:51

Transfer the file /home/oracle/scripts/kerberos-setup/oracle_ticket_dbaas4.sh to the node with Kerberos Utilities to execute

See my note above about certificates

Once you verify that the KVNOs match - then there is no more to do on the node with krb5-workstation utilities installed

### 04_database_user.sh, 04a_database_cmu_user.sh
The difference between the above scripts - CMU requires that the user is global and requires a DN mapping to the AD account, straight kerberos requires that the user is merely external

For straight Kerberos Authentication e.g.
./04_database_user.sh scott
Where scott is the user in AD. The script will create a user in the database called scott, and for convenience, will create a script to generate a ticket - in this case: scott_ticket.sh

For Kerberos with CMU e.g.
./04a_database_cmu_user shared_user "CN=ora_connect,OU=People,DC=winsn1,DC=dbsec,DC=oraclevcn,DC=com"
Where shared_user is the database account that will be shared, and the DN maps to the security group in AD.

Generate the kerberos ticket by running okinit (and entering the password) e.g.
okinit scott
or if CMU shared account
okinit rgreen
(i.e. a user that is in the ora_connect group)

### 05_user_ticket.sh
Script generates the command to obtain a Kerberos ticket. Just for convenience really, you can do the same with the command okinit
Is called from 04_database_user.sh - so if you run this script, you don't need to run it.
But - it is not called from 04a_database_cmu_user.sh

CMU scripts - they rely on the entries in 00_cmu_env.sh

### 06_DSI_create.sh
Generated the dsi.ora file. I can only get this to work if it's in the $ORACLE_HOME/network/admin - I haven't investigated why it doesn't work anywhere else - you can do that if you want.

### 07_wallet_create.sh
Creates the wallet to hold the AD credentials and AD certificate. CMU will NOT work if the creds or the certificate is invalid.
NOTE - this MUST NOT be the same wallet as the TDE wallet.
You MUST set the parameter WALLET_LOCATION in sqlnet.ora
Option to call 08_wallet_entry.sh

### 08_wallet_entry.sh
Adds the credentials and the AD certificate to the wallet.

09_configure_database_for_CMU.sh
sets two LDAP database parameters and an option to restart the database
