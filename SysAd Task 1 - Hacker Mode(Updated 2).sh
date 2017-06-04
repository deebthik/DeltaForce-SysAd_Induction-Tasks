#!/bin/bash

CURRENT_DIR_1=$(pwd)

#SysAd Task 1 - Hacker Mode

mkdir temp_dir
cd temp_dir
touch {0..9}
ls | xargs -I %n sh -c "sudo useradd -m user%n; cd /home/user%n; sudo mkdir delta"

touch folders_creation.sh
chmod 777 folders_creation.sh
sudo echo "#!/bin/bash

cd \$@
sudo mkdir {1..10}
ls | xargs -I %folder_no mv %folder_no folder%folder_no" >> folders_creation.sh

CURRENT_DIR=$(pwd)

sudo find /home/ -type d -name "delta" -exec $CURRENT_DIR/folders_creation.sh {} \;

touch text_files_creation.sh
chmod 777 text_files_creation.sh
sudo echo '#!/bin/bash

cd $@
cd ..

if [ "${PWD##*/}" == "delta" ];
then
	cd ..
	USER_NAME="${PWD##*/}"

	cd $@
	FOLDER_NAME="${PWD##*/}"

	sudo touch "$USER_NAME""$FOLDER_NAME"".txt"
	echo $(cat /dev/urandom | tr -dc "a-zA-Z0-9" | fold -w 10 | head -n 1) > "$USER_NAME""$FOLDER_NAME"".txt"
fi' >> text_files_creation.sh

sudo find /home/ -type d -name "folder*" -exec $CURRENT_DIR/text_files_creation.sh {} \;

touch file_permissions.sh
chmod 777 file_permissions.sh
sudo echo '#!/bin/bash

cd $@
cd ..

if [ "${PWD##*/}" == "home" ];
then
	
	cd $@

	if (( ${PWD##*user} == 0 ));
	then

		sudo chown -R "user""${PWD##*user}":"user""${PWD##*user}" delta
		sudo setfacl -R -m u::rwx delta
		sudo setfacl -R -m g::rwx delta
		sudo setfacl -R -m o::--- delta

	fi

	if (( ${PWD##*user} >= 1 && ${PWD##*user} <= 3));
	then

		sudo chown -R "user""${PWD##*user}":"user""${PWD##*user}" delta
		sudo setfacl -R -m u::rwx delta
		sudo setfacl -R -m g::rwx delta
		sudo setfacl -R -m o::--- delta
		sudo setfacl -R -m u:user0:rwx delta

	fi

	if (( ${PWD##*user} >= 4 && ${PWD##*user} <= 6));
	then

		sudo chown -R "user""${PWD##*user}":"user""${PWD##*user}" delta
		sudo setfacl -R -m u::rwx delta
		sudo setfacl -R -m g::rwx delta
		sudo setfacl -R -m o::--- delta
		sudo setfacl -R -m g:admins:rwx delta
		sudo setfacl -R -m u:user0:rwx delta

	fi

	if (( ${PWD##*user} >= 7 && ${PWD##*user} <= 9));
	then

		sudo chown -R "user""${PWD##*user}":"user""${PWD##*user}" delta
		sudo setfacl -R -m u::rwx delta
		sudo setfacl -R -m g::rwx delta
		sudo setfacl -R -m o::--- delta
		sudo setfacl -R -m g:admins:rwx delta
		sudo setfacl -R -m g:moderators:rwx delta
		sudo setfacl -R -m u:user0:rwx delta

	fi

fi' >> file_permissions.sh

sudo find /home/ -type d -name "user*" -exec $CURRENT_DIR/file_permissions.sh {} \;

cd ..
sudo rm -r temp_dir






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
echo "21 15 * 1-6 * $CURRENT_DIR_1/""scheduled_code.sh" >> mycronjob
sudo crontab mycronjob
rm mycronjob

