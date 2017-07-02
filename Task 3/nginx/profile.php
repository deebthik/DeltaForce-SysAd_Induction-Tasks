<?php
	session_start();
	ini_set("display_errors", 1);

	require("mysql_conn.php");

	$stmt = $sql_conn->prepare("SELECT * FROM users WHERE username=?;");
	$stmt->bind_param("s", $_SESSION["username"]);
	$stmt->execute();
	$result = $stmt->get_result();
	$row = $result->fetch_assoc();

	if (!isset($_SESSION["logged_in"])){
		echo "Invalid URL";
		die;
	}
?>

<!DOCTYPE html>
<html>
	<head>
		<title><?php echo "Welcome " . $row["full_name"] ?></title>
	</head>

	<body>
		<?php
			echo "<b>Successfully Logged In</b><br><br>";
			echo "Full Name: " . $row["full_name"] . "<br>";
			echo "Email ID: " . $row["email"];
		?>
		<br><br>
		<form action="profile.php" method="post">
			<input type="submit" name="log_out" value="Log Out"></input>
		</form>
		<?php
			if (isset($_POST["log_out"])){
				session_destroy();
				header("Location: index.php");
			}
		?>
	</body>
</html>
