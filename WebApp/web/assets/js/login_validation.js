// Melakukan validasi terhadap form login
function validateLogin() {
    var loginForm = [
      "username",
      "password",
    ];

    for(var i = 0; i < loginForm.length; i++) {
        var input = document.getElementById(loginForm[i]).value;
        if(input == "") {
            alert("Form cannot be blank.");
            return false;
        }
    }
}
