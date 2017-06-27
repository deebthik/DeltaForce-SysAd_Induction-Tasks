#!/usr/bin/python

import os
import zlib
import hashlib
import shutil
import fractions



option = "Y"

while (option == "Y"):

	print

	print "Welcome to our FST(File Syncing Tool)"
	print "Enter the paths of the two directories you'd like to synchronize."

	sender_path = raw_input("Enter the path of the sender directory: ")
	while (not os.path.exists(sender_path)):
		sender_path = raw_input("The specified directory doesn't exist. Please enter the name of an existing directory: ")

	if (os.listdir(sender_path) == []):
		print "The sender directory is empty."
		option = raw_input("Do you wish to restart using this tool (Y or N): ")
		while (option not in ["Y", "N"]):
			option = raw_input("Input Valid. Y or N: ");
		if (option == "Y"):
			continue
		else:
			break

	receiver_path = raw_input("Enter the path of the receiver directory: ")
	while (not os.path.exists(receiver_path)):
		receiver_path = raw_input("The specified directory doesn't exist. Please enter the name of an existing directory: ")
	
	try:
		max_size_bar = input("Enter maximum bar for the size of the file (in bytes)(leave blank for none): ")
	except:
		max_size_bar = -1

	source_files_delete = raw_input("Do you want to delete the source files after deletion(Y or N): ")
	while (source_files_delete not in ["Y", "N"]):
		source_files_delete = raw_input("Input Valid. Y or N: ");
	
	for file_name in os.listdir(sender_path):
		sender_file_path = sender_path + "/" + file_name
		sender_file_stat = os.stat(sender_file_path)
		
		if ((sender_file_stat.st_size <= max_size_bar) or (max_size_bar == -1)):
		
			receiver_file_path = receiver_path + "/" + file_name
		
			if (not os.path.exists(receiver_file_path)):
				shutil.copy2(sender_file_path, receiver_file_path)
				continue
			
			sender_file_stat = os.stat(sender_file_path)
			receiver_file_stat = os.stat(receiver_file_path)

			sender_file_original_size = sender_file_stat.st_size
			sender_file_size = sender_file_stat.st_size
			receiver_file_size = receiver_file_stat.st_size

			if ([sender_file_size, int(sender_file_stat.st_mtime)] != [receiver_file_size, int(receiver_file_stat.st_mtime)]):
					
				if ((sender_file_size) <= 32 or (receiver_file_size <= 32)):
					shutil.copy2(sender_file_path, receiver_file_path)
					continue

				smaller_file_size = min(sender_file_size, receiver_file_size)
				
				n = 5
				while True:
					block_size = 2**n
					if (block_size > (smaller_file_size/500)):
						break
					if (block_size == 524288):
						break
					n += 1

				receiver_file_checksums = []
				receiver_file_md5s = []
				receiver_file = open(receiver_file_path, "rb+")

				truncate_size = 0
				while True:
					truncate_size += block_size
					if (truncate_size >= receiver_file_size):
						receiver_file_truncate_size = truncate_size
						break

				receiver_file.truncate(receiver_file_truncate_size)
				receiver_file_size = os.stat(receiver_file_path).st_size

				while True:
					if (receiver_file.tell() == receiver_file_size):
						break
					data = receiver_file.read(block_size)
					data_checksum = zlib.adler32(data)
					data_md5 = hashlib.md5(data).hexdigest()
					receiver_file_checksums += [data_checksum]
					receiver_file_md5s += [data_md5]

				receiver_file.close()

				sender_file = open(sender_file_path, "rb+")

				truncate_size = 0
				while True:
					truncate_size += block_size
					if (truncate_size >= sender_file_size):
						sender_file_truncate_size = truncate_size
						break

				sender_file.truncate(sender_file_truncate_size)
				sender_file_size = os.stat(sender_file_path).st_size

				new_temp_file = open(receiver_path+"/"+"new_temp_file"+sender_file_path[len(sender_file_path)-4::], "wb+")
				
				while True:
					if (sender_file.tell() == sender_file_size):
						break
					if ((sender_file_size - sender_file.tell()) <= block_size):
						data = sender_file.read(block_size)
						new_temp_file.write(data.rstrip("\n\00"))
						break
					data = sender_file.read(block_size)
					data_checksum = zlib.adler32(data)
					data_md5 = hashlib.md5(data).hexdigest()
					if (data_checksum in receiver_file_checksums):
						if (data_md5 in receiver_file_md5s):
							new_temp_file.write(data)
							continue
					print data
					new_temp_file.write(data[:1:])
					sender_file.seek(-(block_size-1), 1)

				new_temp_file.close()

				os.remove(receiver_file_path)
				os.rename(receiver_path+"/"+"new_temp_file"+sender_file_path[len(sender_file_path)-4::], receiver_file_path)

				sender_file.truncate(sender_file_original_size)

			if (source_files_delete == "Y"):
				os.remove(sender_file_path)

				
				
				
				

	else:
		print "Files are synced."
			
	print
	option = raw_input("Do you wish to continue using this tool (Y or N): ")
	while (option not in ["Y", "N"]):
		option = raw_input("Input Valid. Y or N: ");



print
print "Goodbye :)"
print

