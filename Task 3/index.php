<?php
	session_start();
	ini_set("display_errors", 1);
?>

<?php
	require("mysql_conn.php");

	$username_valid = null;
	$password_valid = null;
	$full_name_valid = null;
	$email_valid = null;
	$registered = null;
	
?>

<!DOCTYPE html>

<html>
	<head>
		<title>Register</title>
	</head>

	<body>
		<b><u>Registration Form</u></b>
		<br>
		<br>
		<form action="index.php" method="post">
			<input type="text" name="username" placeholder="Username"></input>
				<?php
					if (isset ($_POST["username"]) && empty($_POST["username"])){
						echo "Username can't be empty";
					}

					$stmt = $sql_conn->prepare("SELECT * FROM users WHERE username=?;");
					$stmt->bind_param("s", $_POST["username"]);
					$stmt->execute();
					$result = $stmt->get_result();
					$num_rows = $result->num_rows;

					if ($num_rows > 0){
						echo "Username already exists";
					}

					else if (isset($_POST["username"])){					
						if (strlen($_POST["username"]) <= 5 || strlen($_POST["username"]) >= 10){
							echo "Username must be between 5 to 10 characters";
						}else{
							$username_valid = true;
						}

					}
				?>
				<br>
			<input type="password" name="password" placeholder="Password"></input>
				<?php
					if (isset ($_POST["password"]) && empty($_POST["password"])){
						echo "Password can't be empty";
					}

					else if (isset($_POST["password"])){
						$ucl = preg_match('/[A-Z]/', $_POST["password"]); 
						$lcl = preg_match('/[a-z]/', $_POST["password"]); 
						$dig = preg_match('/\d/', $_POST["password"]); 
						$spl = preg_match('/\W/', $_POST["password"]);
						$all_conds = $ucl && $lcl && $dig && $spl;

						if (!$all_conds && strlen($_POST["password"]) <= 5){
							echo "Password must contain at least one alphabet, one digit and one special character, and it must be greater than 5 characters";
						}else{
							$password_valid = true;
						}	
					}
					
				?>			
			<br>
			<input type="text" name="full_name" placeholder="Full Name"></input>
			<?php
				if (isset ($_POST["full_name"]) && empty($_POST["full_name"])){
					echo "Full Name can't be empty";
				}else{
					$full_name_valid = true;
				}
			?>
			<br>
			<input type="text" name="email" placeholder="Email ID"></input>
				<?php
					if (isset ($_POST["email"]) && empty($_POST["email"])){
						echo "Email ID can't be empty";
					}

					$stmt = $sql_conn->prepare("SELECT * FROM users WHERE email=?;");
					$stmt->bind_param("s", $_POST["email"]);
					$stmt->execute();
					$result = $stmt->get_result();
					$num_rows = $result->num_rows;

					if ($num_rows > 0){
						echo "Email ID already exists";
					}

					else if (isset($_POST["email"])){
						if (!filter_var($_POST["email"], FILTER_VALIDATE_EMAIL)){
							echo "Invalid Email ID";
						}else{
							$email_valid = true;
						}
					}
				?>
			<br>
			<input type="submit" name="register" value="Register"></input><br>
			<?php
				
				if (isset($_POST["register"])){
		
					if ($username_valid && $password_valid && $full_name_valid && $email_valid){
						$username = mysqli_real_escape_string($sql_conn, $_POST["username"]);
						$password = mysqli_real_escape_string($sql_conn, sha1($_POST["password"]));
						$full_name = mysqli_real_escape_string($sql_conn, $_POST["full_name"]);
						$email = $_POST["email"];

						$stmt = $sql_conn->prepare("INSERT INTO users (username, password, full_name, email) VALUES (?, ?, ?, ?);");
						$stmt->bind_param("ssss", $username, $password, $full_name, $email);
						$stmt->execute();

						if ($stmt->error){
							echo $stmt->error;
						}else{
							$registered = true;
						}
					}
				}

				if ($registered){
					echo "<b>Successfully Registered</b>";
				}
			?>			
			<br>
			<a href="http://localhost:9001" name="login">Exitsing User? Log In Here</a>
			</form>
	</body>

</html>

<?php
	session_destroy();
?>

