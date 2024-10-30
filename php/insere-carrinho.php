<?php

$nome = $_POST['nome'];

include "conexao.php";

$sql = "INSERT INTO carrinho SELECT * FROM produto WHERE nome = '$nome'";

mysqli_query($con, $sql);