#!/bin/bash

#SysAd Task 1 - Normal Mode

sudo groupadd admins
sudo groupadd moderators
sudo groupadd students

N=9
I=0

while ((I <= 9));
do
	sudo useradd -m "user$I"
	
	if ((I == 0));
	then

		cd /home/"user$I"
		sudo mkdir delta
		cd delta

		Y=10
		Z=1

		while ((Z <= Y));
		do
			sudo mkdir "folder$Z"
			cd "folder$Z"
			sudo touch "user$I""folder$Z.txt"
			RANDOM_STUFF=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)
			sudo chmod 777 "user$I""folder$Z.txt"
			sudo echo $RANDOM_STUFF >> "user$I""folder$Z.txt"
			cd ..
			((Z+=1))
		done

		sudo chown -R "user$I":"user$I" /home/"user$I"/delta
		sudo setfacl -R -m u::rwx /home/"user$I"/delta
		sudo setfacl -R -m g::rwx /home/"user$I"/delta
		sudo setfacl -R -m o::--- /home/"user$I"/delta


	fi

	if((I >=1 && I <= 3));
	then
		sudo usermod -a -G admins "user$I"
		cd /home/"user$I"
		sudo mkdir delta
		cd delta
		
		J=10
		K=1

		while ((K <= J));
		do
			sudo mkdir "folder$K"
			cd "folder$K"
			sudo touch "user$I""folder$K.txt"
			RANDOM_STUFF=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)
			sudo chmod 777 "user$I""folder$K.txt"
			sudo echo $RANDOM_STUFF >> "user$I""folder$K.txt"
			cd ..
			((K+=1))
		done

		sudo chown -R "user$I":"user$I" /home/"user$I"/delta
		sudo setfacl -R -m u::rwx /home/"user$I"/delta
		sudo setfacl -R -m g::rwx /home/"user$I"/delta
		sudo setfacl -R -m o::--- /home/"user$I"/delta
		sudo setfacl -R -m u:user0:rwx /home/"user$I"/delta

	fi

	if((I >=4 && I <= 6));
	then
		sudo usermod -a -G moderators "user$I"
		cd /home/"user$I"
		sudo mkdir delta
		cd delta

		M=10
		N=1

		while ((N <= M));
		do
			sudo mkdir "folder$N"
			cd "folder$N"
			sudo touch "user$I""folder$N.txt"
			RANDOM_STUFF=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)
			sudo chmod 777 "user$I""folder$N.txt"
			sudo echo $RANDOM_STUFF >> "user$I""folder$N.txt"
			cd ..
			((N+=1))
		done
		
		sudo chown -R "user$I":"user$I" /home/"user$I"/delta
		sudo setfacl -R -m u::rwx /home/"user$I"/delta
		sudo setfacl -R -m g::rwx /home/"user$I"/delta
		sudo setfacl -R -m o::--- /home/"user$I"/delta
		sudo setfacl -R -m g:admins:rwx /home/"user$I"/delta
		sudo setfacl -R -m u:user0:rwx /home/"user$I"/delta

		
	fi

	if((I >=7 && I <= 9));
	then
		sudo usermod -a -G students "user$I"
		cd /home/"user$I"
		sudo mkdir delta
		cd delta

		R=10
		S=1

		while ((S <= R));
		do
			sudo mkdir "folder$S"
			cd "folder$S"
			sudo touch "user$I""folder$S.txt"
			RANDOM_STUFF=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)
			sudo chmod 777 "user$I""folder$S.txt"
			sudo echo $RANDOM_STUFF >> "user$I""folder$S.txt"
			cd ..
			((S+=1))
		done
		
		sudo chown -R "user$I":"user$I" /home/"user$I"/delta
		sudo setfacl -R -m u::rwx /home/"user$I"/delta
		sudo setfacl -R -m g::rwx /home/"user$I"/delta
		sudo setfacl -R -m o::--- /home/"user$I"/delta
		sudo setfacl -R -m g:admins:rwx /home/"user$I"/delta
		sudo setfacl -R -m g:moderators:rwx /home/"user$I"/delta
		sudo setfacl -R -m u:user0:rwx /home/"user$I"/delta

	fi

	((I+=1))
done

