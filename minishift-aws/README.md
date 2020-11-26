## Requirements
- AWS EC2
- OS: CentOS 7 Official Image

## Configuration
- Save the scipt
- Execute the script:
```
./minishift-setup.sh
```
- While generating SSH private key, you'll be asked for the following questions. Enter directly when being asked:
```
Enter file in which to save the key (/home/centos/.ssh/id_rsa):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
```
- When being asked for the hostname, paste the **public hostname** of current server.

Wait for the script to finish, and you are ready to go.