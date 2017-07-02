<?php
	session_start();
	ini_set("display_errors", 1);

?>

<?php
	require("mysql_conn.php");

	$logged_in = null;

?>

<!DOCTYPE html>

<html>
	<head>
		<title>Log In</title>
	</head>

	<body>
		<b><u>Login Form</u></b>
		<br>
		<br>
		<form action="index.php" method="post">
			<input type="text" name="username" placeholder="Username"></input>
			<?php
				if (isset($_POST["username"]) && empty($_POST["username"])){
					echo "Username can't be empty";
				}
			?>
			<br>
			<input type="password" name="password" placeholder="Password"></input>
			<?php
				if (isset($_POST["password"]) && empty($_POST["password"])){
					echo "Password can't be empty";
				}
			?>
			<br>
			<input type="submit" name="login" value="Login"></input><br>
			<?php

				if ((isset($_POST["username"]) && !empty($_POST["username"])) && (isset($_POST["password"]) && !empty($_POST["password"]))){
					$username = mysqli_real_escape_string($sql_conn, $_POST["username"]);
					$password = mysqli_real_escape_string($sql_conn, sha1($_POST["password"]));
				
					$stmt = $sql_conn->prepare("SELECT * FROM users WHERE username=? AND password=?");
					$stmt->bind_param("ss", $username, $password);
					$stmt->execute();

					$result = $stmt->get_result();
					$num_rows = $result->num_rows;

					if ($num_rows == 0){
						echo "<b>Invalid username and/or password</b>";
					}else{
						$logged_in = true;
					}
				}
				
			?>			
			<br>
			<a href="http://localhost:9000">Don't have an account? Sign up here</a>
			</form>
	</body>

</html>

<?php	
	if ($logged_in){
		$_SESSION["logged_in"] = true;
		$_SESSION["username"] = $username;
		$_EMAIL["email"] = $email;
		header("Location: profile.php");
	}
?>

