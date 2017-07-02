<?php 
	$server_name = "localhost";
	$username = "root";
	$password = "password";
	$sql_conn = new mysqli($server_name, $username, $password);

	if (!$sql_conn->connect_error){
		
	}else{
		echo $sql_conn->error . "SQL didn't connect. Probably invalid credentials.";
		die;
	}

	$query = "CREATE DATABASE IF NOT EXISTS accounts";
	if (!$sql_conn->query($query)){
		echo $sql_conn->error;
	}

	$query = "use accounts;";

	if (!$sql_conn->query($query)){
		echo $sql_conn->error;
	}

	$query = "CREATE TABLE IF NOT EXISTS users (
id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
username VARCHAR(30) NOT NULL,
password VARCHAR(100) NOT NULL,
full_name CHAR(100) NOT NULL,
email VARCHAR(50),
registration_date TIMESTAMP
);";

	if ($sql_conn->query($query)){
		echo $sql_conn->error;
	}

?>
