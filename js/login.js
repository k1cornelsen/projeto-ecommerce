function login(){

    var email = document.getElementById("email").value;
    var password = document.getElementById("password").value;
    form = new Array(email, password);

    fetch("../php/login.php", {
    method: "GET"
    }).then(async function(resposta){

        var dados = await resposta.json();

        for(i = 0; i < dados.length; i++){

            if(email == dados[i].email && password == dados[i].senha){
                window.location.href = "../index/index.html"
            }

        }
        
    });



}
