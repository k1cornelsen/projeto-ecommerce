function gravar() {

    var form = document.getElementById("formCadastro");
    var dados = new FormData(form);

    fetch("../php/insere-registro.php", {
        method: "POST",
        body: dados
    }).then(window.location.href = "../pages/login.html")


}