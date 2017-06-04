#!/bin/bash

CURRENT_DIR=$(pwd)

#SysAd Task 1 - Hacker Mode

sudo touch scheduled_code.sh
sudo chmod 777 scheduled_code.sh
sudo echo '#!/bin/bash

touch temp_script.sh
chmod 777 temp_script.sh
echo '"'#!/bin/bash

echo \$(cat /dev/urandom | tr -dc "'"a-zA-Z0-9"'" | fold -w 10 | head -n 1) > \$@'"' > temp_script.sh

sudo su user0 -c "find /home/ -name \"user*folder*.txt\" -exec ./temp_script.sh {} \;"

rm temp_script.sh' >> scheduled_code.sh

sudo crontab -l > mycronjob
echo "21 15 * 1-6 * $CURRENT_DIR/""scheduled_code.sh" >> mycronjob
sudo crontab mycronjob
rm mycronjob

