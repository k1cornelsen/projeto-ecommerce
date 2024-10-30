<?php
if(isset($_POST['nome'])) {
    $nome = $_POST['nome'];
}

if(isset($_POST['cpf'])) {
    $cpf = $_POST['cpf'];
}

if(isset($_POST['email'])) {
    $email = $_POST['email'];
}

if(isset($_POST['password'])) {
    $password = $_POST['password'];
}

include "conexao.php";

$sql = "INSERT INTO usuario (email, nome, cpf, senha) VALUES ('$email', '$nome', $cpf, '$password')";

mysqli_query($con, $sql);



?>