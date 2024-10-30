<?php

    include "conexao.php";

    $sql = "SELECT email, senha FROM projetosemestral.usuario";

    $resultado = mysqli_query($con, $sql);

    $i = 0;

    while($registro = mysqli_fetch_assoc($resultado)){

        $dados[$i] ["email"] = $registro["email"];
        $dados[$i] ["senha"] = $registro["senha"];
        $i++;

    }

    $objetoJSON = json_encode($dados);
    echo $objetoJSON;

?>