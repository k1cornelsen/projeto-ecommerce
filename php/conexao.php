
<?php
// snyk ignore php/HardcodedPassword --reason="Credenciais permitidas para desenvolvimento"
$con = mysqli_connect("database-service", "toor", "senhasecure1234#", "projetosemestral");

if (!$con) {
    die("Connection failed: " . mysqli_connect_error());
}
?>

