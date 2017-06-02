#SysAd Task 1 - Hacker Mode

sudo touch scheduled_code.sh
sudo chmod 777 scheduled_code.sh
sudo echo "#!/bin/bash

N2=9
I2=0

while ((I2 <= N2));
do
	sudo su user\$I2 -c \"cd /home/user\$I2\"
	sudo su user\$I2 -c \"cd /home/user\$I2/delta\"
	
	J2=10
	K2=1
	
	while ((K2 <= J2));
	do
		sudo su user\$I2 -c \"cd /home/user\$I2/delta/folder\$K2\"
		RANDOM_STUFF_PERIODIC=\$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)
		sudo su user\$I2 -c \"echo \$RANDOM_STUFF_PERIODIC > \"/home/user\$I2/\"\"delta/folder\$K2/\"\"user\$I2\"\"folder\$K2.txt\"\"
		((K2+=1))
	done
	((I2+=1))
done" >> scheduled_code.sh

sudo crontab -l > mycronjob
echo "21 15 * 1-6 * $CURRENT_DIR/""scheduled_code.sh" >> mycronjob
sudo crontab mycronjob
rm mycronjob

