# mongodb-scripts
scripts for maintaining mongodb
## switch-automation-agent-user.sh
Automation agent runs by `mongod:mongod` by default. Sometimes we want to use different user/group to run agent for various reasons. This script changes automation agent user/group to specified one.

- Usage: Change user/group in the script and run it.

*Warning: For RPM installation on Redhat/CentOS only.*
